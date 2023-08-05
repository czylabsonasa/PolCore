# from NumericSuffixes' make.jl

push!(LOAD_PATH,"../src/")

using Documenter, PolCore, DocumenterMarkdown

#makedocs(sitename="PolCore")

makedocs(
    sitename = "PolCore.jl",
    modules = PolCore,
    #format = Documenter.HTML(),
    format = Markdown(),
    
#    clean = true,
#    pages = Any["Home" => "index.md"],
)



# 
# deploydocs(
#     # target = "build",
#     # deps = nothing,
#     # make = nothing,
#     repo = "github.com/czylabsonasa/PolCore.jl.git",
#     versions=nothing,
# )

