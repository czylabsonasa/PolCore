# __precompile__()


"""
    module PolCore
    
* minimalistic polynomial toolset
  * reason why: did not find a Newtonian-form polynomial+generalized Horner evaluator (for Hermite interpolation)
* "features":
  * types: `PolC` -> classical, `PolN` -> Newton-form (plain Vector based types)
  * brute-force convert `PolN` to `PolC` (easier to comp. the derivative)
  * evaluation by `()`
  * derivative by `adjoint` (the apostrophe)
  * Lagrange-interpolation: `interpol_L`
  * Hermite-interpolation: `interpol_H`
"""
module PolCore
   
"""
    AbstractPol

* the abstract type above all
"""
  abstract type AbstractPol end


@doc raw"""
    struct PolC

* field: `coeff::Vector{T}`
* represents a polynomial in classical-form: 
```math
p(x)=\sum_{k=0}^n coeff[k+1]x^k
```
"""
  struct PolC{T<:Real} <: AbstractPol
    coeff::Vector{T}
  end
  export PolC


@doc raw"""
    struct PolN

* fields: `coeff::Vector{T}` and `pts::Vector{T}`
* represents a polynomial in Newton-form: 
```math
p(x)=\sum_{k=0}^n coeff[k+1]n_k(x)
```
where
```math
n_{k}(x)=\prod_{i=0}^{k-1} (x-pts[i+1])
```
note, that the empty product is 1.
"""
  struct PolN{T<:Real} <: AbstractPol
    coeff::Vector{T}
    pts::Vector{T}
  end
  export PolN



@doc """
    Pol

* convenience function for contruct pol. from `Vector`s
"""
  function Pol(coeff::Vector,pts::Vector=[])
    #printstyled("$(length(pts)) --- $(length(coeff))\n",color=:light_green);flush(stdout)
    err(x)=error("Pol -> $(x)")
    isempty(coeff) && err("empty coeff vector")
    T=eltype(coeff)
    deg=length(coeff)-1
    if isempty(pts) 
      PolC{T}(coeff)
    else
      #println(length(coeff)," ",length(pts))
      (length(coeff)!=length(pts)) && err("if pts>[] then it must be length(coeff) sized")
      T=promote_type(T,eltype(pts))
      PolN{T}(coeff,pts)
    end
  end

  function Pol(coeff,pts=[])
    Pol(Vector(coeff),Vector(pts))
  end
  export Pol


  # evaluation by Horner 
  function (p::AbstractPol)(x)
    rule=if hasproperty(p, :pts)
      #(px,k)->px*(x-p.pts[k])+p.coeff[k]
      (px,k)->Base.muladd(px,(x-p.pts[k]),p.coeff[k])
    else
      #(px,k)->px*x+p.coeff[k]
      (px,k)->Base.muladd(px,x,p.coeff[k])
    end

    deg=length(p.coeff)-1

    px=p.coeff[deg+1]
    @inbounds for k in deg:-1:1
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
