include("lib/types.jl")
include("lib/astar.jl")
include("lib/maps.jl")
include("lib/ocv.jl")

# TODO: stepwise animation

# *----------------------------------------------------------------------------*

# Start And Goal
A::Point = (7, 10)
B::Point = (1, 5)

# Obstacle Map -> Distance Matrix
W::Matrix{Float64} = distMap(Maps.M1)

# Get Shortest Path
Z::MutableLinkedList{Point} = AStar(A, B, W)

# Visualization
cDraw(
  Maps.M1 => :black,  # Obstacles
  Z => :yellow,       # Result
  A => :green,        # Start
  B => :red           # Goal
) |> cPlot

# *----------------------------------------------------------------------------*

A, B = (1, 1), (11, 10)
W = distMap(Maps.M2)
Z = AStar(A, B, W)

cDraw(
  Maps.M2 => :black,  # Obstacles
  Z => :yellow,       # Result
  A => :green,        # Start
  B => :red           # Goal
) |> cPlot

# *----------------------------------------------------------------------------*

A, B = (2, 2), (80, 40)
W = distMap(Maps.M3)
Z = AStar(A, B, W)
S = cDraw(
  Maps.M3 => :black,  # Obstacles
  Z => :yellow,       # Result
  A => :green,        # Start
  B => :red           # Goal
)

# Plot With Specific Window Size
cPlot(S, (800, 400))

# Save Result To File
# cSave(S, "imgs/path.png")
