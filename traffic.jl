using Convex,LinearAlgebra,Pkg
using SCS
## Defining constants

A=[1 -1 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
-1 1 0 0 1 -1 1 -1 -1 1 0 0 0 0 0 0 0 0;
0 0 -1 1 -1 1 0 0 0 0 0 0 0 0 0 0 1 -1;
0 0 0 0 0 0 -1 1 0 0 -1 1 1 -1 0 0 0 0;
0 0 0 0 0 0 0 0 1 -1 1 -1 0 0 -1 1 -1 1;
0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 -1 0 0]

f14 = 2;
f26 = 7;
f36 = 6;
f61 = 8;

s1 = [-f61;0;0;0;0;f61];
s4 = [f14;0;0;-f14;0;0];
s6 = [0;f26;f36;0;0;-f26-f36]

## Variables and parameters

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;
phi = [10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10]

## Problem
problem = maximize(minimum(t/10))

problem.constraints += [A * x1 == s1,A * x4 == s4,A * x6 == s6,x1 >= 0,x4 >= 0,
x6 >= 0,t <= phi];

solver = () -> SCS.Optimizer(verbose=0);
solve!(problem, solver)
println(problem.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))