## First program and general notes of the Language

# Recall of the different packages
using FiniteDiff

# Hello World Command
print("Hello!")

# Creation of a lambda function
f(x) = 2x^2 + x

# Use of a function of the libraries
λ = FiniteDiff.finite_difference_derivative(f, 2.0)

# Greek symbols supported for the Language
print(λ)