% sampling meta-interpreter with reorders matching clauses at every choice point
%    also returns a proof
sample_with_proof(true,true).
sample_with_proof((A, B), and(ProofA,ProofB)) :-
    sample_with_proof(A, ProofA),
    sample_with_proof(B, ProofB).
sample_with_proof(A, pr(MHead :- MBody, ProofB)) :-
    A \= true,
    A \= (_,_),
    findall(clause(T,TB),(T = A, clause(T,TB)),L),
    random_permutation(L,LPerm),
    member(M,LPerm),
    M =.. [_, MHead, MBody],
    A = MHead,
    sample_with_proof(MBody, ProofB).