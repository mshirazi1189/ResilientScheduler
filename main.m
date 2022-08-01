function [PerformanceLevels, HPBoundariesEnergy, SurpriseHistory] = main()

global log_file;
global LifeTime;
global Emax;
Emax = Emax * 1000;
global H;
global DeltaS;
global ECatPerformanceLevels;
global Rates;
global PredictedRates;
global Pow_s;

Rates = Rates - (Pow_s/1000);
PredictedRates = PredictedRates - (Pow_s/1000);
%% Surprises
global Surprises;
NOSurprises = size(Surprises, 2);
SurpriseHistory = zeros(5, NOSurprises);%To save the history of surprises as (h, Ehat(h), E(h), Severity, NTTR(h))

%% Start Running
IE = Emax;%Amount of energy in the storage unit at time 0
PerformanceLevels = [];
SurpriseMode = false;
CurrentSurpriseIndex = 1;
HPBoundariesEnergy = [IE];
fprintf(log_file, '-------------------------------------------------\n');
fprintf(log_file, 'Start running for %d hyperperiods\n', LifeTime);
fprintf(log_file, '-------------------------------------------------\n');
h=1;
LSurprise = -(DeltaS + 1);%Last surprise occured at hyperperiod LSurprise
while h<=LifeTime    
    R = Rates(1, h:h+H-1);
    Rhat = PredictedRates(1, h:h+H-1);
    
    fprintf(log_file, 'h=%d \n', h);
    if SurpriseMode == true
        TargetEhat = Ehat(3:3+DeltaS-1);
        fprintf(log_file, '**The scheduler is in surprise state**\n');      
        [SelectedPerformanceLevels, TTR] = SurpriseModeScheduler(IE, TargetEhat, R(1, 1:DeltaS), Severity, ECatPerformanceLevels);
        if TTR == -1 %Unable to perform the recovery
            fprintf(log_file, 'Unable to perform the recovery.\n');
            break;
        end
       
        fprintf(log_file, 'Computed Performance levels with TTR of %d are as follows:\n', TTR);
        fprintf(log_file, '%d\n', SelectedPerformanceLevels);
        plFind = true;
        
        for temp_h=h:h+TTR-1 
            pl = SelectedPerformanceLevels(temp_h-h+1);
            PerformanceLevels = [PerformanceLevels pl];
                       
            [Schedule, E, DeadlineMiss] = PFPASAP(IE, R(temp_h-h+1), pl, true);
            if DeadlineMiss > 0
                fprintf(log_file, 'There is a deadline miss with IE=%d, Rate=%d, pl=%d\n', IE, R(temp_h-h+1), pl);
                fprintf(log_file, 'more information:\n');
                fprintf(log_file, 'expectedEC: %d', EChat);
                fprintf(log_file, 'expectedE: %d', Ehat);
                plFind = false;
                break;
            end
            
             fprintf(log_file, 'SurpriseState --> h=%d, Performance level=%d\n',...
                temp_h, pl);
            IE = E(end);
            HPBoundariesEnergy = [HPBoundariesEnergy IE];
            if E(end) >= TargetEhat(temp_h-h+1) %The recovery is done
                TTR = temp_h-h+1;
                SurpriseHistory(5, CurrentSurpriseIndex) = TTR;
                CurrentSurpriseIndex = CurrentSurpriseIndex + 1;
                break;
            end
        end
        if plFind == false
            break;
        end
        h=h+TTR-1;
        SurpriseMode = false;
    else %There was no surprise at previous hyperperiod, i.e. h-1.
        [EChat, Ehat] = LP(h, IE, Rhat, LSurprise);
        if EChat == -1
            return;
        end
        [pl] = FindPerformanceLevel(IE, Rhat(1), EChat(1), ECatPerformanceLevels);
        if pl < 0
            fprintf(log_file, 'cannot find the performance level!');
            break;
        end
                
        PerformanceLevels = [PerformanceLevels pl];
        fprintf(log_file, 'Performance level=%d.\n', pl);
        
        %%Schedule the task set at pl with actual harveting rate      
        [Schedule, E, DeadlineMiss] = PFPASAP(IE, R(1), pl, true);
        if DeadlineMiss > 0
            fprintf(log_file, 'There is a deadline miss with IE=%d, Rate=%d, pl=%d\n', IE, R(h), pl);
            fprintf(log_file, 'more information:\n');
            fprintf(log_file, 'expectedEC: %d', EChat);
            fprintf(log_file, 'expectedE: %d', Ehat);   
            break;
        end
                
        %%Check for Surprises
        if R(1) < Rhat(1) && E(end) < Ehat(2) %there is a surprise
            SurpriseMode = true;
            LSurprise = h;
            Severity = (Ehat(2) - E(end))/Ehat(2);
            SurpriseHistory(1, CurrentSurpriseIndex) = h;
            SurpriseHistory(2, CurrentSurpriseIndex) = Ehat(2);
            SurpriseHistory(3, CurrentSurpriseIndex) = E(end); 
            SurpriseHistory(4, CurrentSurpriseIndex) = Severity;
            
            fprintf(log_file, 'There was a surprise at hyperperiod %d (R=%d, Rhat=%d, E=%d, Ehat=%d, severity=%d). \n', ...
                h, R(1), Rhat(1), E(end), Ehat(2), Severity);
        else
            fprintf(log_file, 'There was no surprise at hyperperiod %d.\n', h);
        end
        
        %%Set value for the storage unit energy at hyperperiod bouandaries
        IE = E(end);
        HPBoundariesEnergy = [HPBoundariesEnergy IE];
    end      
    h = h+1;
    fprintf(log_file, '-------------------------------------------------\n');
end
fprintf(log_file, 'End of lifetime.\n');

end