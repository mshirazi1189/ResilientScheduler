function LoadTaskSet(TaskSetIndex)
global n;
global L;
global Hyperperiod;
global e;
global pi;
global pow;
global TaskSetRootPath;%TaskSet Path

e=load([TaskSetRootPath 'e_' num2str(TaskSetIndex) '.txt']);%WCETs of the tasks
pi=load([TaskSetRootPath 'pi_' num2str(TaskSetIndex) '.txt']);%Periods of the tasks
pow=load([TaskSetRootPath 'pow_' num2str(TaskSetIndex) '.txt']);%Power consumption of the
Hyperperiod = CalculateHyperperiod(pi);
L = size(e, 2);
n = size(e, 1);
end