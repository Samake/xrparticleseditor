--[[
	Name: xrParticlesEditor
	Filename: ParticleEffect3DClassC.lua
	Author: Sam@ke
--]]

local classInstance = nil

ParticleEffect3DClassC = {}

function ParticleEffect3DClassC:constructor(parent, element, id, x, y, z, viewDistance)

	self.parent = parent	
	self.element = element
	self.id = id
	self.x = tonumber(x)
	self.y = tonumber(y)
	self.z = tonumber(z)
	self.viewDistance = tonumber(viewDistance)
	
	self.isSelectedEffect = "false"
	
	if (self.element) and (isElement(self.element)) then
		self.particleTextureID = self.element:getData("texture") or "smoke_B"
		self.maxParticles = tonumber(self.element:getData("maxParticles")) or 64
		self.radius = tonumber(self.element:getData("radius")) or 0
		self.turbulence = tonumber(self.element:getData("turbulence")) or 0.05
		self.velocityX = tonumber(self.element:getData("velocityX")) or 0
		self.velocityY = tonumber(self.element:getData("velocityY")) or 0
		self.velocityZ = tonumber(self.element:getData("velocityZ")) or 0.2
		self.effectRotation = tonumber(self.element:getData("effectRotation")) or 0
		self.startParticleSize = tonumber(self.element:getData("startParticleSize")) or 0.1
		self.endParticleSize = tonumber(self.element:getData("endParticleSize")) or 1
		self.particleLifeTime = tonumber(self.element:getData("particleLifeTime")) or 8000
		self.effectBrightness = tonumber(self.element:getData("effectBrightness")) or 1
		self.effectColorAlpha = tonumber(self.element:getData("effectColorAlpha")) or 90
		self.effectColorRed = tonumber(self.element:getData("effectColorRed")) or 255
		self.effectColorGreen = tonumber(self.element:getData("effectColorGreen")) or 255
		self.effectColorBlue = tonumber(self.element:getData("effectColorBlue")) or 255
		self.isRainBowColor = self.element:getData("isRainBowColor") or "false"
		
		triggerEvent("onEffectCreated", root, self.element)
	else
		self:destroyMe()
	end
	
	if (self.particleTextureID) then
		if (self.parent.textureList[self.particleTextureID]) then
			self.particleTexture = self.parent.textureList[self.particleTextureID]
		else
			self.particleTexture = self.parent.textureList["smoke_A"]
		end
	else
		self.particleTexture = self.parent.textureList["smoke_A"]
	end
	
	if (self.parent) then
		self.element:setData("texture", self.particleTextureID, true)
		self.element:setData("x", self.x, true)
		self.element:setData("y", self.y, true)
		self.element:setData("z", self.z, true)
		self.element:setData("maxParticles", self.maxParticles, true)
		self.element:setData("radius", self.radius, true)
		self.element:setData("turbulence", self.turbulence, true)
		self.element:setData("velocityX", self.velocityX, true)
		self.element:setData("velocityY", self.velocityY, true)
		self.element:setData("velocityZ", self.velocityZ, true)
		self.element:setData("effectRotation", self.effectRotation, true)
		self.element:setData("startParticleSize", self.startParticleSize, true)
		self.element:setData("endParticleSize", self.endParticleSize, true)
		self.element:setData("particleLifeTime", self.particleLifeTime, true)
		self.element:setData("effectBrightness", self.effectBrightness, true)
		self.element:setData("effectColorAlpha", self.effectColorAlpha, true)
		self.element:setData("isRainBowColor", self.isRainBowColor, true)
		self.element:setData("effectColorRed", self.effectColorRed)
		self.element:setData("effectColorGreen", self.effectColorGreen, true)
		self.element:setData("effectColorBlue", self.effectColorBlue, true)
	else
		self:destroyMe()
	end
	
	self.m_SpawnParticle = function(...) self:spawnParticle(...) end
	self.effectParticles = {}
	self.activeParticles = 0

	mainOutput("ParticleEffect3DClassC " .. self.id  .. " was created...")
end

function ParticleEffect3DClassC:update()
	for i = 1, self.maxParticles, 1 do
		if (not self.effectParticles[i]) then
			local activatiomTime = math.random(50, self.particleLifeTime * 0.9)
			self.effectParticles[i] = {}
			self:createParticle(i)
		end
	end
	
	for index, particleContainer in pairs(self.effectParticles) do
		if (particleContainer.particle) then
			particleContainer.particle:update()
		end
	end
	
	if (self.parent:isEditor()) then
		if (self.isSelectedEffect == "true") then
			dxDrawLine3D(self.x, self.y, self.z - 0.4, self.x, self.y, self.z + 0.4, tocolor(55, 255, 0, 255), 3)
			dxDrawLine3D(self.x, self.y - 0.4, self.z, self.x, self.y + 0.4, self.z, tocolor(55, 255, 0, 255), 3)
			dxDrawLine3D(self.x - 0.4, self.y, self.z, self.x + 0.4, self.y, self.z, tocolor(55, 255, 0, 255), 3)
		else
			dxDrawLine3D(self.x, self.y, self.z - 0.4, self.x, self.y, self.z + 0.4, tocolor(255, 55, 0, 200), 2)
			dxDrawLine3D(self.x, self.y - 0.4, self.z, self.x, self.y + 0.4, self.z, tocolor(255, 55, 0, 200), 2)
			dxDrawLine3D(self.x - 0.4, self.y, self.z, self.x + 0.4, self.y, self.z, tocolor(255, 55, 0, 200), 2)
		end
	end

	if (not self.element) or  (not isElement(self.element)) then
		self:destroyMe()
	end
	
	self:refreshEffectsParameters()
