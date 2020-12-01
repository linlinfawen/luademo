--  ed = {} 

-- function newclass(superclass)
--   local class = {
--     mt = {}
--   }
--   if superclass then
--     if type(superclass) == "table" then
--       setmetatable(class, superclass)
--     elseif type(superclass) == "string" and superclass == "g" then
--       setmetatable(class, {__index = _G})
--     end

--   end
--   return class
-- end

-- local class = newclass()
-- ed.dialog = class
-- print("---------class-----------")
-- print("ed.dialog == ",ed.dialog)

-- for k,v in pairs(ed.dialog) do
--   print(k,v)
-- end


-- class.mt.__index = class
-- setmetatable(class, base.mt)

-- local function create()
--   local self = {}
--   setmetatable(self, class.mt)
--   -- local layer = CCLayerColor:create(ccc4(0, 0, 0, 150))
--   self.layer = {"layer"}
--   -- self.layer:setTouchEnabled(true)
--   -- local bg = ed.createSprite("UI/alpha/HVGA/dialog_bg.png")
--   -- bg:setPosition(ccp(400, 240))
--   self.bg = {"bg"}
--   -- self.layer:addChild(bg)
--   -- bg:setScale(0)
--   -- local action = CCScaleTo:create(0.2, 1)
--   -- action = CCEaseBackOut:create(action)
--   -- bg:runAction(action)
--   -- local line = ed.createSprite("UI/alpha/HVGA/dialog_line.png")
--   -- line:setPosition(ccp(172, 75))
--   -- self.line = line
--   -- bg:addChild(line)
--   -- ed.playEffect(ed.sound.dialog.openWindow)
--   return self
-- end


-- class.create = create
-- -- local class = {
-- --   mt = {}
-- -- }
-- local base = ed.dialog
-- ed.alertDialog = class
-- setmetatable(class, base.mt)
-- local doMainLayerTouch = function(self)
--   print("self == ",self)
--      print("doMainLayerTouch") 
-- end
-- class.doMainLayerTouch = doMainLayerTouch


-- -- local function create(info)
-- --   local self = base.create()
-- --   setmetatable(self, class.mt)
-- --   -- self.handler = info.handler
-- --   -- self.layer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -800, true)
-- --   -- local button = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade.png", CCRectMake(20, 22, 40, 23))
-- --   -- self.button = button
-- --   -- button:setContentSize(CCSizeMake(250, 49))
-- --   -- button:setPosition(ccp(172, 44))
-- --   -- self.bg:addChild(button)
-- --   -- local buttonPress = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-upgrade-mask.png", CCRectMake(20, 22, 40, 23))
-- --   -- self.buttonPress = buttonPress
-- --   -- buttonPress:setContentSize(CCSizeMake(250, 49))
-- --   -- buttonPress:setVisible(false)
-- --   -- buttonPress:setAnchorPoint(ccp(0, 0))
-- --   -- buttonPress:setPosition(ccp(0, 0))
-- --   -- button:addChild(buttonPress)
-- --   -- local buttonText = info.buttonText or T(LSTR("FASTSELL.GOOD"))
-- --   -- local buttonLabel = ed.createttf(buttonText, 20, "arial_unicode_ms.ttf")
-- --   -- ed.setLabelColor(buttonLabel, normalColor)
-- --   -- ed.setLabelShadow(buttonLabel, ccc3(63, 5, 0), ccp(1, 2))

-- --   -- buttonLabel:setPosition(ccp(125, 24))
-- --   -- self.buttonLabel = buttonLabel
-- --   -- button:addChild(buttonLabel, 1)
-- --   return self
-- -- end
-- -- class.create = create

-- print("---------newDialog-----------")
-- local newDialog =  ed.dialog.create()

-- -- for k,v in pairs(newDialog) do
-- --   print(k,v)
-- -- end

-- print("__index =",getmetatable(newDialog))

