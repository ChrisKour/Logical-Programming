nFl = 7; 
FLOOR = {a1,a2,a3,a4,a5,a6,a7};
buildWrks = [12,12,10,11,12,14,14];
buildDur = [12,5,10,5,5,10,5];
elecWrks = [10,5,7,3,3,2,1];
elecDur = [10,30,20,25,40,15,25];
plumbingWrks = [4,3,2,5,3,4,3];
plumbingDur = [8,11,18,14,14,13,9];
finishWrks = [3,4,4,6,5,4,4];
finishDur = [10,25,23,10,9,3,13];

int :nFl;
enum FLOOR;
array[FLOOR] of int :buildWrks; 
array[FLOOR] of int :buildDur;
array[FLOOR] of int :elecWrks;
array[FLOOR] of int :elecDur;
array[FLOOR] of int :plumbingWrks;
array[FLOOR] of int :plumbingDur ;
array[FLOOR] of int :finishWrks;
array[FLOOR] of int :finishDur; 

set of int : TIME = 50..140;
array[FLOOR] of var TIME : startB;
array[FLOOR] of var TIME : startE;
array[FLOOR] of var TIME : startP;
array[FLOOR] of var TIME : startF;

array[FLOOR] of var TIME : endB;
array[FLOOR] of var TIME : endE;
array[FLOOR] of var TIME : endP;
array[FLOOR] of var TIME : endF;

constraint forall(f in FLOOR)(endB[f] = startB[f] + buildDur[f]);
constraint forall(f in FLOOR)(endE[f] = startE[f] + elecDur[f]);
constraint forall(f in FLOOR)(endP[f] = startP[f] + plumbingDur[f]);
constraint forall(f in FLOOR)(endF[f] = startF[f] + finishDur[f]);

constraint forall(f in FLOOR)(startE[f] >= endB[f]);
constraint forall(f in FLOOR)(startP[f] >= endB[f]);
constraint forall(f in FLOOR)(startF[f] >= endB[f]);

constraint forall(f,l in FLOOR)((startB[f] <= startF[l] /\ startF[l] < endB[f]) -> (buildWrks[f] + finishWrks[l] <= builders));
constraint forall(f,l in FLOOR)((startF[f] <= startB[l] /\ startB[l] < endF[f]) -> (buildWrks[l] + finishWrks[f] <= builders));

constraint forall(f in FLOOR where f < max(FLOOR))(endB[f] <= startB[enum_next(FLOOR,f)]);
constraint forall(f in FLOOR)(startF[f] >= max(endE[f],endP[f]));

var int : builders;
var int : electricians;
var int : plumbers;
var int : total;
constraint total = builders + electricians + plumbers;

include "globals.mzn";
constraint cumulative(startB,buildDur,buildWrks,builders);
constraint cumulative(startE,elecDur,elecWrks,electricians);
constraint cumulative(startP,plumbingDur,plumbingWrks,plumbers);
constraint cumulative(startF,finishDur,finishWrks,builders);

solve minimize total;
output["startB = \(startB);\n"]++
      ["startE = \(startE);\n"]++
      ["startP = \(startP);\n"]++
      ["startF = \(startF);\n"]++
      ["builders = \(builders);\n"]++
      ["electricians = \(electricians);\n"]++
      ["plumbers = \(plumbers);\n"];