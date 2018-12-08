
--[[

Day 8: Recursive parsing strikes again!

]]


print("---------------- Day 8 ----------------")
require "socket" -- for MS timing...

-- Read Test Inputs...
TEST = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

-- Read 'Real' Inputs...
local file = io.input("input")
INPUT = file:read("*a")
file:close()


function ReadNode(input, pos, partb)
  gCurNode = gCurNode + 1
  partb = partb or false

  local total = 0
  local node = { nodeid = gCurNode }

  local _, pos, cn, md = input:find("(%d+) (%d+)", pos)
  cn, md = tonumber(cn), tonumber(md)

  for i = 1, cn do
    pos, subnode, mdtotal = ReadNode(input, pos+1, partb)
    total = total + mdtotal
    table.insert(node, subnode) -- 1-based nodes...
  end
  
  if (not partb) then
    for i = 1, md do
      _, pos, md = input:find("(%d+)", pos+1) -- Pull each metadata off...  Add them up...
      total = total + tonumber(md)
    end
  else
    node.value = 0
    -- Calculate value of node...  If 0 nodes, count all MD...
    if (#node < 1) then
      for i = 1, md do
        -- Pull each metadata off...  Add them up...
        _, pos, md = input:find("(%d+)", pos+1)
        node.value = node.value + tonumber(md)
        --print("md: " .. md .. " node " .. gCurNode .. " value: " .. node.value)
      end
    else
      for i = 1, md do
        _, pos, md = input:find("(%d+)", pos+1)
        md = tonumber(md)
        if (node[md]) then
          node.value = node.value + node[md].value
          --print("md: " .. md .. " node[md].value: " .. node[md].value .. " node " .. gCurNode .. " value: " .. node.value)
        end
      end
    end
  end
  
  --[[
  if (not partb) then
    print("Node " .. node.nodeid .. " total: " .. total)
  else
    print("Node " .. node.nodeid .. " value: " .. node.value)
  end
  ]]
  return pos, node, total
end

local starttime = socket.gettime()*1000
gCurNode = 0 -- to track node number
assert(select(3, ReadNode(TEST, 1)) == 138)

gCurNode = 0 -- to track node number
assert(select(3, ReadNode(INPUT, 1)) == 42951)

gCurNode = 0 -- to track node number
assert((select(2,ReadNode(TEST, 1, true)).value) == 66) -- pos 1, partb

gCurNode = 0 -- to track node number
assert((select(2,ReadNode(INPUT, 1, true)).value) == 18568) -- pos 1, partb
local endtime = socket.gettime()*1000
print("Elapsed Time (ms): " .. endtime - starttime)


