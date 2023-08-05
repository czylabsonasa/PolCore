"""
    derivative of polynomial

* dp=p' (but the user should convert to PolC first)
"""
function Base.adjoint(p::AbstractPol)
  err(x)=error("derivative -> $(x)")
  hasproperty(p,:pts) && err("not implemented for Newtonian-form")
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
  act[0]=p.coeff[deg]
  for k in deg-1:-1:0
    act,prev=prev,act
    act[0]=p.coeff[k] # px -> ... + coeff[k]
    act[1:deg-k]=prev[0:deg-k-1] # px -> px*x
    act[0:deg-k-1].-=p.pts[k]*prev[0:deg-k-1]
  end
  PolC(act)
  
end
