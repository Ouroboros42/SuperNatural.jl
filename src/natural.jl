rawnatural(q, system::NaturalSystem) = q * naturalconversion(q, system)

"""
Express `q` in terms of the standard units for `system`, using natural conversions.
The default unit system can be changed using `SuperNatural.setdefault`.
"""
natural(q, system::NaturalSystem) = uconvert(naturalunits(q, system), rawnatural(q, system))

"""
Express `q` in terms of the given `units`, given the conversions implied by `system`.
The default unit system can be changed using `SuperNatural.setdefault`.
"""
function natural(q, system::NaturalSystem, units::Unitful.Units...)
    qdims = natdims(q, system)

    if iszero(qdims)
        unit = only(units) # No point trying to infer from multiple units, and no units case is already handled

        if !iszero(natdims(unit, system))
            throw(NaturalDimensionError(q, units, system))
        end
    else
        unit_powers = try
            exact_ldiv(weights(system)(units), qdims)
        catch err
            if err isa LinearAlgebra.SingularException
                throw(NaturalDimensionError(q, units, system))
            else
                rethrow(err)
            end
        end

        unit = mapreduce(^, *, units, unit_powers, init = NoUnits)

        if isinfdims(unit)
            throw(NaturalDimensionError(q, units, system))
        end
    end
    
    uconvert(unit, rawnatural(q, system) / naturalconversion(unit, system))
end

function exact_ldiv(M, v)
    subspace = axes(M, 2)
    
    M[subspace, :] \ v[subspace]
end

natural(q, units::Unitful.Units...) = natural(q, getdefault(), units...)

"""
Convert `q` to a unitless number using `QG_UNITS`.
"""
unitless(q) = natural(q, QG_UNITS)