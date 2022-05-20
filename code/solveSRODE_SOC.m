function [yS, yR, PSA, integerTime_u, t_NewSOC] = solveSRODE_SOC(optimizationParams, t_max, t_firstAbi)

nRKsteps = t_max * 6;

h = t_max/nRKsteps;

yS = optimizationParams(1);
yR = optimizationParams(2);

PSA = yS + yR;

t_NewSOC = 1;

% Create SOC treatment.
integerTime_u = zeros(1750, 1);
integerTime_u(t_firstAbi:end) = 1;

%% Here I am using three times the absolute maximum time reached during the trial. 
for i = 1:1:1750
    
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
    
    t_NewSOC(i+1) = i+1;


end


end

function [dydt] = systemState(yS, yR, u, optimizationParams)

alpha  = optimizationParams(3);

rS = 0.0156 * optimizationParams(4);
rR = 0.0091 * optimizationParams(4);

%% ______________________________________________________________%%
%% ODE %%
dydtS = yS*rS*(1- ( (yS + yR)/(10000-9500*u) ) );
dydtR = yR*rR*(1- ( (alpha*yS + yR) / 10000) );

dydt = [dydtS, dydtR];

end