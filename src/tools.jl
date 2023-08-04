"""
    derivative
"""
function Base.adjoint(p::AbstractPol)
  hasproperty(p,:pts) && error("PolCore: derivative is not implemented for Newtonian-form")
  T=eltype(p.coeff)
  coeff=p.coeff[1:deg]
  isempty(coeff) && (coeff=[zero(T)])
  coeff=coeff.*(1:deg)
  Pol(coeff)
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
  Pol(act)
  
end
