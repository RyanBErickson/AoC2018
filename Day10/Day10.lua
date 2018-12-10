
--[[

Day 10: Cut thin to win!

]]


print("---------------- Day 10 ----------------")


function printgrid(grid, min, max)
  min = min or 0
  max = max or 0
  local out, tins = {}, table.insert
  for row = min, max do
    local outrow = {}
    grid[row] = grid[row] or {}
    for col = min, max do
      tins(outrow, (grid[row][col] or '.'))
    end
    tins(out, table.concat(outrow))
  end
  print(table.concat(out, '\n'))
end


-- Read Test Inputs...
TEST = {}
table.insert(TEST, "position=< 9,  1> velocity=< 0,  2>")
table.insert(TEST, "position=< 7,  0> velocity=<-1,  0>")
table.insert(TEST, "position=< 3, -2> velocity=<-1,  1>")
table.insert(TEST, "position=< 6, 10> velocity=<-2, -1>")
table.insert(TEST, "position=< 2, -4> velocity=< 2,  2>")
table.insert(TEST, "position=<-6, 10> velocity=< 2, -2>")
table.insert(TEST, "position=< 1,  8> velocity=< 1, -1>")
table.insert(TEST, "position=< 1,  7> velocity=< 1,  0>")
table.insert(TEST, "position=<-3, 11> velocity=< 1, -2>")
table.insert(TEST, "position=< 7,  6> velocity=<-1, -1>")
table.insert(TEST, "position=<-2,  3> velocity=< 1,  0>")
table.insert(TEST, "position=<-4,  3> velocity=< 2,  0>")
table.insert(TEST, "position=<10, -3> velocity=<-1,  1>")
table.insert(TEST, "position=< 5, 11> velocity=< 1, -2>")
table.insert(TEST, "position=< 4,  7> velocity=< 0, -1>")
table.insert(TEST, "position=< 8, -2> velocity=< 0,  1>")
table.insert(TEST, "position=<15,  0> velocity=<-2,  0>")
table.insert(TEST, "position=< 1,  6> velocity=< 1,  0>")
table.insert(TEST, "position=< 8,  9> velocity=< 0, -1>")
table.insert(TEST, "position=< 3,  3> velocity=<-1,  1>")
table.insert(TEST, "position=< 0,  5> velocity=< 0, -1>")
table.insert(TEST, "position=<-2,  2> velocity=< 2,  0>")
table.insert(TEST, "position=< 5, -2> velocity=< 1,  2>")
table.insert(TEST, "position=< 1,  4> velocity=< 2,  1>")
table.insert(TEST, "position=<-2,  7> velocity=< 2, -2>")
table.insert(TEST, "position=< 3,  6> velocity=<-1, -1>")
table.insert(TEST, "position=< 5,  0> velocity=< 1,  0>")
table.insert(TEST, "position=<-6,  0> velocity=< 2,  0>")
table.insert(TEST, "position=< 5,  9> velocity=< 1, -2>")
table.insert(TEST, "position=<14,  7> velocity=<-2,  0>")
table.insert(TEST, "position=<-3,  6> velocity=< 2, -1>")


-- Read 'Real' Inputs...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end


function Day10(input)
  local points, tins = {}, table.insert

  -- Load up points...
  for i, line in pairs(input) do
    local _, _, posx, posy, volx, voly = line:find("position=<(.-),(.-)> velocity=<(.-),(.-)>")
    tins(points, {x = tonumber(posx), y = tonumber(posy), dx = tonumber(volx), dy = tonumber(voly)})
  end

  local gridsize = math.huge
  local curgrid
  local i = 0

  while (true) do
    local sky = {}
    local min = math.huge
    local max = -math.huge

    for p = 1, #points do
      local x = points[p].x
      local y = points[p].y
      sky[y] = sky[y] or {} 
      sky[y][x] = '*'
      if (x < min) then min = x end
      if (y < min) then min = y end
      if (x > max) then max = x end
      if (y > max) then max = y end
    end

    -- See if this grid is smaller than last one.  If so, store it...
    -- Smallest version of grid should be the decodeable one...
    if ((max - min) < gridsize) then
      gridsize = max - min
      curgrid = sky
    else
      -- Once grid starts growing, print last one, as it was smallest...
      print(i-1 .. " -----------------------------")
      printgrid(curgrid, min, max)
      return i-1
    end

    i = i + 1

    -- Apply velocity to current points...
    for p = 1, #points do
      local p = points[p]
      p.x = p.x + p.dx 
      p.y = p.y + p.dy 
    end
  end
end


assert(Day10(TEST) == 3) -- Only testing for which second if ended on... to see the message, see the output.
assert(Day10(INPUT) == 10515) -- Same.

