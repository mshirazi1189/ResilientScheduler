function [ECatPerformanceLevels] = ECsAtAllPerformanceLevels()
    
    global n;%Numer of Tasks
    global L;%Maximum performance level
    global Hyperperiod;%Hyperperiod Length
    global e;%execution times
    global pi;%periods
    global pow;%power consumptions    

    ECatPerformanceLevels = zeros(L, 1);
    for pl=1:L
        tempEC = 0;
        for i=1:n
            tempEC = tempEC + (Hyperperiod/pi(i))*e(i, pl)*pow(i, pl);
        end
        ECatPerformanceLevels(pl, 1) = tempEC;
    end
end