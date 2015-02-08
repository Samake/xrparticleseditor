--[[
	Name: xrParticlesEditor
	Filename: EditorClassC.lua
	Author: Sam@ke
--]]

local classInstance = nil

EditorClassC = {}

function EditorClassC:constructor(parent, configFile)

	self.parent = parent
	self.configFile = configFile
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.player = getLocalPlayer()
	
	self.cursor3DSize = 0.6
	self.cursor3DAlpha = 255
	self.cursor3DMaxDistance = 500
	
	self.cursorSize = 32
	self.objectMoveSpeed = 0.2
	self.selectedEffect = nil
	self.editorState = "FlyMode"
	
	self.posX, self.posY, self.posZ = 0, 0, 0
	
	self.x = nil
	self.y = nil
	self.z = nil
	self.cursorElement = nil
	self.clickedElement = nil
	self.distanceToEffect = 0
	
	self.lineSize = 10
	self.fontSize = 0.8

	if (self.configFile) then
		self.keyEnableEffectModeNode = self.configFile:findChild("enableEffectMode", 0)
		self.keyEnableEffectMode = self.keyEnableEffectModeNode:getValue("enableEffectMode") or "f"
		self.keyFastMoveNode = self.configFile:findChild("moveCamFast", 0)
		self.keyFastMove = self.keyFastMoveNode:getValue("moveCamFast") or "lshift"
		self.keySlowMoveNode = self.configFile:findChild("moveCamSlow", 0)
		self.keySlowMove = self.keySlowMoveNode:getValue("moveCamSlow") or "lalt"
		self.keyForwardNode = self.configFile:findChild("moveCamForward", 0)
		self.keyForward = self.keyForwardNode:getValue("moveCamForward") or "w"
		self.keyBackwardNode = self.configFile:findChild("moveCamBack", 0)
		self.keyBackward = self.keyBackwardNode:getValue("moveCamBack") or "s"
		self.keyLeftNode = self.configFile:findChild("moveCamLeft", 0)
		self.keyLeft = self.keyLeftNode:getValue("moveCamLeft") or "a"
		self.keyRightNode = self.configFile:findChild("moveCamRight", 0)
		self.keyRight = self.keyRightNode:getValue("moveCamRight") or "d"
		
		self.keyEffectForwardNode = self.configFile:findChild("moveEffectForward", 0)
		self.keyEffectForward = self.keyEffectForwardNode:getValue("moveEffectForward") or "arrow_u"
		self.keyEffectBackwardNode = self.configFile:findChild("moveEffectBack", 0)
		self.keyEffectBackward = self.keyEffectBackwardNode:getValue("moveEffectBack") or "arrow_d"
		self.keyEffectLeftNode = self.configFile:findChild("moveEffectLeft", 0)
		self.keyEffectLeft = self.keyEffectLeftNode:getValue("moveEffectLeft") or "arrow_l"
		self.keyEffectRightNode = self.configFile:findChild("moveEffectRight", 0)
		self.keyEffectRight = self.keyEffectRightNode:getValue("moveEffectRight") or "arrow_r"
		self.keyEffectUpNode = self.configFile:findChild("moveEffectUp", 0)
		self.keyEffectUp = self.keyEffectUpNode:getValue("moveEffectUp") or "num_8"
		self.keyEffectDownNode = self.configFile:findChild("moveEffectDown", 0)
		self.keyEffectDown = self.keyEffectDownNode:getValue("moveEffectDown") or "num_2"
		self.keyDeleteEffectNode = self.configFile:findChild("deleteEffect", 0)
		self.keyDeleteEffect = self.keyDeleteEffectNode:getValue("deleteEffect") or "delete"
	end
	
	self.cursorTexture = dxCreateTexture("res/textures/misc/cursor.png")
	
	self.player:setFrozen(true)
	
	if (not self.freeCam) then
		self.freeCam = new(FreeCamC, self)
	end
	
	if (not self.editorGUIClass) then
		self.editorGUIClass = new(EditorGUIClassC, self, self.configFile)
	end
	
	self.m_OnClientClick = function(...) self:onClientClick(...) end
	addEventHandler("onClientClick", root, self.m_OnClientClick)
	
	self.m_OnParticleEffectSelected = function(...) self:onParticleEffectSelected(...) end
	addEvent("onParticleEffectSelected", true)
	addEventHandler("onParticleEffectSelected", root, self.m_OnParticleEffectSelected)
	
	self.m_OnParticleEffectDeSelected = function() self:onParticleEffectDeSelected() end
	addEvent("onParticleEffectDeSelected", true)
	addEventHandler("onParticleEffectDeSelected", root, self.m_OnParticleEffectDeSelected)
	
	self.m_OnEffectManualDeleted = function() self:onEffectManualDeleted() end
	bindKey(self.keyDeleteEffect, "down", self.m_OnEffectManualDeleted)
	
	self.m_ToggleCursor = function() self:toggleCursor() end
	bindKey(self.keyEnableEffectMode, "down", self.m_ToggleCursor)
	
	toggleAllControls(false)
	self.player:setAnimation("CLOTHES", "CLO_Pose_Loop", -1, true, false, false, false)
	
	triggerEvent("onXREditorOpened", root)
	
	mainOutput("EditorClassC was started...")
