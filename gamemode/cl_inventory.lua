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
	self.fr:MakePopup()
	self.fr.PerformLayout2 = self.fr.PerformLayout
	self.fr.PerformLayout = function(self)
		self.mom:PerformLayout()
		self:PerformLayout2()
	end
	self.fr.Remove2 = self.fr.Remove
	self.fr.Remove = function(self)
		self.mom:Remove()
	end
	self.fr.inv = vgui.Create( "DPanelListFix", self.fr )
		self.fr.inv:EnableHorizontal(true)
		self.fr.inv:EnableVerticalScrollbar()
		self.fr.inv.DoClick = function(self)
			self:GetParent():GetParent():GetParent():GetParent().mom:OnClick(self)
		end
		self.fr.inv:SetName("wut")

	self.fr.panel = vgui.Create( "DPanel", self.fr )

	self.fr.div = vgui.Create("DVerticalDivider", self.fr)
		self.fr.div:SetPos(5,25) //Set the top left corner of the divider
		self.fr.div:SetSize(self.Width-10,self.Height-30) //Set the overall size of the divider
		self.fr.div:SetTopHeight(self.Height*0.6) //Set the starting width of the left item, the right item will be scaled appropriately.
		self.fr.div:SetTop(self.fr.inv)
		self.fr.div:SetBottom(self.fr.panel)
		self.fr.div:SetDividerHeight(5) //Set the width of the dividing bar.
	self.fr:SetKeyboardInputEnabled(false)
	self.fr:SetMouseInputEnabled(true)
	self.fr:SetVisible(true)
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

function INVENTORY:ToggleOutAll()
	for k, v in pairs(self.Items) do
		if (v.Icon) then v.Icon:ToggleOut() end
	end
end

function INVENTORY:ToggleInAll()
	for k, v in pairs(self.Items) do
		if (v.Icon) then v.Icon:ToggleIn() end
	end
end

function INVENTORY:ToggleAll()
	for k, v in pairs(self.Items) do
		if (v.Icon) then v.Icon:Toggle() end
	end
end

function INVENTORY:ToggleIn(num)
	if (self.Items[num].Icon) then self.Items[num].Icon:ToggleIn() end
end

function INVENTORY:ToggleOut(num)
	if (self.Items[num].Icon) then self.Items[num].Icon:ToggleOut() end
end

function INVENTORY:Toggle(num)
	if (self.Items[num].Icon) then self.Items[num].Icon:Toggle() end
end

function INVENTORY:Select(num)
	for k, v in pairs(self.Items) do
		if (v.Icon) then
			if (k != num) then v.Icon:ToggleOut() else v.Icon:ToggleIn() end
		end
	end
end

function INVENTORY:IsToggled(num)
	return self.Items[num].Icon.Toggled
end

function INVENTORY:GetToggled()
	local Toggled = {}
	for k, v in pairs(self.Items) do
		if (self:IsToggled(k)) then Toggled[k] = v end
	end
end

function INVENTORY:OnClick(Item)
	local num = self:GetItemNum(Item)
	if LocalPlayer():KeyDown( IN_SPEED ) then self:Toggle(num) else self:Select(num) end
end


function INVENTORY:OnClose()
end

function INVENTORY:PerformLayout()
	if (self.fr) then
		self.Width = self.fr:GetWide()
		self.Height = self.fr:GetTall()
		self.X, self.Y = self.fr:GetPos()
	else return end
	if (self.fr.inv) then 
	//	self.fr.inv:SetPos(5,25)
	//	self.fr.inv:SetSize(self.Width-10,self.Height*0.6-25)
	end
	if (self.fr.panel) then
	//	self.fr.panel:SetPos( 5, self.Height*0.6+5)
	//	self.fr.panel:SetSize( self.Width-10, self.Height*0.4-10)
	end
	if (self.fr.div) then
		local OldHeight = self.fr.div:GetTall()
		self.fr.div:SetPos( 5,25 )
		self.fr.div:SetSize( self.Width-10, self.Height-30 )
		local NewHeight = self.fr.div:GetTall()
		self.fr.div:SetTopHeight(self.fr.div:GetTopHeight()*(NewHeight/OldHeight))
	end
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

	local ENTID = decoded[1]
	if (ENTID == nil) then return false end
	local ent = Entity(ENTID)
	if (ent) then
		ent.Items = decoded[2]
	end
	if Interfaces[ENTID] then
		Interfaces[ENTID]:LoadItems(decoded[2])
	end
	

end
datastream.Hook( "ReceiveItems", ReceiveItems );

local function Done( )
 
end
local function Accepted( accepted, tempid, id )
 
end
 
function INVENTORY:RequestItems()
	local tempid = datastream.StreamToServer( "RequestItems", self:GetIndex(), Done, Accepted );
end