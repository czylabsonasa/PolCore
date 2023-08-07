
<a id='PolCore.jl'></a>

<a id='PolCore.jl-1'></a>

## PolCore.jl

<a id='PolCore.PolCore' href='#PolCore.PolCore'>#</a>
**`PolCore.PolCore`** &mdash; *Module*.



```julia
module PolCore
```

  * minimalistic polynomial toolset

      * reason why: did not find a Newtonian-form polynomial+generalized Horner evaluator (for Hermite interpolation)
  * "features":

      * types: `PolC` -> classical, `PolN` -> Newton-form (plain Vector based types)
      * brute-force convert `PolN` to `PolC` (easier to comp. the derivative)
      * evaluation by `()`
      * derivative by `adjoint` (the apostrophe)
      * Lagrange-interpolation: `interpol_L`
      * Hermite-interpolation: `interpol_H`


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/PolCore.jl#L4-L16' class='documenter-source'>source</a><br>

<a id='PolCore.AbstractPol' href='#PolCore.AbstractPol'>#</a>
**`PolCore.AbstractPol`** &mdash; *Type*.



```julia
AbstractPol
```

  * the abstract type above all


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/PolCore.jl#L19-L23' class='documenter-source'>source</a><br>

<a id='PolCore.AbstractPol-Tuple{Any}' href='#PolCore.AbstractPol-Tuple{Any}'>#</a>
**`PolCore.AbstractPol`** &mdash; *Method*.



```julia
(AbstractPol)(x)
```

  * evaluation by Horner


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/PolCore.jl#L91-L95' class='documenter-source'>source</a><br>

<a id='PolCore.PolC' href='#PolCore.PolC'>#</a>
**`PolCore.PolC`** &mdash; *Type*.



```julia
struct PolC
```

  * field: `coeff::Vector{T}`
  * represents a polynomial in classical-form:

$$
p(x)=\sum_{k=0}^n coeff[k+1]x^k
$$


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/PolCore.jl#L27-L35' class='documenter-source'>source</a><br>

<a id='PolCore.PolN' href='#PolCore.PolN'>#</a>
**`PolCore.PolN`** &mdash; *Type*.



```julia
struct PolN
```

  * fields: `coeff::Vector{T}` and `pts::Vector{T}`
  * represents a polynomial in Newton-form:

$$
p(x)=\sum_{k=0}^n coeff[k+1]n_k(x)
$$

where

$$
n_{k}(x)=\prod_{i=0}^{k-1} (x-pts[i+1])
$$

note, that the empty product is 1.


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/PolCore.jl#L42-L55' class='documenter-source'>source</a><br>

<a id='Base.adjoint-Tuple{PolCore.AbstractPol}' href='#Base.adjoint-Tuple{PolCore.AbstractPol}'>#</a>
**`Base.adjoint`** &mdash; *Method*.



```julia
derivative of polynomial
```

  * dp=p' (first the polynomial converted to classical form if neccessary)


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/tools.jl#L1-L5' class='documenter-source'>source</a><br>

<a id='Base.convert-Tuple{Type{PolC}, PolN}' href='#Base.convert-Tuple{Type{PolC}, PolN}'>#</a>
**`Base.convert`** &mdash; *Method*.



```julia
converts from Newton to classical
```

  * essentially Horner method -> brute force


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/tools.jl#L25-L29' class='documenter-source'>source</a><br>

<a id='Base.show-Tuple{IO, PolCore.AbstractPol}' href='#Base.show-Tuple{IO, PolCore.AbstractPol}'>#</a>
**`Base.show`** &mdash; *Method*.



```julia
Base.show(p::AbstractPol;<keyword arguments>)
```

**Arguments**

  * var: a String used as a variable name, default "x"
  * order: a Symbol -> :inc, :dec, :rand, default is :inc
  * digits: num. of digs. used for Float coeff (+pts), default is 4
  * sorry for the mess...


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/io.jl#L22-L30' class='documenter-source'>source</a><br>

<a id='PolCore.Pol' href='#PolCore.Pol'>#</a>
**`PolCore.Pol`** &mdash; *Function*.



```julia
Pol(coeff,pts=[])
```

  * convenience function for contruct pol. from `Vector`s


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/PolCore.jl#L64-L68' class='documenter-source'>source</a><br>

