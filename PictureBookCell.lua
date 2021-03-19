local LuaHeroToolCell = drequire("view.popup.HeroToolCell")
local PictureBookLimitActiveView = drequire("view.popup.pictureBookView.PictureBookLimitActiveView")
local PictureBookSourceView = drequire("view.popup.pictureBookView.PictureBookSourceView")

local PictureBookCell = class("PictureBookCell", function (  )
    return CCTableViewTouchIFCell:create()
end)

local cellHeight = 198
local cellDesHeight = 167

local function pShowStar(node,info)

    local function pSetStarGray(starSp,isGray)
        if not starSp then
            return
        end
        CCCommonUtils:setSpriteGray(starSp, isGray)
    end
    --星星
    node:getChildByTag(18):setVisible(true)
    for i=1,6 do
        if i-1 < info.m_currStartLevel then
            pSetStarGray(node:getChildByTag(18):getChildByTag(i), false)
        else
            pSetStarGray(node:getChildByTag(18):getChildByTag(i), true)
        end
    end
end

local pictureBookState = {

    initIcon = function(cell,node,info)
        --图鉴头像
        local iconPath = info.m_skinBigIcon .. "_new.png"
        local pic = CCLoadSprite:createSprite(iconPath)
        node:getChildByTag(6):addChild(pic)
        if info.m_skinAcitivate == mm.skinTimeType.EM_None_Skin_Type then
            CCCommonUtils:setSpriteGray(pic, true)    
        end

        --图鉴名字
        if info.m_skinName then
            node:getChildByTag(11):setString(info.m_skinName)
        else
            node:getChildByTag(11):setString("")    
        end

        local currentSkinId = cell:getCurrentSkinId(info)
        if currentSkinId then
            node:getChildByTag(16):setVisible(PictureBookController:getInstance():isCanActivateSkinId(currentSkinId))
            node:getChildByTag(17):setVisible(PictureBookController:getInstance():isCanUpStarSkinId(currentSkinId))
        end
    end,

    initState = function(cell,node,info)
        cell.m_activationBtn:setVisible(true)
        local isEnough,idGearVec = cell:getIsEnoughAndGearVecForActive(true,info)
        cell:addSmallPicTureIcon(idGearVec)
    end,

    initHaveState = function(cell,node,info)

    end,

    onActivation = function(cell,node,info)
        
    end,

    onUse = function(cell,node,info)
        
    end,

    onUnsnatch = function(cell,node,info)
        
    end,

    onExchange = function(cell,node,info)
        
    end,

    onStrengthen = function(cell,node,info)
        
    end,
}

