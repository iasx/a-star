import Base: getindex, setindex!

const Scene = Array{Float64,3}
const Point = Tuple{Int,Int}

function getindex(A::Matrix, I::Point)
  getindex(A, CartesianIndex(I))
end

function setindex!(A::Matrix, V::Any, I::Point)
  setindex!(A, V::Any, CartesianIndex(I))
end
