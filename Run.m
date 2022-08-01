%Resilient Scheduler
%M. Shirazi, L. Thiele, M. Kargahi, Energy-Resilient Real-Time Scheduling,
%IEEE Transaction on Computers, Special Issue on Real-Time Systems, 2022

clear all;
clc;

%% Input directory
global TaskSetRootPath;
TaskSetRootPath = './Data/TaskSet/';

global RatesRootPath;
RatesRootPath = './Data/Rates/';

%% General Parameters
global LifeTime;
LifeTime = 350;%in hyperperiods

global Emax;
Emax = 300000;

global H;%Prediction time horizon (hyperperiods)
H=21;

global EpsilonMax;%Maximum prediction method error
EpsilonMax = 0.5;

global DeltaS;%Delta_s
DeltaS = 5;       

global Pow_s;%Static power consumption
Pow_s = 40;
%% Load task set and compute energy consumption at each performance level
global n;%Numer of Tasks
global L;%Maximum performance level
global Hyperperiod;%Hyperperiod Length
global e;%Execution times
global pi;%Periods
global pow;%Power consumptions
LoadTaskSet(1); %Load task set from input files into global variables

global ECatPerformanceLevels; 
[ECatPerformanceLevels] = ECsAtAllPerformanceLevels();%total energy consumptions at each performance levels
%% Load Charging Rates
global Rates;
load([RatesRootPath 'Rates.mat']);%Load harvested energy rates

global PredictedRates;
global Surprises;
generateSurprises();%Generate surprises with EpsilonMax and set PredictedRates
%% log file
global log_file;

log_file = fopen('log/log.txt', 'a');
[PerformanceLevels, HPBoundariesEnergy, SurpriseHistory] = main();
fclose(log_file);
save(strcat('Output/SurpriseHistory_', num2str(EpsilonMax), '_', num2str(DeltaS), '.mat'), 'SurpriseHistory');
save(strcat('Output/PerformanceLevels_', num2str(EpsilonMax), '_', num2str(DeltaS), '.mat'), 'PerformanceLevels');
save(strcat('Output/HPBoundariesEnergy_', num2str(EpsilonMax), '_', num2str(DeltaS), '.mat'), 'HPBoundariesEnergy');

clear PerformanceLevels HPBoundariesEnergy SurpriseHistory


