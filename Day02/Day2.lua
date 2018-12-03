
--[[

Day 2: Find the Checksum, then the Box!

]]


print("---------------- Day 2 ----------------")


-- Read Test A Inputs
TESTA = {}
table.insert(TESTA, "abcdef")
table.insert(TESTA, "bababc")
table.insert(TESTA, "abbcde")
table.insert(TESTA, "abcccd")
table.insert(TESTA, "aabcdd")
table.insert(TESTA, "abcdee")
table.insert(TESTA, "ababab")

-- Read Test B Inputs
TESTB = {}
table.insert(TESTB, "abcde")
table.insert(TESTB, "fghij")
table.insert(TESTB, "klmno")
table.insert(TESTB, "pqrst")
table.insert(TESTB, "fguij")
table.insert(TESTB, "axcye")
table.insert(TESTB, "wvxyz")

-- Read Real Inputs...
INPUT = {}
for line in io.lines("input") do
  table.insert(INPUT, line)
end


function Day2A(input)
  local count_2s= 0
  local count_3s = 0

  for _, line in ipairs(input) do
    -- Tally the numbers of each character in string...
    local sumtab = {}
    for c in line:gmatch('.') do 
      sumtab[c] = (sumtab[c] or 0) + 1
    end

    -- Count characters with 2's and 3's (one ping only!)...
    local counted_2, counted_3 = false, false
    for k,v in pairs(sumtab) do
      if (v == 2) and (not counted_2) then
        count_2s = count_2s + 1
        counted_2 = true
      end
      if (v == 3) and (not counted_3) then
        count_3s = count_3s + 1
        counted_3 = true
      end
    end
  end

  local result = count_2s * count_3s
  print("PartA Checksum: " .. result)
  return result
end


-- Count letter differences between two strings.
function numdiffs(line1, line2)
  local count, pos = 0, 0
  for i = 1, string.len(line1) do
    if (line1:sub(i,i) ~= line2:sub(i,i)) then
      pos = i
      count = count + 1
    end
  end
  return count, pos
end


function Day2B(input)
  for _, line in ipairs(input) do
    for _, line2 in ipairs(input) do
      local count, pos = numdiffs(line, line2)
      if (count == 1) then
        local solution = line:sub(1, pos-1) .. line:sub(pos+1)
        print("PartB Common Chars: " .. solution)
        return solution
      end
    end
  end
end


-- Test PartA assertions
assert(Day2A(TESTA) == 12)
assert(Day2A(INPUT) == 5658)

-- Test PartB assertions
assert(Day2B(TESTB) == "fgij")
assert(Day2B(INPUT) == "nmgyjkpruszlbaqwficavxneo")

