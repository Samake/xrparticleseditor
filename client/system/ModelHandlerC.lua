--[[
	Name: xrParticlesEditor
	Filename: ModelHandlerC.lua
	Author: Sam@ke
--]]

local classInstance = nil

ModelHandlerC = {}

function ModelHandlerC:constructor()
	
	self.fogParticle1ID = 3579

	self.particlesTexture = engineLoadTXD("res/models/particles.txd")
	self.fog1ObjectModel = engineLoadDFF("res/models/fog1Particle.dff", self.fogParticle1ID)
	self.fog1ObjectCol = engineLoadCOL("res/models/fog1Particle.col")
		
	engineImportTXD(self.particlesTexture, self.fogParticle1ID)
	engineReplaceModel(self.fog1ObjectModel, self.fogParticle1ID)
	engineReplaceCOL(self.fog1ObjectCol, self.fogParticle1ID)
	
	mainOutput("ModelHandlerC was started...")
end


function ModelHandlerC:destructor()

	mainOutput("ModelHandlerC was stopped...")
end