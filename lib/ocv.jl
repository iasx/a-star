using OpenCV
const cv = OpenCV
const title = "Window"

const cColors = Dict{Symbol,Vector{Float64}}(
  :black => [0.0, 0.0, 0.0],
  :red => [0.0, 0.0, 1.0],
  :green => [0.0, 1.0, 0.0],
  :yellow => [0.0, 1.0, 1.0],
  :blue => [1.0, 0.0, 0.0],
  :magenta => [1.0, 0.0, 1.0],
  :cyan => [1.0, 1.0, 0.0],
  :white => [1.0, 1.0, 1.0],
)

# *----------------------------------------------------------------------------*

"""Display scene in a window and wait for any key to exit."""
function cShow(scene::Union{cv.Mat,Scene})
  cv.namedWindow(title, cv.WINDOW_AUTOSIZE)

  while true
    cv.imshow(title, scene)
    cv.waitKey(1000) > 0x0 && break
  end

  cv.destroyAllWindows()
end

"""Save scaled scene to file."""
function cSave(scene::Scene, path::String, scale::Float64=25.0)
  cv.imwrite(path, cv.resize(
    scene,
    fx=scale,
    fy=scale,
    cv.Size{Int32}(0, 0),
    interpolation=cv.INTER_AREA
  ) * 255.0)
end

# *----------------------------------------------------------------------------*

"""Display scaled scene."""
function cPlot(scene::Scene, scale::Float64=25.0)
  canvas = OpenCV.resize(
    scene,
    fx=scale, fy=scale,
    cv.Size{Int32}(0, 0),
    interpolation=cv.INTER_AREA
  )

  cShow(canvas)
end

"""Display scaled scene."""
function cPlot(scene::Scene, scale::T) where {T<:Real}
  cPlot(scene, float(scale))
end

"""Display scene scaled to fit a window of a specific size."""
function cPlot(scene::Scene, window::Tuple{Int,Int})
  canvas = OpenCV.resize(
    scene,
    cv.Size{Int32}(window...),
    interpolation=cv.INTER_AREA
  )

  cShow(canvas)
end

# *----------------------------------------------------------------------------*

"""Create scene with colored maze."""
function cDraw((binary, color)::Pair{BitMatrix,Symbol})::Scene
  scene = ones(3, size(binary, 1), size(binary, 2))
  scene[:, findall(binary)] .= cColors[color]
  scene
end

"""Add colored route to scene."""
function cDraw!(scene::Scene, (line, color)::Pair{Vector{Point},Symbol})
  for point in line
    scene[:, CartesianIndex(point)] .= cColors[color]
  end
end

"""Add colored route to scene."""
function cDraw!(scene::Scene, (line, color)::Pair{MutableLinkedList{Point},Symbol})
  for point in line
    scene[:, CartesianIndex(point)] .= cColors[color]
  end
end

"""Add colored point to scene."""
function cDraw!(scene::Scene, (point, color)::Pair{Point,Symbol})
  scene[:, CartesianIndex(point)] .= cColors[color]
end

"""Add colored objects to scene."""
function cDraw!(scene::Scene, objects::Vararg{Pair})
  for object in objects
    cDraw!(scene, object)
  end
end

"""Create maze scene with colored objects."""
function cDraw((binary, color)::Pair{BitMatrix,Symbol}, objects::Vararg{Pair})::Scene
  scene = cDraw(binary => color)
  cDraw!(scene, objects...)
  scene
end
