%%Scheduling the tasks according to PFPF_ASAP within a hyperperiod 
%given
%-initial energy (InitialEnergy),
%-energy harvesting rate (Rate),
%-performance level (1 <= l <= L), and 
%-whether it should consider the storage unit capacity (LimitedStorageCapacity)
function [Schedule, E, DeadlineMiss] = PFPASAP(InitialEnergy, Rate, l, LimitedStorageCapacity)

global n;
global e;
global pi;
global pow;
global Hyperperiod;
global Emax;

E = zeros(1, Hyperperiod+1);
Schedule = zeros(1, Hyperperiod);
DeadlineMiss = 0;
E(1) = InitialEnergy;
ReadyJobCounter = zeros(1, n);
for t=0:Hyperperiod-1
    for i=1:n
        if mod(t, pi(i)) == 0
            if ReadyJobCounter(i) > 0
                DeadlineMiss = i;                
                return;
            end
            ReadyJobCounter(i) = ReadyJobCounter(i) + e(i, l);                       
        end
    end

    EC = 0;
    hasJob = 0;
    for i=1:n
        if ReadyJobCounter(i) > 0
            if E(t+1) + Rate >= pow(i, l)
                Schedule(t+1) = i;
                ReadyJobCounter(i) = ReadyJobCounter(i) - 1;
                EC = pow(i, l);
                hasJob = 1;                
            else
                hasJob = 0;
            end
            break;
        end
    end    
    if hasJob == 0
        Schedule(t+1) = 0;
        EC = 0;
    end
    E(t+2) = E(t+1) + Rate - EC;
    if(LimitedStorageCapacity && E(t+2) > Emax)
        E(t+2)= Emax;
    end
end

for i=1:n
    if ReadyJobCounter(i) > 0
        DeadlineMiss = i;                
        return;
    end
end
end