--[[
	Name: xrParticlesEditor
	Filename: ParticleEffect3DManagerC.lua
	Author: Sam@ke
--]]

local classInstance = nil

ParticleEffect3DManagerC = {}

function ParticleEffect3DManagerC:constructor(parent, configFile)

	self.parent = parent
	self.configFile = configFile
	self.player = getLocalPlayer()
	self.particleEffects = {}
	
	if (self.configFile) then
		self.viewDistanceNode = self.configFile:findChild("viewDistance", 0)
		self.effectViewDistance = tonumber(self.viewDistanceNode:getValue("viewDistance"))
		
		if (not self.effectViewDistance) then
			self.effectViewDistance = 100
		end
	else
		self.effectViewDistance = 100
	end
	
	self.textureList = {}
	self.textureList["smoke_A"] = dxCreateTexture("res/textures/effects/smoke_A.dds")
	self.textureList["smoke_B"] = dxCreateTexture("res/textures/effects/smoke_B.dds")
	self.textureList["smoke_C"] = dxCreateTexture("res/textures/effects/smoke_C.dds")
	self.textureList["smoke_D"] = dxCreateTexture("res/textures/effects/smoke_D.dds")
	self.textureList["dirt_A"] = dxCreateTexture("res/textures/effects/dirt_A.dds")
	self.textureList["dirt_B"] = dxCreateTexture("res/textures/effects/dirt_B.dds")
	self.textureList["dirt_C"] = dxCreateTexture("res/textures/effects/dirt_C.dds")
	self.textureList["colorDot_A"] = dxCreateTexture("res/textures/effects/colorDot_A.dds")
	self.textureList["colorDot_B"] = dxCreateTexture("res/textures/effects/colorDot_B.dds")
	self.textureList["colorDot_C"] = dxCreateTexture("res/textures/effects/colorDot_C.dds")
	self.textureList["colorDot_D"] = dxCreateTexture("res/textures/effects/colorDot_D.dds")
	self.textureList["colorDot_E"] = dxCreateTexture("res/textures/effects/colorDot_E.dds")
	self.textureList["corona_A"] = dxCreateTexture("res/textures/effects/corona_A.dds")
	self.textureList["corona_B"] = dxCreateTexture("res/textures/effects/corona_B.dds")
	self.textureList["galaxy_A"] = dxCreateTexture("res/textures/effects/galaxy_A.dds")
	self.textureList["galaxy_B"] = dxCreateTexture("res/textures/effects/galaxy_B.dds")
	self.textureList["bubbles_A"] = dxCreateTexture("res/textures/effects/bubbles_A.dds")
	self.textureList["bubbles_B"] = dxCreateTexture("res/textures/effects/bubbles_B.dds")
	self.textureList["bubbles_C"] = dxCreateTexture("res/textures/effects/bubbles_C.dds")
	self.textureList["anomaly_A"] = dxCreateTexture("res/textures/effects/anomaly_A.dds")
	self.textureList["blood_A"] = dxCreateTexture("res/textures/effects/blood_A.dds")
	self.textureList["leaf_A"] = dxCreateTexture("res/textures/effects/leaf_A.dds")
	self.textureList["fan_A"] = dxCreateTexture("res/textures/effects/fan_A.dds")
	self.textureList["fan_B"] = dxCreateTexture("res/textures/effects/fan_B.dds")
	self.textureList["fan_C"] = dxCreateTexture("res/textures/effects/fan_C.dds")
	self.textureList["flashback_A"] = dxCreateTexture("res/textures/effects/flashback_A.dds")
	self.textureList["flashback_B"] = dxCreateTexture("res/textures/effects/flashback_B.dds")
	self.textureList["splash_A"] = dxCreateTexture("res/textures/effects/splash_A.dds")
	self.textureList["glow_A"] = dxCreateTexture("res/textures/effects/glow_A.dds")
	self.textureList["glow_B"] = dxCreateTexture("res/textures/effects/glow_B.dds")
	
	self.defaultTexture = "smoke_A"
	
	self.m_OnParticleEffectSelected = function(...) self:onParticleEffectSelected(...) end
	addEvent("onParticleEffectSelected", true)
	addEventHandler("onParticleEffectSelected", root, self.m_OnParticleEffectSelected)
	
	self.m_OnParticleEffectDeSelected = function() self:onParticleEffectDeSelected() end
	addEvent("onParticleEffectDeSelected", true)
	addEventHandler("onParticleEffectDeSelected", root, self.m_OnParticleEffectDeSelected)
	
	self.m_DeleteParticleEffect = function(...) self:deleteParticleEffect(...) end
	addEvent("deleteParticleEffect", true)
	addEventHandler("deleteParticleEffect", root, self.m_DeleteParticleEffect)
	
	self.m_OnTextureChanged = function(...) self:onTextureChanged(...) end
	addEvent("onTextureChanged", true)
	addEventHandler("onTextureChanged", root, self.m_OnTextureChanged)
	
	self.m_OnMaxParticlesChanged = function(...) self:onMaxParticlesChanged(...) end
	addEvent("onMaxParticlesChanged", true)
	addEventHandler("onMaxParticlesChanged", root, self.m_OnMaxParticlesChanged)
	
	self.m_OnRadiusChanged = function(...) self:onRadiusChanged(...) end
	addEvent("onRadiusChanged", true)
	addEventHandler("onRadiusChanged", root, self.m_OnRadiusChanged)
	
	self.m_OnTurbulenceChanged = function(...) self:onTurbulenceChanged(...) end
	addEvent("onTurbulenceChanged", true)
	addEventHandler("onTurbulenceChanged", root, self.m_OnTurbulenceChanged)
	
	self.m_OnVelocityXChanged = function(...) self:onVelocityXChanged(...) end
	addEvent("onVelocityXChanged", true)
	addEventHandler("onVelocityXChanged", root, self.m_OnVelocityXChanged)
	
	self.m_OnVelocityYChanged = function(...) self:onVelocityYChanged(...) end
	addEvent("onVelocityYChanged", true)
	addEventHandler("onVelocityYChanged", root, self.m_OnVelocityYChanged)
	
	self.m_OnVelocityZChanged = function(...) self:onVelocityZChanged(...) end
	addEvent("onVelocityZChanged", true)
	addEventHandler("onVelocityZChanged", root, self.m_OnVelocityZChanged)
	
	self.m_OnEffectRotationChanged = function(...) self:onEffectRotationChanged(...) end
	addEvent("onEffectRotationChanged", true)
	addEventHandler("onEffectRotationChanged", root, self.m_OnEffectRotationChanged)
	
	self.m_OnStartParticleSizeChanged= function(...) self:onStartParticleSizeChanged(...) end
	addEvent("onStartParticleSizeChanged", true)
	addEventHandler("onStartParticleSizeChanged", root, self.m_OnStartParticleSizeChanged)
	
	self.m_OnEndParticleSizeChanged = function(...) self:onEndParticleSizeChanged(...) end
	addEvent("onEndParticleSizeChanged", true)
	addEventHandler("onEndParticleSizeChanged", root, self.m_OnEndParticleSizeChanged)
	
	self.m_OnLifeTimeChanged = function(...) self:onLifeTimeChanged(...) end
	addEvent("onLifeTimeChanged", true)
	addEventHandler("onLifeTimeChanged", root, self.m_OnLifeTimeChanged)
	
	self.m_OnBrightnessChanged = function(...) self:onBrightnessChanged(...) end
	addEvent("onBrightnessChanged", true)
	addEventHandler("onBrightnessChanged", root, self.m_OnBrightnessChanged)
	
	self.m_OnAlphaChanged = function(...) self:onAlphaChanged(...) end
	addEvent("onAlphaChanged", true)
	addEventHandler("onAlphaChanged", root, self.m_OnAlphaChanged)

	self.m_OnRainbowColorChanged = function(...) self:onRainbowColorChanged(...) end
	addEvent("onRainbowColorChanged", true)
	addEventHandler("onRainbowColorChanged", root, self.m_OnRainbowColorChanged)
	
	self.m_OnEffectMoveOnXAxis = function(...) self:onEffectMoveOnXAxis(...) end
	addEvent("onEffectMoveOnXAxis", true)
	addEventHandler("onEffectMoveOnXAxis", root, self.m_OnEffectMoveOnXAxis)
	
	self.m_OnEffectMoveOnYAxis = function(...) self:onEffectMoveOnYAxis(...) end
	addEvent("onEffectMoveOnYAxis", true)
	addEventHandler("onEffectMoveOnYAxis", root, self.m_OnEffectMoveOnYAxis)
	
	self.m_OnEffectMoveOnZAxis = function(...) self:onEffectMoveOnZAxis(...) end
	addEvent("onEffectMoveOnZAxis", true)
	addEventHandler("onEffectMoveOnZAxis", root, self.m_OnEffectMoveOnZAxis)
	
	self.m_OnMapResetted = function(...) self:onMapResetted(...) end
	addEvent("onMapResetted", true)
	addEventHandler("onMapResetted", root, self.m_OnMapResetted)
	
	mainOutput("ParticleEffect3DManagerC was started...")
