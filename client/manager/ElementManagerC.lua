--[[
	Name: xrParticlesEditor
	Filename: ElementManagerC.lua
	Author: Sam@ke
--]]

local classInstance = nil

ElementManagerC = {}

function ElementManagerC:constructor(parent)

	self.parent = parent
	self.fakeObjectID = 1347 -- fake object is needed for picking up effect if editor is running, otherwise it is deleted
	
	self.defaultTexture = "smoke_B"
	self.defaulMaxParticles = 64
	self.defaultRadius = 0
	self.defaultTurbulence = 0.02
	self.defaultVelocityX = 0
	self.defaultVelocityY = 0
	self.defaultVelocityZ = 0.4
	self.defaultEffectRotation = 0
	self.defaultStartParticleSize = 0.1
	self.defaultEndParticleSize = 1.2
	self.defaultParticleLifeTime = 8000
	self.defaultEffectBrightness = 1
	self.defaultEffectColorAlpha = 80
	self.defaultEffectColorRed = 255
	self.defaultEffectColorGreen = 255
	self.defaultEffectColorBlue = 255
	self.defaultIsRainBowColor = "false"
	
	self.effectsTable = {}
	
	self.m_CreateParticleEffect = function(...) self:createParticleEffect(...) end
	addEvent("createParticleEffect", true)
	addEventHandler("createParticleEffect", root, self.m_CreateParticleEffect)
	
	self.m_OnEffectCreated = function(...) self:onEffectCreated(...) end
	addEvent("onEffectCreated", true)
	addEventHandler("onEffectCreated", root, self.m_OnEffectCreated)
	
	self.m_DeleteParticleEffect = function(...) self:deleteParticleEffect(...) end
	addEvent("deleteParticleEffect", true)
	addEventHandler("deleteParticleEffect", root, self.m_DeleteParticleEffect)
	
	self.m_OnEffectDeleted = function(...) self:onEffectDeleted(...) end
	addEvent("onEffectDeleted", true)
	addEventHandler("onEffectDeleted", root, self.m_OnEffectDeleted)
	
	self.m_OnXREditorOpened = function(...) self:onXREditorOpened(...) end
	addEvent("onXREditorOpened", true)
	addEventHandler("onXREditorOpened", root, self.m_OnXREditorOpened)
	
	self.m_OnXREditorClosed = function(...) self:onXREditorClosed(...) end
	addEvent("onXREditorClosed", true)
	addEventHandler("onXREditorClosed", root, self.m_OnXREditorClosed)
	
	self.m_OnPresetWasLoaded = function(...) self:onPresetWasLoaded(...) end
	addEvent("onPresetWasLoaded", true)
	addEventHandler("onPresetWasLoaded", root, self.m_OnPresetWasLoaded)
	
	self.m_OnMapResetted = function(...) self:onMapResetted(...) end
	addEvent("onMapResetted", true)
	addEventHandler("onMapResetted", root, self.m_OnMapResetted)

	mainOutput("ElementManagerC was started...")
end


function ElementManagerC:onXREditorOpened()
	for index, effect in ipairs(getElementsByType("xrParticleEffect")) do
		if (self.effectsTable[effect.id]) then
			if (not self.effectsTable[effect.id].model) then
				local pos = effect:getPosition()
				
				self.effectsTable[effect.id].model = createObject(self.fakeObjectID, pos.x, pos.y, pos.z + 0.5)
				self.effectsTable[effect.id].model:setAlpha(0)
				
				self.effectsTable[effect.id].model:setData("Effect", effect)
				effect:attach(self.effectsTable[effect.id].model)
			end
		end
	end
end


function ElementManagerC:update()
	for index, effect in ipairs(getElementsByType("xrParticleEffect")) do
		if (effect) then
			local pos = effect:getPosition()
			
			if (self.effectsTable[effect.id]) then
				if (self.effectsTable[effect.id].model) then
					self.effectsTable[effect.id].model:setPosition(pos.x, pos.y, pos.z)
				end
			end
		end
	end
end


function ElementManagerC:onXREditorClosed()
	for index, effectElement in pairs(self.effectsTable) do
		if (effectElement) then
			if (effectElement.model) then
				effectElement.model:destroy()
				effectElement.model = nil
			end
		end
	end
end


