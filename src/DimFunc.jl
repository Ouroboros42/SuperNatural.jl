const DimNames{N} = NTuple{N, Symbol}

abstract type DimFunc{N, D} end

Base.length(::DimFunc{N}) where N = N
dimnames(::DimFunc{N, DN}) where {N, DN} = DN

getdim(f::DimFunc, dimname::Symbol) = f[findfirst(isequal(dimname), dimnames(f))]
getdim(f::DimFunc, dim::Unitful.Dimension) = getdim(f, name(dim))

name(::Unitful.Dimension{T}) where T = T
power(dim::Unitful.Dimension) = dim.power

eachdim(dim::Unitful.Dimension) = (dim,)
eachdim(::Unitful.Dimensions{D}) where D = D
eachdim(dimensionful) = eachdim(dimension(dimensionful))

isinfdims(dimensionful) = any(isinf ∘ power, eachdim(dimensionful))

dimnames(dimensionful) = Set(Iterators.map(name, eachdim(dimensionful)))
dimnames(dimensionful...) = union(map(dimnames, dimensionful)...) 
