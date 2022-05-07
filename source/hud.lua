import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

class("hud").extends()

function hud:init(lives)
    self.hud = {
        lives = lives,
        score = 0
    }
end

function hud:addScore()
    print("addScore")
    self.hud.score = self.hud.score + 1
end

function hud:removeLife()
    print("removing life")
    self.hud.lives = self.hud.lives - 1
end

function hud:draw()
    playdate.graphics.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
    playdate.graphics.drawText(
        "Score: "..self.hud.score,
        5, 15
    )
    playdate.graphics.drawText(
        "Lives: "..self.hud.lives,
        5, 35
    )
    
end