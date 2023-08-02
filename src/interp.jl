function interp_L(t,f)
  (isempty(t) || length(t)!=length(f)) && error("interp_L: wrong parameter(s)")
  
  T=promote_type(typeof(t[1]),typeof(f[1]))
  t=convert(Vector{T},t)
  f=convert(Vector{T},f)

  arule=if T<:Rational
    (a,b)->a//b
  else
    (a,b)->a/b
  end
    
  n=length(t)
  coeff=Vector{T}(undef,n)
  act=Vector{T}(undef,n)
  act.=f
  prev=Vector{T}(undef,n)
  coeff[1]=act[1]
  for j in 1:n-1
    act,prev=prev,act
    for i in 1:n-j
      act[i]=arule(prev[i]-prev[i+1],t[i]-t[i+j])
    end
    coeff[j+1]=act[1]
  end
  pol(coeff,copy(t))
end
