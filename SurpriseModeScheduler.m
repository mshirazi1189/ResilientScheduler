function [performanceLevels, TTR] = SurpriseModeScheduler(IE, Ehat, nextRates, Severity, ECatPerformanceLevels)

global Hyperperiod;
global DeltaS;
global Emax;

TTR = -1;
RTStart = ceil(DeltaS*Severity);
for RT=RTStart:DeltaS 
    R = 0;
    for j=1:RT
        R=R+nextRates(j);
    end
    BRT = IE + R*Hyperperiod - Ehat(RT);    

    hpBudgets = zeros(1, RT);
    for j=1:RT
        hpBudgets(j) = floor((nextRates(j)/R)*BRT);
    end
    if min(hpBudgets) < ECatPerformanceLevels(1)
        for j=1:RT
            hpBudgets(j) = floor(BRT/RT);
        end        
    end

    tempIE = IE;
    isFeasible = true;
    pls = zeros(1, RT);
    for j=1:RT
        pls(j) = FindPerformanceLevel(tempIE, nextRates(j), hpBudgets(j), ECatPerformanceLevels);
        if pls(j) > 0
            tempIE = min([tempIE + nextRates(j)*Hyperperiod - ECatPerformanceLevels(pls(j)), Emax]);
        else
            isFeasible = false;
            break;
        end
    end
    
    if isFeasible
        performanceLevels = pls;
        TTR = RT;        
        break;
    end
    
end

if isFeasible == false
    performanceLevels = ones(1, DeltaS);
    TTR = DeltaS;
end

end