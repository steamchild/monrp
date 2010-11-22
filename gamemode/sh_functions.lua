function stringtotable(string)
local pos = 0
local values = {}
local value = ""
local k = 0
	while value != "fend" do
		value,pos,stype = findstatement(pos,string.sub(string,2,-2))
		if (value != "") then
			if stype == "number" then k=k+1 values[k] = tonumber(value) end
			if stype == "string" then k=k+1 values[k] = string.sub(value,2,-2) end
			if stype == "table" then k=k+1 values[k] = stringtotable(value) end
		end
	end
return values
end

function MoneyToString(Money)
	local Mstring = tostring(Money)
	local Mtab = string.ToTable(Mstring)
	local count = 0
	local len = table.Count(Mtab)
	local pos = len
	local k = 0
	while pos>2 do
		pos = len-k
		local v = Mtab[pos]
		if (v!=",") then count = count + 1 end
		if (count >= 3) then count = 0 table.insert(Mtab,pos,",") end
		k = k + 1
	end
	local ExitStr = ""
	for k, v in pairs(Mtab) do
		ExitStr=ExitStr..v
	end	
	return ExitStr
end