local pictureBookStateTable = {
    ------------------------限时 未激活--------------------------------
    [mm.pictureBookState.EM_Limit_Skin_None_State] = {
        
        onActivation = function(cell,node,info)
            cell:onGoToLimitActiveView(info)
        end,
    },
    ------------------------限时 使用中--------------------------------
    [mm.pictureBookState.EM_Limit_Skin_Down_State] = {

        initState = function(cell,node,info)
            cell.m_exchangeBtn:setVisible(true)
            cell.m_UnsnatchBtn:setVisible(true)
            local isEnough,idGearVec = cell:getIsEnoughAndGearVecForActive(true,info)
            cell:addSmallPicTureIcon(idGearVec)
            
        end,

        initHaveState = function(cell,node,info)
            node:getChildByTag(12):setVisible(true)
            return function() 
                if info.m_timeOut then
                    local curTime = GlobalData:shared():getTimeStamp()
                    local durationTime = info.m_timeOut - curTime
                    if durationTime > 0 then
                        node:getChildByTag(19):setString(CC_SECTOA(durationTime))
                        node:getChildByTag(19):setVisible(true)
                    else
                        node:getChildByTag(19):setVisible(false)
                    end
                else
                    node:getChildByTag(19):setVisible(false)
                end
            end
        end,

        onExchange = function(cell,node,info)
            cell:onGoToLimitActiveView(info)
        end,

        onUnsnatch = function(cell,node,info)
            cell:UseSkin()
        end,

    },

    ------------------------限时 卸下中--------------------------------
    [mm.pictureBookState.EM_Limit_Skin_Up_State] = {

        initState = function(cell,node,info)
            cell.m_exchangeBtn:setVisible(true)
            cell.m_useBtn:setVisible(true)
            local isEnough,idGearVec = cell:getIsEnoughAndGearVecForActive(true,info)
            cell:addSmallPicTureIcon(idGearVec)
        end,

        initHaveState = function(cell,node,info)
            return function()  
                if info.m_timeOut then
                    local curTime = GlobalData:shared():getTimeStamp()
                    local durationTime = info.m_timeOut - curTime
                    if durationTime > 0 then
                        node:getChildByTag(19):setString(CC_SECTOA(durationTime))
                        node:getChildByTag(19):setVisible(true)
                    else
                        node:getChildByTag(19):setVisible(false)
                    end
                else
                    node:getChildByTag(19):setVisible(false)
                end
            end
        end,

        onExchange = function(cell,node,info)
            cell:onGoToLimitActiveView(info)
        end,

        onUse = function(cell,node,info)
            cell:UseSkin()
        end,

    },

    -----------------------永久 未激活--------------------------------
    [mm.pictureBookState.EM_Forever_Skin_None_State] = {

        initState = function(cell,node,info)
            cell.m_debrisLabel:setVisible(true)
            cell.m_wPictureArrow:setVisible(true)
            local isEnough,idGearVec = cell:getIsEnoughAndGearVecForActive(false,info)
            cell:addSmallPicTureIcon(idGearVec)
            if isEnough then
                cell.m_activationBtn:setVisible(true)
            else
                cell.m_exchangeBtn:setVisible(true)
                cell.m_exchangeBtn:setPosition(0, 0)
            end
            
        end, 
        
        onActivation = function(cell,node,info)
            cell:foreverSkinAcitivate(info)
        end,

        onExchange = function(cell,node,info)
            cell:onGoToShop(info)
        end,
    },

    -----------------------永久 使用中--------------------------------
    [mm.pictureBookState.EM_Forever_Skin_Down_State] = {

        initState = function(cell,node,info)
            cell.m_wPictureArrow:setVisible(true)
            node:getChildByTag(12):setVisible(true)
            cell.m_UnsnatchBtn:setVisible(true)
            cell.m_debrisLabel:setVisible(true)
            local isEnough,idGearVec = cell:getIsEnoughAndGearVecForStrengthen(info)
            cell:addSmallPicTureIcon(idGearVec)
            local isMAX =(info.m_currStartLevel == info.m_maxStartLevel)
            if isEnough and isMAX == false then
                cell.m_strengthenBtn:setVisible(true)
            else    
                cell.m_exchangeBtn:setVisible(true)
            end

        end,

        initHaveState = function(cell,node,info)
            node:getChildByTag(12):setVisible(true)
            pShowStar(node,info)
        end,

        onExchange = function(cell,node,info)
            cell:onGoToShop(info)
        end,

        onUse = function(cell,node,info)
            cell:UseSkin()
        end,

        onUnsnatch = function(cell,node,info)
            cell:UseSkin()
        end,

        onStrengthen = function(cell,node,info)
            cell:onUpSkin()
        end,
    },

    -----------------------永久 卸下中--------------------------------
    [mm.pictureBookState.EM_Forever_Skin_Up_State] = {

        initState = function(cell,node,info)
            cell.m_wPictureArrow:setVisible(true)
            cell.m_exchangeBtn:setVisible(true)
            cell.m_useBtn:setVisible(true)
            cell.m_debrisLabel:setVisible(true)
            local isEnough,idGearVec = cell:getIsEnoughAndGearVecForStrengthen(info)
            cell:addSmallPicTureIcon(idGearVec)
            local isMAX =(info.m_currStartLevel == info.m_maxStartLevel)
            if isEnough and isMAX == false then
                cell.m_strengthenBtn:setVisible(true)
            else    
                cell.m_exchangeBtn:setVisible(true)
            end
        end,

        initHaveState = function(cell,node,info)
            pShowStar(node,info)
        end,

        onExchange = function(cell,node,info)
            cell:onGoToShop(info)
        end,

        onUse = function(cell,node,info)
            cell:UseSkin()
        end,

        onUnsnatch = function(cell,node,info)
            cell:UseSkin()
        end,

        onStrengthen = function(cell,node,info)
            cell:onUpSkin()
        end,
    },
}

pictureBookState.__index = pictureBookState
for _,v in pairs(pictureBookStateTable) do
    setmetatable(v, pictureBookState)
end

