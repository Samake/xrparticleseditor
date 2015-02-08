--[[
	Name: xrParticlesEditor
	Filename: StartupC.lua
	Author: Sam@ke
--]]

local classInstance = nil

StartupC = {}

function StartupC:constructor(parent, duration)
	mainOutput("StartupC was started...")
	
	self.parent = parent
	self.duration = duration
	self.isCompleted = "false"
	self.maxParticles = 64
	self.particles2D = {}
	
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	self.renderTarget = dxCreateRenderTarget(self.screenWidth, self.screenHeight, true)

	self.particleTexture = dxCreateTexture("res/Textures/effects/dirt_A.dds")
	self.logoTexture = dxCreateTexture("res/textures/misc/xrLogo.png")
	self.logoSizeX = self.screenWidth / 3
	self.logoSizeY = self.screenHeight / 3
	
	self.brightness = 0
	self.alpha = 0
	self.blendModifier = 5
	self.animationValue = 1
	
	self.m_StartUpCompleted = function() self:startUpCompleted() end
	
	if (not self.startUpTimer) then
		self.startUpTimer = setTimer(self.m_StartUpCompleted, self.duration, 1)
	end
	
	if (not self.animationClass) then
		self.animationClass = new(AnimateOutBounceC, self.duration / 2)
	end
	
	self.m_Update = function() self:update() end
	addEventHandler("onClientPreRender", root, self.m_Update)
	
	self:createParticles()
	
	if (self.animationClass) then
		self.animationClass:reset()
		self.animationValue = 0
	end
end


function StartupC:createParticles()
	for i = 1, self.maxParticles, 1 do
		if (not self.particles2D[i]) then
			self.particles2D[i] = new(Particle2DClassC, self, i)
		end
	end
end


function StartupC:destroyParticles()
	for i = 1, self.maxParticles, 1 do
		if (self.particles2D[i]) then
			delete(self.particles2D[i])
			self.particles2D[i] = nil
		end
	end
end


function StartupC:destroySingleParticle(id)
	if (id) then
		if (self.particles2D[id]) then
			delete(self.particles2D[id])
			self.particles2D[id] = nil
		end
	end
end


function StartupC:update()
	if (self.renderTarget) and (self.logoTexture) then
		
		if (self.animationClass) then
			self.animationValue = self.animationClass:getFactor()
		end
		
		if (self.isCompleted == "false") then
			self.alpha = self.alpha + self.blendModifier
			
			if (self.alpha > 255) then
				self.alpha = 255
			end
			
			self.brightness = self.brightness + self.blendModifier / 2
			
			if (self.brightness > 255) then
				self.brightness = 255
			end
		elseif (self.isCompleted == "true") then
			self.alpha = self.alpha - self.blendModifier
			
			if (self.alpha < 0) then
				self.alpha = 0
				triggerEvent("startUpCompleted", root)
			end
			
			self.brightness = self.brightness - self.blendModifier / 2
			
			if (self.brightness < 0) then
				self.brightness = 0
			end
		end
		
		dxSetRenderTarget(self.renderTarget, true)
		
		dxDrawRectangle(0, 0, self.screenWidth, self.screenHeight, tocolor(self.brightness, self.brightness, self.brightness, self.alpha))
		
		for i = 1, self.maxParticles, 1 do
			if (self.particles2D[i]) then
				self.particles2D[i]:update()
			end
		end
		
		if (self.renderTarget) then
			dxDrawImage(0, 0, self.screenWidth, self.screenHeight, self.renderTarget, 0, 0, 0, tocolor(255, 255, 255, self.alpha))
		end
		
		dxSetRenderTarget()
		
		if (self.logoTexture) then
			self.sizeX = self.logoSizeX * self.animationValue
			self.sizeY = self.logoSizeY * self.animationValue
			dxDrawImage((self.screenWidth / 2) - (self.sizeX / 2), (self.screenHeight / 2) - (self.sizeY / 2), self.sizeX, self.sizeY, self.logoTexture, 0, 0, 0, tocolor(255, 255, 255, self.alpha))
		end
		
		dxDrawText("*** Beta version. Work still in progress! ***", self.screenWidth / 2, (self.screenHeight / 2) + (self.sizeY / 2), self.screenWidth / 2, (self.screenHeight / 2) + (self.sizeY / 2), tocolor(255, 0, 0, self.alpha), 1.5, "default-bold", "center")
	end
end

function StartupC:startUpCompleted()
	self.isCompleted = "true"
end


function StartupC:destructor()
	
	self:destroyParticles()
	
	if (self.startUpTimer) and (self.startUpTimer:isValid()) then
		self.startUpTimer:destroy()
		self.startUpTimer = nil
	end

	if (self.renderTarget) then
		self.renderTarget:destroy()
		self.renderTarget = nil
	end
	
	if (self.particleTexture) then
		self.particleTexture:destroy()
		self.particleTexture = nil
	end
	
	if (self.logoTexture) then
		self.logoTexture:destroy()
		self.logoTexture = nil
	end
	
	if (self.animationClass) then
		delete(self.animationClass)
		self.animationClass = nil
	end
	
	mainOutput("StartupC was deleted...")
end