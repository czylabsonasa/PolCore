function pre_interpol(t,f,funname::String; atol=1e-9)
  err(x)=error("$(funname) -> $(x)")
  isempty(t) && err("empty t")
  lt=length(t)
  (length(t)!=length(f)) && err("the length of t and f differs")
  st=Set(t)
  (length(st)!=lt) && err("t has equal elements")
  
  T=promote_type(typeof(t[1]),typeof(f[1]))
  (T<:Integer) && (T=Rational{T})

  if T <: AbstractFloat
    tf=sort((t[k],f[k]) for k in 1:lt)
    ee=false
    prev=tf[1][1]
    for k in 2:lt
      act=tf[k][1]
      (abs(act-prev)<atol*abs(act)) && (ee=true; break)
      prev=act
    end
    ee && err("'almost' equal values in t (atol=$(atol))")
  end
    

  comp_mode=if T<:Rational
    (a,b)->a//b
  else
    (a,b)->a/b
  end

  T,comp_mode
end

function interpol_L(t,f; atol=1e-9)
  T,comp_mode=pre_interpol(t,f,"interp_L"; atol=atol)
    
  n=length(t)
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
  pol(coeff,t)
end