end


function ParticleEffect3DManagerC:update()
	self.streamedInParticles = 0
	self.streamedInActiveParticles = 0
	
	for index, particleEffect in pairs(self.particleEffects) do
		if (particleEffect) then
			particleEffect:update()
			
			self.streamedInParticles = self.streamedInParticles + particleEffect.maxParticles
			self.streamedInActiveParticles = self.streamedInActiveParticles + particleEffect.activeParticles
		end
	end
	
	self.player:setData("streamedInParticles", self.streamedInParticles)
	self.player:setData("streamedInActiveParticles", self.streamedInActiveParticles)
	
	self.allParticles = 0
	
	for index, effectElement in ipairs(getElementsByType("xrParticleEffect")) do
		if (effectElement) and (isElement(effectElement)) then
			self.allParticles = self.allParticles + tonumber(effectElement:getData("maxParticles") or 0)
		end
	end
	
	self.player:setData("allParticles", self.allParticles)

	self:streamParticleEffects()
end


function ParticleEffect3DManagerC:streamParticleEffects()
	for index, effectElement in ipairs(getElementsByType("xrParticleEffect")) do
		if (effectElement) and (isElement(effectElement)) then
			local effectPos = effectElement:getPosition()
			local camPosX, camPosY, camPosZ = getCameraMatrix()
			local distance = getDistanceBetweenPoints3D(effectPos.x, effectPos.y, effectPos.z, camPosX, camPosY, camPosZ)

			if (distance < self.effectViewDistance) then
				self:createParticleEffect(effectElement, effectElement.id, effectPos.x, effectPos.y, effectPos.z)
			else
				self:deleteParticleEffect(effectElement.id)
			end
		end
	end
