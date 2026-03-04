using SuperNatural
using Unitful
using Test

@testset "SuperNatural.jl" begin
    @test natural(u"ħ^2 * c^0.5") ≈ 1
    @test unitless(u"G*ħ*c") ≈ 1
    @test natural(u"ft") ≈ natural(u"ns") rtol = 0.05
    @test natdim(10u"m") == -1
    @test natdim(u"c") == 0
end
