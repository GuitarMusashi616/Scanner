local tArgs = {...}
if #tArgs ~= 1 then
  error("Usage: find <block>", 0)
end

local target = tArgs[1]
local width, height = term.getSize()

local scanner = peripheral.find("geoScanner")
local blocks = scanner.scan(8)


function x2dir(x)
  if x > 0 then
    return ("%i east"):format(x)
  elseif x < 0 then
    return ("%i west"):format(math.abs(x))
  end
end

function y2dir(y)
  if y > 0 then
    return ("%i up"):format(y)
  elseif y < 0 then
    return ("%i down"):format(math.abs(y))
  end
end

function z2dir(z)
  if z > 0 then
    return ("%i south"):format(z)
  elseif z < 0 then
    return ("%i north"):format(math.abs(z))
  end
end


function locate(block)
  local z = z2dir(block.z)
  local y = y2dir(block.y)
  local x = x2dir(block.x)
  local tab = {}
  if z then
    table.insert(tab,z)
  end
  if x then
    table.insert(tab,x)
  end
  if y then
    table.insert(tab,y)
  end
  print(table.concat(tab,", "))
end 



function main()
  local filtered = {}
  for _,block in pairs(blocks) do
    if block.name:find(target) then
      table.insert(filtered, block)
    end
  end
  table.sort(filtered, function(a,b) return math.abs(a.x)+math.abs(a.y)+math.abs(a.z) < math.abs(b.x)+math.abs(b.y)+math.abs(b.z) end)
  local line = 1
  for _,block in pairs(filtered) do
    if line >= height-1 then
      return
    end
    --print(block.x, block.y,block.z)
    locate(block)
    line = line + 1
  end
end

main()
