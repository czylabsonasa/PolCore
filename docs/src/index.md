## PolCore.jl

```@docs
PolCore.PolCore
```


```@autodocs
Modules = [PolCore]
Order   = [:type,:function]
```


### Examples

#### sum of powers
```
Construct a "sum of powers" polynomial `p_d`, such that p_d(k)=1^d+...+k^d for d=1,...,3.
Use Lagrange interpolation - executing the expression:
```

```jldoctest; output=false
using PolCore
for d in 1:3
  # construct it
  t=1:(d+2)
  f=cumsum(t.^d)
  p_d=interpol_L(t,f)
  # test it
  tt=1:100
  ff=cumsum(tt.^d)
  println((p_d, all(p_d.(tt).==ff)))
end

# output
(1 + 2*(x-1) + 1//2*(x-1)(x-2), true)
(1 + 4*(x-1) + 5//2*(x-1)(x-2) + 1//3*(x-1)(x-2)(x-3), true)
(1 + 8*(x-1) + 19//2*(x-1)(x-2) + 3*(x-1)(x-2)(x-3) + 1//4*(x-1)(x-2)(x-3)(x-4), true)

```

```
you will/should see the result as:
(1 + 2*(x-1) + 1//2*(x-1)(x-2), true)
(1 + 4*(x-1) + 5//2*(x-1)(x-2) + 1//3*(x-1)(x-2)(x-3), true)
(1 + 8*(x-1) + 19//2*(x-1)(x-2) + 3*(x-1)(x-2)(x-3) + 1//4*(x-1)(x-2)(x-3)(x-4), true)
```



#### fixed-point iteration
```
Construct a polynomial `p`, such that p(k)=k+1 for k=0,...,3 and p(4)=0. 
Use Lagrange interpolation - executing the expression:
```

```jldoctest; output=false
using PolCore
pre=vcat(0:4,0)
t=pre[1:end-1]
f=pre[2:end]
p=interpol_L(t,f)
(p, all(p.(t).==f))

# output
(1 + x - 5//24*x(x-1)(x-2)(x-3), true)

```

```
you will/should see the result as:
(1 + x - 5//24*x(x-1)(x-2)(x-3), true)
```

#### Newton iteration
```
Construct a polynomial p, such that ns(k)=k+1 for k=0,...,2 and ns(3)=0, where 
ns(x)=x-p(x)/p'(x) is the Newton-step. From the conditions: p(k)=-p'(k) for k=0,...,2 and 
p(3)=3*p'(3). By setting p'(k)=1 for k=0,...,3 (an ad hoc choice) the p(k)-s are determined.
Use Hermite interpolation - executing the expression:
```

```jldoctest; output=false
using PolCore
p=interpol_H([0,1,2,3],[[-1,1],[-1,1],[-1,1],[3,1]])
dp=p'
ns(x)=x-p(x)//dp(x)
(p, all(ns.([0,1,2,3]).==[1,2,3,0]))

# output
(-1 + x - x^2 + 2*x^2(x-1) - 3//2*x^2(x-1)^2 + 3//2*x^2(x-1)^2(x-2) - 13//18*x^2(x-1)^2(x-2)^2 + 4//27*x^2(x-1)^2(x-2)^2(x-3), true)

```

```
you will/should see the result as:
(-1 + x - x^2 + 2*x^2(x-1) - 3//2*x^2(x-1)^2 + 3//2*x^2(x-1)^2(x-2) - 13//18*x^2(x-1)^2(x-2)^2 + 4//27*x^2(x-1)^2(x-2)^2(x-3), true)
```
