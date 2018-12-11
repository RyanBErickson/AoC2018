
--[[

Day 11: Sum the Squares...

]]


print("---------------- Day 11 ----------------")


function printgrid(grid, min, max)
  min = min or 0
  max = max or 0
  local out, tins = {}, table.insert
  for row = min, max do
    local outrow = {}
    grid[row] = grid[row] or {}
    for col = min, max do
      tins(outrow, string.format("%3d ", grid[row][col]))
    end
    tins(out, table.concat(outrow))
  end
  print(table.concat(out, '\n'))
end



function calctotal(grid, x, y, size)
  local sum = 0
  if (x+size-1 > 300) then return 0 end
  if (y+size-1 > 300) then return 0 end
  for yi = y, y+size-1 do
    for xi = x, x+size-1 do
      if (grid[yi] ~= nil) then
        sum = sum + (grid[yi][xi] or -math.huge) -- not found == out-of-bound...
      end
    end
  end
  return sum
end


function Day11(grid_serial, size, sqmin, sqmax)
  local grid = {}
  sqmin = sqmin or 1
  sqmax = sqmax or 300

  -- Assign power levels per item
  for x = 1, size do
    for y = 1, size do
      grid[y] = grid[y] or {} 

      local rack_id = x + 10
      local val = (rack_id * y) + grid_serial
      local val = val * rack_id

      -- keep hundreds digit
      local hundreds = tostring(val):sub(-3, -3)
      hundreds = tonumber(hundreds) or 0
      hundreds = hundreds - 5

      grid[y][x] = hundreds
    end
  end

  -- Find highest YxY grid area...
  local max = -math.huge
  local maxx, maxy, maxsize, maxsquare = 0, 0, 0, 0
  for x = 1, size-2 do
    --print(x)
    for y = 1, size-2 do
      for squaresize = sqmin, sqmax do
      local val = calctotal(grid,x,y,squaresize)
      if (val > max) then
        max = val
        maxx = x
        maxy = y
        maxsquare = squaresize
      end
    end
    end
  end

  print("Max: " .. max .. " Max X,Y: " .. maxx .. "," .. maxy .. " Max square: " .. maxsquare)
  --printgrid(grid, maxx-1, maxx+4)

end


Day11(18, 300, 3, 3) -- default size 3...
Day11(42, 300, 3, 3)
--Day11(6303, 300)

