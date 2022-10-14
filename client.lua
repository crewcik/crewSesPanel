defaultlinks = {}      
defaultlinks[1] = {"Crew Super FM", "http://provisioning.streamtheworld.com/pls/SUPER_FMAAC.pls"}
defaultlinks[2] = {"Crew Kral FM", "http://46.20.3.204:80/"}
defaultlinks[3] = {"Crew Joy FM", "http://provisioning.streamtheworld.com/pls/JOY_TURKAAC.pls"}
defaultlinks[4] = {"Crew Metro FM", "http://provisioning.streamtheworld.com/pls/METRO_FMAAC.pls"}
defaultlinks[5] = {"Crew POP90 FM", "http://provisioning.streamtheworld.com/pls/POP90AAC.pls"}
defaultlinks[6] = {"Crew Nostalji FM", "http://46.20.13.51:1140/"}
defaultlinks[7] = {"Crew Slow FM", "http://radyo.dogannet.tv/slowturk"}
defaultlinks[8] = {"Crew İstanbul FM", "http://yayin1.canliyayin.org:8210/"}

openKey = "f5"
maxdistance = 100
defaultdistance = 50

triggerServerEvent ("clientIsReady", getRootElement())
width, height = guiGetScreenSize ()
speakers = {}
linkTable = {}
selectedURLName = "N/A"

function startScript ()
	mainWindow = guiCreateWindow ((width/2) - (500/2), (height/2) - (417/2), 500, 417, "Hoparlör Müzik Sistemi", false)
	guiWindowSetSizable (mainWindow, false)
	closeButton = guiCreateButton (450, 25, 40, 35, "Kapat", false, mainWindow)
	addEventHandler ("onClientGUIClick", closeButton, closeGUI)
	
	createButton = guiCreateButton (30, 87, 80, 40, "Hoparlör\nOluştur", false, mainWindow)
	addEventHandler ("onClientGUIClick", createButton, onCreateSpeakerKlick)
	
	destroyButton = guiCreateButton (130, 87, 80, 40, "Hoparlör\nKaldır", false, mainWindow)
	addEventHandler ("onClientGUIClick", destroyButton, onDestroySpeakerClick)
	
	myLinksButton = guiCreateButton (420, 114, 70, 35, "Linklerim", false, mainWindow)
	addEventHandler ("onClientGUIClick", myLinksButton, onMyLinksButtonClick)
	guiSetEnabled (myLinksButton, false)
	guiCreateLabel (90, 23, 100, 30, "Radyo URL:", false, mainWindow)
	urlEdit = guiCreateEdit (22, 44, 200, 35, "", false, mainWindow) 
	guiCreateLabel (259, 23, 200, 30, "Maksimim ses (1 - " .. tostring(maxdistance) .. "):", false, mainWindow)
	distanceEdit = guiCreateEdit (290, 44, 50, 35, tostring(defaultdistance), false, mainWindow)
	--
	nowPlayingText = guiCreateLabel (34, 133, 70, 30, "Çalıyor:", false, mainWindow)
	guiSetVisible (nowPlayingText, false)
	nowPlayingEditLabel = guiCreateLabel (112, 133, 288, 30, "-", false, mainWindow)
	guiSetVisible (nowPlayingEditLabel, false)
	guiCreateLabel (25, 145, 600, 30, "_______________________________________________________________", false, mainWindow)
		edit1 = guiCreateEdit (105, 168, 313, 23, defaultlinks[1][2], false, mainWindow)
		guiCreateLabel (30, 170, 200, 30, defaultlinks[1][1], false, mainWindow)
		guiEditSetReadOnly (edit1, true)
		defaultUseButton1 = guiCreateButton (423, 168, 40, 23, "Seç", false, mainWindow)
		edit2 = guiCreateEdit (105, 198, 313, 23, defaultlinks[2][2], false, mainWindow)
		guiCreateLabel (30, 200, 200, 30, defaultlinks[2][1], false, mainWindow)
		guiEditSetReadOnly (edit2, true)
		defaultUseButton2 = guiCreateButton (423, 198, 40, 23, "Seç", false, mainWindow)
		edit3 = guiCreateEdit (105, 228, 313, 23, defaultlinks[3][2], false, mainWindow)
		guiCreateLabel (30, 230, 200, 30, defaultlinks[3][1], false, mainWindow)
		guiEditSetReadOnly (edit3, true)
		defaultUseButton3 = guiCreateButton (423, 228, 40, 23, "Seç", false, mainWindow)
		edit4 = guiCreateEdit (105, 258, 313, 23, defaultlinks[4][2], false, mainWindow)
		guiCreateLabel (30, 260, 200, 30, defaultlinks[4][1], false, mainWindow)
		guiEditSetReadOnly (edit4, true)
		defaultUseButton4 = guiCreateButton (423, 258, 40, 23, "Seç", false, mainWindow)
		edit5 = guiCreateEdit (105, 288, 313, 23, defaultlinks[5][2], false, mainWindow)
		guiCreateLabel (30, 290, 200, 30, defaultlinks[5][1], false, mainWindow)
		guiEditSetReadOnly (edit5, true)
		defaultUseButton5 = guiCreateButton (423, 288, 40, 23, "Seç", false, mainWindow)
		edit6 = guiCreateEdit (105, 318, 313, 23, defaultlinks[6][2], false, mainWindow)
		guiCreateLabel (30, 320, 200, 30, defaultlinks[6][1], false, mainWindow)
		guiEditSetReadOnly (edit6, true)
		defaultUseButton6 = guiCreateButton (423, 318, 40, 23, "Seç", false, mainWindow)
		edit7 = guiCreateEdit (105, 348, 313, 23, defaultlinks[7][2], false, mainWindow)
		guiCreateLabel (30, 350, 200, 30, defaultlinks[7][1], false, mainWindow)
		guiEditSetReadOnly (edit7, true)
		defaultUseButton7 = guiCreateButton (423, 348, 40, 23, "Seç", false, mainWindow)
		edit8 = guiCreateEdit (105, 378, 313, 23, defaultlinks[8][2], false, mainWindow)
		guiCreateLabel (30, 380, 200, 30, defaultlinks[8][1], false, mainWindow)
		guiEditSetReadOnly (edit8, true)
		defaultUseButton8 = guiCreateButton (423, 378, 40, 23, "Seç", false, mainWindow)
	guiSetVisible (mainWindow, false)
	
	--Add some events
	addEvent ("speakerStuffFromServer", true)
	addEventHandler ("speakerStuffFromServer", getRootElement(), createSpeaker)
	
	addEvent ("destroySpeaker", true)
	addEventHandler ("destroySpeaker", getRootElement(), destroySpeaker)
	
	addEvent ("onPQuit", true)
	addEventHandler ("onPQuit", getRootElement(), onPlayerQuit)
	
	addEvent ("createMyLinksGUI", true)
	addEventHandler ("createMyLinksGUI", getRootElement(), createMyLinksGUI)
	
	addEvent ("onPlayerLogout", true)
	addEventHandler ("onPlayerLogout", getRootElement(), onPlayerLogout)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(), startScript)