end


function ParticleEffect3DClassC:createParticle(id)
	if (id) then
		local id = id
		local spawnTime = math.random(50, self.particleLifeTime * 0.9)
		
		self.effectParticles[id].isActive = "true"
		setTimer(self.m_SpawnParticle, spawnTime, 1, id)
	end
end


function ParticleEffect3DClassC:spawnParticle(id)
	if (id) then
		if (not self.effectParticles[id].particle) then
			self.effectParticles[id].particle = new(Particle3DClassC, self, id)
		end
	end
end


function ParticleEffect3DClassC:refreshEffectsParameters()
	if (self.element) and (isElement(self.element)) then
		local x = self.element:getData("x")
		
		if (x) then
			if (x ~= self.x) then
				self.x = x
			end
		end
		
		local y = self.element:getData("y")
		
		if (y) then
			if (y ~= self.y) then
				self.y = y
			end
		end
		
		local z = self.element:getData("z")
		
		if (z) then
			if (z ~= self.z) then
				self.z = z
			end
		end
		
	
		local textureID = self.element:getData("texture")
		
		if (textureID) then
			if (textureID ~= self.particleTextureID) then
				self.particleTextureID = textureID
				self.particleTexture = self.parent.textureList[self.particleTextureID]
			end
		end
		
		local maxParticles = self.element:getData("maxParticles")
		
		if (maxParticles) then
			if (maxParticles ~= self.maxParticles) then
				self.maxParticles = maxParticles
			end
		end
		
		local radius = self.element:getData("radius")
		
		if (radius) then
			if (radius ~= self.radius) then
				self.radius = radius
			end
		end
		
		local turbulence = self.element:getData("turbulence")
		
		if (turbulence) then
			if (turbulence ~= self.turbulence) then
				self.turbulence = turbulence
			end
		end
		
		local velocityX = self.element:getData("velocityX")
		
		if (velocityX) then
			if (velocityX ~= self.velocityX) then
				self.velocityX = velocityX
			end
		end
		
		local velocityY = self.element:getData("velocityY")
		
		if (velocityY) then
			if (velocityY ~= self.velocityY) then
				self.velocityY = velocityY
			end
		end
		
		local velocityZ = self.element:getData("velocityZ")
		
		if (velocityZ) then
			if (velocityZ ~= self.velocityZ) then
				self.velocityZ = velocityZ
			end
		end
		
		local effectRotation = self.element:getData("effectRotation")
		
		if (effectRotation) then
			if (effectRotation ~= self.effectRotation) then
				self.effectRotation = effectRotation
			end
		end
		
		local startParticleSize = self.element:getData("startParticleSize")
		
		if (startParticleSize) then
			if (startParticleSize ~= self.startParticleSize) then
				self.startParticleSize = startParticleSize
			end
		end
		
		local endParticleSize = self.element:getData("endParticleSize")
		
		if (endParticleSize) then
			if (endParticleSize ~= self.endParticleSize) then
				self.endParticleSize = endParticleSize
			end
		end
		
		local particleLifeTime = self.element:getData("particleLifeTime")
		
		if (particleLifeTime) then
			if (endParticleSize ~= self.particleLifeTime) then
				self.particleLifeTime = particleLifeTime
			end
		end
		
		local effectBrightness = self.element:getData("effectBrightness")
		
		if (effectBrightness) then
			if (effectBrightness ~= self.effectBrightness) then
				self.effectBrightness = effectBrightness
			end
		end
		
		local effectColorAlpha = self.element:getData("effectColorAlpha")
		
		if (effectColorAlpha) then
			if (effectColorAlpha ~= self.effectColorAlpha) then
				self.effectColorAlpha = effectColorAlpha
			end
		end
		
		local isRainBowColor = self.element:getData("isRainBowColor")
		
		if (isRainBowColor) then
			if (isRainBowColor ~= self.isRainBowColor) then
				self.isRainBowColor = isRainBowColor
			end
		end
		
		local effectColorRed = self.element:getData("effectColorRed")
		
		if (effectColorRed) then
			if (effectColorRed ~= self.effectColorRed) then
				self.effectColorRed = effectColorRed
			end
		end
		
		local effectColorGreen = self.element:getData("effectColorGreen")
		
		if (effectColorGreen) then
			if (effectColorGreen ~= self.effectColorGreen) then
				self.effectColorGreen = effectColorGreen
			end
		end
		
		local effectColorBlue = self.element:getData("effectColorBlue")
		
		if (effectColorBlue) then
			if (effectColorBlue ~= self.effectColorBlue) then
				self.effectColorBlue = effectColorBlue
			end
		end
	else
		--self:destroyMe()
	end
