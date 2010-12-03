INVENTORY = {}

function INVENTORY:Create(x,y,w,h,Index)
	if !self:SetIndex( Index ) then return end
	self.Width = 500
	self.Height = 800
	self.Items = {}
	self.fr = vgui.Create("DFrame")
	self.fr.mom = self
	self.fr:SetName("Inventory")
	self.fr:SetPos(ScrW()/2-self.Width/2,ScrH()/2-self.Height/2)
	self.fr:SetWide(self.Width)
	self.fr:SetTall(self.Height)
	self.fr:SetSizable(true)
	self.fr:SetMouseInputEnabled(true)
	self.fr:SetEnabled(true)
	self.fr.PerformLayout2 = self.fr.PerformLayout
	self.fr.PerformLayout = function(self)
		if (self.inv) then 
			self.inv:SetPos(5,25) 
			self.inv:SetSize(self:GetWide()-10,self:GetTall()-30) 
			self.inv:PerformLayout()
		end
		self.mom:PerformLayout()
		self:PerformLayout2()
	end
	self.fr.Remove2 = self.fr.Remove
	self.fr.Remove = function(self)
		self.mom:Remove()
	end
	self.fr.inv = vgui.Create( "DPanelListFix", self.fr )
		self.fr.inv:SetPos(5,25)
		self.fr.inv:SetSize(self.Width-10,self.Height-30)
		self.fr.inv:EnableHorizontal(true)
		self.fr.inv:EnableVerticalScrollbar()
		self.fr.inv.DoClick = function(self)
			self:GetParent():GetParent():GetParent().mom:OnClick(self)
		end
		self.fr.inv:SetName("wut")
	self:LoadItems(Entity(Index).Items)
	self:RequestItems()
	return self
end

function INVENTORY:AddIcon(Model)
	local item = {}
	item.Model = Model
	self:AddItem(item)
end

function INVENTORY:AddItem(item)
	if (!item.Model) then return end
	item.num = table.insert( self.Items, item )
	self.Items[item.num].Icon=self.fr.inv:AddIcon(item)
end

function INVENTORY:RemoveItem(Num)
	table.remove( self.Items, Num)
	self.fr.inv:RemoveItemNum( Num )
end

function INVENTORY:GetItem(num)
	for k, v in pairs(self.Items) do 
		if (v.num == item) then
			return v
		end
	end
end

function INVENTORY:OnClick(Item)
	print(self.Items[1].Icon)
	print(self:GetItemNum(Item))
end

function INVENTORY:OnClose()
 	print("Closed")
end

function INVENTORY:PerformLayout()
end

function INVENTORY:SetIndex( Index )
	if (!Index) then return false end
	if (Interfaces[Index] == nil or Interfaces[Index].Index != Index) then
		self.Index = Index
		Interfaces[Index] = self return true
	end
	return false
end

function INVENTORY:GetIndex()
	return self.Index
end

function INVENTORY:Remove()
	self:OnClose()
	if (self.Index != nil) then
		Interfaces[self.Index] = nil
	end
	print("Removed")
end

function INVENTORY:GetItemNum(item)
	if (!item.num) then 
		for k, v in pairs(self.Items) do
			if (item == v.Icon) then return k end
		end
		return false
	end
	return item.num
end

function INVENTORY:LoadItems(Items)
	if !Items then return end
	self.Items = {}
	for k, v in pairs(Items) do
		local item = table.Copy(v)
		self:AddItem(item)
	end
end

Interfaces = {}

/*-----------------------------------------
	INVENTORY DATA RECEIVER
-----------------------------------------*/

function ReceiveItems( handler, id, encoded, decoded )
 
	print( "Received data on client!" );

	local ENTID = decoded[1]
	if (ENTID == nil) then return false end
	local ent = Entity(ENTID)
	if (ent) then
		ent.Items = decoded[2]
		print(ent.Items)
		print(ENTID)
		print(ent)
	end
	if Interfaces[ENTID] then
		Interfaces[ENTID]:LoadItems(decoded[2])
	end
	

end
datastream.Hook( "ReceiveItems", ReceiveItems );

local function Done( )
 
            print( "Done sending." );
 
end
local function Accepted( accepted, tempid, id )
 
            if accepted then
                        print( "Temporary stream " .. tempid .. " was accepted! It's official ID is now " .. id );
            else
                        print( "Temporary stream " .. tempid .. " was denied." );
            end
 
end
 
function INVENTORY:RequestItems()
	local tempid = datastream.StreamToServer( "RequestItems", self:GetIndex(), Done, Accepted );
	print( "Sent an operation. Our assigned tempid is " .. tempid );
end