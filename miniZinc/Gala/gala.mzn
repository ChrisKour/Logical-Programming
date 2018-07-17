%%% Number of Guests N            
int :N;
set of int: GUESTS  = 1..N;
set of int: POSITIONS = 1..N;
%%% Gender Array
array[GUESTS] of 1..2 : gender;
%%% Hobbies Array
array[GUESTS] of set of int: hobbies;

%%% Enemies (Part B)
enum PAIR = {first,second};
int : pR;
set of int: LIST = 1..pR;
array[LIST,PAIR] of GUESTS : furious;

%%% Decision variables 
%%% Array that demonstrates which guest is at each position
array[POSITIONS] of var GUESTS : guest_at;

%%% The gender at each position. 
array[POSITIONS] of var 1..2: table_gender;
%%% Add your code here
include "alldifferent.mzn";
constraint alldifferent(guest_at);

constraint forall(p in POSITIONS)(table_gender[p] = gender[guest_at[p]]);

constraint forall(p in POSITIONS where p < N)(table_gender[p] != table_gender[p+1]);
constraint table_gender[1] != table_gender[N];

constraint forall(p in POSITIONS where p < N)(card(hobbies[guest_at[p]] intersect hobbies[guest_at[p+1]]) > 0);
constraint card(hobbies[guest_at[1]] intersect hobbies[guest_at[N]]) > 0;

constraint forall(l in LIST,p in PAIR)(guest_at[1] != furious[l,p]);
constraint forall(l in LIST,p in PAIR)(guest_at[N] != furious[l,p]);

constraint forall(p in POSITIONS,l in LIST where p>1 /\ p<N)(guest_at[p] = furious[l,first] -> guest_at[p+1] != furious[l,second] /\ guest_at[p-1] != furious[l,second]);

solve satisfy;
output 
       ["guest_at = \(guest_at);"]
       ++ ["\ntable_gender = \(table_gender); \n" ] 
       ++ ["Furious Placement\n"]
       ++ [show_int(4,furious[i,j]) | i in LIST, j in PAIR] ++["\n"] 
       ++ [if fix(guest_at[p]) = furious[i,j] then show_int(4,p) else "" endif | i in LIST, j in PAIR, p in POSITIONS];