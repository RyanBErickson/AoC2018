
--[[

Day 3: 

]]


print("---------------- Day 3 ----------------")

-- Read Test Inputs...
TEST = {}
table.insert(TEST, "#1 @ 1,3: 4x4")
table.insert(TEST, "#2 @ 3,1: 4x4")
table.insert(TEST, "#3 @ 5,5: 2x2")


-- Read 'Real' Inputs...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end


fabric = {} -- fabric global, since both PartA and PartB use same data...


function Day3A(input)
  -- PartA - Count fabric square when they pass 2 patterns using a square.
  local count = 0
  for _, line in ipairs(input) do
    local _, _, linenum, x, y, width, height = line:find("#(%d+) @ (%d-),(%d-): (%d-)x(%d+)")
    for i = x, x+width-1 do
      for j = y, y+height-1 do
        fabric[i] = fabric[i] or {}
        fabric[i][j] = (fabric[i][j] or 0) + 1

        -- Count when any grid square hits 2, which indicates it's overlapped at least once.
        if (fabric[i][j] == 2) then
          count = count + 1
        end
      end
    end
  end
  print("PartA: " .. count .. " grid squares overlap at least one other grid square")
  return count
end


function Day3B(input)
  -- PartB - Check existing marked fabric for a pattern with all '1' accesses...
  for _, line in ipairs(input) do
    local _, _, linenum, x, y, width, height = line:find("#(%d+) @ (%d-),(%d-): (%d-)x(%d+)")
    local ok = true
    for i = x, x+width-1 do
      for j = y, y+height-1 do
        if (fabric[i][j] > 1) then
          ok = false
          --goto next -- removed b/c editor doesn't like... works, though, and shortcuts the process...
        end
      end
    end
    --::next::

    -- Found one that doesn't overlap...
    if (ok) then
      print("PartB: claim " .. linenum .. " doesn't overlap with any others.")
      return tonumber(linenum)
    end
  end
end


-- Test PartA assertions
assert(Day3A(TEST) == 4)
assert(Day3A(INPUT) == 118858)

-- Test PartB assertions
assert(Day3B(TEST) == 3)
assert(Day3B(INPUT) == 1100)

