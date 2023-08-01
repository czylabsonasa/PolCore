"""
* the coefficients are stored in increasing degree
* only the very basic operations defined
* currently:
  * evaluation by `()`
  * derivative by `adjoint` (the apostrophe)
* bcos: did not find a Newtonian-form polynomial+generalized Horner evaluator (for Hermite interpolation)
"""
module PolCore
  struct polcore{T<:Real}
    coeff::Vector{T}
    pts::Vector{T}
  end

  function polcore(;coeff=[],pts=[])
    #printstyled("$(length(pts)) --- $(length(coeff))\n",color=:light_green);flush(stdout)
    isempty(coeff) && error("polcore: empty coeff vector")
    T=typeof(coeff[1])
    if isempty(pts) 
      polcore{T}(coeff,T[])
    else
      #println(length(coeff)," ",length(pts))
      (length(coeff)!=length(pts)) && error("polcore: if pts>[] the it must length(coeff) sized")
      T=promote_type(T,typeof(pts[1]))
      polcore{T}(T.(coeff),T.(pts))
    end
  end
  export polcore


  function (p::polcore)(x)
    np=length(p.coeff)
    px=p.coeff[np]
    if isempty(p.pts)
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


  function Base.adjoint(p::polcore)
    T=typeof(p.coeff[1])
    coeff=p.coeff[2:end]
    isempty(coeff) && (coeff=[zero(T)])
    coeff=coeff.*(1:length(coeff))
    polcore(coeff,T[])
  end


  function interp_L(t,f)
    (isempty(t) || length(t)!=length(f)) && error("interp_L: wrong parameter(s)")
    
    T=promote_type(typeof(t[1]),typeof(f[1]))
    t=convert(Vector{T},t)
    f=convert(Vector{T},f)

    arule=if T<:Rational
      (a,b)->a//b
    else
      (a,b)->a/b
    end
      
    n=length(t)
    coeff=Vector{T}(undef,n)
    act=Vector{T}(undef,n)
    act.=f
    prev=Vector{T}(undef,n)
    coeff[1]=act[1]
    for j in 1:n-1
      act,prev=prev,act
      for i in 1:n-j
        act[i]=arule(prev[i]-prev[i+1],t[i]-t[i+j])
      end
      coeff[j+1]=act[1]
    end
    polcore(coeff,t)
  end
  export interp_L




"""
    Base.string(p::polcore;x=:x,order=:inc)
    ...
"""
  # function Base.string(p::polcore;var=:x,order=:inc)
    # x=string(var)
    # deg=length(p.coeff)-1
    # (deg==0) && (return string(p.coeff[1]))
# 
    # idx=(order===:inc ? (0:deg) : (deg:-1:0))
    # ret=""
    # for k in idx
      # c=p.coeff[k+1]
      # iszero(c) && continue
      # ret*=(c>0 ? "+" : "-")
      # ac=abs(c)
      # (ac!=1) && (ret*=string(ac))
      # if k>0
        # ret*=x
        # (k>1) && (ret*="^$(k)")
      # else
        # (ac==1) && (ret*="1")
      # end
    # end
    # if '+'==ret[1]
      # ret=ret[2:end]
    # end
    # ret
  # end
  function Base.string(p::polcore;var=:x,order=:inc)
    x=string(var)
    deg=length(p.coeff)-1
    (deg==0) && (return string(p.coeff[1]))

    idx=(order===:inc ? (0:deg) : (deg:-1:0))
    ret=String[]
    for i in idx
      c=p.coeff[i+1]
      iszero(c) && continue
      push!(ret,(c>0 ? " + " : " - "))
      ac=abs(c)
      flag=false
      (ac!=1) && (flag=true;push!(ret,string(ac)))
      if i>0
        push!(ret,(flag ? "*$(x)" : x))
        (i>1) && push!(ret,"^$(i)")
      else
        (ac==1) && push!(ret,"1")
      end
    end
    
    ret[1]=(" + "==ret[1] ? "" : "-")
    join(ret)
  end




end # module PolCore
