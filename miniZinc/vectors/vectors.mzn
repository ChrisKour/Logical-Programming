%%% Vectors

int : vlen;
set of int : LEN  = 1..vlen;
set of int : VECS = 1..2;
array[VECS,LEN] of int : vector;

%%% Add your code here
array[LEN] of var int : total;
array[LEN,LEN] of var int : apot;
array[LEN] of var LEN : index;

constraint forall(i,l in LEN)(apot[i,l] = vector[1,i] * vector[2,l] * abs(i-l));

include "alldifferent.mzn";
constraint alldifferent(index);

constraint forall(i in LEN)(total[i] = apot[i,index[i]]);

var int : sumTotal;
constraint sumTotal = sum(total);

solve minimize sumTotal;

output["vector\(i) = \(row(vector,i));\n" | i in VECS]++
      ["sumTotal = \(sumTotal);"];