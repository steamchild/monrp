INVENTORY = {}

function INVENTORY:Create(x,y,w,h,Index)
	if !self:SetIndex( Index ) then return end
	self.Width = 500
	self.Height = 800
	self.Items = {}
	self.Functions = {}
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
			print(self:GetParent():GetParent():GetParent():GetParent():GetName())
			print(self:GetParent():GetParent():GetParent():GetParent().mom)
			self:GetParent():GetParent():GetParent():GetParent().mom:OnClick(self)
		end
		self.fr.inv:SetName("wut")

	self.fr.property = vgui.Create( "DPropertySheet", self.fr )
		self.fr.property:SetPos( 5, 30 )
		self.fr.property:SetSize( 340, 315 )
	self.fr.panel = vgui.Create("DPanel", self.fr)
		self.fr.panel.Paint = function() end
	self.fr.panel.icon = vgui.Create("SpawnIcon", self.fr.panel)
	self.fr.panel.ListFunc = vgui.Create( "DPanelList", self.fr.panel )
		self.fr.panel.ListFunc:EnableHorizontal(true)
		self.fr.panel.ListFunc:SetName("wut")
		//self.fr.panel.ListFunc:SetDynamicSpacing(true)
	self.fr.panel.PerformLayout2 = self.fr.panel.PerformLayout

	self.fr.panel.PerformLayout = function(self)
		print("self:GetWide():")
		print(self:GetWide())
		print("self:GetTall():")
		print(self:GetTall())

		local x,y = self.icon:GetPos()
		if (x <= 0) or (y <= 0) then self.fr.property:PerformLayout() end
		x = x + self.icon:GetWide() + y
		local wide = self:GetWide() - x - y
		local tall = self:GetTall() - y*2	
		print("wide: ")
		print(wide)
		print("tall: ")
		print(tall)
		self.ListFunc:SetPos(x,y)
		self.ListFunc:SetSize(wide,tall)

		self:PerformLayout2()
	end

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
	self:RefreshFunctions()
	self:CallOpen()
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

function INVENTORY:ClearItems()
	self.Items = {}
	self.fr.inv:Clear()
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
	return self.Items[num].Icon.Toggled
end

function INVENTORY:GetToggled()
	local Toggled = {}
	local num = 0
	for k, v in pairs(self.Items) do
		if (self:IsToggled(k)) then num = num+1 Toggled[num] = v end
	end
	return Toggled
end

function INVENTORY:GetToggledNums()
	local Toggled = {}
	local num = 0
	for k, v in pairs(self.Items) do
		if (self:IsToggled(k)) then num = num+1 Toggled[num] = k end
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

/*----------------------------------------------
	ON CLICK
------------------------------------------------*/
function INVENTORY:OnClick(item)
	local num = self:GetItemNum(item)
	if LocalPlayer():KeyDown( IN_SPEED ) then self:Toggle(num) else self:Select(num) end
end


function INVENTORY:OnClose()
	print("INV ONClosed")
	self:CallClose()
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
	
	if (self.fr.panel.ListFunc) then
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
	self:ClearItems()
	for k, v in pairs(Items) do
		local item = table.Copy(v)
		self:AddItem(item)
	end
end

function INVENTORY:RefreshFunctions()
	local ent = Entity(self:GetIndex())
	self.fr.panel.ListFunc:Clear()
	if (ent and ent:IsValid() and ent.InvFunctions) then
		for k, v in pairs(ent.InvFunctions) do
			local button = vgui.Create( "DButton", self.fr.panel.ListFunc )
				button:SetSize( 128, 16 )
				button:SetPos( 200, 20 )
				button:SetText( v )
				button.mom = self
				button.DoClick =  function( self )
					print("PRESSED")
					self.mom:CallFunction(self:GetText())
				end
			self.fr.panel.ListFunc:AddItem(button)
		end
	end
end

Interfaces = {}

/*-----------------------------------------
	INVENTORY DATA RECEIVER
-----------------------------------------*/

function ReceiveItems( handler, id, encoded, decoded ) // Called when Entity calls monrp function to send its items
	print("ITEMS RECEIVED")
	local ENTID = decoded[1]
	print(ENTID)
	local Items= decoded[2]
	print(dec)
	local svn_mode = decoded[3]
	if (ENTID == nil) then return false end
	local ent = Entity(ENTID)
	if (!ent.Items) then ent.Items = {} end

	if (svn_mode == -1) then ent.Items = Items else
		for k, v in pairs(Items) do
			if (tonumber(v)) then table.remove(ent.Items,
		end
	end

	if Interfaces[ENTID] then
		Interfaces[ENTID]:LoadItems(ent.Items)
	end
	

end
datastream.Hook( "ReceiveItems", ReceiveItems );

function ReceiveFunctions( handler, id, encoded, decoded ) // Called when Entity calls monrp function to send its items
	local ENTID = decoded[1]
	local functions = decoded[2]
	print("functions: ")
	print(functions)
	if (functions) then
		PrintTable(functions)
	end
	local ent = Entity(ENTID)
	if ( !ent or !ent:IsValid() ) then return end
	ent.InvFunctions = functions
	if Interfaces[ENTID] then
		Interfaces[ENTID]:RefreshFunctions()
	end
end
datastream.Hook( "ReceiveFunctions", ReceiveFunctions );
 
local function Done( )
 
end
local function Accepted( accepted, tempid, id )
 
end

/*-----------------------------------------
	INVENTORY DATA SENDER
-----------------------------------------*/

function INVENTORY:CallOpen() // send request to server
	if (!self.svn) then self.svn = 0 end
	local tempid = datastream.StreamToServer( "CallOpen", {self:GetIndex(),self.svn}, Done, Accepted );
end

function INVENTORY:CallClose()
	local tempid = datastream.StreamToServer( "CallClose", self:GetIndex(), Done, Accepted );
end

function INVENTORY:RequestFunctions() // send request to server
	if (!self.svn) then self.svn = 0 end
	datastream.StreamToServer( "RequestFunctions", self:GetIndex());
end

function INVENTORY:CallFunction(func) // send request to server
	print("CALLED: "..func)
	PrintTable(self:GetToggledNums())
	datastream.StreamToServer( "CallFunction", {self:GetIndex(),self:GetToggledNums(),func} );
end