"""
    derivative of polynomial

* dp=p' (first the polynomial converted to classical form if neccessary)
"""
function Base.adjoint(p::AbstractPol)
  err(x)=error("derivative -> $(x)")
  if hasproperty(p,:pts)
    p=convert(PolC,p)
  end
  # err("not implemented for Newtonian-form")
  T=eltype(p.coeff)
  deg=length(p.coeff)-1
  coeff=p.coeff[2:deg+1]
  Pol(
    if isempty(coeff) 
      [zero(T)]
    else
      (coeff.*(1:deg))[:]
    end
  )
end


"""
    converts from Newton to classical

* essentially Horner method -> brute force
"""
function Base.convert(::Type{PolC},p::PolN)
  act=similar(p.coeff)
  prev=similar(p.coeff)
  deg=length(p.coeff)-1
  act[1]=p.coeff[deg+1]
  for k in deg:-1:1
    act,prev=prev,act
    act[1]=p.coeff[k] # px -> ... + coeff[k]
    act[2:deg+2-k]=prev[1:deg+1-k] # px -> px*x
    act[1:deg+1-k].-=p.pts[k]*prev[1:deg+1-k]
  end
  PolC(act)
  
end
