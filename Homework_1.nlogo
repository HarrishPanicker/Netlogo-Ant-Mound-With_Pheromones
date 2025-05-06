turtles-own [food-eaten]
patches-own [pheromone]

to setup
  clear-all
  reset-ticks
  create-turtles population
  ask turtles
  [
    set shape "bug"
    set size 2
    set color white
    set food-eaten 0
  ]
  grow-food
  color-nest
end

to go
  if not any? patches with [pcolor = green] [stop]
  ask turtles
  [
    ;colors the current patch with pheromone
    ask patch-here [set pheromone pheromone + 1]

    ;if true rotate right, if false rotate left. Then move forward.
    ifelse coin-flip?[right random max-turn-angle][left random max-turn-angle]
    forward random max-step-size

    ;If the patch is green, set it to black, and add 1 to the total food-eaten by this turtle.
    if pcolor = green;
    [
      set pcolor black
      set food-eaten (food-eaten + 1)

      let target-patch min-one-of patches with [pcolor = brown][distance myself]
      move-to target-patch
    ]

    ;if  the turtle ate more than 2, turn the turtle blue
    if (food-eaten > 2)
    [
      set color blue
    ]

    ;if the turtle ate more than 4 green patches, turn the turtle yellow
    if (food-eaten > 4)
    [
      set color yellow
    ]

    if pheromone > 0
    [
      let target-patch min-one-of patches with [pheromone > 0] [distance myself]
      move-to target-patch
    ]

    ask patches with [pheromone > 0] [set pheromone pheromone - (1 / pheromone-evaporation-time)]
  ]
  tick
end

to-report coin-flip? ;returns true or false at random
  report random 2 = 0
end

to color-nest
  let center-x (max-pxcor + min-pxcor) / 2
  let center-y (max-pycor + min-pxcor) / 2

  ask patches with [ abs (pycor - center-y) < 3 and abs (pxcor - center-x) < 3 ]
  [set pcolor brown]
end

to grow-food
  ask patches
  [set pcolor green]

end

