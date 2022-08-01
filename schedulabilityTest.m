function [isSchedulable] = schedulabilityTest(IE, Rate, pl)

global n;%Numer of Tasks
global Hyperperiod;%Hyperperiod Length
global e;%execution times
global pi;%periods
global pow;%power consumptions

sum = 0;
for i=1:n
    sum = sum + e(i, pl)*Hyperperiod/pi(i);
end

ConsumingTask_EnergyConsumption = 0;
for i=1:n
    if pow(i, pl) > Rate
        ConsumingTask_EnergyConsumption = ConsumingTask_EnergyConsumption + ...
            pow(i, pl)*e(i, pl)*Hyperperiod/pi(i);
    end    
end

isSchedulable = false;
if IE + Rate*sum - ConsumingTask_EnergyConsumption >= 0
    isSchedulable = true;
end

end