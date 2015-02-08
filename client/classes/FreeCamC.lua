--[[
	Name: xrParticlesEditor
	Filename: FreeCamC.lua
	Authors: eAi, QA Team, Sam@ke
--]]

local classInstance = nil

FreeCamC = {}

function FreeCamC:constructor(parent)

	self.parent = parent
	self.screenWidth, self.screenHeight = guiGetScreenSize()
	
	self.speed = 0
	self.strafeSpeed = 0
	self.rotX = 0
	self.rotY = 0
	self.velocityX = 0
	self.velocityY = 0
	self.velocityZ = 0
	self.isEnabled = "true"
	
	self.invertMouseLook = "false"
	self.normalMaxSpeed = 0.8
	self.slowMaxSpeed = 0.08
	self.fastMaxSpeed = 25
	self.acceleration = 0.1
	self.decceleration = 0.2
	self.mouseSensitivity = 0.1
	self.maxYAngle = 120
	self.PI = math.pi
	
	self.mouseFrameDelay = 0
	self.camPosX, self.camPosY, self.camPosZ = getCameraMatrix()
	
	self.m_onClientCursorMove = function(...) self:onClientCursorMove(...) end
	addEventHandler("onClientCursorMove", root, self.m_onClientCursorMove)
	
	self.m_Update = function() self:update() end
	addEventHandler("onClientRender", root, self.m_Update)
	
	mainOutput("FreeCamC was started...")
end


function FreeCamC:update()
	if (not isMTAWindowActive()) and (self.parent) and (self.isEnabled == "true") then
		setCameraClip(true, false)
		
		self.cameraAngleX = self.rotX
		self.cameraAngleY = self.rotY

		self.freeModeAngleZ = math.sin(self.cameraAngleY)
		self.freeModeAngleY = math.cos(self.cameraAngleY) * math.cos(self.cameraAngleX)
		self.freeModeAngleX = math.cos(self.cameraAngleY) * math.sin(self.cameraAngleX)

		self.camTargetX = self.camPosX + self.freeModeAngleX * 100
		self.camTargetY = self.camPosY + self.freeModeAngleY * 100
		self.camTargetZ = self.camPosZ + self.freeModeAngleZ * 100
		
		self.maxSpeed = self.normalMaxSpeed
		
		if (getKeyState(self.parent.keyFastMove) == true) then
			self.maxSpeed = self.fastMaxSpeed
		elseif (getKeyState(self.parent.keySlowMove) == true) then
			self.maxSpeed = self.slowMaxSpeed
		end
		
		self.speedKeyPressed = false
		if (getKeyState(self.parent.keyForward ) == true) then
			self.speed = self.speed + self.acceleration 
			self.speedKeyPressed = true
		end
		
		if (getKeyState(self.parent.keyBackward) == true) then
			self.speed = self.speed - self.acceleration 
			self.speedKeyPressed = true
		end

		self.strafeSpeedKeyPressed = "false"
		
		if (getKeyState(self.parent.keyLeft) == true) then
			if (self.strafeSpeed < 0) then
				self.strafeSpeed = 0
			end
			self.strafeSpeed = self.strafeSpeed + self.acceleration / 2
			self.strafeSpeedKeyPressed = "true"
		end
		
		if (getKeyState(self.parent.keyRight) == true) then
			if self.strafeSpeed > 0 then
				self.strafeSpeed = 0
			end
			self.strafeSpeed = self.strafeSpeed - self.acceleration / 2
			self.strafeSpeedKeyPressed = "true"
		end

		if (self.speedKeyPressed ~= true) then
			if (self.speed > 0) then
				self.speed = self.speed - self.decceleration
			elseif (self.speed < 0) then
				self.speed = self.speed + self.decceleration
			end
		end

		if (self.strafeSpeedKeyPressed == "false") then
			if (self.strafeSpeed > 0) then
				self.strafeSpeed = self.strafeSpeed - self.decceleration
			elseif (self.strafeSpeed < 0) then
				self.strafeSpeed = self.strafeSpeed + self.decceleration
			end
		end

		if (self.speed > -self.acceleration / 2) and (self.speed < self.acceleration / 2) then
			self.speed = 0
		elseif (self.speed > self.maxSpeed) then
			self.speed = self.maxSpeed
		elseif (self.speed < -self.maxSpeed) then
			self.speed = -self.maxSpeed
		end
	 
		if (self.strafeSpeed > -self.acceleration / 2) and (self.strafeSpeed < self.acceleration / 2) then
			self.strafeSpeed = 0
		elseif (self.strafeSpeed > self.maxSpeed) then
			self.strafeSpeed = self.maxSpeed
		elseif (self.strafeSpeed < -self.maxSpeed) then
			self.strafeSpeed = -self.maxSpeed
		end
		
		if (getKeyState(self.parent.keyForward) ~= true) and (getKeyState(self.parent.keyBackward) ~= true) and (getKeyState(self.parent.keyLeft) ~= true) and (getKeyState(self.parent.keyRight) ~= true) then
			self.speed = 0
			self.strafeSpeed = 0
		end
		
		self.camAngleX = self.camPosX - self.camTargetX
		self.camAngleY = self.camPosY - self.camTargetY
		self.camAngleZ = 0

		self.angleLength = math.sqrt(self.camAngleX * self.camAngleX + self.camAngleY * self.camAngleY + self.camAngleZ * self.camAngleZ)

		self.camNormalizedAngleX = self.camAngleX / self.angleLength
		self.camNormalizedAngleY = self.camAngleY / self.angleLength
		self.camNormalizedAngleZ = 0

		self.normalAngleX = 0
		self.normalAngleY = 0
		self.normalAngleZ = 1

		self.normalX = (self.camNormalizedAngleY * self.normalAngleZ - self.camNormalizedAngleZ * self.normalAngleY)
		self.normalY = (self.camNormalizedAngleZ * self.normalAngleX - self.camNormalizedAngleX * self.normalAngleZ)
		self.normalZ = (self.camNormalizedAngleX * self.normalAngleY - self.camNormalizedAngleY * self.normalAngleX)

		self.camPosX = self.camPosX + self.freeModeAngleX * self.speed
		self.camPosY = self.camPosY + self.freeModeAngleY * self.speed
		self.camPosZ = self.camPosZ + self.freeModeAngleZ * self.speed
		
		self.camPosX = self.camPosX + self.normalX * self.strafeSpeed
		self.camPosY = self.camPosY + self.normalY * self.strafeSpeed
		self.camPosZ = self.camPosZ + self.normalZ * self.strafeSpeed
		
		self.velocityX = (self.freeModeAngleX * self.speed) + (self.normalX * self.strafeSpeed)
		self.velocityY = (self.freeModeAngleY * self.speed) + (self.normalY * self.strafeSpeed)
		self.velocityZ = (self.freeModeAngleZ * self.speed) + (self.normalZ * self.strafeSpeed)

		setCameraMatrix(self.camPosX, self.camPosY, self.camPosZ, self.camTargetX, self.camTargetY, self.camTargetZ)
	end
