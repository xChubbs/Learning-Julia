## Introduction to Scientific Machine Learning
#=
This part of the course it's going to be heavily based in the package
Flux, is an elegant machine learning package that will be the base 
and pillar to our upcoming projects and scientific focus models.
=#

using Flux

## Training Neural Network
#=
The training of a NN it's basically finding the way to minimize a
function, particullary it's a function that for desired values it
will output learned and predicted values for that data.
=#

NN = Chain(Dense(10, 32, tanh),
            Dense(32, 32, tanh),
            Dense(32,5))

loss() = sum(abs2, sum(abs2, NN(rand(10)).-1) for i in 1:100)
loss()

#=
At the start the model will be inneficient, and doesn't have
the desired behaviour. So we can see the problem we're looking here
=#

params = Flux.params(NN)

#=
For training we can now call the method, compared to the loss
function, give the initial parameters and an evolution model.
=#

Flux.train!(loss, params, Iterators.repeated((), 10000), ADAM(.1))

loss()

#=
It's important to note a huge decay in the loss function. Now the NN
it's an aproximator the the function f(x) = 1, we can compare them
to see the results.
=#

testSet = rand(10)
Error = sum(abs2, NN(testSet) .- 1)

#=
Let's see that in a brief case the NN it's an aproximation to data
trying to generalize a desired behaviour in the data. It's important
to point out that this implies that existence of a correlation in the
data used, and the existence of a mathematical model we can aproximate.
The new problem now it's finding the weights such that it minimizes the
loss function implied.
=#

## The Curse of Dimentionality
#=
If we go further in the Taylor aproximation approach, for one dimention 
it's just needed n coefficients, but if we explore the second dimention,
it's now needed the new dimention one dimentional expantion plus the
combination of this new terms (tensor of the dimentions). basically
for every d dimentional aproximation of n coefficients we have an 
exponential growth n^d. Neural Network overcome this curse.
Even it can be proof that a NN it's more efficient for 10 dimentional
operations even more than tensoring this dimentions.
=#