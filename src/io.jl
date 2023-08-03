# old, but works:
# https://stackoverflow.com/questions/28793623/julia-interpolation-of-own-type-with-string/36050956#36050956
# 

using StatsBase # not a must, used only to order=:rand
"""
    Base.string(p::AbstractPol;<keyword arguments>)

# Arguments
* var: a String used as a variable name, default "x"
* order: a Symbol -> :inc, :dec, :rand, default is :inc
* digits: num. of digs. used for Float coeff (+pts), default is 4
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

  
  deg=length(p.coeff)-1

  T=typeof(p.coeff[1])
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

  (deg==0) && print(io,ms(coeff[1]))


  vars=if hasproperty(p,:pts)
    vcat(
      "",
      [ 
        if iszero(pts[k+1])
          var 
        else
          if pts[k+1]>0
            "($(var)-$(ms(pts[k+1])))"
          else
            "($(var)+$(ms(-pts[k+1])))"
          end
        end 
        for k in 0:deg-1 
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

# function Base.show(
  # io::IO,
  # p::AbstractPol ;
  # var="x",
  # order=:inc,
  # digits=4
# )
  # ms(x)=if x isa Rational
    # if x.den==1
      # "$(x.num)"
    # else
      # "$(x.num)/$(x.den)"
    # end
  # else
    # "$(x)"
  # end
# 
  # 
  # x=var
  # deg=length(p.coeff)-1
# 
  # T=typeof(p.coeff[1])
  # handle_float(arr)=(tol=eval(Meta.parse("5e$(-digits)"));map(t->abs(t)<tol ? zero(T) : round(t, digits=digits), arr))
  # if T <: AbstractFloat
    # coeff=handle_float(p.coeff)
    # if hasproperty(p,:pts)
      # pts=handle_float(p.coeff)
    # end
  # else
    # coeff=p.coeff
    # if hasproperty(p,:pts)
      # pts=p.pts
    # end
  # end
# 
  # (deg==0) && ms(coeff[1])
# 
# 
  # vars=if hasproperty(p,:pts)
    # vcat(
      # "",
      # [
        # if iszero(pts[k+1])
          # x
        # else
          # "($(ms(x))$(pts[k+1]>0 ? "-" : "+")$(ms(pts[k+1])))"
        # end
        # for k in 0:deg-1
      # ] |> cumprod
    # )
  # else
    # vcat(["",x],["$(ms(x))^$(ms(k))" for k in 2:deg])
  # end
# 
# 
  # idx=if order===:inc
    # 0:deg
  # elseif order===:dec
    # deg:-1:0
  # elseif order===:rand
    # sample(0:deg,deg+1,replace=false)
  # else
    # error("string(polcore): unsupported order par. -> $(order)")
  # end
  # 
  # ret=String[]
  # for i in idx
    # c=coeff[i+1]
    # iszero(c) && continue
    # push!(ret,(c>0 ? " + " : " - "))
    # ac=abs(c)
# 
    # non1=(ac!=1)
    # non1 && push!(ret,ms(ac))
    # if i>0
      # non1 && push!(ret, "*")
    # else
      # (ac==1) && push!(ret,"1")
    # end
    # push!(ret,vars[i+1])
  # end
  # 
  # ret[1]=(" + "==ret[1] ? "" : "-")
  # print(io,join(ret))
# end


