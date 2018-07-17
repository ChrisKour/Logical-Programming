nDays = 15;
nGen = 5;

include "globals.mzn";
%% number of days
int : nDays;
set of int : PERIOD = 1..nDays;
%% number of generators
int : nGen;
set of int : GEN = 1..nGen;
% Power Production
array[GEN] of int : power25 = [20,25,15,30,40];
% Modes  
enum MODE = {L025,L050,L100,SHDN};

int : ns = 6;
set of int : STATE = 1..ns;

array[STATE,MODE] of int : allowed = 
    [|2, 0, 0, 1
     |0, 3, 4, 0
     |0, 4, 6, 0
     |0, 6, 5, 0
     |0, 0, 0, 1
     |0, 5, 0, 0|];
     
array[GEN,PERIOD] of var MODE: schedule;
constraint forall(g in GEN)(regular(row(schedule,g),ns,card(MODE),allowed,1,STATE));

array[PERIOD] of var int : production;
constraint forall(p in PERIOD)(production[p] = sum([if schedule[g,p] == L025 then power25[g] elseif schedule[g,p] == L050 then power25[g]*2 elseif schedule[g,p] == L100 then power25[g]*4 else 0 endif| g in GEN]));

constraint forall(p in PERIOD where p > 1)(production[p] >= 150);
constraint forall(p in PERIOD where p > 1)(production[p] <= 200);

solve satisfy;

output[show_int(5,d) | d in PERIOD ] ++ ["\n"] ++
       [" \(schedule[t,d])" ++ if (d==card(PERIOD)) then "\n" else "" endif | t in GEN, d in PERIOD] ++
       [" -Power Production----------"] ++ ["\n"] ++ 
       [show_int(5,production[d])| d in PERIOD ] ++ ["\n\n"] ++ 
       [" -Data in Tables------------"]++ ["\n"] ++ 
       ["schedule=\(schedule);"] ++ ["\n\n"] ++
       ["production=\(production);"];