end


function EditorClassC:toggleCursor()
	if (isCursorShowing()) then
		showCursor(false)
		self.editorState = "FlyMode"
	else
		showCursor(true)
		self.editorState = "EffectMode"
	end
end


function EditorClassC:onParticleEffectSelected(selectedEffect)
	if (selectedEffect) and (isElement(selectedEffect)) then
		self.selectedEffect = selectedEffect
	end
end


function EditorClassC:onParticleEffectDeSelected()
	self.selectedEffect = nil
end


function EditorClassC:onEffectManualDeleted()
	if (self.selectedEffect) then
		triggerEvent("deleteParticleEffect", root, self.selectedEffect)
		triggerEvent("onParticleEffectDeSelected", root)
		self.selectedEffect = nil
	end
end


function EditorClassC:onClientClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (self.editorState == "EffectMode") then
		if (button) and (state) and (absoluteX) and (absoluteY) and (worldX) and (worldY) and (worldZ) then
			if (button == "left") and (state == "down") then
				if (clickedElement) and (isElement(clickedElement)) then
					local effect = clickedElement:getData("Effect")
					
					if (effect) then
						triggerEvent("onParticleEffectSelected", root, effect)
						self.clickedElement = effect
					end
				else
					if (self.editorGUIClass) then
						if (guiGetVisible(self.editorGUIClass.particelSettingsWindow) ~= true) then
							self.clickedElement = nil
							triggerEvent("onParticleEffectDeSelected", root)
						end
					else
						self.clickedElement = nil
						triggerEvent("onParticleEffectDeSelected", root)
					end
				end			
			elseif (button == "right") and (state == "down") then
				if (self.distanceToEffect < self.cursor3DMaxDistance) then
					triggerEvent("createParticleEffect", root, worldX, worldY, worldZ)
				end
			end
		end
	end
end