function openOrCloseGUI ()
	if guiGetVisible (mainWindow) then
		guiSetVisible (mainWindow, false)
		guiSetVisible (linkWindow, false)
		showCursor (false)
	else
		guiSetVisible (mainWindow, true)
		showCursor (true)
	end
end
addCommandHandler ("speaker", openOrCloseGUI)
bindKey (openKey, "down", openOrCloseGUI)


function closeGUI ()
	if source == closeButton then
		guiSetVisible (mainWindow, false)
		showCursor (false)
	end
end


function createMyLinksGUI (tableoflinks)
	linkTable = tableoflinks
	guiSetEnabled (myLinksButton, true)
	
	linkWindow = guiCreateWindow ((width/2) - (483/2), (height/2) - (375/2), 483, 375, "Linklerim", false)
	guiWindowSetSizable (linkWindow, false)
	guiSetAlpha (linkWindow, 0.8)
	guiSetVisible (linkWindow, false)
	saveLinksButton = guiCreateButton (428, 25, 40, 35, "Kapat", false, linkWindow)
	guiCreateLabel (63, 48, 100, 30, "İsim", false, linkWindow)
	guiCreateLabel (260, 48, 100, 30, "Link", false, linkWindow)
	
	--Link pad 1
	linkname1 = guiCreateEdit (17, 70, 125, 23, linkTable[1]["name"], false, linkWindow)
	linkedit1 = guiCreateEdit (145, 70, 253, 23, linkTable[1]["link"], false, linkWindow)
	linkUseButton1 = guiCreateButton (428, 70, 40, 23, "Seç", false, linkWindow)
	removeButton1 = guiCreateButton (400.5, 70, 23, 23, "X", false, linkWindow)
	
	--Link pad 2
	linkname2 = guiCreateEdit (17, 100, 125, 23, linkTable[2]["name"], false, linkWindow)
	linkedit2 = guiCreateEdit (145, 100, 253, 23, linkTable[2]["link"], false, linkWindow)
	linkUseButton2 = guiCreateButton (428, 100, 40, 23, "Seç", false, linkWindow)
	removeButton2 = guiCreateButton (400.5, 100, 23, 23, "X", false, linkWindow)
	
	--Link pad 3
	linkname3 = guiCreateEdit (17, 130, 125, 23, linkTable[3]["name"], false, linkWindow)
	linkedit3 = guiCreateEdit (145, 130, 253, 23, linkTable[3]["link"], false, linkWindow)
	linkUseButton3 = guiCreateButton (428, 130, 40, 23, "Seç", false, linkWindow)
	removeButton3 = guiCreateButton (400.5, 130, 23, 23, "X", false, linkWindow)
	
	--Link pad 4
	linkname4 = guiCreateEdit (17, 160, 125, 23, linkTable[4]["name"], false, linkWindow)
	linkedit4 = guiCreateEdit (145, 160, 253, 23, linkTable[4]["link"], false, linkWindow)
	linkUseButton4 = guiCreateButton (428, 160, 40, 23, "Seç", false, linkWindow)
	removeButton4 = guiCreateButton (400.5, 160, 23, 23, "X", false, linkWindow)
	
	--Link pad 5
	linkname5 = guiCreateEdit (17, 190, 125, 23, linkTable[5]["name"], false, linkWindow)
	linkedit5 = guiCreateEdit (145, 190, 253, 23, linkTable[5]["link"], false, linkWindow)
	linkUseButton5 = guiCreateButton (428, 190, 40, 23, "Seç", false, linkWindow)
	removeButton5 = guiCreateButton (400.5, 190, 23, 23, "X", false, linkWindow)
	
	--Link pad 6
	linkname6 = guiCreateEdit (17, 220, 125, 23, linkTable[6]["name"], false, linkWindow)
	linkedit6 = guiCreateEdit (145, 220, 253, 23, linkTable[6]["link"], false, linkWindow)
	linkUseButton6 = guiCreateButton (428, 220, 40, 23, "Seç", false, linkWindow)
	removeButton6 = guiCreateButton (400.5, 220, 23, 23, "X", false, linkWindow)
	
	--Link pad 7
	linkname7 = guiCreateEdit (17, 250, 125, 23, linkTable[7]["name"], false, linkWindow)
	linkedit7 = guiCreateEdit (145, 250, 253, 23, linkTable[7]["link"], false, linkWindow)
	linkUseButton7 = guiCreateButton (428, 250, 40, 23, "Seç", false, linkWindow)
	removeButton7 = guiCreateButton (400.5, 250, 23, 23, "X", false, linkWindow)
	
	--Link pa d8
	linkname8 = guiCreateEdit (17, 280, 125, 23, linkTable[8]["name"], false, linkWindow)
	linkedit8 = guiCreateEdit (145, 280, 253, 23, linkTable[8]["link"], false, linkWindow)
	linkUseButton8 = guiCreateButton (428, 280, 40, 23, "Seç", false, linkWindow)
	removeButton8 = guiCreateButton (400.5, 280, 23, 23, "X", false, linkWindow)
	
	--Link pad 9
	linkname9 = guiCreateEdit (17, 310, 125, 23, linkTable[9]["name"], false, linkWindow)
	linkedit9 = guiCreateEdit (145, 310, 253, 23, linkTable[9]["link"], false, linkWindow)
	linkUseButton9 = guiCreateButton (428, 310, 40, 23, "Seç", false, linkWindow)
	removeButton9 = guiCreateButton (400.5, 310, 23, 23, "X", false, linkWindow)
	
	--Link pad 10
	linkname10 = guiCreateEdit (17, 340, 125, 23, linkTable[10]["name"], false, linkWindow)
	linkedit10 = guiCreateEdit (145, 340, 253, 23, linkTable[10]["link"], false, linkWindow)
	linkUseButton10 = guiCreateButton (428, 340, 40, 23, "Seç", false, linkWindow)
	removeButton10 = guiCreateButton (400.5, 340, 23, 23, "X", false, linkWindow)