local pictureBookStateManage = {
    [mm.skinUseType.EM_Limit_Skin_Type] = function (cell,node,info )
        --限时 0
        node:getChildByTag(13):setVisible(true)
        if info.m_skinAcitivate == mm.skinTimeType.EM_Up_Skin_Type then
            return pictureBookStateTable[mm.pictureBookState.EM_Limit_Skin_Up_State]
        elseif info.m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then   
            return pictureBookStateTable[mm.pictureBookState.EM_Limit_Skin_Down_State]
        end
        return pictureBookStateTable[mm.pictureBookState.EM_Limit_Skin_None_State]
    end,

    [mm.skinUseType.EM_Forever_Skin_Type] = function (cell,node,info)
        --永久 1
        node:getChildByTag(14):setVisible(true)
        
        if info.m_skinAcitivate == mm.skinTimeType.EM_Up_Skin_Type then
            return pictureBookStateTable[mm.pictureBookState.EM_Forever_Skin_Up_State]
        elseif info.m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then   
            return pictureBookStateTable[mm.pictureBookState.EM_Forever_Skin_Down_State]
        end
        return pictureBookStateTable[mm.pictureBookState.EM_Forever_Skin_None_State]
    end,
}

function PictureBookCell:dtor()
    if self.m_updateId then
        self:getScheduler():unscheduleScriptEntry(self.m_updateId)
        self.m_updateId = nil
    end

    -- CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.HIDE_PICTUREBOOK_SELECT_STATUS)
end

function PictureBookCell:create(infos,touchNode,selectIndex,type,Parent)
    local ret = PictureBookCell.new()
    if ret and ret:initView(infos,touchNode,selectIndex,type,Parent) then
        return ret
    end
    CC_SAFE_DELETE(ret)
    return nil
end

function PictureBookCell:initView(infos,touchNode,selectIndex,type,Parent)
    self:initBase()
    self.ccbNode = CCBLoadFile("PictureBookCell", self, self)
    self:setContentSize(SCREEN_SIZE.width,cellHeight)
    self.m_touchNode = touchNode
    self.m_infoNodes = {self.m_infoNode1, self.m_infoNode2, self.m_infoNode3, self.m_infoNode4}
    self.Parent = Parent
    
    CCCommonUtils:setButtonTitle(self.m_useBtn, _lang("501184"))
    CCCommonUtils:setButtonTitle(self.m_strengthenBtn, _lang("7100366"))
    CCCommonUtils:setButtonTitle(self.m_exchangeBtn, _lang("128106"))
    CCCommonUtils:setButtonTitle(self.m_activationBtn, _lang("3621005"))
    CCCommonUtils:setButtonTitle(self.m_UnsnatchBtn, _lang("119003"))

    self:setData(infos,selectIndex,type)
    -- CCSafeNotificationCenter:sharedNotificationCenter():registerScriptObserver(self, PictureBookCell.hideSelectStatus, mm.HIDE_PICTUREBOOK_SELECT_STATUS, nil)
    return true
end

function PictureBookCell:setData(infos,selectIndex,type)
    self:restoreCell()
    if not infos then
        return
    end
    
    self.selectIndex = selectIndex
    self.infos = infos
    self.m_type = type
    self.durationFunctinTable = {}
    for i,info in ipairs(infos) do
        local m_infoNode = self.m_infoNodes[i]
        if info and m_infoNode then
            self:refreshCell(m_infoNode,info)
            --选中状态
            if self.selectIndex == i then
                self:selectNode(m_infoNode,info)
                self:addSelectEffect(m_infoNode:getChildByTag(6))
            else
                self:addSelectEffect(m_infoNode:getChildByTag(6),true)
            end
        end
    end

    if self.m_updateId then
        self:getScheduler():unscheduleScriptEntry(self.m_updateId)
        self.m_updateId = nil
    end
    if table.nums(self.durationFunctinTable) > 0 then
        if self.m_updateId == nil then
            self.m_updateId = self:getScheduler():scheduleScriptFunc(handler(self, PictureBookCell.onSkinEndTime), 1.0, false)
        end 
    end
    
end