end


function ParticleEffect3DManagerC:createParticleEffect(element, effectID, x, y, z)
	if (element) and (effectID) and (x) and (y) and (z) then
		if (not self.particleEffects[effectID]) then
			self.particleEffects[effectID] = new(ParticleEffect3DClassC, self, element, effectID, x, y, z, self.effectViewDistance)
			triggerEvent("onParticleEffectSelected", root, element)
		end
	end
end


function ParticleEffect3DManagerC:deleteParticleEffect(effectID)
	if (effectID) then
		if (self.particleEffects[effectID]) then
			delete(self.particleEffects[effectID])
			self.particleEffects[effectID] = false
		end
	end
end


function ParticleEffect3DManagerC:onParticleEffectSelected(selectedEffect)
	if (selectedEffect) then
		for index, particleEffect in pairs(self.particleEffects) do
			if (particleEffect) then
				local id = selectedEffect:getData("id")
				
				if (id) then
					if (id == particleEffect.id) then
						particleEffect.isSelectedEffect = "true"
					else
						particleEffect.isSelectedEffect = "false"
					end
				else
					particleEffect.isSelectedEffect = "false"
				end
			end
		end
	end
end


function ParticleEffect3DManagerC:onParticleEffectDeSelected()
	for index, particleEffect in pairs(self.particleEffects) do
		if (particleEffect) then
			particleEffect.isSelectedEffect = "false"
		end
	end
end


function ParticleEffect3DManagerC:isEditor()
	return self.parent.editorClass
end


function ParticleEffect3DManagerC:onTextureChanged(effectID, textureID)
	if (effectID) and (textureID) then
		if (self.particleEffects[effectID]) then
			if (self.textureList[textureID]) then
				self.particleEffects[effectID]:setTexture(textureID, self.textureList[textureID])
			end
		end
	end
end


function ParticleEffect3DManagerC:onMaxParticlesChanged(effectID, maxParticles)
	if (effectID) and (maxParticles) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setMaxParticles(maxParticles)
		end
	end
end


function ParticleEffect3DManagerC:onRadiusChanged(effectID, radius)
	if (effectID) and (radius) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setRadius(radius)
		end
	end
end


function ParticleEffect3DManagerC:onTurbulenceChanged(effectID, turbulence)
	if (effectID) and (turbulence) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setTurbulence(turbulence)
		end
	end
end


function ParticleEffect3DManagerC:onVelocityXChanged(effectID, velocityX)
	if (effectID) and (velocityX) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setVelocityX(velocityX)
		end
	end
end


function ParticleEffect3DManagerC:onVelocityYChanged(effectID, velocityY)
	if (effectID) and (velocityY) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setVelocityY(velocityY)
		end
	end
end


function ParticleEffect3DManagerC:onVelocityZChanged(effectID, velocityZ)
	if (effectID) and (velocityZ) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setVelocityZ(velocityZ)
		end
	end
end