-- for k,v in pairs(getmetatable(newDialog).__index) do
--   print(k,v)
-- end

-- newDialog:doMainLayerTouch()


-- ed = {} 
-- ed.ballSlots = {}
-- -- local ed = ed
-- local class = {
--   mt = {}
-- }
-- ed.Loot = class
-- class.mt.__index = class

-- local function BallCreate(idx)
--   local self = {
--     what = "Ball",
--   }
--   setmetatable(self, class.mt)
--   ed.ballSlots[idx] = self
--   return self
-- end
-- ed.BallCreate = BallCreate
-- class.BallCreate = BallCreate

-- local update = function(self, dt)
--   if self.terminated then
--     return
--   end
--   self.ball:update(dt)
-- end
-- class.update = update

-- local function onTapped(self)
--     print("onTapped")
-- end
-- class.onTapped = onTapped

-- local function onTapped2(self, myslotidx)
--     print("onTapped2")
-- end
-- class.onTapped2 = onTapped2

-- local b = ed.BallCreate(1)

-- print(b)
-- -- print("b.__index=",getmetatable(b))
-- print(b:onTapped())
-- print(b:onTapped2(10))

-- for k,v in pairs(b) do
--   print(k,v)
-- end

-- print("--------b.__index--------")

-- for k,v in pairs(getmetatable(b).__index) do
--   print(k,v)
-- end
-- function newCounter()
--     local i = 0
--     local j = 0
--     print("newCounter i=",i)
--     return function ()      -- 匿名函数
--         i = i + 1
--         return function ()
--             j = j + 1 + i
--             return j
--         end
--     end
-- end

-- c1 = newCounter()
-- print(c1()())     --> 1
-- print(c1()())     --> 2

-- print(tonumber("0999999"))

-- print(tonumber("04512")))

-- a = "2"
-- b = "2"
-- print(b == a and "a" or "b")
-- print(2>1)

-- function traceback(err)

-- print("LUA ERROR: " .. tostring(err))
-- print(debug.traceback())

-- end

 


-- local function main()

-- -- self:hello() --function is null

-- print("hello")

-- end

 

-- local status = xpcall(main, traceback)

-- -- print("status: ", status)
-- index =  string.find("haha", 'ah')
-- print(index)  ----- 输出 2 3  

-- for k,v in pairs(table_name) do
-- 	print(k,v)
-- end
-- function atoi(str)
--     return tonumber(str) or 0
-- end

-- local str = "120"
-- local pos = atoi(string.sub(str,1, string.find(str, '1234567890')))
-- -- print(string.find(str, '1234567890'))
-- -- local pos = string.sub(str,1, string.find(str, '1234567890'))
-- print(pos)


-- function setBlendFunc( ... )
-- 	-- body
-- end

-- local test = test or {}
 
-- function test:testFuncA()
--     print("testFuncA")
--     print(debug.traceback())
--     self:testFuncB()
-- end

-- function test:testFuncB()
--     print("testFuncB")
--     print(debug.traceback("", 2))
--     self:testFuncC()
-- end

-- function test:testFuncC()
--     print("testFuncC")
--     print(debug.traceback("message", 1))
-- end

-- test:testFuncA()

-- local command = {}
-- local list = {}

-- local function addList(num)
-- 	table.insert(list,num);
-- end

-- command.__add = addList


-- local r = command + 1



-- --  local Infor_class = {}
--  local Infor_class = {}

--  function Infor_class.create(_t)

--   local newTable = {};

--   setmetatable(newTable, Infor_class); --set the metatable

--   for i, v in pairs(_t) do

--    newTable[i] = v;

--   end

--   return newTable;

--  end

--  function Infor_class.sum(c1, c2)

