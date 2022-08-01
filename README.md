# ResilientScheduler
Based on the journal paper "Energy-Resilient Real-Time Scheduling" by M. Shirazi, L. Thiele, and M. Kargahi, submitted to IEEE Transaction on Computers, Special Issue on Real-Time System.

# Quick Start
1) download "yalmip" from https://yalmip.github.io/
2) add yalmip path to Matlab
3) Run the file "Run.m"

# Inputs
The inputs are in "Data" directory include:
1) the harvested rates in Data/Rates/Rates.mat, and
2) the task set parameters in Data/Taskset:
     * e_1.txt => WCET of the tasks at different performance levels
     * pi_1.txt => period of the tasks
     * pow_1.txt => power consumption of the tasks at different performance levels
     
In all of the above-mentioned files, each row corresponds to a task and each column corresponds to a performance level.

# Outpus
The outputs include:
1) a log file in "log" directory which saves the details of the schedule at each hyperperiod, and
2) three files in "Output" directory:
    - SurpriseHistory: the information about the surprises (where the surprise happened, its severity, TTR, etc.)
    - PerformanceLevels: the selected performance levels by resilient scheduler
    - HPBoundariesEnergy: the amout of energy in the storage unit at hyperperiod boundaries

# Parameters
The parameters, such as Emax (storage unit capacity), H (prediction time horizon), EpsilonMax, DeltaS, and Pow_s (static power consumption) can be set in "Run.m" file.
