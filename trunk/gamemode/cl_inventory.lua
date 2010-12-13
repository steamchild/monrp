INVENTORY = {}

function INVENTORY:Create(x,y,w,h,Index)
	if !self:SetIndex( Index ) then return end
	self.Width = 500
	self.Height = 800
	self.Items = {}
	self.Toggled = {}
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

	self.fr.property = vgui.Create( "DPropertySheet", self.fr )
		self.fr.property:SetPos( 5, 30 )
		self.fr.property:SetSize( 340, 315 )
	self.fr.panel = vgui.Create("DPanel", self.fr)
		self.fr.panel.Paint = function() end
	self.fr.panel.icon = vgui.Create("SpawnIcon", self.fr.panel)
	self.fr.panel2 = vgui.Create("DPanel", self.fr)
		self.fr.panel2.Paint = function() end
	self.fr.panel2.icon = vgui.Create("SpawnIcon", self.fr.panel2)
	self.fr.property:AddSheet( "Actions", self.fr.panel, "gui/silkicons/box", false, false, "Get your item" )
	self.fr.property:AddSheet( "Info", self.fr.panel2, "gui/silkicons/page", false, false, "Information about item" )

	self.fr.div = vgui.Create("DVerticalDivider", self.fr)
		self.fr.div:SetPos(5,25) //Set the top left corner of the divider
		self.fr.div:SetSize(self.Width-10,self.Height-30) //Set the overall size of the divider
		self.fr.div:SetTopHeight(self.Height*0.6) //Set the starting width of the left item, the right item will be scaled appropriately.
		self.fr.div:SetTop(self.fr.inv)
		self.fr.div:SetBottom(self.fr.property)
		self.fr.div:SetDividerHeight(5) //Set the width of the dividing bar.
	self.fr:SetKeyboardInputEnabled(false)
	self.fr:SetMouseInputEnabled(true)
	self.fr:SetVisible(true)
	if (Entity(Index) and Entity(Index):IsValid()) then
		if (!Entity(Index).svn and Entity(Index).svn != 0) then Entity(Index).svn = 0 end
		self.svn = Entity(Index).svn
		self:LoadItems(Entity(Index).Items)
	end
	self:RequestItems()
	return self
end

function INVENTORY:AddIcon(Model)
	local item = {}
	item.Model = Model
	item.Class = "prop_physics"
	self:AddItem(item)
end

function INVENTORY:AddItem(item)
	if (!item.Model or !item.Class) then return end
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
	self:UpdatePanelIcon()
end

function INVENTORY:ToggleInAll()
	for k, v in pairs(self.Items) do
		if (v.Icon) then v.Icon:ToggleIn() end
	end
	self:UpdatePanelIcon()
end

function INVENTORY:ToggleAll()
	for k, v in pairs(self.Items) do
		if (v.Icon) then v.Icon:Toggle() end
	end
	self:UpdatePanelIcon()
end

function INVENTORY:ToggleIn(num)
	if (self.Items[num].Icon) then self.Items[num].Icon:ToggleIn() end
	self:UpdatePanelIcon()
end

function INVENTORY:ToggleOut(num)
	if (self.Items[num].Icon) then self.Items[num].Icon:ToggleOut() end
	self:UpdatePanelIcon()
end

function INVENTORY:Toggle(num)
	if (self.Items[num].Icon) then self.Items[num].Icon:Toggle() end
	self:UpdatePanelIcon()
end

function INVENTORY:Select(num)
	for k, v in pairs(self.Items) do
		if (v.Icon) then
			if (k != num) then v.Icon:ToggleOut() else v.Icon:ToggleIn() self:SetIcon(v) end
		end
	end
end

function INVENTORY:IsToggled(num)
	print("Toggled: ")
	print(self.Items[num].Icon.Toggled)
	return self.Items[num].Icon.Toggled
end

function INVENTORY:GetToggled()
	local Toggled = {}
	local num = 0
	for k, v in pairs(self.Items) do
		if (self:IsToggled(k)) then print("Toggled") num = num+1 Toggled[num] = v end
	end
	return Toggled
end

function INVENTORY:UpdatePanelIcon()
	local toggled = self:GetToggled()
	print(toggled)
	if (table.Count(toggled) > 1) then return end
	self:SetIcon(toggled[1])
end

function INVENTORY:SetIcon(item)
	self.fr.panel.icon:SetModel(item.Model)
	self.fr.panel.icon:SetToolTip('Class: "'..item.Class..'"')
	self.fr.panel2.icon:SetModel(item.Model)
	self.fr.panel2.icon:SetToolTip('Class: "'..item.Class..'"')
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

	if (self.fr.div) then
		local OldHeight = self.fr.div:GetTall()
		self.fr.div:SetPos( 5,25 )
		self.fr.div:SetSize( self.Width-10, self.Height-30 )
		local NewHeight = self.fr.div:GetTall()
		self.fr.div:SetTopHeight(self.fr.div:GetTopHeight()*(NewHeight/OldHeight))
	end
	if (self.fr.panel.icon) then
		self.fr.panel.icon:SetPos(10,10)
	end
	if (self.fr.panel2.icon) then
		self.fr.panel2.icon:SetPos(10,10)
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

function ReceiveItems( handler, id, encoded, decoded ) // Called when Entity calls monrp function to send its items

	local ENTID = decoded[1]
	print(ENTID)
	local dec= decoded[2]
	print(dec)
	local svn = decoded[3]
	print(svn)
	if (ENTID == nil) then return false end
	local ent = Entity(ENTID)
	if (!ent.Items) then ent.Items = {} end
	if (!ent.svn) then ent.svn = -1 end
	if (ent) then 
		if (ent.svn < svn) then
			for k, v in pairs(dec) do
				if (v) then
					print("k: "..k)
					print(v)
					if (tonumber(v) and v <= 0) then table.remove(ent.Items,-v) else table.insert(ent.Items,v) end
				end
			end
		end
		if (ent.svn > svn) then
			ent.Items = dec
		end
		ent.svn = svn
	end
	if Interfaces[ENTID] then
		Interfaces[ENTID]:LoadItems(ent.Items)
	end
	

end
datastream.Hook( "ReceiveItems", ReceiveItems );

local function Done( )
 
end
local function Accepted( accepted, tempid, id )
 
end
function INVENTORY:RequestItems() // send request to server
	if (!self.svn) then self.svn = 0 end
	local tempid = datastream.StreamToServer( "RequestItems", {self:GetIndex(),self.svn}, Done, Accepted );
end