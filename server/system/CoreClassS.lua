--[[
	Name: xrParticlesEditor
	Filename: CoreClassS.lua
	Author: Sam@ke
--]]

local classInstance = nil

CoreClassS = {}

function CoreClassS:constructor()
	mainOutput("SERVER: xrParticleEditor was started.")
	
	setFPSLimit(50)
	self.updateIntervall = 250
	
	if (not self.elementManager) then
		self.elementManager = new(ElementManagerS, self)
	end
	
	if (not self.resourceManager) then
		self.resourceManager = new(ResourceManagerS, self)
	end
	
	self.m_Update = function() self:update() end
	
	if (not self.updateTimer) then
		self.updateTimer = setTimer(self.m_Update, self.updateIntervall, 0)
	end
	
	self.m_IsEditorAllowedForClient = function(...) self:isEditorAllowedForClient(...) end
	addEvent("isEditorAllowedForClient", true)
	addEventHandler("isEditorAllowedForClient", root, self.m_IsEditorAllowedForClient)
	
	mainOutput("CoreClassS was started...")
end


function CoreClassS:isEditorAllowedForClient(player)
	if (get("editorNeedACLPermission")) then
		if (get("editorNeedACLPermission") == "true") then
			if (player) and (isElement(player)) then
				local accName = getAccountName(getPlayerAccount(player))
				
				if (isObjectInACLGroup("user." .. accName, aclGetGroup("Admin"))) then
					triggerClientEvent(player, "allowEditorForClient", player, true)
					return nil
				else
					triggerClientEvent(player, "allowEditorForClient", player, false)
					return nil
				end
			end
		end
	end

	triggerClientEvent(player, "allowEditorForClient", player, true)
end


function CoreClassS:update()
	if (self.elementManager) then
		self.elementManager:update()
	end
	
	if (self.resourceManager) then
		self.resourceManager:update()
	end
end


function CoreClassS:destructor()
	removeEventHandler("isEditorAllowedForClient", root, self.m_IsEditorAllowedForClient)

	if (self.elementManager) then
		delete(self.elementManager)
		self.elementManager = nil
	end

	if (self.resourceManager) then
		delete(self.resourceManager)
		self.resourceManager = nil
	end
	
	if (self.updateTimer) and (self.updateTimer:isValid()) then
		self.updateTimer:destroy()
		self.updateTimer = nil
	end

	mainOutput("CoreClassS was stopped...")
	mainOutput("SERVER: xrParticleEditor was stopped.")
end


addEventHandler("onResourceStart", resourceRoot, 
function()
	classInstance = new(CoreClassS)
end)


addEventHandler("onResourceStop", resourceRoot, 
function()
	if (classInstance) then
		delete(classInstance)
		classInstance = nil
	end
end)