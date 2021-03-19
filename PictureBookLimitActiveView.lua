-- 限时图鉴激活和获取
local PictureBookLimitActiveCell = drequire("view.popup.pictureBookView.PictureBookLimitActiveCell")
local PictureBookSourceView = drequire("view.popup.pictureBookView.PictureBookSourceView")
local PictureBookLimitActiveView = class("PictureBookLimitActiveView", function (  )
    return PopupBaseView:create()
end)
function PictureBookLimitActiveView:ctor()
    self.m_viewDataArray = {}
end

function PictureBookLimitActiveView:dtor()
    if self.m_updateId then
        self:getScheduler():unscheduleScriptEntry(self.m_updateId)
        self.m_updateId = nil
    end
end

function PictureBookLimitActiveView:create(info,type)
    local ret = PictureBookLimitActiveView.new()
    if ret and ret:initView(info,type) then
        return ret
    end
    CC_SAFE_DELETE(ret)
    return nil
end

function PictureBookLimitActiveView:initView(info,type)
    if not self:initBase() then
        return false
    end
    CCLoadSprite:doResourceByCommonIndex(1105, true, true)
    self:setCleanFunction(function ()
        CCLoadSprite:doResourceByCommonIndex(1105, false, true)
    end)
    local node = CCBLoadFile("PictureBookLimitActiveView", self, self)
    self:setContentSize(SCREEN_SIZE)
    self.m_sourceTitle:setString(_lang("3621023"))
    self.info = info
    self.m_type = type

    if info.m_skinAcitivate ~= mm.skinTimeType.EM_None_Skin_Type then
        if self.m_updateId == nil then
            self.m_updateId = self:getScheduler():scheduleScriptFunc(handler(self, PictureBookLimitActiveView.onSkinEndTime), 1.0, false)
            self:onSkinEndTime()
        end 
    end

    self:onInitUpdateViewData(info)

    return true
end

function PictureBookLimitActiveView:onSkinEndTime(dt)
    if self.info.m_timeOut then
        local curTime = GlobalData:shared():getTimeStamp()
        local durationTime = self.info.m_timeOut - curTime
        if durationTime > 0 then
            self.m_timeLabel:setString(CC_SECTOA(durationTime))
            self.m_timeLabel:setVisible(true)
        else
            self.m_timeLabel:setVisible(false)
        end
    else
        self.m_timeLabel:setVisible(false)
    end

end

function PictureBookLimitActiveView:onEnter()
    self:setTouchEnabled(true)
end

function PictureBookLimitActiveView:onExit()
end

function PictureBookLimitActiveView:onTouchBegan(pTouch, pEvent)
    if self.m_tabView:isDragging() then
        return false
    end
    return true
end

function PictureBookLimitActiveView:onTouchMoved(pTouch, pEvent)
end

function PictureBookLimitActiveView:onTouchEnded(pTouch, pEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if not isTouchInside(self.m_touchNode, pTouch) then
        self:closeSelf()
    end
end

--#pragma mark********************* tableview ****************
function PictureBookLimitActiveView:tableCellSizeForIndex(tablePram, idx)
    return 552, 100
end

function PictureBookLimitActiveView:cellSizeForTable(tablePram)
    return 552, 100
end
function PictureBookLimitActiveView:tableCellAtIndex(tablePram, idx)

    local cell = tablePram:dequeueCell()
    local toolID = self.m_viewDataArray[idx+1]
    if cell then
        cell:setData(toolID,self)
    else
        cell = PictureBookLimitActiveCell:create()
        cell:setData(toolID,self)
    end
    return cell
end
function PictureBookLimitActiveView:numberOfCellsInTableView(tablePram)
    local num = table.nums(self.m_viewDataArray)
    return num
end
function PictureBookLimitActiveView:tableCellWillRecycle(tablePram, cell)
end

function PictureBookLimitActiveView:onCloseBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    self:closeSelf()
end

function PictureBookLimitActiveView:onInitUpdateViewData(info)
   
    -- self.m_sourceTitle:setString(_lang(self.m_name))
    local idGearVec = info.m_gearVec
    if idGearVec then
        for i,itemId in ipairs(idGearVec) do
            local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(idGearVec[i]))
            if toolInfo.type == mm.ItemType.ITEM_TYPE_SPECIFIED_SKIN then
                table.insert(self.m_viewDataArray, idGearVec[i])
            end
        end
    end

    self.m_tabView = cc.TableView:create(self.m_listNode:getContentSize())
    self.m_tabView:setDirection(kCCScrollViewDirectionVertical)
    self.m_tabView:setVerticalFillOrder(kCCTableViewFillTopDown)
    self.m_tabView:setDelegate()
    self.m_tabView:registerScriptHandler(handler(self, PictureBookLimitActiveView.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_tabView:registerScriptHandler(handler(self, PictureBookLimitActiveView.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.m_tabView:registerScriptHandler(handler(self, PictureBookLimitActiveView.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.m_tabView:registerScriptHandler(handler(self, PictureBookLimitActiveView.tableCellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_tabView:reloadData()

    self.m_listNode:addChild(self.m_tabView)
end


function PictureBookLimitActiveView:onGoToShop()
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local pathWay = ""
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", self.info.m_heroSkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", self.info.m_armySkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", self.info.m_mechaSkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", self.info.m_citySkinId, "skin_btn")
    end
    local sourceNode = PictureBookSourceView:create()
    sourceNode:setGroupId("skinSource")
    sourceNode:setPathWay(pathWay)
    sourceNode:onInitUpdateViewData()
    -- self:onUpdateGearsNodeState(false)
    PopupViewController:getInstance():addPopupView(sourceNode, true)
end

function PictureBookLimitActiveView:Activation(toolID)
    if toolID ~= "" then
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(toolID))
        if toolInfo:getCNT() < 1 then
            CCCommonUtils:flyHint("", "", _lang("102198"))
            self:closeSelf()
            return
        end

        local skinId = ""
        if self.m_type == mm.skinType.EM_Hero_Skin_Type then
            skinId = self.info.m_heroSkinId
        elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
            skinId = self.info.m_armySkinId
        elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
            skinId = self.info.m_mechaSkinId
        elseif self.m_type == mm.skinType.EM_City_Skin_Type then
            skinId = self.info.m_citySkinId
        end

        local cmd = drequire("net.command.PictureBookActiveCommand").new(skinId, toolID)
        if cmd then
            cmd:send()
        end
        self:closeSelf()
    end
end

return PictureBookLimitActiveView
