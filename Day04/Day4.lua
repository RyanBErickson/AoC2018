
--[[

Day 4: 

]]


print("---------------- Day 4 ----------------")

-- Read Test Inputs...
TEST = {}
table.insert(TEST, "[1518-11-01 00:00] Guard #10 begins shift")
table.insert(TEST, "[1518-11-01 00:05] falls asleep")
table.insert(TEST, "[1518-11-01 00:25] wakes up")
table.insert(TEST, "[1518-11-01 00:30] falls asleep")
table.insert(TEST, "[1518-11-01 00:55] wakes up")
table.insert(TEST, "[1518-11-01 23:58] Guard #99 begins shift")
table.insert(TEST, "[1518-11-02 00:40] falls asleep")
table.insert(TEST, "[1518-11-02 00:50] wakes up")
table.insert(TEST, "[1518-11-03 00:05] Guard #10 begins shift")
table.insert(TEST, "[1518-11-03 00:24] falls asleep")
table.insert(TEST, "[1518-11-03 00:29] wakes up")
table.insert(TEST, "[1518-11-04 00:02] Guard #99 begins shift")
table.insert(TEST, "[1518-11-04 00:36] falls asleep")
table.insert(TEST, "[1518-11-04 00:46] wakes up")
table.insert(TEST, "[1518-11-05 00:03] Guard #99 begins shift")
table.insert(TEST, "[1518-11-05 00:45] falls asleep")
table.insert(TEST, "[1518-11-05 00:55] wakes up")


-- Read 'Real' Inputs...
-- Do sort on data before processing...
INP = {}
for line in io.lines("input") do
  table.insert(INP, line)
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

local sortedKeys = getKeysSortedByValue(INP, function(a,b) return a < b end)

INPUT = {}
for _, key in ipairs(sortedKeys) do
  table.insert(INPUT, INP[key])
end


function Day4(input, partb)
  local count = 0
  local guard_num = -1
  local guard_totals = {}
  local guard_min_sleep = {}
  local guard_start = -1
  local guard_end = -1

  local max = 0
  local max_guard = -1

  for _, line in ipairs(input) do

    local _, _, year, month, day, hour, minute, activity = line:find("%[(%d+)-(%d+)-(%d+) (%d+):(%d+)%] (.+)")
    if (activity:find("Guard #")) then
      _, _, guard_num = activity:find("Guard #(%d+) begins.+")
      guard_num = tonumber(guard_num) or -1
      --print("guard: " .. guard_num)
      guard_totals[guard_num] = guard_totals[guard_num] or 0
      guard_min_sleep = guard_min_sleep or {}
      guard_min_sleep[guard_num] = guard_min_sleep[guard_num] or {}
    end
    if (activity:find("falls")) then
      --print("falls")
      guard_start = tonumber(minute)
    end
    if (activity:find("wakes")) then
      --print("wakes")
      guard_end = tonumber(minute)
      local elapsed = guard_end - guard_start
      --print("Guard[" .. guard_num .. "]: " .. elapsed .. " minutes")
      guard_totals[guard_num] = guard_totals[guard_num] + elapsed
      if (guard_totals[guard_num] > max) then
        max = guard_totals[guard_num]
        max_guard = guard_num
      end

      -- Mark all hours for guard...
      for i = guard_start, guard_end-1 do
        guard_min_sleep[guard_num][i] = (guard_min_sleep[guard_num][i] or 0) + 1
      end
    end
    --print(year, month, day, hour, minute)
    end

    if (not partb) then
      print("max_guard: " .. max_guard .. " mins: " .. max)

      -- Determine which minute the guard has slept the most...
      local max_min = 0
      local min_max = 0
      for i = 0, 59 do
        if ((guard_min_sleep[max_guard][i] or 0) > max_min) then
          min_max = i
          max_min = guard_min_sleep[max_guard][i]
        end
      end
      print("Guard " .. max_guard .. " slept " .. max_min .. " minutes at 00:" .. min_max)
      return min_max * max_guard
    else
      -- For each guard, calculate the number of times asleep for each minute...
      -- Then which one is max for any particular minute...
      local max_minute = -1
      local max_guard = -1
      local max_time = -1

      -- Max Minute per Guard...
      for i = 0, 59 do
        local guard_min = {}
        for guard_num, _ in pairs(guard_min_sleep) do
          guard_min[guard_num] = (guard_min[guard_num] or 0) + (guard_min_sleep[guard_num][i] or 0)
          if (guard_min[guard_num] > max_time) then
            max_minute = i
            max_guard = guard_num
            max_time = guard_min[guard_num]
          end
        end
      end
      return max_guard * max_minute
    end
end


-- Test PartA assertions
assert(Day4(TEST) == 240)
assert(Day4(INPUT) == 102688)

-- Test PartB assertions
assert(Day4(TEST, true) == 4455)
assert(Day4(INPUT, true) == 56901)

