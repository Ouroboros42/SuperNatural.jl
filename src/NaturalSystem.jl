sindices(tup::Tuple, offset = 0) = SVector{length(tup)}(eachindex(tup)) .+ offset
sindices(tup1::Tuple, tup2::Tuple) = sindices(tup1), sindices(tup2, length(tup1))

struct NaturalSystem{C, W, U}
    """
    Define a natural unit system where `free_units` are the preferred units, and the quantities `naturally_one` are used to convert units as needed. 
    """
    function NaturalSystem(free_units::Tuple, naturally_one::Tuple)
        basis = DimBasis(free_units..., naturally_one...)

        coordtransform = inv(basis((free_units..., naturally_one...)))

        i_free, i_natural = sindices(free_units, naturally_one)

        weights = coordtransform * basis

        conversion = DimProd(-subspace(weights, i_natural), 1, naturally_one)

        free_weights = subspace(weights, i_free)

        dim_units = DimProd(free_weights, NoUnits, free_units)

        new{conversion, free_weights, dim_units}()
    end
end

conversions(::NaturalSystem{C, W, U}) where {C, W, U} = C
weights(::NaturalSystem{C, W, U}) where {C, W, U} = W
units(::NaturalSystem{C, W, U}) where {C, W, U} = U

naturalconversion(q, system::NaturalSystem = getdefault()) = conversions(system)(q)
naturalunits(q, system::NaturalSystem = getdefault()) = units(system)(q)

"""
Get the dimensions of `q` in terms of the preferred units of `system`, as a vector of powers.
"""
natdims(q, system::NaturalSystem = getdefault()) = weights(system)(q)

"""
For one-unit systems, get the power of the standard unit needed to express the quantity.
"""
natdim(args...) = only(natdims(args...))

