
--[[

Day 1: What's the Frequency, Kenneth???

]]

print("---------------- Day 1 ----------------")


-- Read Test Inputs...
local TEST, tins = {}, table.insert
tins(TEST, "+1")
tins(TEST, "-2")
tins(TEST, "+3")
tins(TEST, "+1")


-- Read 'Real' Inputs...
INPUT = {}
for line in io.lines("input") do
  tins(INPUT, line)
end


function Day1(input, isPartB)
  isPartB = isPartB or false
  local freq = 0
  local freqtab = {}
  local INVALID = math.maxinteger

  repeat
    for _, line in ipairs(input) do
      local _, _, sign, val = line:find("(.)(.+)")
      val = tonumber(val) or INVALID
      if (val == INVALID) then print("ERROR") end

      if (sign == '-') then
        freq = freq - tonumber(val)
      elseif (sign == '+') then
        freq = freq + tonumber(val)
      else
        print("Invalid Input.  Sign: " .. sign)
      end

      --print("sign: " .. sign .. " val: " .. val .. " freq: " .. freq)

      -- For PartB, store frequencies in Lua table, if one already exists in that slot, we've found the repeat.
      if (freqtab[freq]) and isPartB then
        print("PartB Repeat Frequency Found: " .. freq)
        return freq
      end
      freqtab[freq] = (freqtab[freq] or 0) + 1

    end
  until not isPartB -- PartB loops until solution found...

  print("PartA Ending Frequency: " .. freq)
  return freq
end


-- Test PartA assertions
assert(Day1(TEST) == 3) -- Test Input
assert(Day1(INPUT) == 510) -- 'Real' Input


-- Test PartB assertions
assert(Day1(TEST, true) == 2) -- Test Input
assert(Day1(INPUT, true) == 69074) -- 'Real' Input


