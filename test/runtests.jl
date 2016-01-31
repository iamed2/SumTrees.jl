using SumTrees
if VERSION < v"0.5-"
    using BaseTestNext
else
    using Base.Test
end

@testset "Tiny" begin
    @testset "Default Type" begin
        tree = SumTree(1)
        @test isa(tree, SumTree)
        @test isa(tree, SumTree{Float64, 1})
        @test eltype(tree) === Float64

        @test tree[1] == 0.0
        @test sum(tree) == 0.0

        tree[1] = 3.0
        @test tree[1] == 3.0
        @test sum(tree) == 3.0

        tree[1] = 8
        @test tree[1] == 8.0
        @test sum(tree) == 8.0
        @test isa(tree[1], Float64)

        @test_throws BoundsError tree[0]
        @test_throws BoundsError tree[2]

        @test_throws BoundsError tree[0] = 1.0
        @test_throws BoundsError tree[2] = 1.0

        @test [x for x in tree] == [8.0]
    end

    @testset "Rational" begin
        tree = SumTree(Rational, 1)
        @test isa(tree, SumTree)
        @test isa(tree, SumTree{Rational, 1})

        @test tree[1] == zero(Rational)
        @test sum(tree) == zero(Rational)

        tree[1] = 3//4
        @test tree[1] == 3//4
        @test sum(tree) == 3//4
        @test isa(tree[1], Rational)

        @test [x for x in tree] == [3//4]
    end
end

@testset "Normal" begin
    @testset "Default Type" begin
        tree = SumTree(8)

        @test collect(tree) == zeros(Float64, 8)

        buffer = IOBuffer()
        show(buffer, tree)

        @test takebuf_string(buffer) == "SumTree{Float64, 8} ::\n    (0.0,)\n    (0.0,0.0,)\n    (0.0,0.0,0.0,0.0,)\n    (0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,)\n"

        tree[1] = 3
        tree[4] = 99

        @test tree[1] == 3
        @test tree[4] == 99
        @test tree[2] == 0
        @test sum(tree) == 102

        tree[8] = 0.0001
        @test tree[8] == 0.0001
        @test tree[1] == 3
        @test tree[4] == 99
        @test tree[2] == 0
        @test sum(tree) == 102.0001
    end
end
