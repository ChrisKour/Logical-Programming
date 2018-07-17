%%% Allign Problem
array[int] of int : list1 = [2,3,4,10,22,11,17]; 
array[int] of int : list2 = [1,2,3,4,10,22,11,11,10,24]; 
array[int] of int : list3 = [2,3,4,5,10,23,10,22,11,17];

%% Add your code here.
int : adj = 3;
set of int : ADJACENT = 1..adj;

array[ADJACENT] of var int : values;
array[ADJACENT] of var int : indices;
var int : sum;

include "element.mzn";                         
constraint sum = sum(values);
include "alldifferent.mzn";
constraint alldifferent(values);

constraint element(indices[1],list1,values[1]) /\
           element(indices[2],list2,values[1]) /\
           element(indices[3],list3,values[1]);

constraint forall(i in ADJACENT where i < adj)(list1[indices[1]+i] = values[i+1]);
constraint forall(i in ADJACENT where i < adj)(list2[indices[2]+i] = values[i+1]);
constraint forall(i in ADJACENT where i < adj)(list3[indices[3]+i] = values[i+1]);

solve maximize sum;
output ["values = \(values);\n"]++
       ["indices = \(indices);\n"]++
       ["sum = \(sum);"];