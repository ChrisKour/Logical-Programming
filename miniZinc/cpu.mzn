enum TASK = {A,B,C,D};

array[TASK] of int : load = [60,30,50,40];
array[TASK] of int : duration = [2,1,2,5];
int : max_d = sum(duration);
set of int : TIME = 0..max_d;

array[TASK] of var TIME : start;
array[TASK] of var TIME : end;
constraint forall(t in TASK)(end[t] = start[t] + duration[t]);

include "globals.mzn";
constraint cumulative(start,duration,load,100);

var int : totalTime;
constraint totalTime = max(end);

solve minimize totalTime;

output["start = \(start);\ntotalTime = \(totalTime);"];