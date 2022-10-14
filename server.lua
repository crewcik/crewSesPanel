clientIsReady = false

function startScript ()
	addEvent ("onSpeakerCreate", true)
	addEventHandler ("onSpeakerCreate", getRootElement(), onSpeakerCreate)
	
	addEvent ("onSpeakerDestroy", true)
	addEventHandler ("onSpeakerDestroy", getRootElement(), onSpeakerDestroy)
	
	addEvent ("clientIsReady", true)
	addEventHandler ("clientIsReady", getRootElement(), enableClientIsReady)
	
	addEvent ("saveLinks", true)
	addEventHandler ("saveLinks", getRootElement(), saveLinks)
	
	linkTimer = setTimer (enableLinksForPlayers, 500, 0)
end
addEventHandler ("onResourceStart", getResourceRootElement(), startScript)


function onSpeakerCreate (player, url, distance)
	if getPedOccupiedVehicle (player) then
		if getPedOccupiedVehicleSeat (player) > 0 then
			outputChatBox ("[CREW]:#ffffff Sürücü olmadan müzik açamazsın!", player, 255, 0, 0, true)
			return false
		end
	end
	local x, y, z = getElementPosition (player)
	local z = z - 1
	local rx, ry, rz = getElementRotation (player)
	
	local rz = rz + 90
	local rz = 0.0174532925 * rz
	local x = (math.cos(rz) * 1.5) + x
	local y = (math.sin(rz) * 1.5) + y
	
	local ox, oy, oz = getElementPosition (player)
	local rotation = findRotation(x, y, ox, oy)
	local rotation = rotation + 180
	
	
	triggerClientEvent ("speakerStuffFromServer", getRootElement(), player, url, distance, x, y, z, rotation)
end


function onSpeakerDestroy (player)
	triggerClientEvent ("destroySpeaker", getRootElement(), player)
end


function onPlayerQuit ()
	local player = source
	triggerClientEvent ("onPQuit", getRootElement(), player)
end
addEventHandler ("onPlayerQuit", getRootElement(), onPlayerQuit)


function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end;
	return t;
end


function getLinks (player)
	local account = getPlayerAccount (player)
	if getAccountData (account, "urlLinks") then
		linkJSONTable = getAccountData (account, "urlLinks")
		linkTable = fromJSON (linkJSONTable)
	else
		linkTable = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
		linkTable[1]["name"] = ""
		linkTable[1]["link"] = ""
		
		linkTable[2]["name"] = ""
		linkTable[2]["link"] = ""
		
		linkTable[3]["name"] = ""
		linkTable[3]["link"] = ""
		
		linkTable[4]["name"] = ""
		linkTable[4]["link"] = ""
		
		linkTable[5]["name"] = ""
		linkTable[5]["link"] = ""
		
		linkTable[6]["name"] = ""
		linkTable[6]["link"] = ""
		
		linkTable[7]["name"] = ""
		linkTable[7]["link"] = ""
		
		linkTable[8]["name"] = ""
		linkTable[8]["link"] = ""
		
		linkTable[9]["name"] = ""
		linkTable[9]["link"] = ""
		
		linkTable[10]["name"] = ""
		linkTable[10]["link"] = ""
	end
	local tableoflinks = linkTable
	triggerClientEvent (player, "createMyLinksGUI", getRootElement(), tableoflinks)
end


function onLogin ()
	local player = source
	getLinks (player)
end
addEventHandler ("onPlayerLogin", getRootElement(), onLogin)


function onLogout ()
	local player = source
	triggerClientEvent (player, "onPlayerLogout", getRootElement())
end
addEventHandler ("onPlayerLogout", getRootElement(), onLogout)


function saveLinks (player, linkTable)
	local account = getPlayerAccount (player)
	local linkTable = toJSON (linkTable)
	setAccountData (account, "urlLinks", linkTable)
end


function enableClientIsReady ()
	clientIsReady = true
end


function enableLinksForPlayers ()
	if clientIsReady == true then
		local players = getElementsByType ("player")
		for k, player in ipairs (players) do
			local account = getPlayerAccount (player)
			if isGuestAccount (account) == false then
				getLinks (player)
			end
		end
		killTimer (linkTimer)
	end
end