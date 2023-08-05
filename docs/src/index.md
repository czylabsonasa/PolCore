## PolCore.jl

```@docs
PolCore.PolCore
```


```@autodocs
Modules = [PolCore]
Order   = [:type,:function]
```


### Examples

#### fixed-point iteration
```
Construct a polynomial `p`, such that p(k)=k+1 for k=0,...,4 and p(4)=0. Use Lagrange interpolation - executing the expression:
```

```jldoctest; output=false
using PolCore
pre=vcat(0:4,0)
t=pre[1:end-1]
f=pre[2:end]
p=interpol_L(t,f)
(p, all(p.(t).==f))

# output
(1 + x - 5/24*x(x-1)(x-2)(x-3), true)

```

```
you will/should see the result as:
(1 + x - 5/24*x(x-1)(x-2)(x-3), true)
```

