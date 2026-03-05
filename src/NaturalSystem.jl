struct NaturalSystem{C <: DimProd, U <: DimProd}
    conversion::C
    weights::Basis
    units::U

    NaturalSystem(conversions::DimProd, weights::Basis, units::DimProd) = new{typeof(conversions), typeof(units)}(conversions, weights, units)
end

"""
Define a natural unit system where `free_units` are the preferred units, and the quantities `naturally_one` are used to convert units as needed. 
"""
function NaturalSystem(free_units, naturally_one)
    basis = Basis(free_units..., naturally_one...)
    coordtransform = inv(stack(basis, (free_units..., naturally_one...)))

    i_free = 1:length(free_units)
    i_natural = last(i_free) .+ (1:length(naturally_one))

    weights = coordtransform * basis

    conversion = DimProd(-weights[i_natural], naturally_one, 1)

    free_weights = weights[i_free]

    dim_units = DimProd(free_weights, free_units, NoUnits)

    NaturalSystem(conversion, free_weights, dim_units)
end