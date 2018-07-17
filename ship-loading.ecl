:-use_module(library(ic)).
:-use_module(library(ic_global)).
:-use_module(library(branch_and_bound)). 
:-use_module(library(ic_edge_finder)).

ship_loading(V,L):-
	V = [StA,StB,StC,StD,StE],
	[StA,StB,StC,StD,StE] #:: 0..inf,
	StA + 2 #= Ea,
	StB + 1 #= Eb,
	StC + 3 #= Ec,
	StD + 2 #= Ed,
	StE + 3 #= Ee,
	cumulative([StA,StB,StC,StD,StE],[2,1,3,2,3],[150,180,230,130,200], 400),
	ic_global:maxlist([Ea,Eb,Ec,Ed,Ee],L),
	bb_min(labeling([StA,StB,StC,StD,StE]),L,bb_options{strategy:restart}).
