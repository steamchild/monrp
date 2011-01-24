function ModifyAllGroupNamesToCores()
	for k, v in pairs(ents.FindCores()) do
		if (v.mrp_door_group) then
			v.Doors = {}
			for k, d in pairs(ents.FindDoors()) do
				if (d.mrp_door_group == v.mrp_door_group) then
					d.Core = v
					table.insert(v.Doors,d)
				end
			end
		end
	end
end