
package.path = 'source/?.lua;example/?.lua;?.lua;'    --搜索lua模块

local Luabt     = require "luabt"
local Flee      = require "flee"
local Attack    = require "attack"
local HpCheck   = require "hp_check"

local Priority  = Luabt.Priority
local Sequence  = Luabt.Sequence

local robot = {id = 1, hp = 100}

local root = Priority(
    Sequence(
        HpCheck(50),
        Flee(5)
    ),
    Attack(20)
)

local bt = Luabt.new(robot, root)
-- print = function(...) end
-- print(inspect(Tick))
for i = 1, 10 do
    -- print("================", i)
    -- if i == 10 then
    --     print(">>>>>>>> hp == 10")
    --     robot.hp = 10
    -- end
    -- if i == 18 then
    --     print(">>>>>>>> hp == 100")
    --     robot.hp = 100
    -- end
    bt:tick()
end
