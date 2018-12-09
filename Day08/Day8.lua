
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
  local parta, pop, node = not partb, table.remove, { value = 0 }

  local num_childnodes, num_metadata = pop(input,1), pop(input,1)

  -- Insert Child Nodes...
  for i = 1, num_childnodes do
    subnode = ReadNode(input, partb)
    table.insert(node, subnode)

    -- Don't double-count, if we're in PartB, node value computed below...
    if (parta) then node.value = node.value + subnode.value end
  end
  
  -- Calculate value of node...  If 0 nodes (or PartA), count all Metadata items ...
  if (#node < 1) or (parta) then
    -- Sum up each metadata
    for i = 1, num_metadata do
      local value = pop(input,1)
      node.value = node.value + value
    end
  else
    -- Sum up each subnode if metadata finds it.
    for i = 1, num_metadata do
      local md = pop(input,1)
      if (node[md]) then
        node.value = node.value + node[md].value
      end
    end
  end
  
  --print("Node value: " .. node.value)
  return node
end


-- Test PartA
assert(ReadNode(ReadNumArray(TEST)).value == 138)
assert(ReadNode(ReadNumArray(INPUT)).value == 42951)

-- Test PartB
assert(ReadNode(ReadNumArray(TEST), true).value == 66)
assert(ReadNode(ReadNumArray(INPUT), true).value == 18568)

