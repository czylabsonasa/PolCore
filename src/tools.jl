"""
    derivative of polynomial

* dp=p' (but the user should convert to PolC first)
"""
function Base.adjoint(p::AbstractPol)
  err(x)=error("derivative -> $(x)")
  if hasproperty(p,:pts)
    p=convert(PolC,p)
  end
  # err("not implemented for Newtonian-form")
  T=eltype(p.coeff)
  deg=length(p.coeff)-1
  coeff=p.coeff[1:deg]
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
    act[2:deg-k+1]=prev[1:deg-k] # px -> px*x
    act[1:deg-k].-=p.pts[k]*prev[1:deg-k]
  end
  PolC(act)
  
end
