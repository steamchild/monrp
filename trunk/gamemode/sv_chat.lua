function AddChatCommand(name,func)
	if (!ChatCommands) then ChatCommands = {} end
	if (string.sub(name,1,1) == "/") and string.len( name )>1 and !table.HasValue(ChatCommands,name)  then 
		local slot = {name,func}
		table.insert(ChatCommands,slot)
		return true
	end 
	return false
end

function MonrpDoSay(ply,text)
	if (string.sub(text, 1, 1)=="/") then
		local tab = string.ToTable(text)
		local cmd = ""
		local arg = ""
		local reading="cmd"
		for k , v in pairs(tab) do
			if(v==" " and reading != "arg") then reading = "arg" else
				if(reading=="arg") then arg=arg..v end
				if(reading=="cmd") then cmd=cmd..v end
			end
		end
		if (arg) then
			for k, v in pairs(ChatCommands) do
				if (v[1]==cmd) then v[2](ply,arg) return end
			end
		end 
	end

	Type = CHAT_NORM
	From = ply
	Text = text

	for k, v in pairs(ents.FindInSphere(ply:GetPos(),100)) do
		if (v:IsPlayer()) then datastream.StreamToClients(v, "Player_Say", {From,Type,Text} ); end
	end
end

function OOCsay(ply,text)
	for k, v in pairs(player.GetAll()) do
		if (v:IsPlayer()) then datastream.StreamToClients(v, "Player_Say", {ply,CHAT_OOC,text} ); end
	end
end
AddChatCommand("//",OOCsay)
AddChatCommand("/ooc",OOCsay)

function Advert(ply,text)
	for k, v in pairs(player.GetAll()) do
		if (v:IsPlayer()) then datastream.StreamToClients(v, "Player_Say", {false,CHAT_ADVERT,text} ); end
	end
end
AddChatCommand("/adv",Advert)
AddChatCommand("/advert",Advert)