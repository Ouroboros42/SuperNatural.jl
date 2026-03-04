name(::Unitful.Dimension{T}) where T = T
power(dim::Unitful.Dimension) = dim.power

eachdim(dim::Unitful.Dimension) = (dim,)
eachdim(::Unitful.Dimensions{T}) where T = T
eachdim(dimensionful) = eachdim(dimension(dimensionful))

dimnames(dimensionful) = Set(Iterators.map(name, eachdim(dimensionful)))
dimnames(dimensionful...) = union(map(dimnames, dimensionful)...) 
