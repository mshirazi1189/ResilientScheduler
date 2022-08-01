function [Sum_Gamma_h_k_c, Sum_Pow_Gamma_h_k_c] = Calculate_Sum_Gamma(Rate, pl)
    global n;%Numer of Tasks
    global Hyperperiod;%Hyperperiod Length
    global e;%execution times
    global pi;%periods
    global pow;%power consumptions
    Sum_Gamma_h_k_c = 0;
    for i=1:n
        if pow(i, pl) > Rate
            Sum_Gamma_h_k_c = Sum_Gamma_h_k_c + e(i, pl)*Hyperperiod/pi(i);
        end
    end
    
    Sum_Pow_Gamma_h_k_c = 0;
    for i=1:n
        if pow(i, pl) > Rate
            Sum_Pow_Gamma_h_k_c = Sum_Pow_Gamma_h_k_c + pow(i, pl)*e(i, pl)*Hyperperiod/pi(i);
        end
    end
end