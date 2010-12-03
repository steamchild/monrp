function PlayerSay( handle, id, encoded, decoded )
local ply = decoded[1] 
local type = decoded[2]
local text = decoded[3]
local textcol = Color(255,255,255)
local prefix=""
local prefixcol=Color(0,0,0)
local postfix=": "
local postfixcol=Color(255,255,255)
local name
local namecol

if (ply) then
	name=ply.MrpName
	if (name) then namecol = Color(50,30,255) else name="unknown" namecol = Color(50,50,50) end
else 
	name = "" 
	namecol = Color(0,0,0) 
	postfix = "" 
end

if (type == CHAT_ADVERT) then prefix = "[ADVERT] " prefixcol=Color(255,255,255) textcol = Color(255,255,0) end
if (type == CHAT_OOC) then prefix = "(OOC) " prefixcol = namecol textcol = Color(200,200,200) end

chat.AddText(
		prefixcol, prefix,
		namecol, name,
		postfixcol, postfix,
		textcol, text
	)
chat.PlaySound()


end
datastream.Hook( "Player_Say", PlayerSay );