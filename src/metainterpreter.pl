
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


% sampling meta-interpreter with reorders matching clauses at every breakpoint
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


% sampling meta-interpreter with reorders matching clauses at every breakpoint
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


% Problog meta-interpreter
problog_with_proof(true, true, 1.0).
problog_with_proof((A,B), and(ProofA, ProofB), Prob) :-
    problog_with_proof(A, ProofA, ProbA),
    problog_with_proof(B, ProofB, ProbB),
    Prob is ProbA * ProbB.
problog_with_proof(A, pr(A :- B, ProofB), ProbB) :-   % for a deterministic fact or clause
    A \= true,
    A \= (_,_),
    clause(A,B),
    problog_with_proof(B, ProofB, ProbB).
%problog_with_proof(A, pr(A :- true, true), ProbF) :- % for a probabilistic fact
%    A \= true,
%    A \= (_,_),
%    A =.. [Functor | Args],
%    pfact(Functor,PFArgs,ProbF),
%    Args = PFArgs.
problog_with_proof(A, pr(HeadProb, A :- Body, ProofB), Prob) :- % for annotated disjunction
    A \= true,
    A \= (_,_),
    A =.. [Functor | _],
    adc(Functor, _, Head, HeadProb, Body),
    A = Head,
    problog_with_proof(Body, ProofB, BProb),
    Prob is HeadProb * BProb.




adc(stress,1,stress(X),0.3,person(X)). 
adc(asthma,2,asthma(X),0.4,smokes(X)).
smokes(X) :- stress(X).
smokes(X) :- friend(X,Y), influences(Y,X), smokes(Y).


person(angelika).
person(joris).
person(jonas).
person(dimitar).

friend(joris,jonas).
friend(joris,angelika).
friend(joris,dimitar).
friend(angelika,jonas).