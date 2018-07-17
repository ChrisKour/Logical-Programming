:-use_module(library(ic)).
:-use_module(library(ic_global)).
:-use_module(library(branch_and_bound)). 
:-use_module(library(ic_edge_finder)).

order(product(a),24).
order(product(b),16).
order(product(c),19).
order(product(d),22).

workload(product(a),8,3).
workload(product(b),9,5).
workload(product(c),9,3).
workload(product(d),8,4).

my_workplan(W,S):-
	findall(X,order(_,X),Deadlines),
	findall(Y,workload(_,Y,_),DaysProd),
	findall(Z,workload(_,_,Z),HoursProd),
	findall(B,order(B,_),Names),
	length(Deadlines,N),
	length(Starts,N),
	length(Ends,N),
	Starts #:: 0..inf,
	Ends #:: 0..inf,
	constraint(Starts,Ends,DaysProd,Deadlines,Costs),
	sumlist(Costs,Cost),
	cumulative(Starts,DaysProd,HoursProd,8),
	bb_min(labeling(Starts),Cost,bb_options{strategy:restart}),
	print(Names,Starts,W),
	ic_global:minlist(Starts,S).

constraint([],[],[],[],[]).
constraint([S|Starts],[E|Ends],[D|Days],[Dead|Deadline],[C|Costs]):-
	E #= S+D,
	E #< Dead,
	C #= D-E,
	constraint(Starts,Ends,Days,Deadline,Costs).

print([],[],[]).
print([N|Names],[S|Starts],[start(N, S)|Rest]):-
	print(Names,Starts,Rest).