end


function ParticleEffect3DClassC:deleteParticle(id)
	if (id) then
		if (self.effectParticles[id].particle) then
			delete(self.effectParticles[id].particle)
			self.effectParticles[id].particle = nil
			self.effectParticles[id] = nil
		end
	end
end


function ParticleEffect3DClassC:setTexture(textureID, texture)
	if (textureID) and (texture) then
		self.particleTexture = texture
		self.element:setData("texture", textureID, true)
	end
end


function ParticleEffect3DClassC:setMaxParticles(maxParticles)
	if (maxParticles) then
		self.maxParticles = maxParticles
		self.element:setData("maxParticles", maxParticles, true)
	end
end


function ParticleEffect3DClassC:setRadius(radius)
	if (radius) then
		self.radius = radius
		self.element:setData("radius", radius, true)
	end
end


function ParticleEffect3DClassC:setTurbulence(turbulence)
	if (turbulence) then
		self.turbulence = turbulence
		self.element:setData("turbulence", turbulence, true)
	end
end


function ParticleEffect3DClassC:setVelocityX(velocityX)
	if (velocityX) then
		self.velocityX = velocityX
		self.element:setData("velocityX", velocityX, true)
	end
end


function ParticleEffect3DClassC:setVelocityY(velocityY)
	if (velocityY) then
		self.velocityY = velocityY
		self.element:setData("velocityY", velocityY, true)
	end
end


function ParticleEffect3DClassC:setVelocityZ(velocityZ)
	if (velocityZ) then
		self.velocityZ = velocityZ
		self.element:setData("velocityZ", velocityZ, true)
	end
end


function ParticleEffect3DClassC:setEffectRotation(rotation)
	if (rotation) then
		self.effectRotation = rotation
		self.element:setData("effectRotation", rotation, true)
	end
end


function ParticleEffect3DClassC:setStartParticleSize(startParticleSize)
	if (startParticleSize) then
		self.startParticleSize = startParticleSize
		self.element:setData("startParticleSize", startParticleSize, true)
	end
end


function ParticleEffect3DClassC:setEndParticleSize(endParticleSize)
	if (endParticleSize) then
		self.endParticleSize = endParticleSize
		self.element:setData("endParticleSize", endParticleSize, true)
	end
end


function ParticleEffect3DClassC:setParticleLifeTime(particleLifeTime)
	if (particleLifeTime) then
		if (particleLifeTime > 50) then
			self.particleLifeTime = particleLifeTime
			self.element:setData("particleLifeTime", particleLifeTime, true)
		end
	end
end


function ParticleEffect3DClassC:setBrightness(effectBrightness)
	if (effectBrightness) then
		self.effectBrightness = effectBrightness
		self.element:setData("effectBrightness", effectBrightness, true)
	end
end


function ParticleEffect3DClassC:setAlpha(effectColorAlpha)
	if (effectColorAlpha) then
		self.effectColorAlpha = effectColorAlpha
		self.element:setData("effectColorAlpha", effectColorAlpha, true)
	end
end


function ParticleEffect3DClassC:setRainBowColor(isRainBowColor)
	if (isRainBowColor) then
		self.isRainBowColor = isRainBowColor
		self.element:setData("isRainBowColor", isRainBowColor, true)
	end
end


function ParticleEffect3DClassC:setColor(effectColorRed, effectColorGreen, effectColorBlue)
	if (effectColorRed) and (effectColorGreen) and (effectColorBlue) then
		self.effectColorRed = effectColorRed
		self.effectColorGreen = effectColorGreen
		self.effectColorBlue = effectColorBlue
		self.element:setData("effectColorRed", effectColorRed, true)
		self.element:setData("effectColorGreen", effectColorGreen, true)
		self.element:setData("effectColorBlue", effectColorBlue, true)
	end
end


function ParticleEffect3DClassC:moveOnXAxis(amount)
	if (amount) then
		self.x = self.x + tonumber(amount)
		self.element:setData("x", self.x, true)
	end
end


function ParticleEffect3DClassC:moveOnYAxis(amount)
	if (amount) then
		self.y = self.y + tonumber(amount)
		self.element:setData("y", self.y, true)
	end
end


function ParticleEffect3DClassC:moveOnZAxis(amount)
	if (amount) then
		self.z = self.z + tonumber(amount)
		self.element:setData("z", self.z, true)
	end
end


function ParticleEffect3DClassC:destroyMe()
	self.parent:deleteParticleEffect(self.id)
end


function ParticleEffect3DClassC:destructor()

	for index, particle in pairs(self.effectParticles) do
		if (particle) then
			delete(particle)
			particle = nil
		end
	end

	mainOutput("ParticleEffect3DClassC " .. self.id  .. " was deleted...")
end