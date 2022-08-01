function [EChat, Ehat] = LP(h, IE, Rhat, LSurprise)

global n;%Numer of Tasks
global Hyperperiod;%Hyperperiod Length
global e;%execution times
global pi;%periods
global pow;%power consumptions

global H;%Prediction time horizon (hyperperiods)
global DeltaS;%Delta_s
global EpsilonMax;
global Emax;%Storage unit capacity
global log_file;

%% Set fixed variables of LP ------------------------------------------------
EC1 = 0;
for i=1:n
    EC1 = EC1 + (pow(i, 1)*e(i, 1)*(Hyperperiod/pi(i)));
end

B = zeros(1,H);
for j=1:DeltaS
    B(j) = 1;
end

E=sdpvar(H+1,1);
EC = sdpvar(H, 1);

Rate = (1- EpsilonMax)*Rhat;
for i=1:(DeltaS+LSurprise+1)-h
    Rate(i) = Rhat(i);
end

%% Set the constraints -----------------------------------------------------
constraints = [];
constraints = [constraints E(1) == IE];

%\hat{E}((h+k+1)\Pi) = \hat{E}((h+k)\Pi) + \hat{R}_{h+k}\Pi - \hat{EC}_{h+k}, 
%forall 0 \leq k \leq H-1
for i=1:H
    constraints = [constraints E(i+1) == E(i) + Rhat(i)*Hyperperiod - EC(i)];
end

%\hat E((h+k)\Pi)+ 
%  Rate_{h+k} \sum_{\tau_i \in \Gamma^{h+k}_c}^{}{e_{i1}\frac{\Pi}{\pi_i}}  
%  -\sum_{\tau_i \in \Gamma^{h+k}_c}^{}{e_{i1}pow_i\frac{\Pi}{\pi_i}}\geq 0
%\forall 1 \leq k \leq H-1
for i=1:H-1 
    [Sum_Gamma_h_k_c, Sum_Pow_Gamma_h_k_c] = Calculate_Sum_Gamma(Rate(i+1), 1);%for l = one
    constraints = [constraints E(i+1) + Rate(i+1)*Sum_Gamma_h_k_c - Sum_Pow_Gamma_h_k_c >= 0];
end

%E(h\Pi)+ Rate_{h} \sum_{\tau_i \in \Gamma^{h}_c}^{}{e_{il}\frac{\Pi}{\pi_i}} 
%- \sum_{\tau_i \in \Gamma^{h}_c}^{}{e_{il}pow_i\frac{\Pi}{\pi_i}} \geq 0

[Sum_Gamma_h_k_c, Sum_Pow_Gamma_h_k_c] = Calculate_Sum_Gamma(Rate(1), 1);
constraints = [constraints E(1) + Rate(1)*Sum_Gamma_h_k_c - Sum_Pow_Gamma_h_k_c >= 0 ];

%\sum_{k=1}^{\Delta_s}{\hat{EC}_{h+k}} \geq 
%\epsilon_{max} \hat{R}_h \Pi +
%\Delta_s \sum_{\tau_i \in \Gamma}^{}{e_{i1}pow_i\frac{\Pi}{\pi_i}}, \\
%Delta_s - k' < 0
[Sum_Gamma_h_k_c, Sum_Pow_Gamma_h_k_c] = Calculate_Sum_Gamma(Rate(1), 1);
if h > DeltaS + LSurprise
    constraints = [constraints (B * EC) >= EpsilonMax*Rhat(1)*Hyperperiod + ...
        DeltaS*Sum_Pow_Gamma_h_k_c];
end

for i=1:H 
    constraints = [constraints EC(i) >= EC1];
end


for i=1:H+1 
    constraints = [constraints E(i) >= 0];
end

for i=1:H+1
    constraints = [constraints E(i) <= Emax];
end

%% Objective ----------------------------------------------------------------
objective = sum(EC);

%% Optimization -------------------------------------------------------------
options = sdpsettings('verbose',0, 'cachesolvers', 1);
sol = optimize(constraints,objective, options);

%%Set Result ---------------------------------------------------------------
if sol.problem == 0
    EChat = value(EC);
    Ehat = value(E);
else
    fprintf(log_file, '%s %s\n', sol.problem, sol.info);    
    EChat = -1;
    Ehat = -1;
end


end