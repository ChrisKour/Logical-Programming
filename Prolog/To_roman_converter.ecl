toroman(1,[i]).
toroman(4,[i,v]).
toroman(5,[v]).
toroman(9,[i,x]).
toroman(10,[x]).
toroman(40,[x,l]).
toroman(50,[l]).
toroman(90,[x,c]).
toroman(100,[c]).
toroman(400,[c,d]).
toroman(500,[d]).
toroman(900,[c,m]).
toroman(1000,[m]).

toroman(Value,[i|List]):-
	Value < 4,
	Value > 0,
	NewValue is Value -1,
	toroman(NewValue,List).

toroman(Value,[v|List]):-
	Value < 9,
	Value > 0,
	NewValue is Value -5,
	toroman(NewValue,List).

toroman(Value,[x|List]):-
	Value < 40,
	Value > 0,
	NewValue is Value -10,
	toroman(NewValue,List).

toroman(Value,[x,l|List]):-
	Value < 50,
	Value > 0,
	NewValue is Value -40,
	toroman(NewValue,List).

toroman(Value,[l|List]):-
	Value < 90,
	Value > 0,
	NewValue is Value -50,
	toroman(NewValue,List).

toroman(Value,[x,c|List]):-
	Value < 100,
	Value > 0,
	NewValue is Value -90,
	toroman(NewValue,List).

toroman(Value,[c|List]):-
	Value < 400,
	Value > 0,
	NewValue is Value -100,
	toroman(NewValue,List).

toroman(Value,[c,d|List]):-
	Value < 500,
	Value > 0,
	NewValue is Value -400,
	toroman(NewValue,List).

toroman(Value,[d|List]):-
	Value < 900,
	Value > 0,
	NewValue is Value -500,
	toroman(NewValue,List).

toroman(Value,[c,m|List]):-
	Value < 1000,
	Value > 0,
	NewValue is Value -900,
	toroman(NewValue,List).

toroman(Value,[m|List]):-
	Value >= 1000,
	NewValue is Value -1000,
	toroman(NewValue,List).

line(anemos,[mon,tue,wed,fri],[athens,syros,paros,naxos]).
line(maria,[mon,tue,thu],[naxos,amorgos,santorini]).
line(minos,[tue,fri],[paros,syros,andros,tinos]).
line(pelagos,[mon,wed,fri],[amorgos,ios,milos]).

sched(anemos,[athens(06),syros(10),paros(12),naxos(13)]).
sched(maria,[naxos(13),amorgos(17),santorini(19)]).
sched(minos,[paros(13),syros(15),andros(17),tinos(19)] ).
sched(pelagos,[amorgos(15),ios(17),milos(20)]).

connects(Dep,Des,Day,ship(Ship,Dep,Des)):-
	line(Ship,Days,Destinations),
	append(Front,End,Destinations),
	member(Dep,Front),
	member(Des,End),
	member(Day,Days).

find_trip(Dep,Des,Day,[Trip]):-
	connects(Dep,Des,Day,Trip).

find_trip(Dep,Des,Day,[ship(Ship,Dep,X)|T]):-
	connects(Dep,X,Day,ship(Ship,Dep,X)),
	find_trip(X,Des,Day,T,[Ship]).

find_trip(Dep,Des,Day,[ship(Ship,Dep,Des)],PreviousShips):-
	connects(Dep,Des,Day,ship(Ship,Dep,Des)),
	\+ member(Ship,PreviousShips).

find_trip(Dep,Des,Day,[ship(Ship,Dep,X)|T],PreviousShips):-
	connects(Dep,X,Day,ship(Ship,Dep,X)),
	\+ member(Ship,PreviousShips),
	find_trip(X,Des,Day,T,[Ship|PreviousShips]).

arrival(ship(Ship,_,Des),Arr):-
	sched(Ship,Locations),
	C =..[Des,Arr],
	member(C,Locations).

departure(ship(Ship,Depar,_),Dep):-
	sched(Ship,Locations),
	C =..[Depar,X],
	member(C,Locations),
	Dep is X+1.

valid_trip([_]).

valid_trip([ship(Ship,Dep,Des),ship(Ship2,Des,Des2)|List]):-
	find_trip(Dep,Des2,_,[ship(Ship,Dep,Des),ship(Ship2,Des,Des2)]),
	arrival(ship(Ship,Dep,Des),Arr),
	departure(ship(Ship2,Des,Des2),DepTime),
	Arr<DepTime,
	valid_trip([ship(Ship2,Des,Des2)|List]).

all_ports(P):-
	findall(Y,(line(_,_,Locations),member(Y,Locations)),List),
	setof(X,member(X,List),P).

connection_ports(L):-
	all_ports(P),
	findall(X,(line(Ship1,_,Destinations1),line(Ship2,_,Destinations2),member(X,P),member(X,Destinations1),member(X,Destinations2),Ship1\=Ship2),List),
	setof(Y,member(Y,List),L).
	
