natdims(q, system::NaturalSystem = getdefault()) = system.weights(q)
natdim(args...) = only(natdims(args...))

rawnatural(q, system::NaturalSystem) = q * system.conversion(q)

natural(q, system::NaturalSystem) = uconvert(system.units(q), rawnatural(q, system))

"""
Express `q` in terms of the given `units`, given the conversions implied by `system`.
"""
function natural(q, system::NaturalSystem, units::Unitful.Units...)
    qweights = system.weights(q)

    if iszero(qweights)
        unit = only(units) # No point trying to infer from multiple units

        if !iszero(system.weights(unit))
            throw(ArgumentError("Cannot express naturally unitless quantity $q in terms of unitful $unit."))
        end
    else
        unit_powers = try
            exact_ldiv(stack(system.weights, units), qweights)
        catch err
            if err isa LinearAlgebra.SingularException
                throw(ArgumentError("Cannot express $q in units $units for the given system."))
            else
                rethrow(err)
            end
        end
        
        unit = mapreduce(^, *, units, unit_powers, init = NoUnits)
    end
    

    uconvert(unit, rawnatural(q, system) / system.conversion(unit))
end

natural(q, units::Unitful.Units...) = natural(q, getdefault(), units...)

unitless(q) = natural(q, QG_UNITS)