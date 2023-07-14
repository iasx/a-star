using DataStructures

"""Convert obstacle map to distance matrix."""
function distMap(obstacles::BitMatrix)::Matrix{Float64}
  W::Matrix{Float64} = ones(size(obstacles))
  W[obstacles] .= NaN
  W
end

"""Euclidean distance between two points."""
function H(X::Point, Y::Point)::Float64
  sqrt(sum((X .- Y) .^ 2))
end

"""Legitimate neighbors of a point."""
function neighbors(X::Point, M::Array)::MutableLinkedList{Point}
  Y::MutableLinkedList{Point} = MutableLinkedList{Point}()

  X[1] < size(M, 1) && push!(Y, (X[1] + 1, X[2]))
  X[2] < size(M, 2) && push!(Y, (X[1], X[2] + 1))
  X[1] > 1 && push!(Y, (X[1] - 1, X[2]))
  X[2] > 1 && push!(Y, (X[1], X[2] - 1))

  filter(x::Point -> !isnan(M[x]), Y)
end

"""Best path between two points."""
function AStar(A::Point, B::Point, W::Matrix{Float64})::Union{MutableLinkedList{Point},Nothing}
  prev = Dict{Point,Union{Point,Nothing}}(A => nothing)
  open = PriorityQueue{Point,Float64}(A => 0)
  path = Dict{Point,Float64}(A => 0)
  closed = Set{Point}()

  while !isempty(open)
    X = dequeue!(open)
    X == B && break

    for N in neighbors(X, W)
      N in closed && continue

      G = path[X] + W[N]

      if haskey(open, N) && G < path[N]
        delete!(open, N)
      end

      if !(haskey(open, N) || N in closed)
        enqueue!(open, N => G + H(N, B))
        prev[N] = X
        path[N] = G
      end
    end

    push!(closed, X)
  end

  haskey(prev, B) || return nothing

  result = MutableLinkedList{Point}()
  cursor = B

  while !isnothing(cursor)
    pushfirst!(result, cursor)
    cursor = prev[cursor]
  end

  result
end