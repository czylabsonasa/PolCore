function Base.adjoint(p::AbstractPol)
  hasproperty(p,:pts) && error("PolCore: derivative is not implemented for Newtonian-form")
  T=typeof(p.coeff[1])
  coeff=p.coeff[2:end]
  isempty(coeff) && (coeff=[zero(T)])
  coeff=coeff.*(1:length(coeff))
  pol(coeff)
end


