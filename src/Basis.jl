const Q = Rational{Int}

struct Basis
    zerovec::Vector{Q}
    elements::Dict{Symbol, Vector{Q}}

    Basis(zerovec::Vector{Q}, elements::Dict{Symbol, Vector{Q}}) = new(zerovec, elements)
end

function Basis(names::Symbol...)
    zerovec = zeros(Q, length(names))
    elements = Iterators.map(enumerate(names)) do (i, name)
        v = copy(zerovec)
        v[i] = 1

        name => v
    end |> Dict{Symbol, Vector{Q}}

    Basis(zerovec, elements)
end

Basis(dimensionful...) = Basis(dimnames(dimensionful...)...)

mapvals(f, dict) = Iterators.map(pairs(dict)) do (key, value)
    key => f(value)
end |> Dict

Base.length(basis::Basis) = length(basis.zerovec)
Base.map(f, basis::Basis) = Basis(f(basis.zerovec), mapvals(f, basis.elements)) 
Base.getindex(basis::Basis, inds...) = map(v -> v[inds...], basis)
Base.:*(M, basis::Basis) = map(v -> M * v, basis)
Base.:-(basis::Basis) = map(-, basis)

(basis::Basis)(dimname::Symbol) = get(basis.elements, dimname, basis.zerovec)
(basis::Basis)(dim::Unitful.Dimension) = basis(name(dim)) * power(dim)
(basis::Basis)(dimensionful) = sum(basis, eachdim(dimensionful); init = basis.zerovec)

function exact_ldiv(M, v)
    subspace = axes(M, 2)
    
    @views M[subspace, :] \ v[subspace]
end