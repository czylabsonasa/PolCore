### PolCore 
* minimal set of polynomial operations
* [docs](docs/build/index.md)
* you can pass the example expressions to `include_string` as follows:
```julia
"""
...paste here the the expr. to be executed...
""" |> x->include_string(Main,x)
```


* example usage (from the docs):
```julia
import Pkg
Pkg.activate(;temp=true)
Pkg.add(;url="https://github.com/czylabsonasa/PolCore")
using PolCore
pre=vcat(0:4,0);
t=pre[1:end-1];
f=pre[2:end];
p=interpol_L(t,f);
(p, all(p.(t).==f))
```
