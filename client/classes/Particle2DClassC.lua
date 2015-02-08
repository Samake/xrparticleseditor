--[[
	Name: xrParticlesEditor
	Filename: Particle2DClassC.lua
	Author: Sam@ke
--]]

local classInstance = nil

Particle2DClassC = {}

function Particle2DClassC:constructor(parent, id)

	self.parent = parent
	self.id = id
	
	if (self.parent) then	
		self.size = math.random(self.parent.screenHeight, self.parent.screenHeight * 3)
		self.x = math.random(0 - self.size/2, self.parent.screenWidth + self.size/2)
		self.y = math.random(0 - self.size/2, self.parent.screenHeight + self.size/2)
		
		self.moveSpeedVar = math.random(20, 70) / 100
		self.moveXDirection = math.random(1, 2)
		self.moveYDirection = math.random(1, 2)
		
		self.rotation = math.random(0, 360)
		self.rotSpeed = math.random(10, 50) / 100
		self.rotDirection = math.random(1, 2)
	else
		self:destroyMe()
	end
	
	-- mainOutput("Particle2DClassC " .. self.id .. " was started.")
end


function Particle2DClassC:update()
	if (self.parent) then
		if (self.parent.renderTarget) then
			if (self.rotDirection == 1) then
				self.rotation = self.rotation + self.rotSpeed
				
				if (self.rotation > 360) then
					self.rotation = 0
				end
			elseif (self.rotDirection == 2) then
				self.rotation = self.rotation - self.rotSpeed
				
				if (self.rotation < 0) then
					self.rotation = 360
				end
			end
			
			if (self.moveXDirection == 1) then
				self.x = self.x + self.moveSpeedVar
				
				if (self.x > self.parent.screenWidth) then
					self.x = 0 - self.size
				end
				
			elseif (self.moveXDirection == 2) then
				self.x = self.x - self.moveSpeedVar
				
				if (self.x < 0 - self.size) then
					self.x = self.parent.screenWidth + self.size
				end
			end
			
			if (self.moveYDirection == 1) then
				self.y = self.y + self.moveSpeedVar
				
				if (self.y > self.parent.screenHeight) then
					self.y = 0 - self.size
				end
				
			elseif (self.moveYDirection == 2) then
				self.y = self.y - self.moveSpeedVar
				
				if (self.y < 0 - self.size) then
					self.y = self.parent.screenHeight + self.size
				end
			end
			
			
			dxSetRenderTarget(self.parent.renderTarget, false)
			dxSetBlendMode("modulate_add")

			dxDrawImage(self.x, self.y, self.size, self.size, self.parent.particleTexture, self.rotation, 0, 0, tocolor(0, 0, 0, 55))
			
			dxSetBlendMode("blend") 
			dxSetRenderTarget()
		end
	end
end


function Particle2DClassC:destroyMe()
	if (self.parent) then
		self.parent:destroySingleParticle(self.id)
	end
end


function Particle2DClassC:destructor()
	
	--mainOutput("Particle2DClassC " .. self.id .. " was stopped.")
end