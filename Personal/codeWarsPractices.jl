## CodeWars Practices done during the weekend
# In this code you will find some of the test coding made during
# the weekend, focusing in the basics of the language.

using BenchmarkTools

function makenegative(number::Int)
    if number > 0
        number = -number
    end
    return number
end

testCase= -1
@btime makenegative(testCase)

function friend(friends::Vector{Any})
    return filter(name -> length(name) == 4, friends)
end

testCase=  ["Ryan", "Kieran", "Jason", "Yous"]
@btime friend(testCase)

function findmissingletter(chars::Vector{Char})
    for char= chars[begin]:chars[end]
        if !(char in chars)
            return char
        end
    end
end

testCase= ['a','b','c','d','f']

@btime findmissingletter(testCase)