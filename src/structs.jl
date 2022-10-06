

"Annotated disjunction is a key constract supporting stochastic behaviour in Problog"
struct AnnotateDisjunction <: AbstractClause
    head::Vector{Term}
    probs::Vector{Float64}
    body::Vector{Term}
end


"Check if two annotated disjunctions are equal"
Base.:(==)(ad1::AnnotatedDisjunction, ad2::AnnotatedDisjunction) = 
    (length(ad1.head) == length(ad2.head) && 
    length(ad1.body) == length(ad2.body) && 
    ad1.probs == ad2.probs &&
    all(t1 == t2 for (t1, t2) in zip(ad1.head, ad2.head)) &&
    all(t1 == t2 for (t1, t2) in zip(ad1.body, ad2.body)))

"Compute hash of Problog terms"
Base.hash(ad::AnnotatedDisjunction, h::UInt) = hash(ad.head, hash(ad.body, hash(ad.probs, h)))


"Print terms"

function Base.show(io::IO, ad::AnnotatedDisjunction)
    if length(ad.body) == 0
        print(io, join(["$(repr(p))::$(repr(t))" for (p, t) in zip(ad.prob, ad.head)], "; "))
    else
        print(io, join(["$(repr(p))::$(repr(t))" for (p, t) in zip(ad.prob, ad.head)], "; ")..., "<<=", join([repr(t) for t in ad.body], ", ")...)
    end
end

