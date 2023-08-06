# old, but works:
# https://stackoverflow.com/questions/28793623/julia-interpolation-of-own-type-with-string/36050956#36050956
# 

using StatsBase # not a must, used only to order=:rand

ms(x::Rational)=if x.den==1
  ms(x.num)
else
  "$(x)"
end

ms(x::Complex)="($(x))"
ms(x)="$(x)"

takeit(x::AbstractFloat; digits=4)=abs(x)<5*10.0^(-digits) ? 0.0 : round(x, digits=digits)
takeit(x::Complex; digits=4)=Complex(takeit(x.re,digits=digits),takeit(x.im,digits=digits))
takeit(x; digits=4)=x



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


  coeff=takeit.(p.coeff; digits=digits)
  if hasproperty(p,:pts)
    pts=takeit.(p.pts; digits=digits)
  end

  deg=length(p.coeff)-1
  (deg==0) && (print(io,ms(coeff[1]));return)

  genterm(x::Real)=if iszero(x)
    var
  elseif x>0
    "($(var)-$(ms(x)))"
  else
    "($(var)+$(ms(-x)))"
  end

  genterm(x)=if iszero(x)
    var
  else
    "($(var)-$(ms(x)))"
  end


  vars=if hasproperty(p,:pts)
    trm,ftrm=genterm(pts[1]),1
    atrm=""
    tmp=[trm]
    for k in 2:deg
      if pts[k]==pts[k-1]
        ftrm+=1
        push!(tmp, atrm*"$(trm)^$(ftrm)")
      else
        atrm=(ftrm>1 ? "$(atrm)$(trm)^$(ftrm)" : "$(atrm)$(trm)")
        trm,ftrm=genterm(pts[k]),1
        push!(tmp, "$(atrm)$(trm)")
      end
    end
    vcat("",tmp)    
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
  if eltype(coeff)<:Real
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
  else
    for i in idx
      c=coeff[i+1]
      iszero(c) && continue
      if volt
        print(io," + ")
      else
        volt=true
      end
      print(io,"$(ms(c))"*(i!=0 ? "*$(vars[i+1])" : ""))
    end
  end
end


