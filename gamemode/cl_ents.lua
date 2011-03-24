local ENTITY = FindMetaTable("Entity")

function ENTITY:MrpAddOwner(ply)
	table.insert(self.MrpOwners,ply)
end

function ENTITY:MrpRemoveOwner(ply)
	local removed
	for k, v in pairs(self.MrpOwners) do
		if (v == ply) then table.remove(self.MrpOwners,k) return k end
	end
end

function ENTITY:MrpClearOwners()
	self.MrpOwners = {}
end