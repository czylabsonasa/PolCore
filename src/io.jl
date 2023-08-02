# old, but works:
# https://stackoverflow.com/questions/28793623/julia-interpolation-of-own-type-with-string/36050956#36050956
Base.show(io::IO, x::Rational)=print(io, if x.den==1
    "$(x.num)"
  else
    "$(x.num)/$(x.den)"
  end
)


using StatsBase # not a must, used only to order=:rand
"""
    Base.string(p::AbstractPol;<keyword arguments>)

# Arguments
* var: a String used as a variable name, default "x"
* order: a Symbol -> :inc, :dec, :rand, default is :inc
* digits: used for Float coeff (pts), default is 4
"""
function Base.show(
  io::IO,
  p::AbstractPol ;
  var="x",
  order=:inc,
  digits=4
)
  x=var
  deg=length(p.coeff)-1

  T=typeof(p.coeff[1])
  handle_float(arr)=(tol=eval(Meta.parse("5e$(-digits)"));map(t->abs(t)<tol ? zero(T) : round(t, digits=digits), arr))
  if T <: AbstractFloat
    coeff=handle_float(p.coeff)
    if hasproperty(p,:pts)
      pts=handle_float(p.coeff)
    end
  else
    coeff=p.coeff
    if hasproperty(p,:pts)
      pts=p.pts
    end
  end

  (deg==0) && print(io,string(coeff[1]))


  vars=if hasproperty(p,:pts)
    vcat(
      "",
      [ 
        if iszero(pts[k+1])
          x 
        elseif pts[k+1]>0
          "($(x)-$(pts[k+1]))" 
        else
          "($(x)+$(abs(pts[k+1])))"
        end 
        for k in 0:deg-1 
      ] |> cumprod
    )
  else
    vcat(["",x],String["$(x)^$(k)" for k in 2:deg])
  end


  idx=if order===:inc 
    0:deg
  elseif order===:dec
    deg:-1:0
  elseif order===:rand
    sample(0:deg,deg+1,replace=false)
  else
    error("string(polcore): unsupported order par. -> $(order)")
  end
  
  ret=String[]
  for i in idx
    c=coeff[i+1]
    iszero(c) && continue
    push!(ret,(c>0 ? " + " : " - "))
    ac=abs(c)

    non1=(ac!=1)
    non1 && push!(ret,string(ac))
    if i>0
      non1 && push!(ret, "*")
    else
      (ac==1) && push!(ret,"1")
    end
    push!(ret,vars[i+1])
  end
  
  ret[1]=(" + "==ret[1] ? "" : "-")
  print(io,join(ret))
end
