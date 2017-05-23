using LazyQuery

import LazyContext, ChainRecursive, LazyQuery, DataFrames;

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