function EditorClassC:update()
	if (self.editorGUIClass) then
		self.editorGUIClass:update()
	end
		
	if (self.editorState == "EffectMode") then		
		if (self.freeCam) then
			self.freeCam.isEnabled = "false"
		end
			
		if (isCursorShowing()) then
			self.screenX, self.screenY, self.worldX, self.worldY, self.worldZ = getCursorPosition()
			self.camX, self.camY, self.camZ = getCameraMatrix()
			local hit, x, y, z, hitElement = processLineOfSight(self.camX, self.camY, self.camZ, self.worldX, self.worldY, self.worldZ, true, true, true, true, false, false, false, false)

			if (hit) then
				self.x, self.y, self.z = x, y, z
			end
			
			if (hitElement) then
				self.cursorElement = hitElement
			end
			
			self.distanceToEffect = getDistanceBetweenPoints3D(self.camX, self.camY, self.camZ, self.x, self.y, self.z)
			
			local dynamicValue = 1 / 255 * self.distanceToEffect
			self.dynamicAlpha = self.cursor3DAlpha - 255 * dynamicValue
			
			if (self.dynamicAlpha < 0) then
				self.dynamicAlpha = 0
			end
			
			if (self.x) and (self.y) and (self.z) then
				dxDrawCircle3D(self.x, self.y, self.z, self.cursor3DSize / 8, 32, tocolor(255, 255, 0, self.dynamicAlpha ), 3 + dynamicValue)
				dxDrawLine3D(self.x, self.y, self.z, self.x, self.y, self.z + self.cursor3DSize, tocolor(255, 0, 0, self.dynamicAlpha ), 3 + dynamicValue)
				dxDrawLine3D(self.x, self.y, self.z, self.x, self.y + self.cursor3DSize, self.z, tocolor(0, 255, 0, self.dynamicAlpha ), 3 + dynamicValue)
				dxDrawLine3D(self.x, self.y, self.z, self.x + self.cursor3DSize, self.y, self.z, tocolor(0, 0, 255, self.dynamicAlpha ), 3 + dynamicValue)
			end
			
			self.line = 0
			dxDrawText("Press key '" .. self.parent.keyOpenEditor .. "' to close editor.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.parent.keyOpenEditor .. "' #FFFFFF to close editor.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 1
			dxDrawText("Press key 'F3' to open selected effect settings.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'F3' #FFFFFFto open selected effect settings.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 2
			dxDrawText("Click 'Left Mouse' to selected an effect.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFClick #FFCC22'Left Mouse' #FFFFFFto selected an effect.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 3
			dxDrawText("Click 'Right Mouse' to place an effect.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFClick #FFCC22'Right Mouse' #FFFFFFto place an effect.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 4
			dxDrawText("Press key '" .. self.keyEnableEffectMode .. "' to close effect mode.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255),self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyEnableEffectMode .. "' #FFFFFFto close effect mode.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 5
			dxDrawText("Press key '" .. self.keyEffectForward .. "' to move effect forward.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyEffectForward .. "' #FFFFFFto move effect forward.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 6
			dxDrawText("Press key '" .. self.keyEffectBackward .. "' to move effect back.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyEffectBackward .. "' #FFFFFFto move effect back.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 7
			dxDrawText("Press key '" .. self.keyEffectLeft .. "' to move effect left.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyEffectLeft .. "' #FFFFFFto move effect left.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 8
			dxDrawText("Press key '" .. self.keyEffectRight .. "' to move effect right.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyEffectRight .. "' #FFFFFFto move effect right.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 9
			dxDrawText("Press key '" .. self.keyEffectUp .. "' to move effect up.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyEffectUp .. "' #FFFFFFto move effect up.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 10
			dxDrawText("Press key '" .. self.keyEffectDown .. "' to move effect down.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyEffectDown .. "' #FFFFFFto move effect down.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
			self.line = 11
			dxDrawText("Press key '" .. self.keyDeleteEffect .. "' to delete effect.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
			dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyDeleteEffect .. "' #FFFFFFto delete effect.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)		
		end
	elseif (self.editorState == "FlyMode") then
		if (self.freeCam) then
			self.freeCam.isEnabled = "true"
		end
	
		if (self.cursorTexture) then
			dxDrawImage((self.screenWidth / 2) - (self.cursorSize / 2), (self.screenHeight / 2) - (self.cursorSize / 2), self.cursorSize, self.cursorSize, self.cursorTexture, 0, 0, 0, tocolor(255, 255, 255, 128))
		end
		
		self.line = 0
		dxDrawText("Press key '" .. self.parent.keyOpenEditor .. "' to close editor.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawText("#FFFFFFPress key #FFCC22'" .. self.parent.keyOpenEditor .. "' #FFFFFF to close editor.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
		self.line = 1
		dxDrawText("Press key '" .. self.keyEnableEffectMode .. "' to open effect mode.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyEnableEffectMode .. "' #FFFFFFto open effect mode.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
		self.line = 2
		dxDrawText("Press key '" .. self.keyForward .. "' to fly forward.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyForward .. "' #FFFFFFto fly forward.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
		self.line = 3
		dxDrawText("Press key '" .. self.keyBackward .. "' to fly back.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyBackward .. "' #FFFFFFto fly back.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
		self.line = 4
		dxDrawText("Press key '" .. self.keyLeft .. "' to strafe left.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyLeft .. "' #FFFFFFto strafe left.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
		self.line = 5
		dxDrawText("Press key '" .. self.keyRight .. "' to strafe right.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawText("#FFFFFFPress key #FFCC22'" .. self.keyRight .. "' #FFFFFFto strafe right.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
		self.line = 6
		dxDrawText("Hold key '" .. self.keyFastMove .. "' to fly faster.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawText("#FFFFFFHold key #FFCC22'" .. self.keyFastMove .. "' #FFFFFFto fly faster.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
		self.line = 7
		dxDrawText("Hold key '" .. self.keySlowMove .. "' to fly slower.", 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, 10 + 1, (self.screenHeight * 0.8) + (self.lineSize * self.line) + 1, tocolor(0, 0, 0, 255), self.fontSize, "default-bold", "left", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawText("#FFFFFFHold key #FFCC22'" .. self.keySlowMove .. "' #FFFFFFto fly slower.", 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), 10, (self.screenHeight * 0.8) + (self.lineSize * self.line), white, self.fontSize, "default-bold", "left", "center", false, false, false, true, false, 0, 0, 0)
	end
	
	if (self.selectedEffect) and (isElement(self.selectedEffect)) then
		local id = self.selectedEffect.id
		
		self.tempX, self.tempY, self.tempZ = self.posX, self.posY, self.posZ
		_, _, self.camRotZ = getCameraRotation()
		self.camRotZ = self.camRotZ%360
		
		self.camRotZ = math.rad(self.camRotZ)
		local distanceX = self.objectMoveSpeed * math.cos(self.camRotZ)
		local distanceY = self.objectMoveSpeed * math.sin(self.camRotZ)

		if (id) then
			if (getKeyState(self.keyEffectForward) == true) then
				self.tempX = self.tempX + distanceY
				self.tempY = self.tempY + distanceX
				triggerEvent("onEffectMoveOnXAxis", root, id, self.tempX)
				triggerEvent("onEffectMoveOnYAxis", root, id, self.tempY)
			end
			
			if (getKeyState(self.keyEffectBackward) == true) then
				self.tempX = self.tempX - distanceY
				self.tempY = self.tempY - distanceX
				triggerEvent("onEffectMoveOnXAxis", root, id, self.tempX)
				triggerEvent("onEffectMoveOnYAxis", root, id, self.tempY)
			end
			
			if (getKeyState(self.keyEffectLeft) == true) then
				self.tempX = self.tempX - distanceX
				self.tempY = self.tempY + distanceY
				triggerEvent("onEffectMoveOnXAxis", root, id, self.tempX)
				triggerEvent("onEffectMoveOnYAxis", root, id, self.tempY)
			end
			
			if (getKeyState(self.keyEffectRight) == true) then
				self.tempX = self.tempX + distanceX
				self.tempY = self.tempY - distanceY
				triggerEvent("onEffectMoveOnXAxis", root, id, self.tempX)
				triggerEvent("onEffectMoveOnYAxis", root, id, self.tempY)
			end
			
			if (getKeyState(self.keyEffectUp) == true) then
				self.tempZ = self.tempZ + self.objectMoveSpeed
				triggerEvent("onEffectMoveOnZAxis", root, id, self.tempZ)
			end
			
			if (getKeyState(self.keyEffectDown) == true) then
				self.tempZ = self.tempZ - self.objectMoveSpeed
				triggerEvent("onEffectMoveOnZAxis", root, id, self.tempZ)
			end
		end
	end
end


function EditorClassC:getClickedElement()
	return self.clickedElement
end


function EditorClassC:destructor()
	removeEventHandler("onClientClick", root, self.m_OnClientClick)
	removeEventHandler("onParticleEffectSelected", root, self.m_OnParticleEffectSelected)
	removeEventHandler("onParticleEffectDeSelected", root, self.m_OnParticleEffectDeSelected)
	unbindKey("delete", "down", self.m_OnEffectManualDeleted)
	unbindKey("F", "down", self.m_ToggleCursor)
	
	if (self.cursorTexture) then
		self.cursorTexture:destroy()
		self.cursorTexture = nil
	end
	
	if (self.freeCam) then
		delete(self.freeCam)
		self.freeCam = nil
	end
	
	if (self.editorGUIClass) then
		delete(self.editorGUIClass)
		self.editorGUIClass = nil
	end
	
	self.player:setAnimation(false)
	setCameraTarget(self.player)
	toggleAllControls(true)
	self.player:setFrozen(false)
	showCursor(false)
	
	triggerEvent("onXREditorClosed", root)
	mainOutput("EditorClassC was stopped...")
end