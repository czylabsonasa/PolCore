# __precompile__()


"""
    module PolCore
    
* minimalistic polynomial toolset
  * reason why: did not find a Newtonian-form polynomial+generalized Horner evaluator (for Hermite interpolation)
* "features":
  * types: `PolC` -> classical, `PolN` -> Newton-form
    * both are OffsetArray based
  * brute-force convert `PolN` to `PolC` (easier to comp. the derivative)
  * evaluation by `()`
  * derivative by `adjoint` (the apostrophe)
  * Lagrange-interpolation: `interpol_L`
  * Hermite-interpolation: `interpol_H`
"""
module PolCore
    using OffsetArrays
    
"""
    AbstractPol

* the abstract type above all
"""
  abstract type AbstractPol end


@doc raw"""
    struct PolC

* field: `coeff::OffsetArray{T}`
* represents a polynomial in classical-form: 
```math
p(x)=\sum_{k=0}^n coeff[k]x^k
```
"""
  struct PolC{T<:Real} <: AbstractPol
    coeff::OffsetArray{T}
  end
  export PolC


@doc raw"""
    struct PolN

* fields: `coeff::OffsetArray{T}` and `pts::OffsetArray{T}`
* represents a polynomial in Newton-form: 
```math
p(x)=\sum_{k=0}^n coeff[k]n_k(x)
```
where
```math
n_{k}(x)=\prod_{i=0}^{k-1} (x-pts[i])
```
note, that the empty product is 1.
"""
  struct PolN{T<:Real} <: AbstractPol
    coeff::OffsetArray{T}
    pts::OffsetArray{T}
  end
  export PolN



@doc """
    Pol

* convenience function for contruct pol. from (plain) `Vector`s
"""
  function Pol(coeff::Vector,pts::Vector=[])
    #printstyled("$(length(pts)) --- $(length(coeff))\n",color=:light_green);flush(stdout)
    err(x)=error("Pol -> $(x)")
    isempty(coeff) && err("empty coeff vector")
    T=eltype(coeff)
    deg=length(coeff)-1
    if isempty(pts) 
      PolC{T}(OffsetArray{T}(coeff,0:deg))
    else
      #println(length(coeff)," ",length(pts))
      (length(coeff)!=length(pts)) && err("if pts>[] then it must be length(coeff) sized")
      T=promote_type(T,eltype(pts))
      PolN{T}(
        OffsetArray{T}(coeff,0:deg),
        OffsetArray{T}(pts,0:deg),
      )
    end
  end

  function Pol(coeff,pts=[])
    Pol(Vector(coeff),Vector(pts))
  end
  export Pol


  # evaluation by Horner 
  function (p::AbstractPol)(x)
    rule=if hasproperty(p, :pts)
      (px,k)->px*(x-p.pts[k])+p.coeff[k]
    else
      (px,k)->px*x+p.coeff[k]
    end

    deg=length(p.coeff)-1

    px=p.coeff[deg]
    @inbounds for k in deg-1:-1:0
      px=rule(px,k)
    end
    px
  end


  include("tools.jl") # ', convert 


  #printstyled("include interp.jl\n",color=:light_yellow)
  include("interpol.jl")
  export interpol_L, interpol_H


  include("io.jl") # for Base.string


end # module PolCore