end


function onMyLinksButtonClick ()
	if source == myLinksButton then
		guiSetVisible (linkWindow, true)
		guiMoveToBack (mainWindow)
	end
end


function closeLinkWindow ()
	if source == closeLinkWindowButton then
		guiSetVisible (linkWindow, false)
		reloadLinkPads ()
	end
end


function onCreateSpeakerKlick ()
	if source == createButton then
		if speakers[player] then
			outputChatBox ("[CREW]:#ffffff Bir ses sistemine sahipsiniz.", player, 255, 0, 0, true)
		else
			local guiText = guiGetText (urlEdit)
			if guiText == "" then
				outputChatBox ("[CREW]:#ffffff Bir url&link belirtmelisin.", player, 255, 0, 0, true)
			else
				local distance = guiGetText (distanceEdit)
				distance = tonumber (distance)
				if type (distance) ~= "number" then
					outputChatBox ("[CREW]:#ffffff Girdiğiniz ses geçersiz.", player, 255, 0, 0, true)
				else
					if distance > maxdistance then
						outputChatBox ("[CREW]:#ffffff En az ses değeri 1 olmalıdır." .. maxdistance .. "!", player, 255, 0, 0, true)
						return false
					else
						if distance < 1 then
							outputChatBox ("[CREW]:#ffffff En az ses değeri 1 olmalıdır." .. maxdistance .. "!", player, 255, 0, 0, true)
							return false
						else
							player = localPlayer
							local url = guiGetText (urlEdit)
							local distance = guiGetText (distanceEdit)
							triggerServerEvent ("onSpeakerCreate", getRootElement(), player, url, distance)
						end
					end
				end
			end
		end
	end
