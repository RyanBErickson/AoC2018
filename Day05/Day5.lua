
--[[

Day 5: In which I learn that Lua puts a newline at the end of a file read, making my count off by one...  :|

]]


print("---------------- Day 5 ----------------")

-- Read Test Inputs...
TEST = "dabAcCaCBAcCcaDA"

-- Read 'Real' Inputs...
local file = io.input("input")
INPUT = file:read("*a")
file:close()

INPUT = INPUT:gsub("^%s*(.-)%s*$", "%1") -- l/r trim input...  Not doing this will kill you.  :)


function Day5A(input, partb)
  local pos = 1
  local count = 0
  while (pos < string.len(input)) do
    count = count + 1
    --if (count > 10) then os.exit() end
    local c1 = input:sub(pos, pos)
    local c2 = input:sub(pos+1, pos+1)
    --print(pos, c1, c2)
    if (c1 ~= c2) and (string.upper(c1) == string.upper(c2)) then
      local first = pos - 5 if (first < 1) then first = 1 end
      --print("[" .. pos .. "] Pre: " .. input:sub(first, pos-1) .. "[" .. input:sub(pos, pos+1) .. "]" .. input:sub(pos+2, pos+5))
      found = true
      input = input:sub(1, pos-1) .. input:sub(pos+2)
      pos = pos - 1
      if (pos < 1) then pos = 1 end
      first = pos - 5 if (first < 1) then first = 1 end
      --print("[" .. pos .. "] Post: " .. input:sub(first, pos+5))
    else
      pos = pos + 1
    end
  end
  local len = string.len(input)
  if (not partb) then print("Resulting Polymer Length: " .. len) end
  return len
end


function Day5B(input)
  -- Find all unique chars...
  local chars = {}
  for c in input:gmatch("(.)") do
    chars[string.upper(c)] = true
  end

  local min, minc = 50000, ""

  -- Test without each character, find min...
  for k, _ in pairs(chars) do
    local inp = input:gsub(k, "")
    inp = inp:gsub(string.lower(k), "")
    local len = Day5A(inp, true)
    if (len < min) then
      min = len
      minc = k
    end
  end
  print("Minimum polymer (" .. minc .. "): " .. min)
  return min
end

-- Test PartA assertions
assert(Day5A(TEST) == 10)
assert(Day5A(INPUT) == 10564)

-- Test PartB assertions
assert(Day5B(TEST) == 4)
assert(Day5B(INPUT) == 6336)

