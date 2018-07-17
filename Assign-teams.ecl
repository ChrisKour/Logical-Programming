:-use_module(library(ic)).
:-use_module(library(branch_and_bound)). 

assign_teams(Workers,Cost):-
	Workers = [A,B,C,D,E,F],
	Thesis = [1,2,3,4,5,6],
	Starts = [StA,StB,StC,StD,StE,StF],
	Ends = [E1,E2,E3,E4,E5,E6],
	Starts #:: 0..inf,
	Ends #:: 0..inf,
	StA #= 5,
	StB #= 6,
	StC #= 2,
	StD #= 4,
	StE #= 0,
	StF #= 3,
	element(I1,Thesis,A), element(I1,[3,4,1,3,5,6],C1),
	element(I2,Thesis,B), element(I2,[4,1,3,2,1,2 ],C2),
	element(I3,Thesis,C), element(I3,[2,1,4,5,2,1 ],C3),
	element(I4,Thesis,D), element(I4,[3,3,2,1,9,4],C4),
	element(I5,Thesis,E), element(I5,[6,2,1,3,4,7 ],C5),
	element(I6,Thesis,F), element(I6,[6,2,3,8,9,11],C6),
	alldifferent(Workers),
	E1 #= StA + C1,
	E2 #= StB + C2,
	E3 #= StC + C3,
	E4 #= StD + C4,
	E5 #= StE + C5,
	E6 #= StF + C6,
	Cost #= 14*E1+3*E2+6*E3+2*E4+8*E5+10*E6,
	bb_min(labeling(Workers),Cost,_).