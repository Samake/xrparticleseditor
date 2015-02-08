--[[
	Name: xrParticlesEditor
	Filename: AnimateOutBounceC.lua
	Author: Sam@ke, Krischkros, Jusonex
--]]

AnimateOutBounceC = {}

function AnimateOutBounceC:constructor(time)	
	
	self.easingTable = {}
	self.easingTime = not time and 0.5 or time
	self.easingTable.startTime = getTickCount()
	self.easingTable.endTime = self.easingTable.startTime + self.easingTime
	self.easingTable.easingFunction = "OutBounce"
	self.easingValue = 0
	
	self.m_Update = function() self:update() end
	addEventHandler("onClientPreRender", root, self.m_Update)
end

function AnimateOutBounceC:update()
	if (self.easingTable) and (self.easingValue < 1) then
		self.now = getTickCount()
		self.elapsedTime = self.now - self.easingTable.startTime
		self.duration = self.easingTable.endTime - self.easingTable.startTime
		self.progress = self.elapsedTime / self.duration
		self.easingValue = getEasingValue(self.progress, self.easingTable.easingFunction, 0.5, 1, 1.7)
	end
end


function AnimateOutBounceC:reset()
	self.easingTable.startTime = getTickCount()
	self.easingTable.endTime = self.easingTable.startTime + self.easingTime
	self.easingValue = 0
end

function AnimateOutBounceC:getFactor()
	return self.easingValue
end

function AnimateOutBounceC:destructor()
	removeEventHandler("onClientPreRender", root, self.m_Update)
end