--   if(#c1 ~= #c2) then

--    return nil;

--   else

--    local result = {};

--    local len = #c1;

--    for i = 1, len do

--     result[i] = c1[i] + c2[i];

--    end

--    print("result");

--    return result;

--   end

--   print("nil");

--   return nil;

--  end
--  Infor_class.__add = Infor_class.sum --override the _add
--  r1 = Infor_class.create{3, 4}

--  r2 = Infor_class.create{5, 6};
--  result = r1 + r2;

--  print(unpack(result));


-- local Infor_class = {};
--  function Infor_class.create(_t)
--   local newTable = {};
--   setmetatable(newTable, Infor_class); --set the metatable
--   for i, v in pairs(_t) do
--    newTable[i] = v;
--   end
--   return newTable;
--  end

--  function Infor_class.sum(c1, c2)
--  	print("Infor_class.sum")
--   for k,v in pairs(c1) do
--   	print(k,v)
--   end
--   if(#c1 ~= #c2) then
--    return nil;
--   else
--    local result = {};
--    local len = #c1;
--    for i = 1, len do
--     result[i] = c1[i] + c2[i];
--    end
--    print("result");
--    return result;
--   end
--   print("nil");

--   return nil;
--  end

 -- function sum(c1, c2)
 --  if(#c1 ~= #c2) then
 --   return nil;
 --  else
 --   local result = {};
 --   local len = #c1;
 --   for i = 1, len do
 --    result[i] = c1[i] + c2[i];
 --   end
 --   print("result");
 --   return result;
 --  end
 --  print("nil");
 --  return nil;
--  -- end

--  Infor_class.__add = Infor_class.sum --override the _add

--  r1 = Infor_class.create{3, 4}
--  r2 = Infor_class.create{5, 6};
-- print(r1)
-- print(r2)
--  result = r1 + r2;
--  print("result == ",unpack(result));

-- local command = {1}
-- local list = {}
-- local list1 = {}

-- function list.addList(num1,num2)
-- 	print("num1=" , num1)
-- 	for i,v in pairs(num1) do
-- 		print(i,v)
-- 	end
-- 	table.insert(list1,num1);
-- end

-- function list:test()
-- 	self:testComand()
-- end

-- function command:testComand()
-- 	print("testComand")
-- end


-- list.__add = Infor_class.sum
-- command.__index = list


-- list.__index = list
-- setmetatable(command,list); --set the metatable
-- list.__add = list.addList

-- -- list.__add = list.addList
-- local y = command.addList({1},{2})
-- command:test()
-- setmetatable(list ,{__index = command}); 
-- list:test()
-- local x = command + {1}

-- local nnnnnn = {}

-- function nnnnnn.addList(num1)
-- 	print("nnnnnn num1 =",#num1)
-- 	for k,v in pairs(num1) do
-- 		print(k,v)
-- 	end
-- 	table.insert(list,num1);
-- end


-- local ttttt = {}

-- function ttttt.addTwoList(num1,num2)
-- 	table.insert(list,num1);
-- 	table.insert(list,num2);
-- end
-- -- command.__add = addList
-- -- ttttt.__index = addTwoList
-- setmetatable(command, {__index = ttttt ,__add = nnnnnn.addList});
-- -- setmetatable(command, {__add = nnnnnn});

-- -- local r = command + 1000
-- command.addTwoList(1,2)
-- local r = command + ttttt
-- print("r == ",r)
-- for i,v in ipairs(list) do
-- 	print(i,v)
-- end

-- print("command.__add ",command.__add)
-- print("command.__index ",getmetatable(command))
-- print("command.__index ",command.__index)

-- coroutine_test.lua 文件
-- co = coroutine.create(
--     function(i)
--         print(i);
--     end
-- )
 
-- -- coroutine.resume(co, 1)   -- 1
-- -- print(coroutine.status(co))  -- dead
 
-- print("----------")
 
-- co = coroutine.wrap(
--     function(i)
--         print(i);
--     end
-- )
 
-- co(1)
 
-- print("----------")
 
-- co2 = coroutine.create(
--     function()
--         for i=1,1 do
--             print(i)
--             if i == 3 then
--                 print(coroutine.status(co2))  --running
--                 print(coroutine.running()) --thread:XXXXXX
--             end
--             coroutine.yield()
--             print("coroutine.yield 22222")
--         end
--     end
-- )

-- co3 = coroutine.create(
--     function()
--         for i=1,1 do
--             print(i)
--             if i == 3 then
--                 print(coroutine.status(co2))  --running
--                 print(coroutine.running()) --thread:XXXXXX
--             end
--             print("coroutine.yield 1111")
--             coroutine.yield()
--             print("coroutine.yield 22222")
--         end
--     end
-- )

-- -- local starttime = os.clock();                           --> os.clock()用法
-- -- print(string.format("start time 1111: %.8f", starttime)); 
-- coroutine.resume(co2) --1
-- -- print("-------222222---")
-- coroutine.resume(co2) --2
-- -- print("-------3333333---")
-- -- starttime2 = os.clock();                           --> os.clock()用法
-- -- print(string.format("start time 22222 : %.8f", starttime2)); 
-- coroutine.resume(co2) --3
 
-- print(coroutine.status(co2))   -- suspended
-- print(coroutine.running())
 
-- print("----------")
-- print(string.format("start time 1111: %.8f", starttime)); 
-- print(string.format("start time 22222 : %.8f", starttime2)); 

-- local newProductor

-- function productor()
--      local i = 0
--      while true do
--           i = i + 1
--           send(i)     -- 将生产的物品发送给消费者
--      end
-- end

-- function consumer(str)
     
--      while true do
--           local i = receive()     -- 从生产者那里得到物品
--           print("consumer"..str)
--           print(i)
--      end
-- end

-- function receive()
--      local status, value = coroutine.resume(newProductor)
--      print("status",coroutine.status(newProductor))
--      return value
-- end

-- function send(x)
--      coroutine.yield(x)     -- x表示需要发送的值，值返回以后，就挂起该协同程序
-- end

-- -- 启动程序
-- newProductor = coroutine.create(productor)
-- consumer("11111111")
-- print("consumer")
-- consumer("2222222")

-- local function numbers( )
--      return 1 , 2, 3, 4
-- end 



-- local one ,two= numbers()
-- print(one,two)

-- for i=1,1 do
-- 	print(i)
-- end

--  for i = 1, 10 do
--     repeat
--          if i%2 == 0 then
--             break
--          end
--          print(i)
--          break
--     until true 
-- end

-- for i = 1, 10 do
--     if i%2 == 0 then
--          goto continue
--      end
--      print(i)
--      ::continue::
-- --  end

-- for i = 1, 10 do
--     while true do
--        if i%2 == 0 then
--             break
--         end
--         print(i)
--         break
--     end
-- end

-- local index = 0
-- print(index == 1 and 1 or 0)

-- local switch = {  
--     [1] = function()  
--         print("switch:"..1)  
--     end,  
--     [2] = function()  
--         print("switch:"..2)  
--     end,  
--     ["test"] = function()  
--         print("switch:test")  
--     end,  
-- }  


-- function table.nums(t)
--     local count = 0
--     for k, v in pairs(t) do
--         count = count + 1
--     end
--     return count
-- end

-- print(table.nums({nil,nil,1}))

-- t0 = {name = "www"}
-- function t0:show() 
-- 	print("t0:show")
-- end

-- t1 = {name = "www"
-- }function t1:show() 
-- 	print("t1:show")
-- end
-- print("t1==",t1)

-- t2 = {}
-- t2.super = t1
-- t2.super0 = t0

-- t2.__index = t2

-- setmetatable(t2, {__index = t2.super})

-- print("t2==",t2)
-- -- t1.__call = function( ... )
-- -- 	print("call")
-- -- end
-- -- -- t2.__index = t1
-- print("------------getmetatable--------------------")
-- -- print(getmetatable(t2))
-- for k,v in pairs(getmetatable(t2)) do
-- 	print(k,v)
-- end

-- t2:show()


-- for k,v in pairs(getmetatable(cell)) do
--             print(k,v)
--         end


-- t3 = {}
-- t2.__index = t2
-- setmetatable(t3, t2)
-- t3:show()

-- print("------------t3 getmetatable--------------------")
-- print(getmetatable(t3))
-- for k,v in pairs(getmetatable(t3)) do
-- 	print(k,v)
-- end


-- print("------------getmetatable __index--------------------")
-- for k,v in pairs(getmetatable(t2).__index) do
-- 	print(k,v)
-- end
-- print(t2.name)
-- print(t2)
-- print(t2())


-- function ShowMainCitySkinView:LoadSkinScrollView()

--     self.m_skinScrollView = ccui.ScrollView:create()
--     self.m_skinScrollView:setContentSize(cc.size(self.m_skinlistNode:getContentSize().width, self.m_skinlistNode:getContentSize().height))
--     self.m_skinScrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--     self.m_skinScrollView:jumpToTop()
--     self.m_skinScrollView:setAnchorPoint(cc.p(0.5, 0.5))
--     self.m_skinScrollView:setPosition(self.m_skinlistNode:getContentSize().width/2, self.m_skinlistNode:getContentSize().height/2)
--     self.m_skinScrollView:setBounceEnabled(false)
--     self.m_skinScrollView:setTouchEnabled(true)
--     self.m_skinlistNode:addChild(self.m_skinScrollView)

--     if self.m_curType == SkinType.USE_SKIN then

--         self.m_skillTitle:setString(_lang("2050"))
--         self.m_btnHave:setTitleForState(_lang("1580"), cc.CONTROL_STATE_NORMAL)
--         self.m_btnNotHave:setTitleForState(_lang("101914"), cc.CONTROL_STATE_NORMAL)
--         self.m_btnGet:setTitleForState(_lang("3800170"), cc.CONTROL_STATE_NORMAL)

--         self:initPageHave()
--         self:addSkinNodeToScrollView(false)

--         if (self.m_index + 1) > SHOWCELLNUM then
--             self.m_tableView:setContentOffset(ccp(-((self.m_index + 1 - SHOWCELLNUM) * CELLSIZE.width), 0), false)
--         end
--         self.m_chooseIndex = self.m_index
--         self:tableCellTouched(self.m_tableView, self.m_tableView:cellAtIndex(self.m_chooseIndex))
--         self.m_offsetNum = self.m_listNode:getContentSize().width / CELLSIZE.width
--         self.m_btnLeft:setVisible(false)
--         self.m_btnRight:setVisible(self.m_cellNum > self.m_offsetNum)

--         self.m_mainNode:setVisible(false)
--         self.m_bottomNode:setVisible(false)
--         self.m_mainSkinNode:setVisible(true)
--         self.m_bottomSkinNode:setVisible(true)
--     end
-- end

-- function ShowMainCitySkinView:addSkinNodeToScrollView(isReload)

--     if isReload then
--         self.m_skinScrollView:removeAllChildren()
--     end

--     if self.m_skinGroupInfo:count() == 0 then
--         return
--     end

--     local innerContainerSize = CCSize(self.m_skinlistNode:getContentSize().width, 168*math.ceil(self.m_skinGroupInfo:count() / 4))

--     for index = 0,self.m_skinGroupInfo:count() - 1 do
--         local skinInfo = self.m_skinGroupInfo:objectAtIndex(index)
--         local skinNode = ShowMainCitySkinNode:create(skinInfo,index)
--         local skinNodeSize = skinNode:getSkinNodeContentSize()
        
--         local distance = (SCREEN_SIZE.width - skinNodeSize.width * 4) / 5
--         -- local point = cc.p(distance + index * skinNodeSize.width + skinNodeSize.width/2 + distance*index, 130)
--         local point = cc.p(distance + math.ceil(index % 4) * skinNodeSize.width + skinNodeSize.width/2 + distance*math.ceil(index % 4),innerContainerSize.height-skinNodeSize.height/2 - math.ceil(index / 4) * 168)
--         skinNode:setPosition(point)
--         if index > 10 then
--             print("index == ",index)
--         end

--         skinNode:setTag(index)
--         self.m_skinScrollView:addChild(skinNode)
        
--     end

--     self.m_skinScrollView:setInnerContainerSize(innerContainerSize)    
-- end

--------------城市装扮-----------------------------------
-- function ShowMainCitySkinView:LoadSkinScrollView()

--     self.m_skinScrollView = ccui.ScrollView:create()
--     self.m_skinScrollView:setContentSize(cc.size(self.m_skinlistNode:getContentSize().width, self.m_skinlistNode:getContentSize().height))
--     self.m_skinScrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--     self.m_skinScrollView:jumpToTop()
--     self.m_skinScrollView:setAnchorPoint(cc.p(0.5, 0.5))
--     self.m_skinScrollView:setPosition(self.m_skinlistNode:getContentSize().width/2, self.m_skinlistNode:getContentSize().height/2)
--     self.m_skinScrollView:setBounceEnabled(false)
--     self.m_skinScrollView:setTouchEnabled(true)
--     self.m_skinlistNode:addChild(self.m_skinScrollView)

--     if self.m_curType == SkinType.USE_SKIN then

--         self.m_skillTitle:setString(_lang("2050"))
--         self.m_btnHave:setTitleForState(_lang("1580"), cc.CONTROL_STATE_NORMAL)
--         self.m_btnNotHave:setTitleForState(_lang("101914"), cc.CONTROL_STATE_NORMAL)
--         self.m_btnGet:setTitleForState(_lang("3800170"), cc.CONTROL_STATE_NORMAL)

--         self:initPageHave()
--         self:addSkinNodeToScrollView(false)

--         if (self.m_index + 1) > SHOWCELLNUM then
--             self.m_tableView:setContentOffset(ccp(-((self.m_index + 1 - SHOWCELLNUM) * CELLSIZE.width), 0), false)
--         end
--         self.m_chooseIndex = self.m_index
--         self:tableCellTouched(self.m_tableView, self.m_tableView:cellAtIndex(self.m_chooseIndex))
--         self.m_offsetNum = self.m_listNode:getContentSize().width / CELLSIZE.width
--         self.m_btnLeft:setVisible(false)
--         self.m_btnRight:setVisible(self.m_cellNum > self.m_offsetNum)

--         self.m_mainNode:setVisible(false)
--         self.m_bottomNode:setVisible(false)
--         self.m_mainSkinNode:setVisible(true)
--         self.m_bottomSkinNode:setVisible(true)
--     end
-- end

-- function ShowMainCitySkinView:addSkinNodeToScrollView(isReload)

--     if isReload then
--         self.m_skinScrollView:removeAllChildren()
--     end

--     if self.m_skinGroupInfo:count() == 0 then
--         return
--     end

--     local innerContainerSize = CCSize(self.m_skinlistNode:getContentSize().width, 168*math.ceil(self.m_skinGroupInfo:count() / 4))

--     for index = 0,self.m_skinGroupInfo:count() - 1 do
--         local skinInfo = self.m_skinGroupInfo:objectAtIndex(index)
--         local skinNode = ShowMainCitySkinNode:create(skinInfo,index)
--         local skinNodeSize = skinNode:getSkinNodeContentSize()
        
--         local distance = (SCREEN_SIZE.width - skinNodeSize.width * 4) / 5
--         -- local point = cc.p(distance + index * skinNodeSize.width + skinNodeSize.width/2 + distance*index, 130)
--         local point = cc.p(distance + math.ceil(index % 4) * skinNodeSize.width + skinNodeSize.width/2 + distance*math.ceil(index % 4),innerContainerSize.height-skinNodeSize.height/2 - math.ceil(index / 4) * 168)
--         skinNode:setPosition(point)
--         if index > 10 then
--             print("index == ",index)
--         end

--         skinNode:setTag(index)
--         self.m_skinScrollView:addChild(skinNode)
        
--     end

--     self.m_skinScrollView:setInnerContainerSize(innerContainerSize)    
-- end

-- local t = {}

-- local function setT(t)
-- 	t[1] = 1
-- 	-- t = {1,2,3}
-- 	-- body
-- 	print("setT")
-- 	-- t = newT
-- end

-- setT(t)

-- for i,v in ipairs(t) do
-- 	print(i,v)
-- end

-- local t = 1
-- local function setT(t)
-- 	t = 100
-- 	print("setT")
-- 	-- t = newT
-- end

-- setT(t)

-- print(t)

-- function xx( ... )
-- 	print(x)
-- end

-- local x = 1

-- xx()
-- xx = nil
-- if xx and xx.xx then
-- 	print(xx.xx)
-- end

-- local path = package.path



-- -- module("module123",package.seeall)  
-- -- -- 
-- local x,y = require "test"
-- print(x,y)

-- -- show()

-- for k,v in pairs(package.loaded) do
-- 	print(k,v)
-- end

-- for k,v in pairs(package.loaded.test123) do
-- 	print(k,v)
-- -- end
-- list_node = {}
-- function list_node:new(object)
--   object = object or {}
--   setmetatable(object, self)
--   self.__index = self
--   return object
-- end

-- function list_node:dump(object)
-- 	print("object==",object)
-- end

-- tempList = {}

-- function tempList:dump1(object)
-- 	print("object1==",object)
-- end


-- local list = list_node:new(tempList)
-- list:dump("object")
-- list:dump1("object1")



-- local x = true

-- if x then
-- 	print("x=",x)
-- end
-- print(string.len("s") > 0 and "sssss" or "")
-- local x = 1
-- print(string.format("Alliance_R%d.png", x))

local setmetatableindex_
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_




function class(classname, ...)
	print("classclassclassclassclassclassclassclass")
    local cls = {__cname = classname}

    local supers = {...}
     print("supers =",supers)
    for _, super in ipairs(supers) do
        local superType = type(super)
        print("superType =",superType)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.__create = function() return super:create() end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    print("cls.__index=",cls)
    if not cls.__supers or #cls.__supers == 1 then
    	print("cls.super=",cls.super)
        setmetatable(cls, {__index = cls.super})
    else
    	print("__index = function")
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
        	print("cls.__create")
            instance = cls.__create(...)
        else
        	print("instance = {}")
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        if not instance.super then
            instance.super = getmetatable(instance)
        end
        print("instance ==",instance)
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end
    print("return cls =",cls)
    return cls
end


-- ControllerBase = class("ControllerBase")
-- print("ControllerBase==",ControllerBase)

-- -- print("------------------- pairs(ControllerBase)-------------------")
-- -- for k,v in pairs(ControllerBase) do
-- -- 	print(k,v)
-- -- end
-- -- print("------------------- pairs(ControllerBase)-------------------")
-- -- print("ControllerBase==",ControllerBase)
-- function ControllerBase:ctor()
-- 	print("ControllerBase:baseCtor")
-- 	self:addPurgeDataCallBack()
-- end

-- function ControllerBase:addPurgeDataCallBack()
-- 	print("self.purgeData==",self.purgeData)
-- 	-- print("ControllerBase:addPurgeDataCallBack")
-- end

-- print("ControllerBase.addPurgeDataCallBack= ",ControllerBase.addPurgeDataCallBack)

-- print("---------------------------ActivityRescueController---------------------------------------")
-- print("")

-- print("")
-- print("")
-- print("")
-- print("")
-- ActivityRescueController = class("ActivityRescueController",ControllerBase)

-- print("ActivityRescueController  ==",ActivityRescueController)
-- -- local _instance = nil

-- function ActivityRescueController:getInstance()
--     if not _instance then
--         _instance = ActivityRescueController:new()
--     end
--     return _instance
-- end
-- function ActivityRescueController:ctor()
-- 	print("ActivityRescueController:ctor")
-- 	self.super:ctor()
-- 	print("self.super == ",self.super)
--     self.m_activityInfo = nil
-- end
-- print("ActivityRescueController==",ActivityRescueController)

-- function ActivityRescueController:purgeData()
 
-- end

-- local arc = ActivityRescueController:getInstance()

-- -- -- arc:baseCtor()
-- -- -- print(getmetatable(arc).baseCtor)
-- print("arc ====",arc)
-- print("getmetatable.__index=",getmetatable(arc).__index)

-- print("------------------- getmetatable(arc) __index-------------------")
-- for k,v in pairs(getmetatable(arc).__index.__index) do
-- 	print(k,v)
-- end
-- print("------------------- getmetatable(arc)-------------------")

-- print("arc:addPurgeDataCallBack=",arc.addPurgeDataCallBack)
-- arc:addPurgeDataCallBack()
-- for k,v in pairs(getmetatable(arc)) do
-- 	print(k,v)
-- end
-- print("ActivityRescueController=",arc)

-- print("---------------arc-----------------------")
-- for k,v in pairs(arc) do
-- 	print(k,v)
-- end

-- getmetatable(arc).__index:addPurgeDataCallBack()


-- print("\n\n\n\n")


-- print("------------------- getmetatable(arc) __index-------------------")
-- for k,v in pairs(getmetatable(arc).__index.__index.__index) do
-- 	print(k,v)
-- end
-- print("------------------- getmetatable(arc)-------------------")

-- function handler(obj, method)
--     return function(...)
--         return method(obj, ...)
--     end
-- end


-- RankListInfoShared = class("RankListInfo")
-- print("RankListInfoShared == ",RankListInfoShared)
-- -- RankListInfoShared.__call = function ()
	
-- -- 	print("__call")
-- --     if RankListInfoShared.rankListInfo then
        
-- --     end
-- -- end

-- setmetatable(RankListInfoShared, {__index = RankListInfoShared})

-- local function function_name( ... )
-- 	-- body
-- end



-- getmetatable(RankListInfoShared).__call = handler(RankListInfoShared,function (shared)
-- 	local cs = {...}

-- 	for k,v in pairs(cs) do
-- 		print(k,v)
-- 	end
-- 	-- body
-- 	-- if self.rankListInfo == nil then
-- 	-- 	--todo
-- 	-- 	self.rankListInfo = 12
-- 	-- end

-- 	-- return self.rankListInfo
-- end)

-- RankListInfoSharedTemp = {}

-- function RankListInfoSharedTemp:initInfo()
-- 	if self.rankListInfo == nil then
-- 		--todo
-- 		self.rankListInfo = 12
-- 	end

-- 	return self.rankListInfo

-- end

-- function RankListInfoSharedTemp:initShared( )
-- 	-- body
-- 	getmetatable(RankListInfoShared).__call = handler(self, RankListInfoSharedTemp.initInfo)
-- end





-- -- print(getmetatable(RankListInfoShared))

-- -- print(RankListInfoShared())
-- -- RankListInfoSharedTemp:initShared()
-- -- print(RankListInfoShared())

-- local x = 1

-- print(x>1 and 1 or 2)


local RewardViewType = {
    RewardViewRank = 1;  --阶段排名奖励
    RewardViewTotalRank = 2;  --最强指挥官奖励.
    RewardViewServerRank = 3;  --家园阶段阶段奖励
    RewardViewServerTotalRank = 4;  --家园阶段阶段奖励
    RewardViewTypeTotal = 5;
    RewardViewTypeRescue = 6;
}

print(RewardViewType.RewardViewTypeRescue)

for i,v in pairs(RewardViewType) do
	print(i,v)
end



