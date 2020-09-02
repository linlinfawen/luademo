-- MMData = require("MMDataManager")
-- print(MMData)
-- for k,v in pairs(MMData) do
-- 	print(k,v)
-- end
-- print("+++++++++++")
-- for k,v in pairs(getmetatable(MMData)) do
-- 	print(k,v)
-- -- end

-- print("-----")
-- local instance = setmetatable(MMData, {})
-- print(MMData)
-- for k,v in pairs(MMData) do
-- 	print(k,v)
-- end

-- print("+++++++++++")
-- for k,v in pairs(getmetatable(MMData)) do
-- 	print(k,v)
-- end
-- print(getmetatable(MMData))

-- print("__index == ",MMData.__index)


-- for k,v in pairs(getmetatable(MMData)) do
-- 	print(k,v)
-- end
-- print("------------------")
-- -- MMData.newData.dddd
-- print(MMData.newData)

-- mytable = setmetatable({key1 = "value1"}, {
--   __index = function(mytable, key)
--     if key == "key2" then
--       return "metatablevalue"
--     else
--       return nil
--     end
--   end
-- })

-- print(mytable.key1,mytable.key2)

-- mytable = setmetatable({key1 = "value1"}, {
--   __index = function(mytable, key)
--     if key == "key2" then
--       return "metatablevalue"
--     else
--       return nil
--     end
--   end
-- })

-- print(mytable.key1,mytable.key2)


-- mytable = {"apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana","apple", "orange", "banana"}

-- print(collectgarbage("count"))

-- mytable = nil

-- print(collectgarbage("count"))

-- print(collectgarbage("collect"))

-- print(collectgarbage("count"))


-- mm = {}

-- mm.t = {onTouch = function()
-- 	print("onTouch")
-- end}

-- if mm then
-- 	error("map config error ccbName: ")
-- end

-- print(mm.t.onTouch)


-- function mm:a( )
	
-- end

-- function mm:b( )
	
-- end

-- mm.name = "1123"

-- for k,v in pairs(mm) do
-- 	print(k,v)
-- end

-- print(mm["a"])

-- print(string.byte("DefenseAI",1))

local t = {1=1,2=2,}

