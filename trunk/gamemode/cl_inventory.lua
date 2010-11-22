INV = {}

function INV:Create(x,y,w,h,Index)
	if !self:SetIndex( Index ) then return end
	self.Width = 500
	self.Height = 800
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
	self.fr.inv = vgui.Create( "DPanelListFix", self.fr )
		self.fr.inv:SetPos(5,25)
		self.fr.inv:SetSize(self.Width-10,self.Height-30)
		self.fr.inv:EnableHorizontal(true)
		self.fr.inv:SetName("wut")
	return self
end

function INV:AddIcon(Model)
	self.fr.inv:AddIcon(LocalPlayer():GetModel())
end

function INV:OnSelect(ItemNum)
	local Item = self.fr.inv.Items[ItemNum]
end

function INV:OnClose()

end

function INV:PerformLayout()

end

function INV:SetIndex( Index )
	self.Index = Index
	if (Interfaces[Index] == nil) then
		Interfaces[Index] = self return true
	end
	return false
end

function INV:GetIndex()
	return self.Index
end

Interfaces = {}