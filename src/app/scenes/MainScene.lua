
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)



function MainScene:ctor()
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)

    local layer=display.newColorLayer(cc.c4b(255,255,255,255))
    self.layer = layer
    self:addChild(self.layer, -1)

    local lottery = import("app.scenes.LotteryLayer").new()

    lottery:addTo(self)

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
