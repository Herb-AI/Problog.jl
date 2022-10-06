% Meta-interpreter that returns a trace -- all facts that were used in a proof, as a list
with_trace(true, []).
with_trace((A,B), R) :-
    with_trace(A, RA),
    with_trace(B, RB),
    append(RA,RB,R).
with_trace(A, [A]) :-
    A \= true,
    A \= (_,_),
    clause(A, B),
    B == true.
with_trace(A, [A | RB]) :-
    A \= true,
    A \= (_,_),
    clause(A, B),
    B \= true,
    with_trace(B, RB).