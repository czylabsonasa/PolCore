"""
    pre_interpol(t,f,kind; <keyword args>)

* performs pre-checks/type promotions before interpolation
"""
function pre_interpol(t,f,kind::String; rtol=1e-9)
  err(x)=error("$(kind) -> $(x)")
  isempty(t) && err("empty t")
  lt=length(t)
  (length(t)!=length(f)) && err("the length of t and f differs")
  st=Set(t)
  (length(st)!=lt) && err("t has equal elements")

  ncond=0
  T=eltype(t)
  for v in f
    if v isa Vector
      T=promote_type(T,eltype(v))
      ncond+=length(v)
    else
      T=promote_type(T,typeof(v))
      ncond+=1
    end
  end

  (T<:Integer) && (T=Rational{T})

  if T <: AbstractFloat
    tf=sort((t[k],f[k]) for k in 1:lt)
    ee=false
    prev=tf[1][1]
    for k in 2:lt
      act=tf[k][1]
      (abs(act-prev)<rtol*abs(act)) && (ee=true; break)
      prev=act
    end
    ee && err("'almost' equal values in t (rtol=$(rtol))")
  end
    

  comp_mode=if T<:Rational
    (a,b)->a//b
  else
    (a,b)->a/b
  end

  T,comp_mode,ncond
end

"""
    interpol_L(t,f; <keyword args>)

* t -> base points, f -> the corresponding values
* computes the minimal degree (Lagrange) interpolational pol. by the divided difference method

# Arguments

* rtol controls the equality for floats (relative tolerance)
"""
function interpol_L(t,f; rtol=1e-9)
  T,comp_mode,n=pre_interpol(t,f,"interp_L"; rtol=rtol)
    
  coeff=Vector{T}(undef,n)
  act=Vector{T}(undef,n)
  act.=f
  prev=Vector{T}(undef,n)
  coeff[1]=act[1]
  for j in 1:n-1
    act,prev=prev,act
    for i in 1:n-j
      act[i]=comp_mode(prev[i]-prev[i+1],t[i]-t[i+j])
    end
    coeff[j+1]=act[1]
  end
  Pol(coeff,t)
end



"""
    interpol_H(t,f; <keyword args>)

* t -> base points, f -> the corresponding values, that is f^(0),...,f^(k) at the given point
* computes the minimal degree (Hermite) interpolational pol. 
* by the divided difference method

# Arguments
* f is a vector of vectors - but for points where only the function value (f^(0)) is known, a plain 
scalar also acceptable.

* rtol controls the equality for floats (relative tolerance)
"""
function interpol_H(tt,ff; rtol=1e-9)
  T,comp_mode,n=pre_interpol(tt,ff,"interp_H"; rtol=rtol)
    

  bel=Vector{Int}(undef,n) # "belonging" to
  t=Vector{T}(undef,n)
  coeff=Vector{T}(undef,n)
  act=Vector{T}(undef,n)
  prev=Vector{T}(undef,n)

  ii=0
  for (i,v) in enumerate(tt)
    ni=length(ff[i])
    bel[ii+1:ii+ni].=i
    act[ii+1:ii+ni].=ff[i][1]
    t[ii+1:ii+ni].=v
    ii+=ni
  end

  fct=one(T)
  coeff[1]=act[1]
  for j in 1:n-1
    fct=fct*T(j)
    act,prev=prev,act
    for i in 1:n-j
      act[i]=if bel[i]==bel[i+j]
        comp_mode(ff[bel[i]][j+1],fct)
      else
        comp_mode(prev[i]-prev[i+1],t[i]-t[i+j])
      end
    end
    coeff[j+1]=act[1]
  end
  Pol(coeff,t)
end

