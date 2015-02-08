--[[
	Name: xrParticlesEditor
	Filename: ElementManagerS.lua
	Author: Sam@ke
--]]

local classInstance = nil

ElementManagerS = {}

function ElementManagerS:constructor(parent)

	self.parent = parent
	
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
	
	self.m_Update = function() self:update() end
	
	self.m_CreateParticleEffect = function(...) self:createParticleEffect(...) end
	addEvent("createParticleEffect", true)
	addEventHandler("createParticleEffect", root, self.m_CreateParticleEffect)
	
	self.m_DeleteParticleEffect = function(...) self:deleteParticleEffect(...) end
	addEvent("deleteParticleEffect", true)
	addEventHandler("deleteParticleEffect", root, self.m_DeleteParticleEffect)
	
	self.m_ResetCompleteMap = function(...) self:resetCompleteMap(...) end
	addEvent("resetCompleteMap", true)
	addEventHandler("resetCompleteMap", root, self.m_ResetCompleteMap)

	mainOutput("ElementManagerS was started...")
end


function ElementManagerS:update()
	for index, effect in pairs(getElementsByType("xrParticleEffect")) do
		if (effect) then
			local x = effect:getData("x")
			local y = effect:getData("y")
			local z = effect:getData("z")
			
			if (x) and (y) and (z) then
				effect:setPosition(tonumber(x), tonumber(y), tonumber(z))
			end
		end
	end
end


function ElementManagerS:createParticleEffect(	x, y, z, texture, maxParticles, radius, turbulence, 
												velocityX, velocityY, velocityZ, effectRotation, startParticleSize, 
												endParticleSize, particleLifeTime, effectBrightness, effectColorAlpha, 
												effectColorRed, effectColorGreen, effectColorBlue, isRainBowColor)
	if (x) and (y) and (z) then
		local texture = texture or self.defaultTexture
		local maxParticles = maxParticles or self.defaulMaxParticles
		local radius = radius or self.defaultRadius
		local turbulence = turbulence or self.defaultTurbulence
		local velocityX = velocityX or self.defaultVelocityX
		local velocityY = velocityY or self.defaultVelocityY
		local velocityZ = velocityZ or self.defaultVelocityZ
		local effectRotation = effectRotation or self.defaultEffectRotation
		local startParticleSize = startParticleSize or self.defaultStartParticleSize
		local endParticleSize = endParticleSize or self.defaultEndParticleSize
		local particleLifeTime = particleLifeTime or self.defaultParticleLifeTime
		local effectBrightness = effectBrightness or self.defaultEffectBrightness
		local effectColorAlpha = effectColorAlpha or self.defaultEffectColorAlpha
		local effectColorRed = effectColorRed or self.defaultEffectColorRed
		local effectColorGreen = effectColorGreen or self.defaultEffectColorGreen
		local effectColorBlue = effectColorBlue or self.defaultEffectColorBlue
		local isRainBowColor = isRainBowColor or self.defaultIsRainBowColor
		
		local effectsCount = #getElementsByType("xrParticleEffect") or 0
		local id = "xrParticleEffect" .. effectsCount + 1
		
		if (not self.effectsTable[id]) then
			self.effectsTable[id] = {}
			
			self.effectsTable[id].element = createElement("xrParticleEffect", id)
			self.effectsTable[id].element:setPosition(x, y, z)
			self.effectsTable[id].element:setData("id", id)
			self.effectsTable[id].element:setData("texture", texture)
			self.effectsTable[id].element:setData("x", x)
			self.effectsTable[id].element:setData("y", y)
			self.effectsTable[id].element:setData("z", z)
			self.effectsTable[id].element:setData("maxParticles", maxParticles)
			self.effectsTable[id].element:setData("radius", radius)
			self.effectsTable[id].element:setData("turbulence", turbulence)
			self.effectsTable[id].element:setData("velocityX", velocityX)
			self.effectsTable[id].element:setData("velocityY", velocityY)
			self.effectsTable[id].element:setData("velocityZ", velocityZ)
			self.effectsTable[id].element:setData("effectRotation", effectRotation)
			self.effectsTable[id].element:setData("startParticleSize", startParticleSize)
			self.effectsTable[id].element:setData("endParticleSize", endParticleSize)
			self.effectsTable[id].element:setData("particleLifeTime", particleLifeTime)
			self.effectsTable[id].element:setData("effectBrightness", effectBrightness)
			self.effectsTable[id].element:setData("effectColorAlpha", effectColorAlpha)
			self.effectsTable[id].element:setData("effectColorRed", effectColorRed)
			self.effectsTable[id].element:setData("effectColorGreen", effectColorGreen)
			self.effectsTable[id].element:setData("effectColorBlue", effectColorBlue)
			self.effectsTable[id].element:setData("isRainBowColor", isRainBowColor)
		end
	end
end


function ElementManagerS:deleteParticleEffect(id)
	if (id) then
		if (self.effectsTable[id]) then			
			if (self.effectsTable[id].element) then
				self.effectsTable[id].element:destroy()
				self.effectsTable[id].element = nil
			end
			
			self.effectsTable[id] = nil
		end
		
		triggerClientEvent("onEffectDeleted", root, id)
	end
end


function ElementManagerS:resetCompleteMap()
	if (isElement(source)) then
	
		triggerEvent("stopRunningEffectMaps", root)
		
		for index, effect in pairs(self.effectsTable) do
			if (effect) then
				if (effect.element) then
					effect.element:destroy()
					effect.element = nil
				end
			end
		end

		for index, effect in pairs(getElementsByType("xrParticleEffect")) do
			if (effect) then
				effect:destroy()
				effect = nil
			end
		end
		
		self.effectsTable = {}
		
		mainOutput("SERVER: New Map was started...")
		
		triggerClientEvent("onMapResetted", root)
	end
end


function ElementManagerS:destructor()
	removeEventHandler("createParticleEffect", root, self.m_CreateParticleEffect)
	removeEventHandler("deleteParticleEffect", root, self.m_DeleteParticleEffect)
	removeEventHandler("resetCompleteMap", root, self.m_ResetCompleteMap)
	
	for index, effectElement in ipairs(self.effectsTable) do
		if (effectElement) then	
			if (effectElement.element) then
				effectElement.element:destroy()
				effectElement.element = nil
			end
		end
	end

	mainOutput("ElementManagerS was stopped...")
end