function PictureBookCell:restoreCell()

    self.state = nil
    self.selectIndex = -1
    self:setContentSize(SCREEN_SIZE.width,cellHeight)
    self.ccbNode:setPosition(0, 0)
    self.m_desNode:setVisible(false)

    --图鉴相关按钮
    self.m_activationBtn:setVisible(false)
    self.m_wPictureArrow:setVisible(false)
    self.m_activationBtn:setTouchEnabled(true)
    self.m_useBtn:setVisible(false)
    self.m_UnsnatchBtn:setVisible(false)
    self.m_exchangeBtn:setVisible(false)
    self.m_exchangeBtn:setPosition(0, 30)
    self.m_strengthenBtn:setVisible(false)
    self.m_strengthenBtn:setTouchEnabled(true)
    self.m_picTureBookNode:removeAllChildren(true)
    self.m_startNode:setVisible(false)
    self.m_debrisLabel:setVisible(false)

    for i,m_infoNode in ipairs(self.m_infoNodes) do
        m_infoNode:setVisible(false)
        m_infoNode:getChildByTag(13):setVisible(false)
        m_infoNode:getChildByTag(14):setVisible(false)
        m_infoNode:getChildByTag(12):setVisible(false)
        m_infoNode:getChildByTag(16):setVisible(false)
        m_infoNode:getChildByTag(17):setVisible(false)
        m_infoNode:getChildByTag(18):setVisible(false)
        m_infoNode:getChildByTag(19):setVisible(false)
        m_infoNode:getChildByTag(6):removeAllChildren(true)
    end
end

function PictureBookCell:refreshCell(node,info)
    node:setVisible(true)
    if pictureBookStateManage[info.m_skinType] then
        local state = pictureBookStateManage[info.m_skinType](self,node,info)
        state.initIcon(self,node,info)
        local durationFunctin = state.initHaveState(self,node,info)
        if type(durationFunctin) == "function" then
            durationFunctin()
            table.insert(self.durationFunctinTable, durationFunctin)
        end
    end
end

function PictureBookCell:onSkinEndTime(dt)
    for i,func in ipairs(self.durationFunctinTable) do
        if type(func) == "function" then
            func()
        end
    end
end

function PictureBookCell:selectNode(node,info)
    self:showSelectDesNode(node)
    if pictureBookStateManage[info.m_skinType] then
        self.state = pictureBookStateManage[info.m_skinType](self,node,info)
        self.state.initState(self,node,info)
    end
end

function PictureBookCell:showSelectDesNode(m_infoNode)
    self:setContentSize(SCREEN_SIZE.width,cellHeight + cellDesHeight)
    self.ccbNode:setPosition(0, cellDesHeight)
    self.m_desNode:setVisible(true)
    self.m_arrowSpr:setPositionX(m_infoNode:getPositionX() - 20)
end

function PictureBookCell:addSelectEffect(node,isRemove)

    if isRemove then
        if node:getChildByName("EffectIcon_33") then
            node:removeChildByName("EffectIcon_33", false)
        end
        return
    end

    if not node:getChildByName("EffectIcon_33") then
        local EffectNode = CCBLoadFile("Effect/EffectIcon_33", node)
        EffectNode:setName("EffectIcon_33")
        local size = node:getContentSize()
        EffectNode:setPosition(size.width * 0.5, size.height * 0.5)
    end
end

function PictureBookCell:addSmallPicTureIcon(idGearVec)
    -- m_picTureBookNode
    self.m_picTureBookNode:removeAllChildren(false)
    local scale = 0.72
    if table.nums(idGearVec) > 0 then
        for i,v in ipairs(idGearVec) do
            local data = {}
            data.value = {}
            data.type = mm.RewardType.R_GOODS
            data.value.id = idGearVec[i]
            local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(data.value.id)
            data.value.num = toolInfo:getCNT()
            
            local cell = LuaHeroToolCell:create(data,false)
            cell:hideName()
            cell:setSelectVisible(false)
            cell:setIsTopTips(true)
            cell:setScale(scale, scale)
            cell:showNum()
            cell:setAnchorPoint(ccp(0.5, 0.5))
            cell:setPosition(-108*scale / 2 + 108*scale * (i-1),-157*scale / 2)
            self.m_picTureBookNode:addChild(cell)
        end
    end
end

function PictureBookCell:getCurrentSkinId(info)
    local currentSkinId = nil
    if info.m_heroSkinId then
        currentSkinId = info.m_heroSkinId
    elseif info.m_armySkinId then
        currentSkinId = info.m_armySkinId
    elseif info.m_mechaSkinId then
        currentSkinId = info.m_mechaSkinId
    elseif info.m_citySkinId then
        currentSkinId = info.m_citySkinId
    end
    return currentSkinId
