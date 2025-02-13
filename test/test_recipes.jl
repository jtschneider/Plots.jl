using Plots, Test
using OffsetArrays

@testset "lens!" begin
    pl = plot(1:5)
    lens!(pl, [1, 2], [1, 2], inset = (1, bbox(0.0, 0.0, 0.2, 0.2)), colorbar = false)
    @test length(pl.series_list) == 4
    @test pl[2][:colorbar] == :none
end # testset

@testset "vline, vspan" begin
    vl = vline([1], widen = false)
    @test Plots.xlims(vl) == (1, 2)
    @test Plots.ylims(vl) == (1, 2)
    vl = vline([1], xlims = (0, 2), widen = false)
    @test Plots.xlims(vl) == (0, 2)
    vl = vline([1], ylims = (-3, 5), widen = false)
    @test Plots.ylims(vl) == (-3, 5)

    vsp = vspan([1, 3], widen = false)
    @test Plots.xlims(vsp) == (1, 3)
    @test Plots.ylims(vsp) == (0, 1) # TODO: might be problematic on log-scales
    vsp = vspan([1, 3], xlims = (-2, 5), widen = false)
    @test Plots.xlims(vsp) == (-2, 5)
    vsp = vspan([1, 3], ylims = (-2, 5), widen = false)
    @test Plots.ylims(vsp) == (-2, 5)
end # testset

@testset "offset axes" begin
    tri = OffsetVector(vcat(1:5, 4:-1:1), 11:19)
    sticks = plot(tri, seriestype = :sticks)
    @test length(sticks) == 1
end

@testset "framestyle axes" begin
    pl = plot(-1:1, -1:1, -1:1)
    sp = pl.subplots[1]
    defaultret = Plots.axis_drawing_info_3d(sp, :x)
    for letter in [:x, :y, :z]
        for fr in [:box :semi :origin :zerolines :grid :none]
            prevha = UInt64(0)
            push!(sp.attr, :framestyle => fr)
            ret = Plots.axis_drawing_info_3d(sp, letter)
            ha = hash(string(ret))
            @test ha != prevha
            prevha = ha
        end
    end
end
