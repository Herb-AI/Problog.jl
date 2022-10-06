% sampling meta-interpreter with reorders matching clauses at every choice point
sample(true).
sample((A, B)) :-
    sample(A),
    sample(B).
sample(A) :-
    A \= true,
    A \= (_,_),
    findall(clause(T,TB),(T = A, clause(T,TB)),L),
    random_permutation(L,LPerm),
    member(M,LPerm),
    M =.. [_, MHead, MBody],
    A = MHead,
    sample(MBody).