end

function PictureBookCell:setDebrisLabelCount(isEnough,count1,count2)
    if isEnough then
        local numTxt = _lang_1("3621035", CC_ITOA(count1))
        numTxt = numTxt..(_lang_1("3621036", CC_ITOA(count2)))
        self.m_debrisLabel:setString(numTxt)
    else
        local numTxt = _lang_1("3621035", CC_ITOA(count1))
        numTxt = numTxt..(_lang_1("3621037", CC_ITOA(count2)))
        self.m_debrisLabel:setString(numTxt)
    end
end

--是否可以激活
function PictureBookCell:getIsEnoughAndGearVecForActive(isLimit,info)
    local skinId = ""
    local idGearVec = {}
    local totalNum = 0

    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        skinId = info.m_heroSkinId
        idGearVec = info.m_gearVec
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        skinId = info.m_armySkinId
        idGearVec = info.m_gearVec
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        skinId = info.m_mechaSkinId
        idGearVec = info.m_gearVec
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        skinId = info.m_citySkinId
        idGearVec = info.m_gearVec
    end
    local useNumString = CCCommonUtils:getXmlPropById("skinBase", skinId, "active")
    local needNum = atoi(useNumString)

    print("激活道具",isLimit and "限时")
    for i,v in ipairs(idGearVec) do
        print("id =",idGearVec[i])
    end

    --限时返回限时图鉴兑换券
    if isLimit then
        return false,idGearVec
    end

    --优先判断图鉴兑换券
    local toolInfo1 = ToolController:getInstance():getToolInfoByIdForLua(atoi(idGearVec[1]))
    if toolInfo1.type == mm.ItemType.ITEM_TYPE_SPECIFIED_SKIN then
        if toolInfo1:getCNT() >= 1 then 
            self:setDebrisLabelCount(true,toolInfo1:getCNT(),1)        
            return true,{idGearVec[1]},idGearVec[1]
        end
    end

    local fragmentItemIdTable = {}
    local fragmentItemIdTable2 = {}
    for i=1,#idGearVec do
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(idGearVec[i]))
        if toolInfo.type ~= mm.ItemType.ITEM_TYPE_SPECIFIED_SKIN then  --如果不是兑换券
            if totalNum < needNum and toolInfo:getCNT() > 0 then  ----当专属碎片不足时 ，需要显示万能碎片的数量
                totalNum = totalNum + toolInfo:getCNT()
                table.insert(fragmentItemIdTable, idGearVec[i])   
            end
            table.insert(fragmentItemIdTable2, idGearVec[i]) 
        end
    end

    if totalNum >= needNum then
        self:setDebrisLabelCount(true,totalNum,needNum)
        return true,fragmentItemIdTable,idGearVec[2]
    end
    self:setDebrisLabelCount(false,totalNum,needNum)
    --已经激活未达到强化返回需要兑换的碎片
    return false,fragmentItemIdTable2
end

--是否可以强化
function PictureBookCell:getIsEnoughAndGearVecForStrengthen(info,debrisLabel)
    local idLevelStr = ""
    local totalNum = 0

    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        idLevelStr = string.format("%s_%d", info.m_heroSkinId, MIN(info.m_currStartLevel + 1, info.m_maxStartLevel))
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        idLevelStr = string.format("%s_%d", info.m_armySkinId, MIN(info.m_currStartLevel + 1, info.m_maxStartLevel))
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        idLevelStr = string.format("%s_%d", info.m_mechaSkinId, MIN(info.m_currStartLevel + 1, info.m_maxStartLevel))
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        idLevelStr = string.format("%s_%d", info.m_citySkinId, MIN(info.m_currStartLevel + 1, info.m_maxStartLevel))
    end

    local useItemString = CCCommonUtils:getXmlPropById("attributeBase", idLevelStr, "use_item")
    local useNumString = CCCommonUtils:getXmlPropById("attributeBase", idLevelStr, "allexp")
    local idVec = CCCommonUtils:splitString(useItemString, ";")
    local needNum = atoi(useNumString)

    local fragmentItemIdTable = {}
    local fragmentItemIdTable2 = {}
    for i=1,#idVec do
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(idVec[i]))
        if totalNum < needNum and toolInfo:getCNT() > 0 then  ----当专属碎片不足时 ，需要显示万能碎片的数量
            totalNum = totalNum + toolInfo:getCNT()
            table.insert(fragmentItemIdTable, idVec[i])
        end
        table.insert(fragmentItemIdTable2, idVec[i]) 
    end

    if totalNum >= needNum then
        self:setDebrisLabelCount(true,totalNum,needNum)
        return true,fragmentItemIdTable
    end
    self:setDebrisLabelCount(false,totalNum,needNum)
    --碎片数量没有达到强化
    return false,fragmentItemIdTable2
