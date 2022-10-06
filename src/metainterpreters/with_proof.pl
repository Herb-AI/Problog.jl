% Meta-interpreter that returns the proof tree of the query
with_proof(true,true).
with_proof((A, B), and(ProofA, ProofB)) :-
    with_proof(A, ProofA),
    with_proof(B, ProofB).
with_proof(A, pr(A :- B,  ProofB)) :-
    A \= true,
    A \= (_,_),
    clause(A, B),
    with_proof(B, ProofB).