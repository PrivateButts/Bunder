import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

Gravity = .01
ThrustStrength = .1
Thrusting = false

local gfx <const> = playdate.graphics

class("lander").extends()

function lander:init(y, terrainPolygon, EventsHandler)
	local startX = math.random(50, 350)
    self.lander = {
		initY = y,
		x = startX,
		y = y,
		xspeed = 0,
		yspeed = 0,
		thrusting = false,
		terrainPolygon = terrainPolygon,
		boundPoints = {
			{-15, 15},
			{15, 15},
			{-6, -14},
			{6, -14}
		},
	}
	self.eventsHandler = EventsHandler
end

local LanderImage = gfx.image.new("images/Lander.png")
local LanderSprite = playdate.graphics.sprite.new(LanderImage)
LanderSprite:setCollideRect( 0, 0, LanderSprite:getSize() )
LanderSprite:add()
LanderSprite:moveTo(155, 40)

function checkOutOfBounds(lander)
	return lander.x < -50 or lander.x > 450 or lander.y < -50 or lander.y > 290
end

function checkTerrainCollision(lander)
	local terrainPolygon = lander.terrainPolygon
	for i, point in ipairs(lander.boundPoints) do
		local x,y = lander.x + point[1], lander.y + point[2]
		if terrainPolygon:containsPoint(x,y) then
			return true
		end
	end

	return false
end

function lander:update()
	local lander = self.lander
	local crankAngle = playdate.getCrankPosition()

	if (checkTerrainCollision(lander) or checkOutOfBounds(lander)) then
		self.die(self)
	end

	-- Apply Rotation
	LanderSprite:setRotation(crankAngle)

	-- Apply Thrust
	if (Thrusting) then
		-- Decompose the thrust vector into x and y components
		local thrustX = math.cos(math.rad(crankAngle-90)) * ThrustStrength
		local thrustY = math.sin(math.rad(crankAngle-90)) * ThrustStrength

		-- Apply the thrust vector
		lander.xspeed = lander.xspeed + thrustX
		lander.yspeed = lander.yspeed + thrustY
	end

	-- Apply Gravity
	lander.yspeed = lander.yspeed + Gravity

	-- Apply Speeds
	lander.x = lander.x + lander.xspeed
	lander.y = lander.y + lander.yspeed
end

function lander:draw()
    local lander = self.lander;
	lander.x, lander.y, collisions, colAmt = LanderSprite:moveWithCollisions(lander.x, lander.y)
	if (colAmt>0) then
		lander.xspeed = 0
		lander.yspeed = 0

		if collisions[1].other:getTag() == 2 then
			print("Collision with platform")
			self.win(self)
		end
	end
	LanderSprite:update()
end

function lander:die()
	self.eventsHandler.removeLife()
	self.reset(self)
end

function lander:win()
	self.eventsHandler.addScore()
	self.lander.terrainPolygon = self.eventsHandler.regenLevel()
	self.reset(self)
end

function lander:reset()
	self.init(self, self.lander.initY, self.lander.terrainPolygon, self.eventsHandler)
end

local inputHandler = {
	upButtonDown = function ()
		Thrusting = true
	end,

	upButtonUp = function ()
		Thrusting = false
	end,
}

playdate.inputHandlers.push(inputHandler)