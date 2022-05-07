import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/animation"

local gfx <const> = playdate.graphics

class("terrain").extends()

local PlatformImageTable = gfx.imagetable.new("images/Platform.gif")
local PlatformAnimation = playdate.graphics.animation.loop.new(100, PlatformImageTable)
local PlatformSprite = playdate.graphics.sprite.new(PlatformAnimation:image())

PlatformSprite:setCollideRect( 0, 0, PlatformSprite:getSize() )
PlatformSprite:setTag(2)
PlatformSprite:add()


function terrain:init(startHeight, minHeight, minVarX, maxVarX, minVarY, maxVarY, platformWidth)
    local x,y = 0, startHeight
    local points = {}
    local platformStart = math.random(5, 395-platformWidth)
    local platformPnt = nil

    table.insert(
        points, playdate.geometry.point.new(0, 240)
    )

    while x < 400+maxVarX do
        table.insert(
            points, playdate.geometry.point.new(x, y)
        )
        if platformStart <= x and x <= (platformStart + platformWidth) then
            x = x + platformWidth
            table.insert(
                points, playdate.geometry.point.new(x, y)
            )
            platformPnt = {x=x, y=y}
        end
        x = x + math.random(minVarX, maxVarX)
        y = y + math.random(minVarY, maxVarY)
        if y > minHeight then
            y = math.random(minHeight+minVarY, minHeight)
        end
    end

    table.insert(
        points, playdate.geometry.point.new(400, 240)
    )

    local gon = playdate.geometry.polygon.new(table.unpack(points))
    gon:close()
    
    PlatformSprite:moveTo(platformPnt.x-platformWidth/2, platformPnt.y-5)

    self.terrain = {
        gon = gon,
        platformPnt = platformPnt,
        parameters = {startHeight, minHeight, minVarX, maxVarX, minVarY, maxVarY, platformWidth}
    }
end

function terrain:draw()
    local terrain = self.terrain
    PlatformSprite:setImage(PlatformAnimation:image())
    PlatformSprite:update()
    playdate.graphics.setColor(gfx.kColorWhite)
    playdate.graphics.fillPolygon(terrain.gon)
end

function terrain:regenLevel()
    self.init(self, table.unpack(self.terrain.parameters))
    return self.terrain.gon
end