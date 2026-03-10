module SuperNatural

export natural, natdims, natdim, unitless
export NaturalSystem, oneunit_system, unitless_system
export PARTICLE_UNITS, QG_UNITS

using Unitful
using LinearAlgebra
using StaticArrays

include("errors.jl")
include("DimFunc.jl")
include("DimBasis.jl")
include("DimProd.jl")
include("NaturalSystem.jl")
include("systems.jl")
include("natural.jl")

end
