local LotteryLayer = class("LotteryLayer", function()
    return display.newColorLayer(cc.c4b(0,0,0,0)) --透明
end)


local SpriteItem = import("app.scenes.SpriteItem")

local RECT_WIDTH = 340
local RECT_HEIGHT = 450

function LotteryLayer:ctor()
    local bgSprite = display.newSprite("Part1.png")
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite,-1)

    local bgSprite = display.newSprite("WindowsFrame.png")
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite,-1)

    self.items = {}



    -- clippingNode 绘制矩形 xy左下角
    local rect = cc.rect(display.cx - RECT_WIDTH/2,
                        display.cy - RECT_HEIGHT/2,
                        RECT_WIDTH,
                        RECT_HEIGHT)
    local clipnode = display.newClippingRegionNode(rect)

    -- clipnode:addChild(display.newSprite("1.png"))
    -- clipnode:addChild(display.newSprite("2.png"))

    self:addChild(clipnode)

    -- node默认锚点(0.5,0.5)
    local baseNode = display.newNode()
    baseNode:setContentSize(RECT_WIDTH,RECT_HEIGHT)
    --baseNode:setPosition(display.cx,display.cy)

    for i=1,4 do
      local item = SpriteItem.new(i)
      item:setContentSize(300, 150)
      item:setPosition(display.cx, display.cy +  150 - 150 * (i-1) )
      --item:setPosition(RECT_WIDTH/2 - 150, RECT_HEIGHT/2 +  150/2 - 150 * (i-1) )
      baseNode:addChild(item)

      self.items[i] = item
    end

    clipnode:addChild(baseNode)


  --   self.listView = cc.ui.UIListView.new({       
  --       bg = "WindowsFrame.png",
  --       viewRect = cc.rect(display.cx - RECT_WIDTH/2, display.cy - RECT_HEIGHT/2, RECT_WIDTH, RECT_HEIGHT), --viewRect.x viewRect.y决定list的position
  --       direction = cc.ui.UIScrollView.DIRECTION_VERTICAL
  --       })
  --       --:onTouch(touchListener)
  --       :addTo(self)

  -- --       local item = self.listView:newItem()
  -- --   	local content = display.newSprite("4.png")
  -- --   	item:addContent(content)
		-- -- item:setItemSize(300, 130)
  -- --   	self.listView:addItem(item)

  --       for i=1,4 do
  --       	item = self.listView:newItem()
  --       	content = display.newSprite(i..".png")
  --       	item:addContent(content)
		-- 	item:setItemSize(300, 150)
  --       	self.listView:addItem(item)
  --       end

  -- --       item = self.listView:newItem()
  -- --   	content = display.newSprite("1.png")
  -- --   	item:addContent(content)
		-- -- item:setItemSize(300, 130)
  -- --   	self.listView:addItem(item)

  --   self.listView:reload()
  --   self.listView:setTouchEnabled(false)

    self:Arrow()
    self:PullBar()

--self:MoveCircle()

end

function LotteryLayer:MoveCircle( count, callback )
    -- body
    --local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

    local length = #self.items
    
    local oneTime = (length - 1) * 0.01

    local i = 0

    local function onInterval()

      if i == count then

        --一次循环结束
        callback()
        return
      end

      print("Custom")

      

      self:Move(oneTime)



      i = i + 1
      oneTime = oneTime + 0.01 * i + 0.005
      self:performWithDelay(onInterval,oneTime)
    end

    self:performWithDelay(onInterval,oneTime)
    

    --scheduler.scheduleGlobal(onInterval, 0.5)
end

function LotteryLayer:Move(oneTime)
  local length = #self.items

  local topY = display.cy +  150
  local bottomY = display.cy +  150 - (length - 1) * 150

  local speed = oneTime / (length - 1)

  for i=1, length do
    print(i)
    local item = self.items[i]

    print(item:getY())
    if topY == item:getY() then -- 移到顶部，顶部的移到最后
      --todo
      --将起始元素移到最后一个元素的位置；
      --将后面的元素依次往上移动一个位置；
      local moveTo = cc.MoveTo:create(speed, cc.p(item:getX(), item:getY() + 150))
      local seq = cc.Sequence:create(moveTo,
        cc.CallFunc:create(function()
          -- body
          item:setPosition(item:getX(), bottomY)
        end)
      )

      item:runAction(seq)

    else
      --todo
      --将最后一个元素移到起始元素的位置；
      --将前面的元素依次往下移动一个位置；
      local moveTo = cc.MoveTo:create(speed,cc.p(item:getX(), item:getY() + 150))

      item:runAction(moveTo)
    end

  end

end


function LotteryLayer:Arrow()
	-- body

	local arrowL = display.newSprite("arrow.png")
    arrowL:setPosition(display.cx - RECT_WIDTH/2 - 20, display.cy)
    arrowL:addTo(self)
    arrowL:setFlippedX(true)

    local arrowR = display.newSprite("arrow.png")
    arrowR:setPosition(display.cx + RECT_WIDTH/2 + 10, display.cy) -- 修正10p
    arrowR:addTo(self)
end


function LotteryLayer:PullBar()
	-- body
	local baseX,baseY = 400,200

    local pullBarBase = display.newSprite("PullBarBase.png")
    pullBarBase:setPosition(baseX,baseY)
    pullBarBase:addTo(self)


    local pullBarPart1 = display.newSprite("PullBarPart1.png")
    pullBarPart1:setPosition(baseX,baseY+50)
    pullBarPart1:addTo(self)

    local pullBarPart2 = display.newSprite("PullBarPart2.png")
    pullBarPart2:setPosition(baseX,baseY+100)
    pullBarPart2:addTo(self)

    pullBarPart2:setTouchEnabled(true)
	  pullBarPart2:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
	 	function ( event )
	 		-- body
	 		pullBarPart2:setTouchEnabled(false)

	 		if(event.name == "ended") then
	            print("xxxxxxx")

				local action = cc.MoveBy:create(0.2, cc.p(0,-100))
				local actionBack = action:reverse()
	            -- local action1 = cc.MoveTo:create(0.1, cc.p(baseX,baseY-50))
	            -- local action1Back = action1:reverse()
	            -- local  seq = cc.Sequence:create(action1, action1Back)

	            local seq = cc.Sequence:create(action, actionBack)
	            pullBarPart2:runAction(seq)


				local action1 = cc.MoveBy:create(0.2, cc.p(0,-80))
				local action1Back = action1:reverse()
	            local seq1 = cc.Sequence:create(action1, action1Back, cc.CallFunc:create(function(sender)
	            	-- body
	            	

                self:MoveCircle(10, function ()
                  -- body
                  -- 抽奖没结束不能再次摇奖
                  pullBarPart2:setTouchEnabled(true)
                end)
                
	            end)
	            )

	            pullBarPart1:runAction(seq1)
	        else
	            return true
	        end
	 	end)
end


return LotteryLayer
