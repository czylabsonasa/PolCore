"""
* only the very basic operations defined
* the coefficients are stored in increasing degree
* currently:
  * evaluation by `()`
  * derivative by `adjoint` (the apostrophe)
"""
module PolCore

  struct polcore{T<:Number}
    coeff::Vector{T}
    pts::Vector{T}
  end

  function polcore(coeff)
    isempty(coeff) && error("polcore: empty coeff vector")
    T=typeof(coeff[1])
    polcore{T}(coeff,T[])
  end
  export polcore


  function (p::polcore)(x)
    px=zero(promote_type(typeof(p.coeff[1]),typeof(x)))
    for c in p.coeff[end:-1:1]
      px=px*x+c
    end
    px
  end


  function Base.adjoint(p::polcore)
    T=typeof(p.coeff[1])
    coeff=p.coeff[2:end]
    isempty(coeff) && (coeff=[zero(T)])
    coeff=coeff.*(1:length(coeff))
    polcore(coeff,T[])
  end

end # module PolCore
