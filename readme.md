### PolCore 
* minimal set of polynomial operations

* usage:
```julia
import Pkg
Pkg.activate(;temp=true)
Pkg.add(;url="https://github.com/czylabsonasa/PolCore")
Pkg.add("Polynomials") # for testing
import Polynomials: Polynomial, derivative
...

```
