import "lander"
import "terrain"
import "hud"
import "CoreLibs/ui"


local gfx <const> = playdate.graphics
local terrainInstance = nil
local hudInstance = nil
local landerInstance = nil

local function loadGame(GameEvents)
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	gfx.setFont(font)
	gfx.setBackgroundColor(gfx.kColorBlack)
	playdate.ui.crankIndicator:start()
	
	-- Sprites
	terrainInstance = terrain(200, 235, 1, 10, -10, 10, 40)
	hudInstance = hud(3)
	landerInstance = lander(40, terrainInstance.terrain.gon, GameEvents)
end

local function updateGame()
	landerInstance:update()
end

local function drawGame()
	gfx.clear() -- Clears the screen
	landerInstance:draw()
	terrainInstance:draw()
	hudInstance:draw()

	if playdate.isCrankDocked() then
		playdate.ui.crankIndicator:update()
	end
end


function playdate.update()
	playdate.timer.updateTimers() 
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end

local GameEvents = {
	addScore = function()
		hudInstance:addScore()
	end,
	
	removeLife = function()
		hudInstance:removeLife()
	end,

	regenLevel = function()
		return terrainInstance:regenLevel()
	end,
}

loadGame(GameEvents)