end


function FreeCamC:onClientCursorMove(cX, cY, aX, aY)

	if (isCursorShowing()) or (isMTAWindowActive()) then
		self.mouseFrameDelay = 5
		return
	elseif self.mouseFrameDelay > 0 then
		self.mouseFrameDelay = self.mouseFrameDelay - 1
		return
	end
	
    aX = aX - self.screenWidth / 2 
    aY = aY - self.screenHeight / 2
	
	if (self.invertMouseLook == "true") then
		aY = -aY
	end
	
	self.rotX = self.rotX + aX * self.mouseSensitivity * 0.01745
    self.rotY = self.rotY - aY * self.mouseSensitivity * 0.01745
	
	if (self.rotX > self.PI) then
		self.rotX = self.rotX - 2 * self.PI
	elseif (self.rotX < -self.PI) then
		self.rotX = self.rotX + 2 * self.PI
	end
	
	if (self.rotY > self.PI) then
		self.rotY = self.rotY - 2 * self.PI
	elseif (self.rotY < -self.PI) then
		self.rotY = self.rotY + 2 * self.PI
	end

    if (self.rotY < -self.PI / 2.05) then
       self.rotY = -self.PI / 2.05
    elseif (self.rotY > self.PI / 2.05) then
        self.rotY = self.PI / 2.05
    end
end


function FreeCamC:destructor()
	removeEventHandler("onClientCursorMove", root, self.m_onClientCursorMove)
	removeEventHandler("onClientRender", root, self.m_Update)

	mainOutput("FreeCamC was stopped...")
end