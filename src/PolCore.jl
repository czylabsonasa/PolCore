"""
    module PolCore
    
* minimalistic polynomial toolset
  * reason why: did not find a Newtonian-form polynomial+generalized Horner evaluator (for Hermite interpolation)
* the coefficients are stored in increasing degree
* "features":
  * types: PolC -> classical, PolN -> Newton-form
  * brute-force convert PolN to PolC (easier to comp. the derivative)
  * evaluation by `()`
  * derivative by `adjoint` (the apostrophe)
  * Lagrangian interpolation: interpol_L
"""

module PolCore
  abstract type AbstractPol end

  # classical-form
  struct PolC{T<:Real} <: AbstractPol
    coeff::Vector{T}
  end
  export PolC


  # Newton
  struct PolN{T<:Real} <: AbstractPol
    coeff::Vector{T}
    pts::Vector{T}
  end
  export PolN




  function Pol(coeff,pts=[])
    #printstyled("$(length(pts)) --- $(length(coeff))\n",color=:light_green);flush(stdout)
    err(x)=error("Pol -> $(x)")
    isempty(coeff) && err("empty coeff vector")
    T=typeof(coeff[1])
    if isempty(pts) 
      PolC{T}(coeff[:])
    else
      #println(length(coeff)," ",length(pts))
      (length(coeff)!=length(pts)) && err("if pts>[] then it must be length(coeff) sized")
      T=promote_type(T,typeof(pts[1]))
      PolN{T}(T.(coeff[:]),T.(pts[:]))
    end
  end
  export Pol


  # evaluation by Horner 
  function (p::AbstractPol)(x)
    np=length(p.coeff)
    rule=if hasproperty(p, :pts)
      (px,k)->px*(x-p.pts[k])+p.coeff[k]
    else
      (px,k)->px*x+p.coeff[k]
    end

    px=p.coeff[np]
    for k in np-1:-1:1
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
