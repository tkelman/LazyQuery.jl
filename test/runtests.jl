using LazyQuery

import LazyContext, ChainRecursive, DataFrames;

import Documenter
Documenter.makedocs(
    modules = [LazyQuery],
    format = :html,
    sitename = "LazyQuery.jl",
    root = joinpath(dirname(dirname(@__FILE__)), "docs"),
    pages = Any["Home" => "index.md"],
    strict = true,
    linkcheck = true,
    checkdocs = :exports,
    authors = "Brandon Taylor"
)

using Base.Test

LazyContext.@new_environment

LazyContext.@use_in_environment LazyQuery

Test.@test_throws ErrorException LazyContext.@evaluate begin
    d = Dict(:a => 1, :b => 2)
    @add_to d d
end

LazyContext.@use_in_environment DataFrames

Test.@test_throws ErrorException LazyContext.@evaluate begin
    d = DataFrame(a = 1)
    @choose_from d 1 -1
end
