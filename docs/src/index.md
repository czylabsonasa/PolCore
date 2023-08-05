## PolCore.jl

```@docs
PolCore.PolCore
```


```@autodocs
Modules = [PolCore]
Order   = [:type,:function]
```


### Examples

```jldoctest; output=false
# construct a poly `p`, such that p(k)=k+1 for k=0,...,4 and p(4)=0
# using Lagrange interpolation - after executing the expression below
using PolCore
pre=vcat(0:4,0);
t=pre[1:end-1];
f=pre[2:end];
p=interpol_L(t,f);
(p, all(p.(t).==f))

# you will/should see the result as:
# (1 + x - 5/24*x(x-1)(x-2)(x-3), true)


# output
(1 + x - 5/24*x(x-1)(x-2)(x-3), true)

```
