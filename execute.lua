local SCAN_FOR = {"ore"}

local tArgs = {...}

if #tArgs ~= 10 then
  error("Usage: /execute ...\n1) press f3+c to save coords\n2) press control-v to paste into computer\n3) press enter",0)
end

local x, y, z = tonumber(tArgs[6]), tonumber(tArgs[7]), tonumber(tArgs[8])

local scanner = peripheral.find("geoScanner")
if not scanner then
  error("must place geoScanner next to computer", 0)
end

local blocks = scanner.scan(8)
if not blocks then
  error("geoScanner scan returns nil", 0)
end

local result = io.open("result","w")
function result:print(...)
  self:write(table.concat({...},",\t"),"\n")
end


for _,block in pairs(blocks) do
  for _,needle in pairs(SCAN_FOR) do
    if block.name:find(needle) then
      result:print(x+block.x,y+block.y,z+block.z,block.name)
    end
  end
end

result:close()
shell.run("edit result")