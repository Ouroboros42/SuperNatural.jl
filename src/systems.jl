oneunit_system(unit, naturals...) = NaturalSystem((unit,), naturals)
unitless_system(naturals...) = NaturalSystem((), naturals)

const MOL_CONVERSION = 6.022_140_76e23 / Unitful.mol

const COMMON_CONVERSIONS = (Unitful.c, Unitful.ħ, Unitful.k, 4π*Unitful.ϵ0, MOL_CONVERSION)

const PARTICLE_UNITS = oneunit_system(Unitful.eV, COMMON_CONVERSIONS...)

const QG_UNITS = unitless_system(Unitful.G, COMMON_CONVERSIONS...)

const INITIAL_DEFAULT = PARTICLE_UNITS
const DEFAULT_UNITS = Ref(INITIAL_DEFAULT)

function setdefault(system::NaturalSystem = INITIAL_DEFAULT)
    DEFAULT_UNITS[] = system
end

function getdefault()
    DEFAULT_UNITS[]
end