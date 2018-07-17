
int : nCars = 6;
set of int : CARS = 1..nCars;

array[CARS] of int: elecTime = [210,90,200,125,115,15];
array[CARS] of int: mechTime = [130,150,120,80,120,135];
array[CARS] of int: washTime = [20,10,10,10,20,20];

%%% Add your code here
set of int : TIME = 0..480;
array[CARS] of var TIME : startE;
array[CARS] of var TIME : startM;
array[CARS] of var TIME : startW;

array[CARS] of var TIME : endE;
array[CARS] of var TIME : endM;
array[CARS] of var TIME : endW;

constraint forall(c in CARS)(endE[c] = startE[c] + elecTime[c]);
constraint forall(c in CARS)(endM[c] = startM[c] + mechTime[c]);
constraint forall(c in CARS)(endW[c] = startW[c] + washTime[c]);

include "globals.mzn";
constraint cumulative(startE,elecTime,[1,1,1,1,1,1],3);
constraint cumulative(startM,mechTime,[1,1,1,1,1,1],2);
constraint cumulative(startW,washTime,[1,1,1,1,1,1],2);

constraint forall(c in CARS)(startW[c] >= max(endE[c],endM[c]));
constraint forall(c in CARS)(startE[c] >= endM[c] \/ startM[c] >= endE[c]);

var int : makespan;
constraint makespan = max(endW);

solve minimize makespan;
output["makespan = \(makespan);\nstartE = \(startE);\nstartM = \(startM);\nstartW = \(startW);"];