## Concepts 01. Memory Models, Mutation and Vectorization.
# Here we review concepts of memory use and impact in different
# Size variables.

# First class were taken offline, no coding notes for this offline

# Second class were taken live. The proceding code it's part of
# the class

## Type inference
# Every variable must have a type, important to give the part of
# memory the tag necesary for implementation & interpretation.
# Part of the Stack, and mutable in the Heap

typeof(2f0)
typeof('a')
typeof(2)
typeof([2f0, 2f1])

# The interpreter must know already the types needed and usable
# Part of definining functions it's flagging the variables, for 
# faster interpretation.

# The Julia approach, in functions it's a predisposition of the
# variables used based in the operations and types used, for ex.
using InteractiveUtils
using BenchmarkTools

f(x, y) = x + y
@code_llvm f(2, 5)
@code_llvm f(2f0, 5)
@code_llvm f(2, 5.)

# We see that all of the functions used are the same, but the 
# arguments creates different functions to be compiled.
# We can see the process of of tagging this different types, for ex.

function multipleAdditions(num1::Int64, num2::Int64)
    const1 = 4
    const2 = 2
    add1 = f(num1, const1)
    add2 = f(num2, const2)
    f(add1, add2)
end

@code_llvm multipleAdditions(2, 5)

# We can see that before-hand knowing the types involved in the 
# different operations, the interpreter already prepared the first
# addition of the constants involved.

@code_typed multipleAdditions(2, 5)
@code_lowered multipleAdditions(2, 5)

# This is the more naitive version of the code run.

@code_warntype multipleAdditions(2, 5)

# Information knowed before the code runned.

## Type stability
# For an unknown output the interpreter flags the possibilities of
# a value and prepare memory for both.

function randomOutput(num1::Integer, num2::Integer)
    output = num1 + num2
    rand() < .5 ? output : Float64(output)
end

@code_warntype randomOutput(2, 5)
@code_llvm randomOutput(2, 5)

## Multiple Dispatch
# Ability to creation of different functions depending in the data
# types of the arguments, this is the advantage of the declaration
# of the variables as typed, for ex.

function dispatchedFunction(num1::Integer, num2::Integer)
    num1 + num2
end

function dispatchedFunction(num1::Float64, num2::Float64)
    num1 / num2
end

dispatchedFunction(2, 5)
dispatchedFunction(2., 5.)

# This is the core of the interpreter and it's velocity, it's the base
# idea of the interpreter knowing how to create code.
# A code readable as python but fast as C

# In this ideas we can have a function

dispatchedFunction(num1, num2) = num1 - num2

# That's a generality for the rest of the non covered data types,
# this runs over the type of Any, universal type of variables

typeof(2) <: Any
typeof(2.) <: Any
typeof('a') <: Any
typeof(0b1) <: Any

# Finally this Multiple Dispatch will find the lowest type to reduce
# ambiguity, this is why for non-covered datatypes will be covered
# over the Any type. Let's see how types can affect the running time

array = ["First", "Second", "Third"]
vectorAny = ["1", 2., 3f0]
vectorInt = [1, 2, 3]

function typedExample(vector::Vector)
    const1 = 3
    const2 = 2
    sum1 = f(vector[2], const1)
    sum2 = f(vector[3], const2)
    f(sum1, sum2)
end

@code_warntype typedExample(vectorAny)
@btime typedExample(vectorAny)

@code_warntype typedExample(vectorInt)
@btime typedExample(vectorInt)

# We can see that just the knowledge and handling of the different 
# data types can represent huge amounts of time.

## Types definition
# We can define primitive types for the different needs in each case
# it takes the syntax primitive type TypeName No.Bits end

primitive type float64 64 end

# Also we can create structures for the needs, for ex.

struct Complex
    real::Int64
    imaginary::Int64
end

Base.:+(C1::Complex, C2::Complex) = 
    Complex(C1.real + C2.real, C1.imaginary + C2.imaginary)
Base.:+(N1::Number, C2::Complex) = 
    Complex(N1 + C2.real, C2.imaginary)
Base.:+(C1::Complex, N2::Number) = 
    Complex(N2 + C1.real, C1.imaginary)

# With the information we can now work with this new struct and
# plug it in the different functions already defined

C1 = Complex(2, 5)
C2 = Complex(0, 2)

C3 = f(C1, C2)
C4 = f(C1, 2)

@code_llvm f(C1, C2)
@code_warntype f(C1, 2.)

# For generalizing we can redifine as:

struct betterComplex{T}
    real::T
    imaginary::T
end

Base.:+(C1::betterComplex, C2::betterComplex) = 
    betterComplex(C1.real + C2.real, C1.imaginary + C2.imaginary)
Base.:+(N1::Number, C2::betterComplex) = 
    betterComplex(N1 + C2.real, C2.imaginary)
Base.:+(C1::betterComplex, N2::Number) = 
    betterComplex(N2 + C1.real, C1.imaginary)

struct worstComplex
    real
    imaginary
end

Base.:+(C1::worstComplex, C2::worstComplex) = 
    worstComplex(C1.real + C2.real, C1.imaginary + C2.imaginary)
Base.:+(N1::Number, C2::worstComplex) = 
    worstComplex(N1 + C2.real, C2.imaginary)
Base.:+(C1::worstComplex, N2::Number) = 
    worstComplex(N2 + C1.real, C1.imaginary)

# This new definition gives more flexibility for the new struct, and
# and now the own structure can redifine it's own type per compilation

C1 = betterComplex(2, 5)
C2 = betterComplex(0., 2.)

C3 = f(C1, C2)
C4 = f(C1, 2)

@code_llvm f(C1, C2)
@code_warntype f(C1, 2.)

# This new structure sacrifices the already known information for the
# new type for being easily adaptable

isbits(Complex(2, 5))
isbits(betterComplex(2, 5))
isbits(worstComplex(2, 5))

# This scope can be used in advantage to get more specialized
# algorithms

C1 isa Complex ? true : false