function Base.adjoint(p::AbstractPol)
  hasproperty(p,:pts) && error("PolCore: derivative is not implemented for Newtonian-form")
  T=typeof(p.coeff[1])
  coeff=p.coeff[2:end]
  isempty(coeff) && (coeff=[zero(T)])
  coeff=coeff.*(1:length(coeff))
  pol(coeff)
end


function Base.convert(PolC,p::PolN)
  act=similar(p.coeff)
  prev=similar(p.coeff)
  n=length(p.coeff)
  act[1]=p.coeff[n]
  for k in n-1:-1:1
    act,prev=prev,act
    act[1]=p.coeff[k] # px -> ... + coeff[k]
    act[2:n-k+1]=prev[1:n-k] # px -> px*x
    act[1:n-k].-=p.pts[k]*prev[1:n-k]
  end
  PolC{typeof(act[1])}(act)
  
end