end


function onDestroySpeakerClick()
	if source == destroyButton then
		if not speakers[player] then
			outputChatBox ("[CREW]:#ffffff Kurulu ses sistemi yok!", player, 255, 0, 0, true)
		else
			triggerServerEvent ("onSpeakerDestroy", getRootElement(), player)
		end
	end
end


function createSpeaker (player, url, distance, x, y, z, rotation)
	local url = tostring (url)
	speakers[player] = {}
	speakers[player]["sound"] = playSound3D (url, x, y, z)
	setSoundMaxDistance (speakers[player]["sound"], distance)
	if isPedInVehicle(player) then
		attachElements(speakers[player]["sound"], getPedOccupiedVehicle (player))
		speakers[player]["invehicle"] = "true"
	else
		speakers[player]["object"] = createObject (2229, x, y, z, 0, 0, rotation)
		speakers[player]["invehicle"] = "false"
	end
	if string.find (selectedURLName, ":") then
		a, b = string.find (selectedURLName, ":")
		selectedURLName = tostring (string.sub(selectedURLName, 0, b - 1))
	end
	guiSetText (nowPlayingEditLabel, selectedURLName)
	guiSetVisible (nowPlayingText, true)
	guiSetVisible (nowPlayingEditLabel, true)
end


function destroySpeaker (player)
	destroyElement (speakers[player]["sound"])
	if speakers[player]["invehicle"] == "false" then
		destroyElement (speakers[player]["object"])
	end
	selectedURLName = "Own URL"
	speakers[player] = false
	guiSetText (nowPlayingEditLabel, "-")
	guiSetVisible (nowPlayingText, false)
	guiSetVisible (nowPlayingEditLabel, false)
end


function onPlayerQuit (player)
	if speakers[player] then
		destroyElement (speakers[player]["sound"])
		if speakers[player]["invehicle"] == "false" then
			destroyElement (speakers[player]["object"])
		end
		speakers[player] = false
	end
end


function onDefaultUseClick ()
	if source == defaultUseButton1 then
		guiSetText (urlEdit, defaultlinks[1][2])
		selectedURLName = defaultlinks[1][1]
	elseif source == defaultUseButton2 then
		guiSetText (urlEdit, defaultlinks[2][2])
		selectedURLName = defaultlinks[2][1]
	elseif source == defaultUseButton3 then
		guiSetText (urlEdit, defaultlinks[3][2])
		selectedURLName = defaultlinks[3][1]
	elseif source == defaultUseButton4 then
		guiSetText (urlEdit, defaultlinks[4][2])
		selectedURLName = defaultlinks[4][1]
	elseif source == defaultUseButton5 then
		guiSetText (urlEdit, defaultlinks[5][2])
		selectedURLName = defaultlinks[5][1]
	elseif source == defaultUseButton6 then
		guiSetText (urlEdit, defaultlinks[6][2])
		selectedURLName = defaultlinks[6][1]
	elseif source == defaultUseButton7 then
		guiSetText (urlEdit, defaultlinks[7][2])
		selectedURLName = defaultlinks[7][1]
	elseif source == defaultUseButton8 then
		guiSetText (urlEdit, defaultlinks[8][2])
		selectedURLName = defaultlinks[8][1]
	end
end
addEventHandler ("onClientGUIClick", getRootElement(), onDefaultUseClick)


