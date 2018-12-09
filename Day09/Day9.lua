
--[[

Day 9: Day2 not optimized...  :)

]]


print("---------------- Day 9 ----------------")

-- Read Test Inputs...
TEST = {}
table.insert(TEST, "")


-- Read 'Real' Inputs...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end

function printcircle(player, circle, curmarble)
  local out, tins = {}, table.insert
  tins(out, "[" .. player .. "]")

  for i, v in ipairs(circle) do
    if (i == curmarble) then
      tins(out, "(" .. circle[i] .. ")")
    else
      tins(out, " " .. circle[i] .. " ")
    end
  end
  print(table.concat(out, " "))
end

function Day9(numplayers, lastmarble)
  local circle = {0, 2, 1} -- Start in step 2... Can't have any winner unless one gets to at least 23...
  local curmarble = 2
  local scores = {}
  local player = 2

  printcircle(2, circle, curmarble)
  for i = 3, lastmarble do
    -- Insert marbles...
    player = player + 1
    if (player > numplayers) then player = 1 end

 
    --if (i > (23*5)) then os.exit() end -- debug...

    if ((i % 23) == 0) then
      scores[player] = (scores[player] or 0) + i

      -- Remove marble 7 back...
      local newcur = curmarble - 7
      if (newcur < 1) then
        --print("newcur < 1: " .. newcur)
        newcur = #circle + newcur
      end
      local val = table.remove(circle, newcur)
      --print("curmarble: " .. curmarble)
      --print("newcur: " .. newcur)
      --print("Marble to be Removed: " .. newcur .. "/" .. #circle .. " val: " .. tostring(val))
      scores[player] = (scores[player] or 0) + val
      curmarble = newcur
    else
      curmarble = curmarble + 2
      if (curmarble > #circle) then
        if (curmarble == #circle + 1) then
          table.insert(circle, i)
          --print("here: " .. i, curmarble)
        else
          curmarble = curmarble - #circle
          table.insert(circle, curmarble, i)
          --print("here2: " .. i, curmarble)
        end
      else
        table.insert(circle, curmarble, i)
        --print("here3: " .. i, curmarble)
      end
    end
    if (i % 71399 == 0) then print((i / 7133900 * 100) .. "%") end
    --printcircle(i, circle, curmarble)
  end

  -- Calculate max score...
  local max, maxplayer = 0, 0
  for player, val in pairs(scores) do
    if ((val or 0) > max) then
      maxplayer = player
      max = val
    end
  end
  print("Max Player: " .. maxplayer .. " with score: " .. max)
  return max
end


-- Test PartA assertions
--[[
assert(Day9(9, 25) == 32)
assert(Day9(10, 1618) == 8317)
assert(Day9(13, 7999) == 146373)
assert(Day9(17, 1104) == 2764)
assert(Day9(21, 6111) == 54718)
assert(Day9(30, 5807) == 37305)
Day9(418, 71339)
]]
assert(Day9(13, 7999) == 146373)


--Day9(418, 7133900)

