local ENTITY = FindMetaTable("Entity")

function ENTITY:MrpAddOwner(ply)
	if (!self.MrpOwners) then self.MrpOwners = {} end
	table.insert(self.MrpOwners,ply)
end

function ENTITY:MrpRemoveOwner(ply)
	local removed
	if (!self.MrpOwners) then self.MrpOwners = {} return end
	for k, v in pairs(self.MrpOwners) do
		if (v == ply) then table.remove(self.MrpOwners,k) return k end
	end
end