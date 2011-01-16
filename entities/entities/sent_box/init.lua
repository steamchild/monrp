AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SpawnFunction(player,trace)
	if trace.Hit then
		local ent = ents.Create("sent_box")
		ent:SetPos(trace.HitPos + trace.HitNormal * 16)
		ent:Spawn()
		ent:Activate()
		return ent
	end
end

function ENT:Initialize()
	self.Entity:SetModel("models/items/item_item_crate.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.Functions = {{"Get Item"},{self.GetItem}}
	self.Commands = {{"Open","Close"},{self.Open,self.Close}}
	self.Items = {}
	self.Opened = {}
	self.OpenedSvns = {}
	self.svn = 0
	self.log = {}
	local phys = self.Entity:GetPhysicsObject()

	if phys and phys:IsValid() then phys:Wake() end
end


function ENT:Use(activator,caller)
	activator:OpenInterface(self:EntIndex())
end

function ENT:AddLog(str) // Logs Changes to sent to client not all items, but only changes
	self.svn = self.svn + 1
	return table.insert(self.log,str)
end

function ENT:CallOpen(ply,svn) // Called when monrp engine detects incoming stream from client asking items
	print("set_box: CALLED CALLOPEN")
	print("CALLER SVN:"..svn)
	self:SendItems(ply,svn,self.svn)
	self:SendFunctions(ply,self.Functions)
	self:SendCommands(ply,self.Commands)
	self.OpenedSvns[ply:EntIndex()] = self.svn 
	table.insert(self.Opened,ply)
end

function ENT:CallClose(ply) // Called when monrp engine detects incoming stream from client asking functions
	for k, v in pairs(self.Opened) do
		if (v == ply) then self.OpenedSvns[ply:EntIndex()] = nil table.remove(self.Opened,k) end
	end
end


function ENT:AddItem(ent)
	if !ent.Model or !ent.Class then return end
	local num = table.insert(self.Items,ent)
	ent.num = num
	self:AddLog(ent)
	self:RefreshInterFaces()
	return num
end

function ENT:RemoveItem(num)
	self:AddLog(num)
	self:RefreshInterFaces()
	return table.remove(self.Items,num)
end

function ENT:RemoveItems(nums)
	for k, v in pairs(nums) do
		self:AddLog(v)
		table.remove(self.Items,v)
	end
	self:RefreshInterFaces()
end

function ENT:GetFunctionNames()
	return self.Functions[1]
end

function ENT:GetFunctions()
	return self.Functions[2]
end

function ENT:GetCommandNames()
	return self.Commands[1]
end

function ENT:GetCommands()
	return self.Commands[2]
end

function ENT:GetClientItems()
	return self.Items
end

function ENT:GetItems()
	return self.Items
end

function ENT:OnRemove( )

end

/*----------------------------------------
	FUNCTIONS AND COMMANDS
----------------------------------------*/

function ENT:RefreshInterFaces()
	for k, v in pairs(self.Opened) do
		self:SendItems(v,self.OpenedSvns[v:EntIndex()],self.svn)
		self.OpenedSvns[v:EntIndex()] = self.svn 
	end
end

function ENT:Open(activator)
	print("ENT:OPEN() CALLED")

	local explode = ents.Create( "env_explosion" )
		explode:SetPos( self:GetPos() )
		explode:SetOwner( self )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", "100" )
		explode:Fire( "Explode", 0, 0 )
		explode:EmitSound( "weapon_AWP.Single", 400, 400 )
	self:Remove()
end

function ENT:Close(activator)
	print("ENT:Close() CALLED")
end

function ENT:GetItem(activator,Toggled)
	print("GETITEM CALLED")
	print(Toggled)
	for k, v in pairs(Toggled) do
		num = v
		
		local item = self.Items[num]
		if (!item) then return end
	
	 	local ent = ents.Create(item.Class)
		if (!ent or !ent:IsValid()) then return end
			ent:SetModel(item.Model)
		
		local boxmaxz = self.Entity:OBBMaxs().z
	
		local entminz = math.abs(ent:OBBMins().z)
		local min = ent:OBBMins()
		local spawnpos = self.Entity:GetPos() + 
			(self.Entity:GetAngles():Up() * (5+math.abs(boxmaxz)+math.abs(entminz)))
	
		ent:SetPos(spawnpos)
		ent:SetAngles(self.Entity:GetAngles())
		ent:Spawn()
	
	end
	self:RemoveItems(Toggled)
end
