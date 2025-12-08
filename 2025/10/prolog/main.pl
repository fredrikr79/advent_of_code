% [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
% [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
% [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
% -> 2 + 3 + 2 = 7

:- consult('example.pl').

% Keep your toggle functions
toggle(Ls, [], Ls).
toggle(Ls, [I|Is], Out) :-
    nth0(I, Ls, V), flip(V, F), set_nth0(I, Ls, F, T), toggle(T, Is, Out).
flip(0, 1). flip(1, 0).
set_nth0(0, [_|Rs], V, [V|Rs]).
set_nth0(N, [R|Rs], V, [R|Ts]) :- N > 0, N1 is N-1, set_nth0(N1, Rs, V, Ts).

% Simple iterative deepening - no visited states needed
solve(L, _, [], 0) :- maplist(=(1), L).
solve(L, Wires, [W|Rest], D) :-
    D > 0, member(W, Wires),
    toggle(L, W, L1),
    D1 is D - 1,
    solve(L1, Wires, Rest, D1).

% Find minimal solution
min_solve(L, Wires, Steps) :-
    between(0, 6, Depth),  % Limit depth to 6
    length(Steps, Depth),
    solve(L, Wires, Steps, Depth).


solve_all :-
    findall([L,W], input(L,W,_), Inputs),
    maplist(solve_one, Inputs, Lengths),
    sum_list(Lengths, Total),
    format('Total: ~w~n', [Total]).

solve_one([L,W], MinLen) :-
    find_min_depth(L, W, MinDepth),
    MinLen = MinDepth.

find_min_depth(L, Wires, MinDepth) :-
    between(0, 6, Depth),
    length(Steps, Depth),
    solve(L, Wires, Steps, Depth), !,
    MinDepth = Depth.

