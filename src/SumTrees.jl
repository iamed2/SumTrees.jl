module SumTrees

export SumTree

import Base: show, setindex!, getindex, sum
import Base: start, next, done, length, eltype

immutable SumTree{T, NCells}
    tree::Vector{T}
end

function SumTree{T}(::Type{T}, ncells::Integer)
    SumTree{T, ncells}(zeros(T, 2 * ncells - 1))
end

# default type is Float64
SumTree(ncells::Integer) = SumTree(Float64, ncells)

function setindex!{T, NCells}(tree::SumTree{T, NCells}, value::T, idx::Integer)
    if idx < 1 || idx > NCells
        throw(BoundsError(tree, idx))
    end

    idx += NCells - 1
    tree.tree[idx] = value

    # bubble up sums
    while idx > 1
        tree.tree[idx >>> 1] = tree.tree[idx] + tree.tree[idx $ 1]
        idx >>>= 1
    end

    return nothing
end

function setindex!{T, NCells}(tree::SumTree{T, NCells}, value, idx::Integer)
    setindex!(tree, convert(T, value), idx)
end

function getindex{T, NCells}(tree::SumTree{T, NCells}, idx)
    if idx < 1 || idx > NCells
        throw(BoundsError(tree, idx))
    end

    tree.tree[idx + NCells - 1]
end

sum(tree::SumTree) = tree.tree[1]

length{T, NCells}(tree::SumTree{T, NCells}) = NCells

start{T, NCells}(tree::SumTree{T, NCells}) = NCells
next{T, NCells}(tree::SumTree{T, NCells}, state) = (tree.tree[state]::T, state + 1)
done{T, NCells}(tree::SumTree{T, NCells}, state) = state >= 2 * NCells

eltype{T, NCells}(tree::SumTree{T, NCells}) = T

function show{T, NCells}(io::IO, tree::SumTree{T, NCells})
    println(io, "SumTree{$T, $(NCells)} ::")

    level = 1
    while level <= NCells
        print(io, "    (")
        next_level = level * 2
        for i = level:(next_level - 1)
            print(io, "$(tree.tree[i]),")
        end
        println(io, ")")

        level = next_level
    end
end


end # module
