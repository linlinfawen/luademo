ed = {}

function newclass(superclass)
  local class = {
    mt = {}
  }
  class.mt.__index = class
  if superclass then
    if type(superclass) == "table" then
      setmetatable(class, superclass)
    elseif type(superclass) == "string" and superclass == "g" then
      setmetatable(class, {__index = _G})
    end
    -- if type(superclass) == "table" then
    --   setmetatable(class, superclass)
    -- elseif type(superclass) == "string" and superclass == "g" then
    --   setmetatable(class, {__index = _G})
    -- end
  end
  return class
end

local class = newclass()
ed.dialog = class
print("---------class-----------")
print(ed.dialog)
for k,v in pairs(ed.dialog) do
  print(k,v)
end

local function create()
  local self = {}
  setmetatable(self, class.mt)
  -- local layer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.layer = {"layer"}
  -- self.layer:setTouchEnabled(true)
  -- local bg = ed.createSprite("UI/alpha/HVGA/dialog_bg.png")
  -- bg:setPosition(ccp(400, 240))
  self.bg = {"bg"}
  -- self.layer:addChild(bg)
  -- bg:setScale(0)
  -- local action = CCScaleTo:create(0.2, 1)
  -- action = CCEaseBackOut:create(action)
  -- bg:runAction(action)
  -- local line = ed.createSprite("UI/alpha/HVGA/dialog_line.png")
  -- line:setPosition(ccp(172, 75))
  -- self.line = line
  -- bg:addChild(line)
  -- ed.playEffect(ed.sound.dialog.openWindow)
  return self
end


class.create = create
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.dialog
ed.alertDialog = class
setmetatable(class, base.mt)
local doMainLayerTouch = function(self)
     print("doMainLayerTouch") 
end
class.doMainLayerTouch = doMainLayerTouch


local function create(info)
  local self = base.create()
  setmetatable(self, class.mt)
  -- self.handler = info.handler
  -- self.layer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -800, true)
  -- local button = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade.png", CCRectMake(20, 22, 40, 23))
  -- self.button = button
  -- button:setContentSize(CCSizeMake(250, 49))
  -- button:setPosition(ccp(172, 44))
  -- self.bg:addChild(button)
  -- local buttonPress = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade-mask.png", CCRectMake(20, 22, 40, 23))
  -- self.buttonPress = buttonPress
  -- buttonPress:setContentSize(CCSizeMake(250, 49))
  -- buttonPress:setVisible(false)
  -- buttonPress:setAnchorPoint(ccp(0, 0))
  -- buttonPress:setPosition(ccp(0, 0))
  -- button:addChild(buttonPress)
  -- local buttonText = info.buttonText or T(LSTR("FASTSELL.GOOD"))
  -- local buttonLabel = ed.createttf(buttonText, 20, "arial_unicode_ms.ttf")
  -- ed.setLabelColor(buttonLabel, normalColor)
  -- ed.setLabelShadow(buttonLabel, ccc3(63, 5, 0), ccp(1, 2))

  -- buttonLabel:setPosition(ccp(125, 24))
  -- self.buttonLabel = buttonLabel
  -- button:addChild(buttonLabel, 1)
  return self
end
class.create = create

print("---------newDialog-----------")
local newDialog =  ed.dialog.create()

for k,v in pairs(newDialog) do
  print(k,v)
end

print(newDialog.doMainLayerTouch)


