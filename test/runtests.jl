# run some tests w/ PolCore

tst=0
ph(x="\n")=(global tst+=1;printstyled("\n($(tst)) $(x)"; color=:light_yellow))


import Test:
  @test, @testset

import Polynomials:
  Polynomial

using PolCore

using StatsBase
using DataInterpolations

"""
Testing constructors (really Pol is under test)
here we expect catched errors.
"""|>ph

println("\n  no argument:")
try 
  Pol()
catch e
  @error e
end

println("\n  empty coeff:")
try 
  Pol([])
catch e
  @error e
end

println("\n  coeff and pts are not equal sized:")
try 
  Pol([1],[1,2])
catch e
  @error e
end

"""
Construct and eval 
some simple polynomial
"""|>ph

@testset "($(tst))" begin
  @test (p=Pol([0]);all(p.(-10:10).==0 ))
  @test (p=Pol([0,1]);all(p.(-10:10).== -10:10 ))
  @test (p=Pol([1,-2,1]);p(1) == 0)
  @test (p=Pol([1.0,-2,1]);p(1.0) == 0.0)
end

"""
Eval test - using Polynomials
"""|>ph

@testset "($(tst))" begin 
  deg=rand(5:7)

  coeff=rand(-10:10,deg+1)
  p1=Polynomial(coeff)
  p2=Pol(coeff)
  x=rand(10)
  @test isapprox(p1.(x),p2.(x))
  x=rand(-100:100,10)
  @test all(p1.(x) .== p2.(x))
  x=rand(-100:100,10).//rand(2:33,10)
  @test all(p1.(x) .== p2.(x))
end


"""
Lagrange interpolation
using DataInterpolation
"""|>ph

@testset "($(tst))"  begin
nt=rand(3:10)
t=sample(-30:30,nt,replace=false,ordered=true)
f=sample(-30:30,nt).*1.0
p1=LagrangeInterpolation(f,t)
x=rand(-30:30,100)
y1=p1.(x)
p2=interpol_L(t,f)
y2=p2.(x)
@test isapprox(y1,y2)
end


"""
Random f64 coeff poly eval 
at random f64 points 
timed,vectorized
"""|>ph

pct,pt=0.0,0.0
@testset "($(tst))" begin 
  global pt,pct
  deg=rand(20:30)
  pre=rand(deg+1)
  p1=Polynomial(pre)
  p2=Pol(pre)

  for _ in 1:3
    x=rand(10000000)
    t=time()
    y2=p2.(x)
    pct+=time()-t

    t=time()
    y1=p1.(x)
    pt+=time()-t

    @test isapprox(y1,y2)
  end
end 
"""
--------------
elapsed times:
Polynomials -> $(round(pt,digits=4))
PolCore     -> $(round(pct,digits=4))
"""|>print
