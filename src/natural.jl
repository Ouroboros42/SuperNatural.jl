"""
Get the dimensions of `q` in terms of the preferred units of `system`, as a vector of powers.
"""
natdims(q, system::NaturalSystem = getdefault()) = system.weights(q)

"""
For one-unit systems, get the power of the standard unit needed to express the quantity.
"""
natdim(args...) = only(natdims(args...))

rawnatural(q, system::NaturalSystem) = q * system.conversion(q)

"""
Express `q` in terms of the standard units for `system`, using natural conversions.
The default unit system can be changed using `SuperNatural.setdefault`.
"""
natural(q, system::NaturalSystem) = uconvert(system.units(q), rawnatural(q, system))

"""
Express `q` in terms of the given `units`, given the conversions implied by `system`.
The default unit system can be changed using `SuperNatural.setdefault`.
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

"""
Convert `q` to a unitless number using `QG_UNITS`.
"""
unitless(q) = natural(q, QG_UNITS)