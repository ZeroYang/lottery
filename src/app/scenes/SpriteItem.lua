--
-- Author: ZeroYang
-- Date: 2015-01-29 11:20:05
--
local SpriteItem = class("SpriteItem", function(index)
    local item = display.newSprite(index .. ".png")
    item.index = index
    return item
end)

function SpriteItem:ctor()

end

function SpriteItem:getX()
	return self:getPositionX()
end

function SpriteItem:getY()
	return self:getPositionY()
end

function SpriteItem:getHeigth()
	local size = self:getContentSize()
	return size.height
end

return SpriteItem