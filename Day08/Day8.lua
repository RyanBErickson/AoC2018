
--[[

Day 8: Recursive parsing strikes again!

]]


print("---------------- Day 8 ----------------")

-- Read Test Inputs...
TEST = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

-- Read 'Real' Inputs...
local file = io.input("input")
INPUT = file:read("*a")
file:close()


function ReadNumArray(input)
  local out, tins, tn = {}, table.insert, tonumber
  input:gsub("[^%s]+", function(m) tins(out, tn(m)) end)
  return out
end


function ReadNode(input, partb)
  partb = partb or false
  local pop = table.remove
  local total, node = 0, {}

  local num_childnodes, num_metadata = pop(input,1), pop(input,1)

  -- Insert Child Nodes...
  for i = 1, num_childnodes do
    subnode, mdtotal = ReadNode(input, partb)
    total = total + mdtotal
    table.insert(node, subnode) -- 1-based nodes...
  end
  
  node.value = 0
  -- Calculate value of node...  If 0 nodes (or part a), count all MD...
  if (#node < 1) or (not partb) then
    -- Sum up each metadata
    for i = 1, num_metadata do
      local value = pop(input,1)
      node.value = node.value + value
      total = total + value
    end
  else
    for i = 1, num_metadata do
      local md = pop(input,1)
      if (node[md]) then
        node.value = node.value + node[md].value
      end
    end
  end
  
  --if (not partb) then
  --  print("Node total: " .. total)
  --else
  --  print("Node value: " .. node.value)
  --end

  return node, total
end


-- Test PartA
assert(select(2, ReadNode(ReadNumArray(TEST))) == 138)
assert(select(2, ReadNode(ReadNumArray(INPUT))) == 42951)

-- Test PartB
assert((select(1,ReadNode(ReadNumArray(TEST), true)).value) == 66)
assert((select(1,ReadNode(ReadNumArray(INPUT), true)).value) == 18568)

