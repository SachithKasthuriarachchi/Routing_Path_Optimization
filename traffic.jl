using Convex,LinearAlgebra,Pkg, Plots
using SCS
## Defining constants

A=[1 -1 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
-1 1 0 0 1 -1 1 -1 -1 1 0 0 0 0 0 0 0 0;
0 0 -1 1 -1 1 0 0 0 0 0 0 0 0 0 0 1 -1;
0 0 0 0 0 0 -1 1 0 0 -1 1 1 -1 0 0 0 0;
0 0 0 0 0 0 0 0 1 -1 1 -1 0 0 -1 1 -1 1;
0 0 0 0 0 0 0 0 0 0 0 0 -1 1 1 -1 0 0]

f14 = 2;
f26 = 5;
f36 = 7;
f61 = 6;

gamma = f14+f26+f36+f61;

s1 = [-f61;0;0;0;0;f61];
s4 = [f14;0;0;-f14;0;0];
s6 = [0;f26;f36;0;0;-f26-f36]

solver = () -> SCS.Optimizer(verbose=0);
## Problem 1

####part 1
####maximizing the total link utilization

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;

problem1 = maximize(sum(t/10))
problem1.constraints += [
    A * x1 == s1,
    A * x4 == s4,
    A * x6 == s6,
    x1 >= 0,
    x4 >= 0,
    x6 >= 0,
    t <= 10,
    t>=0
    ];

solve!(problem1, solver)

println("")
println("Maximizing the total link utilization")
println(problem1.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))

####part 2
####maximizing the minimum link utilization

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;
problem2 = maximize(minimum(t/10))

problem2.constraints += [
    A * x1 == s1,
    A * x4 == s4,
    A * x6 == s6,
    x1 >= 0,
    x4 >= 0,
    x6 >= 0,
    t <= 10,
    t>=0
    ];

solve!(problem2, solver)

println("")
println("Maximizing the minimum link utilization")
println(problem2.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))

optimum_utilization = problem2.optval

## Problem 2

####part 1
####minimize the total delay

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;

problem3 = minimize(sum(dot(/)(10/gamma,10-t))-18/gamma)
problem3.constraints += [
    A * x1 == s1,
    A * x4 == s4,
    A * x6 == s6,
    x1 >= 0,
    x4 >= 0,
    x6 >= 0,
    t <= 10,
    t >=0
    ];

solve!(problem3, solver)

println("")
println("Minimize the total delay")
println(problem3.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))
println("Link Delays =")
println(round.(dot(/)(evaluate(t)/gamma,10 .-evaluate(t)), digits=2))

####part 2
####minimizing the maximum delay

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;

problem4 = minimize(maximum(dot(/)(10/gamma,10-t)-1/gamma))
problem4.constraints += [
    A * x1 == s1,
    A * x4 == s4,
    A * x6 == s6,
    x1 >= 0,
    x4 >= 0,
    x6 >= 0,
    t <= 10,
    t >=0
    ];

solve!(problem4, solver)

println("")
println("Minimizing the maximum delay")
println(problem4.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))
println("Link Delays =")
println(round.(dot(/)(evaluate(t)/gamma,10 .-evaluate(t)), digits=2))

optimum_delay = problem4.optval

## Problem 3

####part 1
####Maximizing the total utilization with the optimum latency

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;

problem5 = maximize(sum(t/10))
problem5.constraints += [
    A * x1 == s1,
    A * x4 == s4,
    A * x6 == s6,
    x1 >= 0,
    x4 >= 0,
    x6 >= 0,
    t>=0,
    t <= 10,
    dot(/)(10/gamma,10-t)-1/gamma <=optimum_delay
    ];

solve!(problem5, solver)

println("")
println("Maximizing the total utilization with the optimum latency")
println(problem5.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))
println("Link Delays =")
println(round.(dot(/)(evaluate(t)/gamma,10 .-evaluate(t)), digits=2))

####part 2
####Maximizing the minimum utilization with the optimum latency

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;

problem6 = maximize(minimum(t/10))
problem6.constraints += [
    A * x1 == s1,
    A * x4 == s4,
    A * x6 == s6,
    x1 >= 0,
    x4 >= 0,
    x6 >= 0,
    t>=0,
    t <= 10,
    dot(/)(10/gamma,10-t)-1/gamma <=optimum_delay
    ];

solve!(problem6, solver)

println("")
println("Maximizing the minimum utilization with the optimum latency")
println(problem6.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))
println("Link Delays =")
println(round.(dot(/)(evaluate(t)/gamma,10 .-evaluate(t)), digits=2))

####part 3
####Minimizing the total delay with the optimum utilization

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;

problem7 = minimize(sum(dot(/)(10/gamma,10-t))-18/gamma)
problem7.constraints += [
    A * x1 == s1,
    A * x4 == s4,
    A * x6 == s6,
    x1 >= 0,
    x4 >= 0,
    x6 >= 0,
    t>=0,
    t>=10*optimum_utilization,
    t<= 10
    ]

solve!(problem7, solver)

println("")
println("Minimizing the total delay with the optimum utilization")
println(problem7.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))
println("Link Delays =")
println(round.(dot(/)(evaluate(t)/gamma,10 .-evaluate(t)), digits=2))

####part 4
####Minimizing the maximum delay with the optimum utilization

x1 = Variable(18,1);
x4 = Variable(18,1);
x6 = Variable(18,1);

t = x1 + x4 + x6;

problem8 = minimize(maximum(dot(/)(10/gamma,10-t)-1/gamma))
problem8.constraints += [
    A * x1 == s1,
    A * x4 == s4,
    A * x6 == s6,
    x1 >= 0,
    x4 >= 0,
    x6 >= 0,
    #=
    x6[14]==0,
    x6[15]==0,
    x4[8]==0,
    x4[13]==0,
    x4[12]==0,
    x1[1]==0,
    x1[3]==0,
    =#
    t >= 10*optimum_utilization, 
    t<= 10
];

solve!(problem8, solver)

println("")
println("8 Minimizing the maximum delay with the optimum utilization")
println(problem8.optval)
println(round.(evaluate(x1),digits=2))
println(round.(evaluate(x4),digits=2))
println(round.(evaluate(x6),digits=2))
println(round.(evaluate(t),digits=2))
println("Link Delays =")
println(round.(dot(/)(evaluate(t)/gamma,10 .-evaluate(t)), digits=2))

## Graph

f=[]
g=[]

# increse step for a smoother graph
for lambda = 0:0.1:1

    y1 = Variable(18,1);
    y4 = Variable(18,1);
    y6 = Variable(18,1);

    u = y1 + y4 + y6;

    obj_func = minimize(lambda*(maximum(dot(/)(10/gamma,10-u)-1/gamma)) + (1-lambda)*(-minimum(u/10)))
    obj_func.constraints += [
        A*y1 == s1,
        A*y4 == s4,
        A*y6 == s6,
        y1 >= 0,
        y4 >= 0,
        y6 >= 0,
        u<= 10
        ];

    solve!(obj_func, solver)
    push!(f,evaluate(maximum(dot(/)(10/gamma,10-u)-1/gamma)))
    push!(g,evaluate(-minimum(u/10)))
end

plot(g,f, title = "Maximum latency vs. minimum utilization")
xlabel!("(-) Minimum utilization")
ylabel!("Maximum latency")
