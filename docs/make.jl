# from NumericSuffixes' make.jl

using Documenter, PolCore

makedocs(
    sitename = "PolCore.jl",
    modules = PolCore,
    format = :html,
    clean = false,
    pages = Any["Home" => "index.md"],
)

deploydocs(
    target = "build",
    deps = nothing,
    make = nothing,
    repo = "github.com/czylabsonasa/PolCore.jl.git",
)
