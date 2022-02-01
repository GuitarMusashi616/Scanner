local SCAN_FOR = {"ore"}

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

local ore_count = {}
for _,block in pairs(blocks) do
  for _,needle in pairs(SCAN_FOR) do
    if block.name:find(needle) then
      if not ore_count[block.name] then
        ore_count[block.name] = 0
      end
      ore_count[block.name] = ore_count[block.name] + 1
    end
  end
end

local sort_table = {}
for k,v in pairs(ore_count) do
  sort_table[#sort_table+1] = {k,v}
end

table.sort(sort_table, function(a,b) return a[2] > b[2] end)

for _,kv in pairs(sort_table) do
  result:print(tostring(kv[2]).."x\t"..kv[1])
end

result:close()
shell.run("edit result")