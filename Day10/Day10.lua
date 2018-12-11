
--[[

Day 10: Cut thin to win!

]]


print("---------------- Day 10 ----------------")


function printgrid(grid, minx, maxx, miny, maxy)
  local out, tins = {}, table.insert
  for row = miny, maxy do
    local outrow = {}
    grid[row] = grid[row] or {}
    for col = minx, maxx do
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


function calcminmaxarea(points)
  local minx, miny, maxx, maxy = math.huge, math.huge, -math.huge, -math.huge
  for _, p in ipairs(points) do
    if (p.x > maxx) then maxx = p.x end
    if (p.x < minx) then minx = p.x end
    if (p.y > maxy) then maxy = p.y end
    if (p.y < miny) then miny = p.y end
  end
  return math.abs(maxx-minx) * (math.abs(maxy-miny)), minx, maxx, miny, maxy -- Return area, min/max of x/y
end


function Day10(input)
  local points, tins = {}, table.insert

  -- Load up points...
  for _, line in pairs(input) do
    local _, _, posx, posy, volx, voly = line:find("position=<(.-),(.-)> velocity=<(.-),(.-)>")
    tins(points, {x = tonumber(posx), y = tonumber(posy), dx = tonumber(volx), dy = tonumber(voly)})
  end

  local count = 0
  local minarea = math.huge

  while (true) do

    -- See if this grid area is smaller than last one.  If so, keep going...  Smallest area of grid should be the decodeable one...
    local area = calcminmaxarea(points)
    if (area < minarea) then
      minarea = area
    else
      -- Grid area is growing, print previous grid, as it was smallest... 'Rewind' and fill grid...
      local grid = {}
      for _, p in ipairs(points) do
        p.x = p.x - p.dx 
        p.y = p.y - p.dy 
        grid[p.y] = grid[p.y] or {} 
        grid[p.y][p.x] = '*'
      end

      print("-------------------------------------------- " .. count-1 .. " --------------------------------------------")
      local _, minx, maxx, miny, maxy = calcminmaxarea(points)
      printgrid(grid, minx-1, maxx+1, miny-1, maxy+1) -- print with border of 1...
      return count-1
    end

    count = count + 1

    -- Apply velocity to current points...
    for p = 1, #points do
      local p = points[p]
      p.x = p.x + p.dx 
      p.y = p.y + p.dy 
    end
  end
end


-- Test TEST and INPUT values for ending second...
-- Only testing for which second if ended on... to see the message, see the output.

assert(Day10(TEST) == 3)
assert(Day10(INPUT) == 10515)