function ElementManagerC:createParticleEffect(x, y, z)
	if (x) and (y) and (z) then
		triggerServerEvent(		"createParticleEffect", root, 
								x, y, z, 
								self.defaultTexture,
								self.defaulMaxParticles,
								self.defaultRadius,
								self.defaultTurbulence,
								self.defaultVelocityX,
								self.defaultVelocityY,
								self.defaultVelocityZ,
								self.defaultEffectRotation,
								self.defaultStartParticleSize,
								self.defaultEndParticleSize,
								self.defaultParticleLifeTime,
								self.defaultEffectBrightness,
								self.defaultEffectColorAlpha,
								self.defaultEffectColorRed,
								self.defaultEffectColorGreen,
								self.defaultEffectColorBlue,
								self.defaultIsRainBowColor)
	end
end


function ElementManagerC:onEffectCreated(effect)
	if (effect) then
		local id = effect:getData("id")
		
		local pos = effect:getPosition()

		if (not self.effectsTable[id]) then
			self.effectsTable[id] = {}
			
			self.effectsTable[id].model = createObject(self.fakeObjectID, pos.x, pos.y, pos.z)
			self.effectsTable[id].model:setAlpha(0)
			self.effectsTable[id].model:setData("Effect", effect)
			--self.effectsTable[id].model:attach(effect)
			effect:attach(self.effectsTable[id].model)
			
			if (self.effectsTable[id].model) then
				mainOutput("Element " .. tostring(id) .. " was created...")
			end
		end
	end
end


function ElementManagerC:deleteParticleEffect(effect)
	if (effect) and (isElement(effect)) then
		local id = effect:getData("id")
		
		if (id) then
			triggerServerEvent("deleteParticleEffect", root, id)
		end
	end
end


function ElementManagerC:onEffectDeleted(id)
	if (id) then
		if (self.effectsTable[id]) then
			if (self.effectsTable[id].model) then
				self.effectsTable[id].model:destroy()
				self.effectsTable[id].model = nil
			end

			self.effectsTable[id] = nil
			
			triggerEvent("deleteParticleEffect", root, id)
		end
	end
end


function ElementManagerC:onPresetWasLoaded(presetTable)
	if (presetTable) then
		self.defaultTexture = presetTable.texture
		self.defaulMaxParticles = presetTable.maxParticles
		self.defaultRadius = presetTable.radius
		self.defaultTurbulence = presetTable.turbulence
		self.defaultVelocityX = presetTable.velocityX
		self.defaultVelocityY = presetTable.velocityY
		self.defaultVelocityZ = presetTable.velocityZ
		self.defaultEffectRotation = presetTable.effectRotation
		self.defaultStartParticleSize = presetTable.startParticleSize
		self.defaultEndParticleSize = presetTable.endParticleSize
		self.defaultParticleLifeTime = presetTable.particleLifeTime
		self.defaultEffectBrightness = presetTable.effectBrightness
		self.defaultEffectColorAlpha = presetTable.effectColorAlpha
		self.defaultEffectColorRed = presetTable.effectColorRed
		self.defaultEffectColorGreen = presetTable.effectColorGreen
		self.defaultEffectColorBlue = presetTable.effectColorBlue
		self.defaultIsRainBowColor = presetTable.isRainBowColor
	end
end


function ElementManagerC:onMapResetted()
	for index, effect in pairs(self.effectsTable) do
		if (effect) then
			if (effect.model) then
				effect.model:destroy()
				effect.model = nil
			end
		end
	end
	
	self.effectsTable = {}
end


function ElementManagerC:destructor()
	removeEventHandler("createParticleEffect", root, self.m_CreateParticleEffect)
	removeEventHandler("onEffectCreated", root, self.m_OnEffectCreated)
	removeEventHandler("deleteParticleEffect", root, self.m_DeleteParticleEffect)
	removeEventHandler("onEffectDeleted", root, self.m_OnEffectDeleted)
	removeEventHandler("onXREditorOpened", root, self.m_OnXREditorOpened)
	removeEventHandler("onXREditorClosed", root, self.m_OnXREditorClosed)
	removeEventHandler("onPresetWasLoaded", root, self.m_OnPresetWasLoaded)
	removeEventHandler("onMapResetted", root, self.m_OnMapResetted)
	
	for index, effectElement in ipairs(self.effectsTable) do
		if (effectElement) then
			if (effectElement.model) then
				effectElement.model:destroy()
				effectElement.model = nil
			end
		end
	end

	mainOutput("ElementManagerC was stopped...")
end