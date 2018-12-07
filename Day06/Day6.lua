
--[[

Day 6: 

]]


print("---------------- Day 6 ----------------")

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
table.insert(TEST, "1, 1")
table.insert(TEST, "1, 6")
table.insert(TEST, "8, 3")
table.insert(TEST, "3, 4")
table.insert(TEST, "5, 5")
table.insert(TEST, "8, 9")


-- Read 'Real' Inputs...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end



-- Only used to mark the 'map'...
gLetters = {}
local name = string.byte('A')-1
repeat
  name = name + 1
  table.insert(gLetters, {char = string.char(name), valid = true})
until string.char(name) == 'Z'

name = string.byte('a')-1
repeat
  name = name + 1
  table.insert(gLetters, {char = string.char(name), valid = true})
until string.char(name) == 'z'



function Manhattan(x1, y1, x2, y2)
  return (math.abs(x1-x2) + math.abs(y1-y2))
end


function Day6A(input)
  local count = 1
  local minX, minY, maxX, maxY = 20000, 20000, -20000, -20000
  local coords = {}

  -- Parse input, save coords
  for _, line in ipairs(input) do
    local _, _, Y, X = line:find("(%d+), (%d+)")

    -- Validate input...
    X = tonumber(X) or 0
    Y = tonumber(Y) or 0
    if (X == 0) or (Y == 0) then print("Invalid Input.") os.exit() end

    -- Find boundary of 'map'...
    if (X > maxX) then maxX = X end
    if (X < minX) then minX = X end
    if (Y > maxY) then maxY = Y end
    if (Y < minY) then minY = Y end

    coords[count] = coords[count] or {} 
    coords[count].x = X
    coords[count].y = Y
    count = count + 1
  end

  local EXTRAS = 30
  maxX = maxX + EXTRAS
  maxY = maxY + EXTRAS
  minX = minX - EXTRAS
  minY = minY - EXTRAS

  local min, max = minX, maxX
  if (minY < minX) then min = minY end
  if (maxY > maxX) then max = maxY end

  local output = {}
  --for num = 1, count-1 do
  -- Get manhattan distance for every grid square from letter location...
  for i = minX, maxX do
    output[i] = output[i] or {}
    for j = minY, maxY do
      --print(i, j)
      output[i][j] = output[i][j] or 0
      local min, minnum = 10000, 0

      for num = 1, count-1 do
        local md = Manhattan(i, j, coords[num].x or 20000, coords[num].y or 20000)
        if (md == min) then
          output[i][j] = 0
          minnum = -1
        elseif (md <= min) then
          min = md
          minnum = num
          output[i][j] = num
        end
      end
      if (output[i][j] ~= 0) then
        gLetters[minnum].count = (gLetters[minnum].count or 0) + 1
      end
    end
  end
  printgrid(output, min, max)

  -- Invalidate any whose markers are in the border...
  --for i = 
 

  -- Count up each, find max of valid (non-infinite) areas...
  for num = 1, count-1 do
    if (gLetters[num].valid) then
      print(gLetters[num].char, gLetters[num].count)
    end
  end
end


-- Test PartA assertions
-- TODO: Need to figure out how to tell if an area is 'infinite' or not...

Day6A(INPUT)
--Day6A(INPUT)
--assert(Day6(TEST) == 240)
--assert(Day6(INPUT) == 102688)


function Day6B(input, lessthan)
  local count = 1
  local coords = {}
  local minX, minY, maxX, maxY = 20000, 20000, -20000, -20000

  -- Parse input, save coords
  for _, line in ipairs(input) do
    local _, _, Y, X = line:find("(%d+), (%d+)")

    -- Validate input...
    X = tonumber(X) or 0
    Y = tonumber(Y) or 0
    if (X == 0) or (Y == 0) then print("Invalid Input.") os.exit() end

    -- Find boundary of 'map'...
    if (X > maxX) then maxX = X end
    if (X < minX) then minX = X end
    if (Y > maxY) then maxY = Y end
    if (Y < minY) then minY = Y end

    coords[count] = coords[count] or {} 
    coords[count].x = X
    coords[count].y = Y
    count = count + 1
  end

  -- Get total manhattan distance for every grid square to every coordinate location...
  local output, tot_safe_size = {}, 0
  for i = minX, maxX do
    output[i] = output[i] or {}
    for j = minY, maxY do
      output[i][j] = "."
      local tot_dist = 0
      for num = 1, count-1 do
        tot_dist = tot_dist + Manhattan(i, j, coords[num].x or 20000, coords[num].y or 20000)
      end
      if (tot_dist < lessthan) then
        output[i][j] = "#"
        tot_safe_size = tot_safe_size + 1
      end
    end
  end

  print(tot_safe_size)
  return tot_safe_size
end

-- Test PartB assertions
--assert(Day6B(TEST, 32) == 16)
--assert(Day6B(INPUT, 10000) == 45509)