function saveLinks ()
	if source == saveLinksButton or source == linkUseButton1 or source == linkUseButton2 or source == linkUseButton3 or source == linkUseButton4 or source == linkUseButton5 or source == linkUseButton6 or source == linkUseButton7 or source == linkUseButton8 or source == linkUseButton9 or source == linkUseButton10 then
		linkTable = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
		linkTable[1]["name"] = guiGetText (linkname1)
		linkTable[1]["link"] = guiGetText (linkedit1)
		
		linkTable[2]["name"] = guiGetText (linkname2)
		linkTable[2]["link"] = guiGetText (linkedit2)
		
		linkTable[3]["name"] = guiGetText (linkname3)
		linkTable[3]["link"] = guiGetText (linkedit3)
		
		linkTable[4]["name"] = guiGetText (linkname4)
		linkTable[4]["link"] = guiGetText (linkedit4)
		
		linkTable[5]["name"] = guiGetText (linkname5)
		linkTable[5]["link"] = guiGetText (linkedit5)
		
		linkTable[6]["name"] = guiGetText (linkname6)
		linkTable[6]["link"] = guiGetText (linkedit6)
		
		linkTable[7]["name"] = guiGetText (linkname7)
		linkTable[7]["link"] = guiGetText (linkedit7)
		
		linkTable[8]["name"] = guiGetText (linkname8)
		linkTable[8]["link"] = guiGetText (linkedit8)
		
		linkTable[9]["name"] = guiGetText (linkname9)
		linkTable[9]["link"] = guiGetText (linkedit9)
		
		linkTable[10]["name"] = guiGetText (linkname10)
		linkTable[10]["link"] = guiGetText (linkedit10)
		
		local player = localPlayer
		triggerServerEvent ("saveLinks", getRootElement(), player, linkTable)
		guiSetVisible (linkWindow, false)
	end
end
addEventHandler ("onClientGUIClick", getRootElement(), saveLinks)


function onMyLinkUse ()
	if source == linkUseButton1 then
		guiSetText (urlEdit, guiGetText (linkedit1))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname1)
	elseif source == linkUseButton2 then
		guiSetText (urlEdit, guiGetText (linkedit2))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname2)
	elseif source == linkUseButton3 then
		guiSetText (urlEdit, guiGetText (linkedit3))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname3)
	elseif source == linkUseButton4 then
		guiSetText (urlEdit, guiGetText (linkedit4))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname4)
	elseif source == linkUseButton5 then
		guiSetText (urlEdit, guiGetText (linkedit5))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname5)
	elseif source == linkUseButton6 then
		guiSetText (urlEdit, guiGetText (linkedit6))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname6)
	elseif source == linkUseButton7 then
		guiSetText (urlEdit, guiGetText (linkedit7))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname7)
	elseif source == linkUseButton8 then
		guiSetText (urlEdit, guiGetText (linkedit8))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname8)
	elseif source == linkUseButton9 then
		guiSetText (urlEdit, guiGetText (linkedit9))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname9)
	elseif source == linkUseButton10 then
		guiSetText (urlEdit, guiGetText (linkedit10))
		guiSetVisible (linkWindow, false)
		selectedURLName = guiGetText (linkname10)
	end
end
addEventHandler ("onClientGUIClick", getRootElement(), onMyLinkUse)


function onMyLinkRemoveButtonClick ()
	if source == removeButton1 then
		guiSetText (linkname1, "")
		guiSetText (linkedit1, "")
	elseif source == removeButton2 then
		guiSetText (linkname2, "")
		guiSetText (linkedit2, "")
	elseif source == removeButton3 then
		guiSetText (linkname3, "")
		guiSetText (linkedit3, "")
	elseif source == removeButton4 then
		guiSetText (linkname4, "")
		guiSetText (linkedit4, "")
	elseif source == removeButton5 then
		guiSetText (linkname5, "")
		guiSetText (linkedit5, "")
	elseif source == removeButton6 then
		guiSetText (linkname6, "")
		guiSetText (linkedit6, "")
	elseif source == removeButton7 then
		guiSetText (linkname7, "")
		guiSetText (linkedit7, "")
	elseif source == removeButton8 then
		guiSetText (linkname8, "")
		guiSetText (linkedit8, "")
	elseif source == removeButton9 then
		guiSetText (linkname9, "")
		guiSetText (linkedit9, "")
	elseif source == removeButton10 then
		guiSetText (linkname10, "")
		guiSetText (linkedit10, "")
	end
end
addEventHandler ("onClientGUIClick", getRootElement(), onMyLinkRemoveButtonClick)


function onPlayerLogout ()
	guiSetEnabled (myLinksButton, false)
	if guiGetVisible (linkWindow) then
		guiSetVisible (linkWindow, false)
	end
end