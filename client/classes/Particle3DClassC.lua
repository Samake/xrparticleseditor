--[[
	Name: xrParticlesEditor
	Filename: Particle3DClassC.lua
	Author: Sam@ke
--]]

local classInstance = nil

Particle3DClassC = {}

function Particle3DClassC:constructor(parent, id)

	self.parent = parent
	self.id = id
	self.player = getLocalPlayer()
	
	if (self.parent) then
	
		self.m_DestroyMe = function() self:destroyMe() end
		
		self.randomizer = math.random(50, 100) / 100
		self.randomVar1 = math.random(1, 2)
		self.randomVar2 = math.random(1, 2)
		self.randomModifier = math.random(25, 45)
		self.x = self.parent.x
		self.y = self.parent.y
		self.z = self.parent.z
		self.size = self.parent.startParticleSize
		self.startSize = self.parent.startParticleSize
		self.endSize = self.parent.endParticleSize
		self.radius = 0
		self.turbolence = 0
		self.effectRotationValue = 0
		self.effectRotation = 0
		
		if (self.parent.radius > 0) then
			self.radius = (math.random(1, 100) / 100)
			self.x, self.y, self.z = getAttachedPosition(self.parent.x, self.parent.y, self.parent.z, 0, 0, 0, self.radius * self.parent.radius, math.random(0, 360), 0)
		end
		
		if (self.parent.turbulence > 0) then
			self.turbolence = (math.random(1, 50) / 50)
		end
		
		if (self.parent.effectRotation > 0) then
			self.effectRotationValue = (math.random(1, 50) / 50)
		end
		
		self.colorRed, self.colorGreen, self.colorBlue = self.parent.effectColorRed, self.parent.effectColorGreen, self.parent.effectColorBlue
		self.rainbowRed, self.rainbowGreen, self.rainbowBlue = math.random(50, 255), math.random(50, 255), math.random(50, 255)
		self.alphaModifier = 1
	
	else
		self:destroyMe()
	end
	
	if (not self.lifeTimer) and (self.parent.particleLifeTime <= 35000) then
		self.lifeTimer = setTimer(self.m_DestroyMe, self.parent.particleLifeTime, 0)
		self.parent.activeParticles = self.parent.activeParticles + 1
	end
	
	--mainOutput("Particle3DClassC " .. self.id  .. " was started...")
end


function Particle3DClassC:update()
	if (self.parent) then
		if (self.x) and (self.y) and (self.z) and (self.parent) then
			
			if (self.randomVar1 == 1) and (self.randomVar2 == 1) then
				self.x = self.x + ((self.parent.velocityX + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
				self.y = self.y + ((self.parent.velocityY + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
				self.z = self.z + ((self.parent.velocityZ + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
			elseif (self.randomVar1 == 1) and (self.randomVar2 == 2) then
				self.x = self.x - ((self.parent.velocityX + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
				self.y = self.y - ((self.parent.velocityY + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
				self.z = self.z + ((self.parent.velocityZ + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
			elseif (self.randomVar1 == 2) and (self.randomVar2 == 1) then
				self.x = self.x + ((self.parent.velocityX + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
				self.y = self.y - ((self.parent.velocityY + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
				self.z = self.z + ((self.parent.velocityZ + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
			elseif (self.randomVar1 == 2) and (self.randomVar2 == 2) then
				self.x = self.x - ((self.parent.velocityX + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
				self.y = self.y + ((self.parent.velocityY + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
				self.z = self.z + ((self.parent.velocityZ + self.turbolence * self.parent.turbulence) / self.randomModifier) * (math.random(75, 100) / 100)
			end
			
			if (self.parent.effectRotation > 0) then
				self.effectRotation = self.effectRotation + self.effectRotationValue * self.parent.effectRotation
				
				if (self.effectRotation > 360) then
					self.effectRotation = 0
				end
										 
				self.x, self.y, self.z = getAttachedPosition(self.parent.x, self.parent.y, self.z, 0, 0, 0, self.radius * self.parent.radius, self.effectRotation, 0)
			end
			
			self.startSize = self.parent.startParticleSize * self.randomizer + 0.05
			self.endSize = self.parent.endParticleSize * self.randomizer + 0.05
			
			if (self.startSize < self.endSize) then
				self.sizeModifier = self.endSize / (self.parent.particleLifeTime / 50)
				self.size = self.size + self.sizeModifier
				
				if (self.size >= self.endSize) then
					self.size = self.endSize
				end
			elseif (self.startSize > self.endSize) then
				self.sizeModifier = self.startSize / (self.parent.particleLifeTime / 50)
				self.size = self.size - self.sizeModifier
				
				if (self.size <= self.endSize) then
					self.size = self.endSize
				end
			end
			
			if (self.lifeTimer) and (self.lifeTimer:isValid())then
				if (self.lifeTimer:getDetails() < self.parent.particleLifeTime / 2) then
					self.alphaModifier = self.alphaModifier - 0.01
					
					if (self.alphaModifier <= 0) then
						self.alphaModifier = 0
					end
				end
			else
				if (self.parent.particleLifeTime <= 35000) then
					self.lifeTimer = setTimer(self.m_DestroyMe, self.parent.particleLifeTime, 0)
				end
			end
			
			self.colorRed, self.colorGreen, self.colorBlue = self.parent.effectColorRed, self.parent.effectColorGreen, self.parent.effectColorBlue
			
			if (self.parent.isRainBowColor == "true") then
				self.color = tocolor(self.rainbowRed * self.parent.effectBrightness, self.rainbowGreen * self.parent.effectBrightness, self.rainbowBlue * self.parent.effectBrightness, self.parent.effectColorAlpha * self.alphaModifier)
			else
				self.color = tocolor(self.colorRed * self.parent.effectBrightness, self.colorGreen * self.parent.effectBrightness, self.colorBlue * self.parent.effectBrightness, self.parent.effectColorAlpha * self.alphaModifier)
			end

			self.camX, self.camY, self.camZ = getCameraMatrix()
			local x1, y1, z1, x2, y2, z2 = self.x + (self.size / 2), self.y, self.z + (self.size / 2), self.x - (self.size / 2), self.y, self.z - (self.size / 2)
			
			dxDrawMaterialLine3D(x1, y1, z1, x2, y2, z2, self.parent.particleTexture, self.size, self.color, self.camX + 1, self.camY, self.camZ + 1)
			
			local distance = getDistanceBetweenPoints3D(self.x, self.y, self.z, self.parent.x, self.parent.y, self.parent.z)
			
			if (distance > self.parent.viewDistance / 4) then
				self:destroyMe()
			end
		end
	end
end


function Particle3DClassC:destroyMe()
	if (self.activationTimer) and (self.activationTimer:isValid()) then
		self.activationTimer:destroy()
		self.activationTimer = nil
	end
	
	if (self.lifeTimer) and (self.lifeTimer:isValid()) then
		self.lifeTimer:destroy()
		self.lifeTimer = nil
	end
	
	self.isActive = "false"
	self.parent:deleteParticle(self.id)
	self.parent.activeParticles = self.parent.activeParticles - 1
	
	--mainOutput("Particle " .. self.id  .. " is dead.")
end


function Particle3DClassC:getPosition()
	return {x = self.x, y = self.y, z = self.z}
end


function Particle3DClassC:destructor()
	
	--mainOutput("Particle3DClassC " .. self.id  .. " was stopped...")
end