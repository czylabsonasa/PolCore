"""
    module PolCore
    
* minimalistic polynomial toolset
* the coefficients are stored in increasing degree
* "features":
  * evaluation by `()`
  * derivative by `adjoint` (the apostrophe)
  * Lagrangian interpolation: interp_L
* reason why: did not find a Newtonian-form polynomial+generalized Horner evaluator (for Hermite interpolation)
"""
module PolCore
  abstract type AbstractPol end

  # classical (0-based)
  struct PolC{T<:Real} <: AbstractPol
    coeff::Vector{T}
  end

  # Newton
  struct PolN{T<:Real} <: AbstractPol
    coeff::Vector{T}
    pts::Vector{T}
  end



  function pol(coeff,pts=[])
    #printstyled("$(length(pts)) --- $(length(coeff))\n",color=:light_green);flush(stdout)
    isempty(coeff) && error("pol: empty coeff vector")
    T=typeof(coeff[1])
    if isempty(pts) 
      PolC{T}(coeff)
    else
      #println(length(coeff)," ",length(pts))
      (length(coeff)!=length(pts)) && error("pol: if pts>[] then it must be length(coeff) sized")
      T=promote_type(T,typeof(pts[1]))
      PolN{T}(T.(coeff),T.(pts))
    end
  end
  export pol


  function (p::AbstractPol)(x)
    np=length(p.coeff)
    px=p.coeff[np]
    if !hasproperty(p, :pts)
      for k in np-1:-1:1
        px=px*x+p.coeff[k]
      end
    else
      for k in np-1:-1:1
        px=px*(x-p.pts[k])+p.coeff[k]
      end
    end
    px
  end


  include("tools.jl") # ', convert 


  #printstyled("include interp.jl\n",color=:light_yellow)
  include("interp.jl")
  export interp_L


  include("io.jl") # for Base.string


end # module PolCore
