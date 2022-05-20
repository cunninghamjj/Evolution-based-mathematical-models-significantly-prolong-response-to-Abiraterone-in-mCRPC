function [yS, yR, PSA, integerTime_u, t_NewAdaptive] = solveSRODE_Adaptive(optimizationParams, t_max, t_firstAbi, adaptivePercent)

nRKsteps = t_max * 6;

h = t_max/nRKsteps;

yS = optimizationParams(1);
yR = optimizationParams(2);

PSA = yS + yR;

t_NewAdaptive = 1;

%% Set initial u
if (t_firstAbi == 1)
    integerTime_u(1) = 1;
else
    integerTime_u(1) = 0;
    PSAmaxFoundFlag = 0;
end

%% Here I am using three times the absolute maximum time reached during the trial. 
for i = 1:1:1750

    
    if i == t_firstAbi
        PSAmax = PSA(i);
        PSAmaxFoundFlag = 1;
    end
    
    [k1] = h .* systemState(yS(i), yR(i), integerTime_u(i), optimizationParams);
    [k2] = h .* systemState(yS(i) + k1(1)/2, yR(i)+ k1(2)/2, integerTime_u(i), optimizationParams);
    [k3] = h .* systemState(yS(i) + k2(1)/2, yR(i)+ k2(2)/2, integerTime_u(i), optimizationParams);
    [k4] = h .* systemState(yS(i) + k3(1), yR(i) + k3(2), integerTime_u(i), optimizationParams);
    
    yS(i+1) = yS(i) + (k1(1)+2*(k2(1)+k3(1))+k4(1))/6;
    yR(i+1) = yR(i) + (k1(2)+2*(k2(2)+k3(2))+k4(2))/6;
    
    yS(i+1) = max(yS(i+1), 0);
    yR(i+1) = max(yR(i+1), 0);
    
    yS(i+1) = min(yS(i+1), 10000);
    yR(i+1) = min(yR(i+1), 10000);
    
    PSA(i+1) = yS(i+1) + yR(i+1);

    t_NewAdaptive(i+1) = i+1;

    
    %% If we know the max, do the algorithm. If we haven't reached the max, then just keep it 0.
    if PSAmaxFoundFlag == 1
                
        %% If greater than max turn it on. If less than cutoff turn it off. If neither then leave it what it was.
        if PSA(i+1) > PSAmax
            integerTime_u(i+1) = 1;
            
        elseif PSA(i+1) < PSAmax * adaptivePercent
            integerTime_u(i+1) = 0;
            
        else
            integerTime_u(i+1) = integerTime_u(i);
            
        end
        
    else
        integerTime_u(i+1) = integerTime_u(i);
    end
    
end


end

function [dydt] = systemState(yS, yR, u, optimizationParams)

rS = 0.0156 * optimizationParams(4);
rR = 0.0091 * optimizationParams(4);

beta  = optimizationParams(3);

%% ______________________________________________________________%%
%% ODE %%
dydtS = yS*rS*(1- ( (yS + yR)/(10000-9500*u) ) );
dydtR = yR*rR*(1- ( (beta*yS + yR) / 10000) );

dydt = [dydtS, dydtR];

end