<a id='PolCore.interpol_H-Tuple{Any, Any}' href='#PolCore.interpol_H-Tuple{Any, Any}'>#</a>
**`PolCore.interpol_H`** &mdash; *Method*.



```julia
interpol_H(t,f; <keyword args>)
```

  * t -> base points, f -> the corresponding values, that is f^(0),...,f^(k) at the given point
  * computes the minimal degree (Hermite) interpolational pol.
  * by the divided difference method

**Arguments**

  * f is a vector of vectors - but for points where only the function value (f^(0)) is known, a plain

scalar also acceptable.

  * rtol controls the equality for floats (relative tolerance)


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/interpol.jl#L80-L92' class='documenter-source'>source</a><br>

<a id='PolCore.interpol_L-Tuple{Any, Any}' href='#PolCore.interpol_L-Tuple{Any, Any}'>#</a>
**`PolCore.interpol_L`** &mdash; *Method*.



```julia
interpol_L(t,f; <keyword args>)
```

  * t -> base points, f -> the corresponding values
  * computes the minimal degree (Lagrange) interpolational pol. by the divided difference method

**Arguments**

  * rtol controls the equality for floats (relative tolerance)


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/interpol.jl#L50-L59' class='documenter-source'>source</a><br>

<a id='PolCore.pre_interpol-Tuple{Any, Any, String}' href='#PolCore.pre_interpol-Tuple{Any, Any, String}'>#</a>
**`PolCore.pre_interpol`** &mdash; *Method*.



```julia
pre_interpol(t,f,kind; <keyword args>)
```

  * performs pre-checks/type promotions before interpolation


<a target='_blank' href='https://github.com/czylabsonasa/PolCore/blob/d39c5537ea78fab32113f8dd2367f2145c551e70/src/interpol.jl#L1-L5' class='documenter-source'>source</a><br>


<a id='Examples'></a>

<a id='Examples-1'></a>

### Examples


<a id='sum-of-powers'></a>

<a id='sum-of-powers-1'></a>

#### sum of powers


```
Construct a "sum of powers" polynomial `p_d`, such that p_d(k)=1^d+...+k^d for d=1,...,3.
Use Lagrange interpolation - executing the expression:
```


```julia
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
```


```
you will/should see the result as:
(1 + 2*(x-1) + 1//2*(x-1)(x-2), true)
(1 + 4*(x-1) + 5//2*(x-1)(x-2) + 1//3*(x-1)(x-2)(x-3), true)
(1 + 8*(x-1) + 19//2*(x-1)(x-2) + 3*(x-1)(x-2)(x-3) + 1//4*(x-1)(x-2)(x-3)(x-4), true)
```


<a id='fixed-point-iteration'></a>

<a id='fixed-point-iteration-1'></a>

#### fixed-point iteration


```
Construct a polynomial `p`, such that p(k)=k+1 for k=0,...,3 and p(4)=0. 
Use Lagrange interpolation - executing the expression:
```


```julia
using PolCore
pre=vcat(0:4,0)
t=pre[1:end-1]
f=pre[2:end]
p=interpol_L(t,f)
(p, all(p.(t).==f))
```


```
you will/should see the result as:
(1 + x - 5//24*x(x-1)(x-2)(x-3), true)
```


<a id='Newton-iteration'></a>

<a id='Newton-iteration-1'></a>

#### Newton iteration


```
Construct a polynomial p, such that ns(k)=k+1 for k=0,...,2 and ns(3)=0, where 
ns(x)=x-p(x)/p'(x) is the Newton-step. From the conditions: p(k)=-p'(k) for k=0,...,2 and 
p(3)=3*p'(3). By setting p'(k)=1 for k=0,...,3 (an ad hoc choice) the p(k)-s are determined.
Use Hermite interpolation - executing the expression:
```


```julia
using PolCore
p=interpol_H([0,1,2,3],[[-1,1],[-1,1],[-1,1],[3,1]])
dp=p'
ns(x)=x-p(x)//dp(x)
(p, all(ns.([0,1,2,3]).==[1,2,3,0]))
```


```
you will/should see the result as:
(-1 + x - x^2 + 2*x^2(x-1) - 3//2*x^2(x-1)^2 + 3//2*x^2(x-1)^2(x-2) - 13//18*x^2(x-1)^2(x-2)^2 + 4//27*x^2(x-1)^2(x-2)^2(x-3), true)
```

