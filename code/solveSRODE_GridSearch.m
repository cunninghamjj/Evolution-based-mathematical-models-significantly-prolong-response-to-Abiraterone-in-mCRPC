function [yS, yR, PSA] = solveSRODE_GridSearch(optimizationParams, t_max, integerTime_u, rScale, beta)

nRKsteps = t_max * 6;

h = t_max/nRKsteps;

yS = optimizationParams(1);
yR = optimizationParams(2);

PSA = yS + yR;

for i = 1:1:t_max - 1
    
    [k1] = h .* systemState(yS(i), yR(i), integerTime_u(i), rScale, beta);
    [k2] = h .* systemState(yS(i) + k1(1)/2, yR(i)+ k1(2)/2, integerTime_u(i), rScale, beta);
    [k3] = h .* systemState(yS(i) + k2(1)/2, yR(i)+ k2(2)/2, integerTime_u(i), rScale, beta);
    [k4] = h .* systemState(yS(i) + k3(1), yR(i) + k3(2), integerTime_u(i), rScale, beta);
    
    yS(i+1) = yS(i) + (k1(1)+2*(k2(1)+k3(1))+k4(1))/6;
    yR(i+1) = yR(i) + (k1(2)+2*(k2(2)+k3(2))+k4(2))/6;
    
    yS(i+1) = max(yS(i+1), 0);
    yR(i+1) = max(yR(i+1), 0);
    
    yS(i+1) = min(yS(i+1), 10000);
    yR(i+1) = min(yR(i+1), 10000);
    
    PSA(i+1) = yS(i+1) + yR(i+1);
end


end

%% For grid search.
function [dydt] = systemState(yS, yR, u, rScale, beta)

rS = 0.0156 * rScale;
rR = 0.0091 * rScale;

%% ______________________________________________________________%%
%% ODE %% 
dydtS = yS*rS*(1- ( (yS + yR)/(10000-9500*u) ) );
dydtR = yR*rR*(1- ( (beta*yS + yR) / 10000) );

dydt = [dydtS, dydtR];

end