function ParticleEffect3DManagerC:onEffectRotationChanged(effectID, rotation)
	if (effectID) and (rotation) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setEffectRotation(rotation)
		end
	end
end


function ParticleEffect3DManagerC:onStartParticleSizeChanged(effectID, startParticleSize)
	if (effectID) and (startParticleSize) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setStartParticleSize(startParticleSize)
		end
	end
end


function ParticleEffect3DManagerC:onEndParticleSizeChanged(effectID, endParticleSize)
	if (effectID) and (endParticleSize) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setEndParticleSize(endParticleSize)
		end
	end
end


function ParticleEffect3DManagerC:onLifeTimeChanged(effectID, particleLifeTime)
	if (effectID) and (particleLifeTime) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setParticleLifeTime(particleLifeTime)
		end
	end
end


function ParticleEffect3DManagerC:onBrightnessChanged(effectID, brightness)
	if (effectID) and (brightness) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setBrightness(brightness)
		end
	end
end


function ParticleEffect3DManagerC:onAlphaChanged(effectID, alpha)
	if (effectID) and (alpha) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setAlpha(alpha)
		end
	end
end


function ParticleEffect3DManagerC:onRainbowColorChanged(effectID, bool)
	if (effectID) and (bool) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:setRainBowColor(bool)
		end
	end
end


function ParticleEffect3DManagerC:onEffectMoveOnXAxis(effectID, amount)
	if (effectID) and (amount) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:moveOnXAxis(amount)
		end
	end
end


function ParticleEffect3DManagerC:onEffectMoveOnYAxis(effectID, amount)
	if (effectID) and (amount) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:moveOnYAxis(amount)
		end
	end
end


function ParticleEffect3DManagerC:onEffectMoveOnZAxis(effectID, amount)
	if (effectID) and (amount) then
		if (self.particleEffects[effectID]) then
			self.particleEffects[effectID]:moveOnZAxis(amount)
		end
	end
end


function ParticleEffect3DManagerC:onMapResetted()
	for index, effect in pairs(self.particleEffects) do
		if (effect) then
			delete(effect)
			effect = nil
		end
	end
	
	self.particleEffects = {}
end


function ParticleEffect3DManagerC:destructor()
	removeEventHandler("onParticleEffectSelected", root, self.m_OnParticleEffectSelected)
	removeEventHandler("onParticleEffectDeSelected", root, self.m_OnParticleEffectDeSelected)
	removeEventHandler("deleteParticleEffect", root, self.m_DeleteParticleEffect)
	removeEventHandler("onTextureChanged", root, self.m_OnTextureChanged)
	removeEventHandler("onMaxParticlesChanged", root, self.m_OnMaxParticlesChanged)
	removeEventHandler("onRadiusChanged", root, self.m_OnRadiusChanged)
	removeEventHandler("onTurbulenceChanged", root, self.m_OnTurbulenceChanged)
	removeEventHandler("onVelocityXChanged", root, self.m_OnVelocityXChanged)
	removeEventHandler("onVelocityYChanged", root, self.m_OnVelocityYChanged)
	removeEventHandler("onVelocityZChanged", root, self.m_OnVelocityZChanged)
	removeEventHandler("onEffectRotationChanged", root, self.m_OnEffectRotationChanged)
	removeEventHandler("onStartParticleSizeChanged", root, self.m_OnStartParticleSizeChanged)
	removeEventHandler("onEndParticleSizeChanged", root, self.m_OnEndParticleSizeChanged)
	removeEventHandler("onLifeTimeChanged", root, self.m_OnLifeTimeChanged)
	removeEventHandler("onBrightnessChanged", root, self.m_OnBrightnessChanged)
	removeEventHandler("onAlphaChanged", root, self.m_OnAlphaChanged)
	removeEventHandler("onRainbowColorChanged", root, self.m_OnRainbowColorChanged)
	removeEventHandler("onEffectMoveOnXAxis", root, self.m_OnEffectMoveOnXAxis)
	removeEventHandler("onEffectMoveOnYAxis", root, self.m_OnEffectMoveOnYAxis)
	removeEventHandler("onEffectMoveOnZAxis", root, self.m_OnEffectMoveOnZAxis)
	removeEventHandler("onMapResetted", root, self.m_OnMapResetted)
	
	for index, particleEffect in ipairs(self.particleEffects) do
		if (particleEffect) then
			delete(particleEffect)
			particleEffect = nil
		end
	end
	
	for index, texture in ipairs(self.textureList) do
		if (texture) then
			texture:destroy()
			texture = nil
		end
	end

	mainOutput("ParticleEffect3DManagerC was stopped...")
end