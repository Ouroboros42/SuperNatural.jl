struct DimProd{T, V}
    neutral::T
    factors::Dict{Symbol, V}

    DimProd(neutral::T, factors::Dict{Symbol, V}) where {T, V} = new{T, V}(neutral, factors)
end

function DimProd(weights::Basis, units, init)
    factors = mapvals(weights.elements) do weight
        mapreduce(^, *, units, weight; init)
    end

    DimProd(init, factors)
end

(f::DimProd)(dimname::Symbol) = get(f.factors, dimname, f.neutral) 
(f::DimProd)(dim::Unitful.Dimension) = f(name(dim)) ^ power(dim)
(f::DimProd)(dimensionful) = prod(f, eachdim(dimensionful); init = f.neutral)
