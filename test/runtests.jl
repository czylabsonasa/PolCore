# run some tests w/ PolCore


import Test:
  @test, @testset

import Polynomials:
  Polynomial

using PolCore


printstyled("testing agains Polynomials.jl\n",color=:light_red)
@testset "random integer coeff poly at random float points (approx)" begin 
  for t in 1:10
    deg=rand(3:10)
    pre=rand(-10:10,deg+1)
    p1=Polynomial(pre)
    p2=polcore(pre)
    pts=rand(10)
    @testset "eval" begin
      for x in pts
        @test isapprox(p1(x),p2(x))
      end
    end
  end 
end

@testset "random integer coeff poly at random rational points (exact)" begin 
  for t in 1:10
    deg=rand(3:8)
    pre=rand(-10:10,deg+1)
    p1=Polynomial(pre)
    p2=polcore(pre)
    nums=rand(-30:30,100)
    dens=rand(vcat(-30:-1,1:30),100)
    pts=nums.//dens
    @testset "eval" begin
      for x in pts
        @test p1(x)==p2(x)
      end
    end
  end 
end



@testset "random f64 coeff poly at random f64 points (timed,vectorized)" begin 
  deg=rand(20:30)
  pre=rand(deg+1)
  p1=Polynomial(pre)
  p2=polcore(pre)


  for _ in 1:10
    x=rand(1000000)

    printstyled("Polynomial:\n",color=:light_yellow)
    @time y1=p1.(x)

    printstyled("polcore:\n",color=:light_yellow)
    @time y2=p2.(x)

    printstyled("Polynomial:\n",color=:light_yellow)
    @time y1=p1.(x)

    printstyled("polcore:\n",color=:light_yellow)
    @time y2=p2.(x)
  end
end 
