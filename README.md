# SuperNatural.jl
A Julia package implementing flexible conversions via natural units for [Unitful.jl](https://github.com/JuliaPhysics/Unitful.jl).

Inspired by [NaturallUnitful.jl](https://github.com/MasonProtter/NaturallyUnitful.jl), includes additional features:
- Define custom natural unit systems:
    - Take any quantities to be 1
    - Retain arbitrary combinations of units
- Dynamically derives appropriate unit combinations
- Evaluate mass-dimension (or equivalent) for any quantity or unit.

```julia
    julia> using SuperNatural, Unitful
    julia> natdim(u"N")
    2//1
    julia> weirdsys = NaturalSystem((u"m", u"s"), (10u"N",));
    julia> natural(u"kg", weirdsys)
    0.1 s^2 m^-1
```

Uses particle physics units (`c = ħ = k = 4πϵ₀ = 1`) by default, which are extended to include `G = 1` in `QG_UNITS`. Other systems can be made the default using `SuperNatural.setdefault`.

## Main Interface
- Convert units via `natural`, or into a number via `unitless` (uses `QG_UNITS`).
- Define a new natural unit system via `NaturalSystem`, `oneunit_system` or `unitless_system`.
- Update/check default system via `SuperNatural.setdefault`/`SuperNatural.getdefault`.
- Get natural dimensions using `natdims`/`natdim`.