end


function PictureBookCell:onEnter()
    self:setTouchEnabled(true)
end

function PictureBookCell:onExit()
    self:setTouchEnabled(false)
end

function PictureBookCell:onTouchBegan(pTouch, pEvent)
    self.m_startPoint = pTouch:getLocation()
    if isTouchInside(self.m_touchNode, pTouch) then
        if isTouchInside(self, pTouch) then
            return true
        end
    end
    return false
end

function PictureBookCell:onTouchMoved(pTouch, pEvent)
end

function PictureBookCell:onTouchEnded(pTouch, pEvent)
    
    local endPoint = pTouch:getLocation()
    if fabs(endPoint.x - self.m_startPoint.x) > 10 or fabs(endPoint.y - self.m_startPoint.y) > 10 then
        return
    end

    for i,infoNode in ipairs(self.m_infoNodes) do
        
        if infoNode:isVisible() and i~= self.selectIndex then
            local bg = infoNode:getChildByTag(15)
            if isTouchInside(bg, pTouch) then
                local skinInfo = self.infos[i]
                if skinInfo then
                    self(skinInfo)
                    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
                end
                return
            end
        end
    end
    return
end

function PictureBookCell:foreverSkinAcitivate(info)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local isEnough,idGearVec ,itemid = self:getIsEnoughAndGearVecForActive(false,info)
    local skinId = ""
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        skinId = info.m_heroSkinId
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        skinId = info.m_armySkinId
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        skinId = info.m_mechaSkinId
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        skinId = info.m_citySkinId
    end

    if itemid and itemid ~= "" then
        local cmd = drequire("net.command.PictureBookActiveCommand").new(skinId, itemid)
        if cmd then
            cmd:send()
            self.m_activationBtn:setTouchEnabled(false)
        end
    end
end

function PictureBookCell:UseSkin()
    if self.Parent then
        self.Parent:onUseBtnClick()
    end
end

function PictureBookCell:onUpSkin()
    if self.Parent then
        self.Parent:onUpBtnClick()
    end
end

function PictureBookCell:onGoToShop(info)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local pathWay = ""
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", info.m_heroSkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", info.m_armySkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", info.m_mechaSkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", info.m_citySkinId, "skin_btn")
    end
    local sourceNode = PictureBookSourceView:create()
    sourceNode:setGroupId("skinSource")
    sourceNode:setPathWay(pathWay)
    sourceNode:onInitUpdateViewData()
    -- self:onUpdateGearsNodeState(false)
    PopupViewController:getInstance():addPopupView(sourceNode, true)
end

function PictureBookCell:onGoToLimitActiveView(info)
    local limitActiveView = PictureBookLimitActiveView:create(info,self.m_type)
    PopupViewController:getInstance():addPopupView(limitActiveView, true)
end


--激活
function PictureBookCell:onClicActivationBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local info = self.infos[self.selectIndex]
    if self.state and info then
        self.state.onActivation(self,nil,info)
    end
end

--获取
function PictureBookCell:onClickExchangeBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local info = self.infos[self.selectIndex]
    if self.state and info then
        self.state.onExchange(self,nil,info)                                                                                                                                                                                                                                                                         
    end
end

--使用
function PictureBookCell:onClickUseBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if self.state then
        self.state.onUse(self,nil,nil)                                                                                                                                                                                                                                                                         
    end
end

--卸下
function PictureBookCell:onClickUnsnatchBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if self.state then
        self.state.onUse(self,nil,nil)                                                                                                                                                                                                                                                                         
    end
end

--强化
function PictureBookCell:onClickStrengthenBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if self.state then
        self.state.onStrengthen(self,nil,nil)                                                                                                                                                                                                                                                                         
    end
end

return PictureBookCell
