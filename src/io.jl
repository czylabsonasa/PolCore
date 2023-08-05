# old, but works:
# https://stackoverflow.com/questions/28793623/julia-interpolation-of-own-type-with-string/36050956#36050956
# 

using StatsBase # not a must, used only to order=:rand
"""
    Base.show(p::AbstractPol;<keyword arguments>)

# Arguments
* var: a String used as a variable name, default "x"
* order: a Symbol -> :inc, :dec, :rand, default is :inc
* digits: num. of digs. used for Float coeff (+pts), default is 4
* sorry for the mess...
"""
function Base.show(
  io::IO,
  p::AbstractPol ;
  var="x",
  order=:inc,
  digits=4
)
  ms(x)=if x isa Rational
    if x.den==1
      "$(x.num)"
    else
      "$(x.num)/$(x.den)"
    end
  else
    "$(x)"
  end

  

  T=eltype(p.coeff)
  handle_float(arr)=(tol=eval(Meta.parse("5e$(-digits)"));map(t->abs(t)<tol ? zero(T) : round(t, digits=digits), arr))
  if T <: AbstractFloat
    coeff=handle_float(p.coeff)
    if hasproperty(p,:pts)
      pts=handle_float(p.pts)
    end
  else
    coeff=p.coeff
    if hasproperty(p,:pts)
      pts=p.pts
    end
  end

  deg=length(p.coeff)-1
  (deg==0) && (print(io,ms(coeff[1]));return)


  vars=if hasproperty(p,:pts)
    vcat(
      "",
      [ 
        if iszero(pts[k])
          var 
        else
          if pts[k]>0
            "($(var)-$(ms(pts[k])))"
          else
            "($(var)+$(ms(-pts[k])))"
          end
        end 
        for k in 1:deg
      ] |> cumprod
    )
  else
    vcat(["",var],["$(var)^$(k)" for k in 2:deg])
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
  
  volt=false
  for i in idx
    c=coeff[i+1]
    iszero(c) && continue
    if volt
      print(io,(c<0 ? " - " : " + "))
    else
      print(io,(c<0 ? "-" : ""))
      volt=true
    end
    ac=abs(c)

    non1=(ac!=1)
    non1 && print(io,ms(ac))
    if i>0
      non1 && print(io, "*")
    else
      (ac==1) && print(io,"1")
    end
    print(io,vars[i+1])
  end

end


