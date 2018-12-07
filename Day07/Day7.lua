
--[[

Day 7: All things in good order...  Needed to realize that steps can have multiple prerequisites...

]]


print("---------------- Day 7 ----------------")

-- Read Test Inputs...
TEST = {}
table.insert(TEST, "Step C must be finished before step A can begin.")
table.insert(TEST, "Step C must be finished before step F can begin.")
table.insert(TEST, "Step A must be finished before step B can begin.")
table.insert(TEST, "Step A must be finished before step D can begin.")
table.insert(TEST, "Step B must be finished before step E can begin.")
table.insert(TEST, "Step D must be finished before step E can begin.")
table.insert(TEST, "Step F must be finished before step E can begin.")


-- Read 'Real' Inputs...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end


function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)

  return keys
end


function LoadSortedData(input, BaseTime)
  local ST = {}
  local prereqs = {}
  local STEPS = {}
  BaseTime = BaseTime or 0

  -- table.insert(TEST, "Step F must be finished before step E can begin.")
  for _, line in ipairs(input) do
    local _, _, PRE, POST = line:find("Step (.-) must be finished before step (.-) can begin.")
    prereqs[POST] = prereqs[POST] or {}
    table.insert(prereqs[POST], PRE)

    -- Track all steps...  Only log them once...
    if (not STEPS[PRE]) then table.insert(ST, PRE) end
    STEPS[PRE] = true
    if (not STEPS[POST]) then table.insert(ST, POST) end
    STEPS[POST] = true
  end

  -- Sort steps back into STEPS...
  sortedKeys = getKeysSortedByValue(ST, function(a,b) return a < b end)
  local STEPTIME, i = {}, 0
  for _, key in ipairs(sortedKeys) do
    table.insert(STEPS, ST[key])
    i = i + 1
    STEPTIME[ST[key]] = i + BaseTime
  end

  return prereqs, STEPS, STEPTIME
end


function Day7A(input)
  local prereqs, STEPS = LoadSortedData(input)

  local order = ""
  local used = {}
  local done = false
  while (not done) do
    local found = ""
    for k,v in ipairs(STEPS) do
      if (not used[v]) and (found == "") and (#(prereqs[v] or {}) == 0) then
        order = order .. v
        used[v] = "*"
        found = v
      end
      local out = {}
      for _, prereq in pairs(prereqs[v] or {}) do
        table.insert(out, prereq)
      end
      --print(k, v .. (used[v] or ""), #(prereqs[v] or {}), table.concat(out, ","))
    end

    -- Remove 'found' letter...
    if (found ~= "") then
      for _, v in ipairs(STEPS) do
        local loc = -1
        for i = 1, #(prereqs[v] or {}) do
          if (prereqs[v][i] == found) then
            loc = i
          end
        end
        if (loc > 0) and ((prereqs[v] or {})[loc]) then
          table.remove(prereqs[v], loc)
        end
      end
    else
      print("Order: " .. order)
      return order
    end
  end
end


-- Test PartA assertions
assert(Day7A(TEST) == "CABDFE")
assert(Day7A(INPUT) == "LFMNJRTQVZCHIABKPXYEUGWDSO")


function Day7B(input, numElves, BaseTime)
  local prereqs, STEPS, STEPTIME = LoadSortedData(input, BaseTime)

  --for k,v in pairs(STEPTIME) do print(k,v) end

  local order = ""
  local used = {}
  local done = false
  local elfbusy = {}

  function NextLetter()
    for i, v in ipairs(STEPS) do
      -- Print current line...
      local out = {}
      for _, prereq in pairs(prereqs[v] or {}) do
        table.insert(out, prereq)
      end

      -- Check for empty line...
      if (not used[v]) and (not elfbusy[v]) and (#(prereqs[v] or {}) == 0) then
        used[v] = "*"
        return i, v
      end

    end
    return nil
  end


  function RemoveLetter(c)
    if (c ~= "") then
      for _, v in ipairs(STEPS) do
        local loc = nil
        for i = 1, #(prereqs[v] or {}) do
          if (prereqs[v][i] == c) then
            loc = i
          end
        end
        if (loc) and ((prereqs[v] or {})[loc]) then
          table.remove(prereqs[v], loc)
          --print("Removed " .. c .. " at [" .. v .. "][" .. loc .. "]")
        end
      end
    end
  end

  local maxElves = numElves
  local curtime = 0
  local count = 0
  while (not done) do

    if (numElves > 0) then
      print("------------------")
      -- Schedule all elves we can...

      local i, c = NextLetter()

      -- Job available...
      if (c) then
        numElves = numElves - 1 


        local time = STEPTIME[c]
        elfbusy[c] = time
        print(c .. " job elf: Time: " .. time)
      else
        print("No Jobs...")
        if (numElves == maxElves) then
          return curtime, order
        end

        -- FFW to time when first elf is done...
        -- Find 'closest' elf by time (smallest), mark his job done, and advance the time.
        -- Adjust all other elves' times left by the time of short elf.
        local min, minjob = 10000, ""
        for elfjob, elftime in pairs(elfbusy) do
          print("Elf: " .. elfjob .. " Time: " .. elftime)
          if (elftime < min) then min = elftime minjob = elfjob end
        end

        if (min < 10000) then
          numElves = numElves + 1
          elfbusy[minjob] = nil
          curtime = curtime + min

          -- mark job done...

          order = order .. minjob
          print("order: " .. order .. " cur time: " .. curtime .. " num elves: " .. numElves)
          RemoveLetter(minjob)

          for elfjob, elftime in pairs(elfbusy) do
            elfbusy[elfjob] = elftime - min
            if (elfbusy[elfjob] == 0) then
              -- Also finish this elf, but no additional time...
              elfbusy[elfjob] = nil
            end
          end
        end

      end
    else
      print("No Elves...")
      -- No Elves available... Figure out time when one will be...

      local min, minjob = 10000, ""
      for elfjob, elftime in pairs(elfbusy) do
        print("Elf: " .. elfjob .. " Time: " .. elftime)
        if (elftime < min) then min = elftime minjob = elfjob end
      end

      if (min < 10000) then
        numElves = numElves + 1
        elfbusy[minjob] = nil
        curtime = curtime + min

        -- mark job done...

        order = order .. minjob
        print("order: " .. order .. " cur time: " .. curtime .. " num elves: " .. numElves)
        RemoveLetter(minjob)

        for elfjob, elftime in pairs(elfbusy) do
          elfbusy[elfjob] = elftime - min
          if (elfbusy[elfjob] == 0) then
            -- Also finish this elf, but no additional time...
            elfbusy[elfjob] = nil
          end
        end
      end

    end
  end
  return curtime, order
end

-- Test PartB assertions
assert(Day7B(TEST, 2, 0) == 15)
assert(Day7B(INPUT, 5, 60) == 1180)

