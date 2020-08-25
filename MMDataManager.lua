local MMDataManager = {}

function MMDataManager:ctor()
    self._gameData = {}
end

function MMDataManager:call(targetData)
    return self[targetData]
end

function MMDataManager:destroy( targetData )
    if targetData then
        if self[targetData] then
            self[targetData]:destroy()
            MMDataManager[targetData] = nil
        end
        return
    end
    
    for k,v in pairs(self._gameData) do
        self[k]:destroy()
        MMDataManager[k] = nil
    end
    self._gameData = nil
    self._gameData = {}
end



--[[
-- base class method
]]
MMDataManager.new = function(...)
    print("MMDataManager.new")
    -- print(MMDataManager)
    local instance = setmetatable({}, MMDataManager)
    instance:ctor(...)
    return instance
end
MMDataManager.__index = function(se_,tar_)
    print("MMDataManager.__index")
    if MMDataManager[tar_] then
        return MMDataManager[tar_]
    end
    local data_ = xpcall(function()
        require("data." .. tar_)
    end, __G__TRACKBACK__)
    if data_ then
        if not MMDataManager[tar_] then
            MMDataManager[tar_] = drequire("data." .. tar_).new()
            MMDataManager[tar_]:init()
            se_._gameData[tar_] = 1
        end
        return MMDataManager[tar_]
        
    end
end

return MMDataManager.new()