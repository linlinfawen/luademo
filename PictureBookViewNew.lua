--
--  PictureBookView.cpp
--  WarZ
--
--  Created by wuyang on 18/9/4.
--
--
local Mech = drequire("view.mech.Mech")
local PictureBookTab = drequire("view.popup.pictureBookView.PictureBookTab")
local PictureBookCell = drequire("view.popup.pictureBookView.PictureBookCell")
local PictureBookGroupView = drequire("view.popup.pictureBookView.PictureBookGroupView")
local PictureBookUpAndDownCommand = drequire("net.command.PictureBookUpAndDownCommand")
local PictureBookUpStartCommand = drequire("net.command.PictureBookUpStartCommand")
local PictureBookSourceView = drequire("view.popup.pictureBookView.PictureBookSourceView")
local PictureBookSuccessView = drequire("view.popup.pictureBookView.PictureBookSuccessView")
local PictureBookView = class("PictureBookView", function (  )
    return PopupBaseView:create()
end)

local cellHeight = 198
local cellDesHeight = 167

local numberOfCellsInTableViewFormTable = function(datas)
    if not datas then
        return 0
    end

    if table.nums(datas) == 0 then
        return 0
    elseif table.nums(datas) <= 4 then
        return 1
    end
    return math.ceil(table.nums(datas) / 4)
end

local tableInfosFormTable = function(datas,idx,chooseIndex)
    local infos = {nil,nil,nil,nil}
    local selectIndex = -1

    if not datas or table.nums(datas) == 0 then
        return {}
    end

    for i=0,3 do
        local index = idx * 3  + i + 1 * idx

        if chooseIndex == index then
            selectIndex = i + 1
        end

        if index <= table.nums(datas) then
            table.insert(infos, datas[index+1])
        end
    end

    return infos,selectIndex
end


local MainCitySkin = drequire("scene.cropscence.MainCitySkin")
function PictureBookView:create(type)
    local ret = PictureBookView.new(type)
    if ret and ret:initView() then
        return ret
    end
    return nil
end

function PictureBookView:ctor(type )
    self.m_type = type
    self.m_gear = 1
    self.m_isShowGear = false
    self.m_guideBookTab = nil
    self.m_cellIndex = 0
    self.m_cellNum = 0
    self.m_offsetNum = 0
    self.m_index = 0
    self.m_useType = 0
    self.m_status = 0
    self.m_isCanUpStart = false
    self.m_heroPageVec = {}
    self.m_armyPageVec = {}
    self.m_mechaPageVec = {}
    self.m_cityPageVec = {}
    self.m_gearsVec = {}
end

function PictureBookView:initView()
    if not self:initBase() then
        return false
    end
    CCLoadSprite:doResourceByCommonIndex(11, true, true)
    CCLoadSprite:doResourceByCommonIndex(1103, true, true)
    CCLoadSprite:doResourceByCommonIndex(1105, true, true)
    CCLoadSprite:doResourceByCommonIndex(1024, true, true)
    CCLoadSprite:doResourceByCommonIndex(1229, true, true)
    CCLoadSprite:doResourceByPath("Common/HeroDetails.plist", true, true)
    CCLoadSprite:doResourceByPath("Common/SkinPNG.plist", true, true)
    CCLoadSprite:doResourceByCommonIndex(1111, true, true)
    CCLoadSprite:doResourceByPath("Common/TowerEmbattle.plist", true, true)
    self:setCleanFunction(function ()
        CCLoadSprite:doResourceByCommonIndex(11, false, true)
        CCLoadSprite:doResourceByCommonIndex(1103, false, true)
        CCLoadSprite:doResourceByCommonIndex(1105, false, true)
        CCLoadSprite:doResourceByPath("Common/HeroDetails.plist", false, true)
        CCLoadSprite:doResourceByPath("Common/SkinPNG.plist", false, true)
        CCLoadSprite:doResourceByCommonIndex(1024, false, true)
        CCLoadSprite:doResourceByCommonIndex(1111, false, true)
        CCLoadSprite:doResourceByCommonIndex(1229, false, true)
        CCLoadSprite:doResourceByPath("Common/TowerEmbattle.plist", false, true)
    end)
    CCBLoadFile("IllustrationInterfaceNew", self, self)
    self.m_needNode:setVisible(false)
    self:setModelLayerOpacity(0)
    self:setContentSize(self.m_mainNode:getContentSize())
    local dh = mm.DEF_HEIGHT - cc.Director:getInstance():getWinSize().height
    if dh >= 0 then
        if self.m_type == mm.skinType.EM_Mecha_Skin_Type then  --由于机甲是3D模型，所以要单独适配
            self.m_uiBgNode:setPositionY(self.m_uiBgNode:getPositionY() - dh)
        end
        self.m_propertyNode:setPositionY(self.m_propertyNode:getPositionY() + dh)
        self.m_propertyNode:setScale(cc.Director:getInstance():getWinSize().height / mm.DEF_HEIGHT)
    else
        if self.m_type == mm.skinType.EM_Mecha_Skin_Type then  --由于机甲是3D模型，所以要单独适配
            self.m_uiBgNode:setPositionY(self.m_uiBgNode:getPositionY() - dh)
        end
    end

    self.m_attributeVec = {self.m_attribute1, self.m_attribute2, self.m_attribute3, self.m_attribute4}
    self.m_attributeValueVec = {self.m_attributeValue1, self.m_attributeValue2, self.m_attributeValue3, self.m_attributeValue4}
    self.m_attributeMaxValueVec = {self.m_attributeMaxValue1, self.m_attributeMaxValue2, self.m_attributeMaxValue3, self.m_attributeMaxValue4}
    self.m_startShowVec = {self.m_startShow1, self.m_startShow2, self.m_startShow3, self.m_startShow4, self.m_startShow5, self.m_startShow6}
    self.m_curVec = {self.m_cur1Label, self.m_cur2Label, self.m_cur3Label, self.m_cur4Label}
    self.m_curValueVec = {self.m_value1Label, self.m_value2Label, self.m_value3Label, self.m_value4Label}
    self.m_nextVec = {self.m_next1Label, self.m_next2Label, self.m_next3Label, self.m_next4Label}
    self.m_nextValueVec = {self.m_nextValue1Label, self.m_nextValue2Label, self.m_nextValue3Label, self.m_nextValue4Label}
    self.m_startSpriteVec = {self.m_startSprite1, self.m_startSprite2, self.m_startSprite3, self.m_startSprite4, self.m_startSprite5, self.m_startSprite6}
    self.m_proNodeVec = {self.m_proNode1, self.m_proNode2, self.m_proNode3, self.m_proNode4}
    self.m_attrNodeVec = {self.m_attrNode1, self.m_attrNode2, self.m_attrNode3, self.m_attrNode4}
    self.m_showStarNodeVec = {self.m_showStarNode1, self.m_showStarNode2, self.m_showStarNode3, self.m_showStarNode4, self.m_showStarNode5, self.m_showStarNode6}

    self.m_propertyTitle:setString(_lang("3621022"))
    self.m_propertyTitle:setMaxScaleXByWidth(130)
    CCCommonUtils:setButtonTitle(self.m_shopBtn, _lang("3621151"))
    CCCommonUtils:setButtonTitle(self.m_useBtn, _lang("501184"))
    CCCommonUtils:setButtonTitle(self.m_goToUpBtn, _lang("7100366"))
    CCCommonUtils:setButtonTitle(self.m_exchangeBtn, _lang("128106"))
    CCCommonUtils:setButtonTitle(self.m_upBtn, _lang("7100366"))
    CCCommonUtils:setButtonTitle(self.m_cancelBtn, _lang("101106"))
    CCCommonUtils:setButtonTitle(self.m_desBtn, _lang("105245"))
    self.m_numNeedTxt:setString(_lang("3621034"))
    self.m_titleTxt:setString(_lang("3621142"))
    self.m_titleTxt:setMaxScaleXByWidth(550)
    self.m_labelStrengthen:setString(_lang("3800036"))
    self.m_detailTitleTxt:setString(_lang("3800037"))

    --适配
    local dh = mm.DEF_HEIGHT - cc.Director:getInstance():getWinSize().height
    local viewSzie = CCSize(self.m_mainListNode:getContentSize().width, self.m_mainListNode:getContentSize().height - dh)
    self.m_mainListNode:setContentSize(viewSzie)
    self.m_PBlistBg:setContentSize(viewSzie)
    self.m_mainListNode:setPositionY(dh)
    self.m_PBlistNode:setContentSize(self.m_PBlistNode:getContentSize().width, self.m_PBlistNode:getContentSize().height - dh)

    self.m_tabView = cc.TableView:create(self.m_PBlistNode:getContentSize())
    self.m_tabView:setDirection(kCCScrollViewDirectionVertical)
    self.m_tabView:setVerticalFillOrder(kCCTableViewFillTopDown)
    self.m_tabView:setDelegate()
    -- self.m_tabView:registerScriptHandler(handler(self, PictureBookView.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.m_tabView:registerScriptHandler(handler(self, PictureBookView.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.m_tabView:registerScriptHandler(handler(self, PictureBookView.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.m_tabView:registerScriptHandler(handler(self, PictureBookView.tableCellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
    -- self.m_tabView:registerScriptHandler(handler(self, PictureBookView.tableCellTouched), cc.TABLECELL_TOUCHED)
    self.m_tabView:registerScriptHandler(handler(self, PictureBookView.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.m_tabView:reloadData()
    self.m_tabView:setTouchEnabled(true)
    self.m_PBlistNode:addChild(self.m_tabView)

    --cell数量数、cell的宽度
    self.m_cellIndex = 0;  --当前选项
    self.m_cellNum = 0;  --cell数量
    self.m_leftBtn:setVisible(false)
    self.m_menuArrow:setRotation(0)
    self.m_offsetNum = self.m_PBlistNode:getContentSize().width / 120
    self.m_leftBtn:setVisible(false)
    self.m_rightBtn:setVisible(self.m_cellNum > self.m_offsetNum)
    return true
end

function PictureBookView:onEnter()
    self:setHideSceneWhenShow(true)
    self:setTouchEnabled(true)
    self:setIsShowConfirm(false)
    self.m_index = 0
    self:onInitUpdateViewData()
    self.m_tabView:reloadData()
    self:onUpdateGearsNodeState(false)
    if self.m_updateId == nil then
        self.m_updateId = self:getScheduler():scheduleScriptFunc(handler(self, PictureBookView.onSkinEndTime), 1.0, false)
    end 
    CCSafeNotificationCenter:sharedNotificationCenter():registerScriptObserver(self, PictureBookView.onUpdateViewData, mm.UPDATE_SKIN_DATA_EVEN, nil)
    CCSafeNotificationCenter:sharedNotificationCenter():registerScriptObserver(self, PictureBookView.onUpdateUpOrDownData, mm.UP_OR_DOWN_SKIN_DATA_EVEN, nil)
    CCSafeNotificationCenter:sharedNotificationCenter():registerScriptObserver(self, PictureBookView.onInitSuccessViewData, mm.UPDATE_SUCCESS_SKIN_DATA_EVEN, nil)
    self:setTitleName(_lang("3621030"))
    
    -- local cmd = drequire("net.command.PictureBookCommand").new()
    -- if cmd then
    --     cmd:send()
    -- end
end

function PictureBookView:onExit()
    self:setTouchEnabled(false)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.UPDATE_SKIN_DATA_EVEN)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.UP_OR_DOWN_SKIN_DATA_EVEN)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.UPDATE_SUCCESS_SKIN_DATA_EVEN)
    if self.m_updateId then
        self:getScheduler():unscheduleScriptEntry(self.m_updateId)
    end
end

function PictureBookView:moveSkinView()
    if #self.m_heroPageVec > 5 and GuideController:share():isInTutorial() then
        local index = 0
        for i,v in ipairs(self.m_heroPageVec) do
            if v.m_heroSkinId == "1012015202" and v.m_skinType == 0 then
                index = index - self.m_offsetNum + 1
                self.m_tabView:setContentOffset(ccp(-(index * 120), 0))
                break
            end
            index = index + 1
        end
    end
end

function PictureBookView:onTouchBegan(pTouch, pEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if not isTouchInside(self.m_ruleNode, pTouch) then
        UIComponent:getInstance():setUiTitleVisible(true)
        self.m_ruleNode:setVisible(false)
    end
    return false
end

function PictureBookView:onTouchEnded(touch, event)
    
end

function PictureBookView:onCloseEvent(pSender, pCCControlEvent)
    UIComponent:getInstance():setUiTitleVisible(true)
    if self.m_ruleNode:isVisible() then
        SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
        self.m_ruleNode:setVisible(false)
    else
        if self.m_upNode:isVisible() then
            SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
            self.m_upNode:setVisible(false)
        end
    end
end

function PictureBookView:onCloseInfdEvent(pSender, pCCControlEvent)
    if self.m_ruleNode:isVisible() then
        SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
        UIComponent:getInstance():setUiTitleVisible(true)
        self.m_ruleNode:setVisible(false)
    end
end


function PictureBookView:pageViewEvent(pSender, type)
    self:onPropertyChange()
    self:onStartData()
end

function PictureBookView:onLeftBtnClick(pSender, pCCControlEvent)
    -- if self.m_cellIndex <= 0 then
    --     return
    -- end
    -- self.m_rightBtn:setVisible(true)
    -- self.m_tabView:getContainer():stopAllActions()
    -- self.m_cellIndex = self.m_cellIndex - 1
    -- self.m_tabView:setContentOffset(ccp(-(self.m_cellIndex * 120), 0))
    -- self.m_leftBtn:setVisible(not (self.m_cellIndex == 0))
end
function PictureBookView:onRightBtnClick(pSender, pCCControlEvent)
    -- if self.m_cellIndex + self.m_offsetNum >= self.m_cellNum then
    --     return
    -- end
    -- self.m_leftBtn:setVisible(true)
    -- self.m_tabView:getContainer():stopAllActions()
    -- self.m_cellIndex = self.m_cellIndex + 1
    -- self.m_tabView:setContentOffset(ccp(-(self.m_cellIndex * 120), 0))
    -- self.m_rightBtn:setVisible(not (self.m_cellIndex + self.m_offsetNum == self.m_cellNum))
end
function PictureBookView:scrollViewDidScroll(view)
    -- if self.m_cellNum > self.m_offsetNum then
        local y = self.m_tabView:getContentOffset().y
        print("scrollViewDidScroll y=",y)
        -- if x > 0 then
        --     self.m_leftBtn:setVisible(false)
        --     self.m_rightBtn:setVisible(true)
        --     return
        -- end
        -- local cellIndex = abs(self.m_tabView:getContentOffset().x / 120)
        -- if cellIndex <= 0 then
        --     self.m_leftBtn:setVisible(false)
        --     self.m_rightBtn:setVisible(true)
        -- elseif cellIndex > 0 and (cellIndex + self.m_offsetNum < self.m_cellNum - 1) then
        --     self.m_leftBtn:setVisible(true)
        --     self.m_rightBtn:setVisible(true)
        -- else
        --     self.m_leftBtn:setVisible(true)
        --     self.m_rightBtn:setVisible(false)
        -- end
    -- end
end
function PictureBookView:scrollViewEndScroll(view)
    -- if self.m_cellNum > self.m_offsetNum then
    --     local x = self.m_tabView:getContentOffset().x
    --     if x > 0 then
    --         self.m_leftBtn:setVisible(false)
    --         self.m_rightBtn:setVisible(true)
    --         self.m_cellIndex = 0
    --         return
    --     end
    --     local cellIndex = abs(self.m_tabView:getContentOffset().x / 120)
    --     if cellIndex <= 0 then
    --         self.m_cellIndex = 0
    --     elseif cellIndex > 0 and (cellIndex + self.m_offsetNum < self.m_cellNum - 1) then
    --         self.m_cellIndex = cellIndex
    --     else
    --         self.m_cellIndex = self.m_cellNum - self.m_offsetNum
    --     end
    -- end
end
--#pragma mark********************* tableview ****************
function PictureBookView:tableCellSizeForIndex(tablePram, idx)

    if math.floor(self.m_index / 4) == idx then
        return SCREEN_SIZE.width,cellHeight+cellDesHeight
    else
        return SCREEN_SIZE.width,cellHeight
    end    
end

function PictureBookView:tableCellAtIndex(tablePram, idx)
    local cell = tablePram:dequeueCell()

    local skinInfos,selectIndex = {},0

    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        skinInfos,selectIndex = tableInfosFormTable(self.m_heroPageVec,idx,self.m_index)
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        skinInfos,selectIndex = tableInfosFormTable(self.m_armyPageVec,idx,self.m_index)
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        skinInfos,selectIndex = tableInfosFormTable(self.m_mechaPageVec,idx,self.m_index)
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        skinInfos,selectIndex = tableInfosFormTable(self.m_cityPageVec,idx,self.m_index)
    end

    print("skinInfos num=",idx,#skinInfos)
    if cell then
        cell:setData(skinInfos,selectIndex,self.m_type)
    else
        cell = PictureBookCell:create(skinInfos,tablePram,selectIndex,self.m_type,self)
        getmetatable(cell).__call = handler(self, PictureBookView.onCellBtnClick)
    end
    return cell
end

function PictureBookView:numberOfCellsInTableView(tablePram)
    local num = 0
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        num = numberOfCellsInTableViewFormTable(self.m_heroPageVec)
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        num = numberOfCellsInTableViewFormTable(self.m_armyPageVec)
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        num = numberOfCellsInTableViewFormTable(self.m_mechaPageVec)
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        num = numberOfCellsInTableViewFormTable(self.m_cityPageVec)
    end
    self.m_cellNum = num
    return num
end

function PictureBookView:tableCellTouched(tablePram, cell)
    -- if not cell then
    --     return
    -- end
    -- local castCell = MMUtils:luaCast(cell, "PictureBookTab")
    -- if not castCell then
    --     return
    -- end
    -- SoundController:sharedSound():playEffects(mm.Music_Sfx_New_Page_Switch)

    -- self.m_index = cell:getIdx()
    -- self:onUpdateGearsNodeState(false)
    -- self:onInitUpdateViewData()
    -- self.m_tabView:reloadAndLocation()
    -- if self.m_guideBookTab then
    --     --开始下一步引导
    --     GuideController:share():next()
    -- end
end

function PictureBookView:tableCellWillRecycle(tablePram, cell)
end

function PictureBookView:ClickScrollToCellIndex()
    if self.m_cellNum > 1 then
        local tempCellNum = self.m_cellNum - 1
        local reciprocalCellNum = tempCellNum - math.floor(self.m_index / 4)
        if reciprocalCellNum <= 0 then
            self.m_tabView:setContentOffsetInDuration(ccp(0,0), 0.1)
        else
            local offsetY = (reciprocalCellNum + 1) * cellHeight + cellDesHeight - self.m_PBlistNode:getContentSize().height
            self.m_tabView:setContentOffsetInDuration(ccp(0,-offsetY), 0.1)
        end       
    end
end

--点击cell回调
function PictureBookView:onCellBtnClick(cell,info)

    if not info then
        return
    end

    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        for i,tInfo in ipairs(self.m_heroPageVec) do
            if info.m_heroSkinId == tInfo.m_heroSkinId then
                self.m_index = i - 1
                break
            end
        end
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        for i,tInfo in ipairs(self.m_armyPageVec) do
            if info.m_armySkinId == tInfo.m_armySkinId then
                self.m_index = i - 1
                break
            end
        end
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        for i,tInfo in ipairs(self.m_mechaPageVec) do
            if info.m_mechaSkinId == tInfo.m_mechaSkinId then
                self.m_index = i - 1
                break
            end
        end
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        for i,tInfo in ipairs(self.m_cityPageVec) do
            if info.m_citySkinId == tInfo.m_citySkinId then
                self.m_index = i - 1
                break
            end
        end
    end

    self:onUpdateGearsNodeState(false)
    self:onInitUpdateViewData()
    self.m_tabView:reloadAndLocation()
    self:ClickScrollToCellIndex()
    -- if self.m_guideBookTab then
    --     --开始下一步引导
    --     GuideController:share():next()
    -- end

end

function PictureBookView:onFetterBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local skinId = ""
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        skinId = self.m_heroPageVec[self.m_index + 1].m_heroSkinId
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        skinId = self.m_armyPageVec[self.m_index + 1].m_armySkinId
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        skinId = self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        skinId = self.m_cityPageVec[self.m_index + 1].m_citySkinId
    end
    local isExist = false
    local m_groupPictureVec = PictureBookController:getInstance().m_groupPictureVec
    for i=1,#m_groupPictureVec do
        for j=1,#m_groupPictureVec[i].m_skinIdVec do
            if skinId == m_groupPictureVec[i].m_skinIdVec[j] and m_groupPictureVec[i].m_show == true then
                isExist = true
            end
        end
    end
    if not isExist then
        CCCommonUtils:flyHint("", "", _lang("3700036"))
        return
    end
    PopupViewController:getInstance():addPopupInView(PictureBookGroupView:create(skinId))
end

function PictureBookView:onGetMenuClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    self.m_isShowGear = not self.m_isShowGear
    self:onUpdateGearsNodeState(self.m_isShowGear)
    self.m_menuArrow:setRotation(self.m_isShowGear and 180 or 0)
end

function PictureBookView:onExchangeBtnCilck(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local skinId = ""
    local idGearVec = {}
    local isCanActivate = false
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        skinId = self.m_heroPageVec[self.m_index + 1].m_heroSkinId
        idGearVec = self.m_heroPageVec[self.m_index + 1].m_gearVec
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        skinId = self.m_armyPageVec[self.m_index + 1].m_armySkinId
        idGearVec = self.m_armyPageVec[self.m_index + 1].m_gearVec
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        skinId = self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId
        idGearVec = self.m_mechaPageVec[self.m_index + 1].m_gearVec
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        skinId = self.m_cityPageVec[self.m_index + 1].m_citySkinId
        idGearVec = self.m_cityPageVec[self.m_index + 1].m_gearVec
    end
    local useItemString = CCCommonUtils:getXmlPropById("skinBase", skinId, "skin_item")
    local useNumString = CCCommonUtils:getXmlPropById("skinBase", skinId, "active")
    local itemId1 = self:onCheckSkinEnoughData(idGearVec, useNumString)
    if itemId1 ~= "" then
        
        local cmd = drequire("net.command.PictureBookActiveCommand").new(skinId, itemId1)
        if cmd then
            cmd:send()
        end
    end
end

function PictureBookView:onGoToShopBtnCilck(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local pathWay = ""
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", self.m_heroPageVec[self.m_index + 1].m_heroSkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", self.m_armyPageVec[self.m_index + 1].m_armySkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, "skin_btn")
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        pathWay = CCCommonUtils:getXmlPropById("skinBase", self.m_cityPageVec[self.m_index + 1].m_citySkinId, "skin_btn")
    end
    local sourceNode = PictureBookSourceView:create()
    sourceNode:setGroupId("skinSource")
    sourceNode:setPathWay(pathWay)
    sourceNode:onInitUpdateViewData()
    self:onUpdateGearsNodeState(false)
    PopupViewController:getInstance():addPopupView(sourceNode, true)
end

function PictureBookView:onUseBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Limit_Skin_Type then
            local entTime = self.m_heroPageVec[self.m_index + 1].m_timeOut
            local curTime = GlobalData:shared():getTimeStamp()
            local durationTime = entTime - curTime
            if durationTime > 0 then
                if self.m_heroPageVec[self.m_index + 1].m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
                    local cmd = PictureBookUpAndDownCommand.new(self.m_heroPageVec[self.m_index + 1].m_heroSkinId, mm.skinTimeType.EM_Down_Skin_Type)
                    if cmd then
                        cmd:send()
                    end
                else
                    local cmd = PictureBookUpAndDownCommand.new(self.m_heroPageVec[self.m_index + 1].m_heroSkinId, mm.skinTimeType.EM_Up_Skin_Type)
                    if cmd then
                        cmd:send()
                    end
                end
            else
                if PictureBookController:getInstance().m_heroPictureVec[self.m_index + 1].m_skinAcitivate ~= mm.skinTimeType.EM_None_Skin_Type then
                    PictureBookController:getInstance().m_heroPictureVec[self.m_index + 1].m_skinAcitivate = mm.skinTimeType.EM_None_Skin_Type
                    CCSafeNotificationCenter:sharedNotificationCenter():postNotification(mm.UPDATE_SKIN_DATA_EVEN)
                end
            end

        else
            if self.m_heroPageVec[self.m_index + 1].m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
                local cmd = PictureBookUpAndDownCommand.new(self.m_heroPageVec[self.m_index + 1].m_heroSkinId, mm.skinTimeType.EM_Down_Skin_Type)
                if cmd then
                    cmd:send()
                end
            else
                local cmd = PictureBookUpAndDownCommand.new(self.m_heroPageVec[self.m_index + 1].m_heroSkinId, mm.skinTimeType.EM_Up_Skin_Type)
                if cmd then
                    cmd:send()
                end
            end
        end
        if GuideController:share():isInTutorial() and self.m_guideBookTab then
            --开始下一步引导
            GuideController:share():next()
        end
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Limit_Skin_Type then
            local entTime = self.m_armyPageVec[self.m_index + 1].m_timeOut
            local curTime = GlobalData:shared():getTimeStamp()
            local durationTime = entTime - curTime
            if durationTime > 0 then
                if self.m_armyPageVec[self.m_index + 1].m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
                    local cmd = PictureBookUpAndDownCommand.new(self.m_armyPageVec[self.m_index + 1].m_armySkinId, mm.skinTimeType.EM_Down_Skin_Type)
                    if cmd then
                        cmd:send()
                    end
                else
                    local cmd = PictureBookUpAndDownCommand.new(self.m_armyPageVec[self.m_index + 1].m_armySkinId, mm.skinTimeType.EM_Up_Skin_Type)
                    if cmd then
                        cmd:send()
                    end
                end
            else
                if PictureBookController:getInstance().m_armyPictureVec[self.m_index + 1].m_skinAcitivate ~= mm.skinTimeType.EM_None_Skin_Type then
                    PictureBookController:getInstance().m_armyPictureVec[self.m_index + 1].m_skinAcitivate = mm.skinTimeType.EM_None_Skin_Type
                    CCSafeNotificationCenter:sharedNotificationCenter():postNotification(mm.UPDATE_SKIN_DATA_EVEN)
                end
            end
        else
            if self.m_armyPageVec[self.m_index + 1].m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
                local cmd = PictureBookUpAndDownCommand.new(self.m_armyPageVec[self.m_index + 1].m_armySkinId, mm.skinTimeType.EM_Down_Skin_Type)
                if cmd then
                    cmd:send()
                end
            else
                local cmd = PictureBookUpAndDownCommand.new(self.m_armyPageVec[self.m_index + 1].m_armySkinId, mm.skinTimeType.EM_Up_Skin_Type)
                if cmd then
                    cmd:send()
                end
            end
        end
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Limit_Skin_Type then
            local entTime = self.m_mechaPageVec[self.m_index + 1].m_timeOut
            local curTime = GlobalData:shared():getTimeStamp()
            local durationTime = entTime - curTime
            if durationTime > 0 then
                if self.m_mechaPageVec[self.m_index + 1].m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
                    local cmd = PictureBookUpAndDownCommand.new(self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, mm.skinTimeType.EM_Down_Skin_Type)
                    if cmd then
                        cmd:send()
                    end
                else
                    local cmd = PictureBookUpAndDownCommand.new(self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, mm.skinTimeType.EM_Up_Skin_Type)
                    if cmd then
                        cmd:send()
                    end
                end
            else
                if PictureBookController:getInstance().m_mechaPictureVec[self.m_index + 1].m_skinAcitivate ~= mm.skinTimeType.EM_None_Skin_Type then
                    PictureBookController:getInstance().m_mechaPictureVec[self.m_index + 1].m_skinAcitivate = mm.skinTimeType.EM_None_Skin_Type
                    CCSafeNotificationCenter:sharedNotificationCenter():postNotification(mm.UPDATE_SKIN_DATA_EVEN)
                end
            end
        else
            if self.m_mechaPageVec[self.m_index + 1].m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
                local cmd = PictureBookUpAndDownCommand.new(self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, mm.skinTimeType.EM_Down_Skin_Type)
                if cmd then
                    cmd:send()
                end
            else
                local cmd = PictureBookUpAndDownCommand.new(self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, mm.skinTimeType.EM_Up_Skin_Type)
                if cmd then
                    cmd:send()
                end
            end
        end
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Limit_Skin_Type then
            local entTime = self.m_cityPageVec[self.m_index + 1].m_timeOut
            local curTime = GlobalData:shared():getTimeStamp()
            local durationTime = entTime - curTime
            if durationTime > 0 then
                if self.m_cityPageVec[self.m_index + 1].m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
                    local cmd = PictureBookUpAndDownCommand.new(self.m_cityPageVec[self.m_index + 1].m_citySkinId, mm.skinTimeType.EM_Down_Skin_Type)
                    if cmd then
                        cmd:send()
                    end
                else
                    local skinId = ToolController:getInstance():getMaincitySkinId()
                    local ccbName = CCCommonUtils:getXmlPropById("status", skinId, "ccbName")
                    local skinPath = CCCommonUtils:getXmlPropById("skinBase", self.m_cityPageVec[self.m_index + 1].m_citySkinId, "effectart")

                    if skinId ~= "" and ccbName ~= skinPath then
                        CCCommonUtils:flyHint("", "", _lang("3700037"))
                    else
                        local cmd = PictureBookUpAndDownCommand.new(self.m_cityPageVec[self.m_index + 1].m_citySkinId, mm.skinTimeType.EM_Up_Skin_Type)
                        if cmd then
                            cmd:send()
                        end
                    end
                end
            else
                if PictureBookController:getInstance().m_cityPictureVec[self.m_index + 1].m_skinAcitivate ~= mm.skinTimeType.EM_None_Skin_Type then
                    PictureBookController:getInstance().m_cityPictureVec[self.m_index + 1].m_skinAcitivate = mm.skinTimeType.EM_None_Skin_Type
                    CCSafeNotificationCenter:sharedNotificationCenter():postNotification(mm.UPDATE_SKIN_DATA_EVEN)
                end
            end
        else
            if self.m_cityPageVec[self.m_index + 1].m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
                local cmd = PictureBookUpAndDownCommand.new(self.m_cityPageVec[self.m_index + 1].m_citySkinId, mm.skinTimeType.EM_Down_Skin_Type)
                if cmd then
                    cmd:send()
                end
            else
                local skinId = ToolController:getInstance():getMaincitySkinId()
                local ccbName = CCCommonUtils:getXmlPropById("status", skinId, "ccbName")
                local skinPath = CCCommonUtils:getXmlPropById("skinBase", self.m_cityPageVec[self.m_index + 1].m_citySkinId, "effectart")
                if skinId ~= "" and ccbName ~= skinPath then
                    CCCommonUtils:flyHint("", "", _lang("3700037"))
                else
                    local cmd = PictureBookUpAndDownCommand.new(self.m_cityPageVec[self.m_index + 1].m_citySkinId, mm.skinTimeType.EM_Up_Skin_Type)
                    if cmd then
                        cmd:send()
                    end
                end
            end
        end
    end
end

function PictureBookView:onRuleBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    self:onRuleData()
    self.m_ruleNode:setVisible(true)
end

function PictureBookView:onGoToUpBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    UIComponent:getInstance():setUiTitleVisible(false)
    self.m_upNode:setVisible(true)
end

function PictureBookView:onCancelBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    UIComponent:getInstance():setUiTitleVisible(true)
    self.m_upNode:setVisible(false)
end

function PictureBookView:onHideUpViewBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    UIComponent:getInstance():setUiTitleVisible(true)
    self.m_upNode:setVisible(false)
end

function PictureBookView:onDesBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        PopupViewController:getInstance():addPopupView(CommonTipsView:create(self.m_heroPageVec[self.m_index + 1].m_skinDes, ""))
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        PopupViewController:getInstance():addPopupView(CommonTipsView:create(self.m_armyPageVec[self.m_index + 1].m_skinDes, ""))
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        PopupViewController:getInstance():addPopupView(CommonTipsView:create(self.m_mechaPageVec[self.m_index + 1].m_skinDes, ""))
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        PopupViewController:getInstance():addPopupView(CommonTipsView:create(self.m_cityPageVec[self.m_index + 1].m_skinDes, ""))
    end
end

function PictureBookView:onUpBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local idLevelStr = ""
    local skinId = ""
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        idLevelStr = string.format("%s_%d", self.m_heroPageVec[self.m_index + 1].m_heroSkinId, MIN(self.m_heroPageVec[self.m_index + 1].m_currStartLevel + 1, self.m_heroPageVec[self.m_index + 1].m_maxStartLevel))
        skinId = self.m_heroPageVec[self.m_index + 1].m_heroSkinId
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        idLevelStr = string.format("%s_%d", self.m_armyPageVec[self.m_index + 1].m_armySkinId, MIN(self.m_armyPageVec[self.m_index + 1].m_currStartLevel + 1, self.m_armyPageVec[self.m_index + 1].m_maxStartLevel))
        skinId = self.m_armyPageVec[self.m_index + 1].m_armySkinId
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        idLevelStr = string.format("%s_%d", self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, MIN(self.m_mechaPageVec[self.m_index + 1].m_currStartLevel + 1, self.m_mechaPageVec[self.m_index + 1].m_maxStartLevel))
        skinId = self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        idLevelStr = string.format("%s_%d", self.m_cityPageVec[self.m_index + 1].m_citySkinId, MIN(self.m_cityPageVec[self.m_index + 1].m_currStartLevel + 1, self.m_cityPageVec[self.m_index + 1].m_maxStartLevel))
        skinId = self.m_cityPageVec[self.m_index + 1].m_citySkinId
    end
    if self.m_isCanUpStart then
        local cmd = PictureBookUpStartCommand.new(skinId)
        if cmd then
            cmd:send()
        end
    else
        CCCommonUtils:flyHint("", "", _lang("102198"))
    end
end

function PictureBookView:onDesHideBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    UIComponent:getInstance():setUiTitleVisible(true)
    self.m_ruleNode:setVisible(false)
end

function PictureBookView:onInitUpdateViewData()
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        self.m_heroPageVec = {}
        local m_heroPictureVec = PictureBookController:getInstance().m_heroPictureVec
        for i=1,#m_heroPictureVec do
            if m_heroPictureVec[i].m_show == true and self:isShowStartViewData(m_heroPictureVec[i]) then
                self.m_heroPageVec[#self.m_heroPageVec + 1] = m_heroPictureVec[i]
            end
        end
        self.m_useType = self.m_heroPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_heroPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        self.m_armyPageVec = {}
        local m_armyPictureVec = PictureBookController:getInstance().m_armyPictureVec
        for i=1,#m_armyPictureVec do
            if m_armyPictureVec[i].m_show == true and self:isShowStartViewData(m_armyPictureVec[i]) then
                self.m_armyPageVec[#self.m_armyPageVec + 1] = m_armyPictureVec[i]
            end
        end
        self.m_useType = self.m_armyPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_armyPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        self.m_mechaPageVec = {}
        local m_mechaPictureVec = PictureBookController:getInstance().m_mechaPictureVec
        for i=1,#m_mechaPictureVec do
            if m_mechaPictureVec[i].m_show == true and self:isShowStartViewData(m_mechaPictureVec[i]) then
                self.m_mechaPageVec[#self.m_mechaPageVec + 1] = m_mechaPictureVec[i]
            end
        end
        self.m_useType = self.m_mechaPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_mechaPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        self.m_cityPageVec = {}
        local m_cityPictureVec = PictureBookController:getInstance().m_cityPictureVec
        for i=1,#m_cityPictureVec do
            if m_cityPictureVec[i].m_show == true and self:isShowStartViewData(m_cityPictureVec[i]) then
                self.m_cityPageVec[#self.m_cityPageVec + 1] = m_cityPictureVec[i]
            end
        end
        self.m_useType = self.m_cityPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_cityPageVec[self.m_index + 1].m_skinAcitivate
    end

    self:onPropertyChange()
    self:onInitSkinView()
    self:onUpdateUpStartData()
    self:onUpdateBtnData()
    self:onStartData()
end


function PictureBookView:isShowStartViewData(data)
    -- if 1 then
    --     return true
    -- end

    --已经激活的图鉴不需要隐藏
    if data.m_skinAcitivate == mm.skinTimeType.EM_Up_Skin_Type 
    or data.m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then
        return true
    end

    --判断是否大于游戏时间
    if string.len(data.m_showStartTime) > 0 then
        local timeopenVec = CCCommonUtils:splitString(data.m_showStartTime, "-")
        local nowtime = CCCommonUtils:timeStampToDate(GlobalData:shared():getTimeStamp())
        local nowtimeVec = CCCommonUtils:splitString(nowtime, "  ")
        local timeday = CCCommonUtils:splitString(nowtimeVec[1], "-")
        local timetink = CCCommonUtils:splitString(nowtimeVec[2], ":")

        if not (atoi(timeday[1]) > atoi(timeopenVec[1]) or
            atoi(timeopenVec[1]) == atoi(timeday[1]) and atoi(timeday[2]) > atoi(timeopenVec[2]) or
            atoi(timeopenVec[1]) == atoi(timeday[1]) and atoi(timeopenVec[2]) == atoi(timeday[2]) and atoi(timeday[3]) > atoi(timeopenVec[3]) or
            atoi(timeopenVec[1]) == atoi(timeday[1]) and atoi(timeopenVec[2]) == atoi(timeday[2]) and atoi(timeopenVec[3]) == atoi(timeday[3]) and atoi(timetink[1]) > atoi(timeopenVec[4]) or
            atoi(timeopenVec[1]) == atoi(timeday[1]) and atoi(timeopenVec[2]) == atoi(timeday[2]) and atoi(timeopenVec[3]) == atoi(timeday[3]) and atoi(timeopenVec[4]) == atoi(timetink[1]) and atoi(timetink[2]) > atoi(timeopenVec[5]))
        then
            return false
        end

    end

    --判断赛季出现的时间
    if string.len(data.m_showStartLimitTime) > 0 then
        -- SeasonController:getInstance():getCurSeasonId()
        local LimitTimeVec = CCCommonUtils:splitString(data.m_showStartLimitTime, "_")
        if atoi(LimitTimeVec[2]) > 0 then
            if atoi(SeasonController:getInstance():getCurSeasonId()) >= atoi(LimitTimeVec[2]) then
                --赛季相同判断时间
                if atoi(SeasonController:getInstance():getCurSeasonId()) == atoi(LimitTimeVec[2]) then
                    if atoi(LimitTimeVec[3]) >= 0 then
                        local showStartTime = atoi(GlobalData:shared():getTimeStamp()) - atoi(LimitTimeVec[3]) 
                        if SeasonController:getInstance().m_curSeasonStartTime[atoi(LimitTimeVec[2])] then
                            local seasonStartTime = SeasonController:getInstance().m_curSeasonStartTime[atoi(LimitTimeVec[2])] / 1000
                            if showStartTime <= seasonStartTime then
                                return false
                            end
                        end
                    end   
                end    
            else
                return false    
            end
        end
    end

    return true
end

function PictureBookView:onInitSkinView()
    local offY = 40
    local offX = 0
    self.m_gearLabelVec = {}
    self.m_gearsVec = {}
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        for i=1,#self.m_heroPageVec[self.m_index + 1].m_gearVec do
            local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(self.m_heroPageVec[self.m_index + 1].m_gearVec[i]))
            if toolInfo.type ~= mm.ItemType.ITEM_TYPE_SKIN_ACTIVATE_DEBRIS then
                local gearsNode = self:onCreateNode(_lang(CCCommonUtils:getXmlPropById("goods", self.m_heroPageVec[self.m_index + 1].m_gearVec[i], "name")), i)
                self.m_menuNode:addChild(gearsNode)
                gearsNode:setVisible(false)
                gearsNode:setPosition(ccp(offX, offY * (i)))
                self.m_gearsVec[#self.m_gearsVec + 1] = gearsNode
            end
        end
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        for i=1,#self.m_armyPageVec[self.m_index + 1].m_gearVec do
            local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(self.m_armyPageVec[self.m_index + 1].m_gearVec[i]))
            if toolInfo.type ~= mm.ItemType.ITEM_TYPE_SKIN_ACTIVATE_DEBRIS then
                local gearsNode = self:onCreateNode(_lang(CCCommonUtils:getXmlPropById("goods", self.m_armyPageVec[self.m_index + 1].m_gearVec[i], "name")), i)
                self.m_menuNode:addChild(gearsNode)
                gearsNode:setVisible(false)
                gearsNode:setPosition(ccp(offX, offY * (i)))
                self.m_gearsVec[#self.m_gearsVec + 1] = gearsNode
            end
        end
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        for i=1,#self.m_mechaPageVec[self.m_index + 1].m_gearVec do
            local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(self.m_mechaPageVec[self.m_index + 1].m_gearVec[i]))
            if toolInfo.type ~= mm.ItemType.ITEM_TYPE_SKIN_ACTIVATE_DEBRIS then
                local gearsNode = self:onCreateNode(_lang(CCCommonUtils:getXmlPropById("goods", self.m_mechaPageVec[self.m_index + 1].m_gearVec[i], "name")), i)
                self.m_menuNode:addChild(gearsNode)
                gearsNode:setVisible(false)
                gearsNode:setPosition(ccp(offX, offY * (i)))
                self.m_gearsVec[#self.m_gearsVec + 1] = gearsNode
            end
        end
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        for i=1,#self.m_cityPageVec[self.m_index + 1].m_gearVec do
            local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(self.m_cityPageVec[self.m_index + 1].m_gearVec[i]))
            if toolInfo.type ~= mm.ItemType.ITEM_TYPE_SKIN_ACTIVATE_DEBRIS then
                local gearsNode = self:onCreateNode(_lang(CCCommonUtils:getXmlPropById("goods", self.m_cityPageVec[self.m_index + 1].m_gearVec[i], "name")), i)
                self.m_menuNode:addChild(gearsNode)
                gearsNode:setVisible(false)
                gearsNode:setPosition(ccp(offX, offY * (i)))
                self.m_gearsVec[#self.m_gearsVec + 1] = gearsNode
            end
        end
    end
end

function PictureBookView:onCreateNode(contentStr, tag)
    local gearsNode = CCNode:create()
    gearsNode:setContentSize(self.m_menuNode:getContentSize())
    local colorBg = CCLayerColor:create(ccc4(0, 0, 0, 255))
    colorBg:setContentSize(self.m_menuNode:getContentSize())
    gearsNode:addChild(colorBg)
    local clickBtn = CCControlButton:create(CCLoadSprite:createScale9Sprite("chuzheng_frame04.png"))
    clickBtn:setBackgroundSpriteForState(CCLoadSprite:createScale9Sprite("chuzheng_frame04.png"), CCControlStateHighlighted)
    clickBtn:setBackgroundSpriteForState(CCLoadSprite:createScale9Sprite("chuzheng_frame04.png"), CCControlStateDisabled)
    clickBtn:registerControlEventHandler(handler(self,PictureBookView.onSelectBtnClick), cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    clickBtn:setPreferredSize(self.m_menuNode:getContentSize())
    clickBtn:setAnchorPoint(ccp(0.5, 0.5))
    clickBtn:setPosition(ccp(colorBg:getContentSize().width / 2, colorBg:getContentSize().height / 2))
    gearsNode:addChild(clickBtn)
    clickBtn:setTag(tag)
    local contentLabel = CCRichLabelTTF:create("", self.m_propertyTitle:getFontName(), 18)
    contentLabel:setAnchorPoint(ccp(1, 0))
    contentLabel:setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
    contentLabel:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)
    contentLabel:setPosition(ccp(colorBg:getContentSize().width - 50, 8))
    gearsNode:addChild(contentLabel)
    contentLabel:setString(contentStr)
    contentLabel:setDimensions(CCSize(500, 0))
    local language = LocalController:shared():getLanguageFileName()
    if language ~= "zh_CN" and language ~= "zh_TW" then
        contentLabel:setScaleX(300 / contentLabel:getContentSize().width)
    end
    self.m_gearLabelVec[#self.m_gearLabelVec + 1] = contentLabel
    return gearsNode
end

function PictureBookView:onUpdateGearsNodeState(isShow)
    self.m_isShowGear = isShow
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        local useNumString = CCCommonUtils:getXmlPropById("skinBase", self.m_heroPageVec[self.m_index + 1].m_heroSkinId, "active")
        self:onInitSkinGearsData(self.m_heroPageVec[self.m_index + 1].m_gearVec, useNumString)
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        local useNumString = CCCommonUtils:getXmlPropById("skinBase", self.m_armyPageVec[self.m_index + 1].m_armySkinId, "active")
        self:onInitSkinGearsData(self.m_armyPageVec[self.m_index + 1].m_gearVec, useNumString)
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        local useNumString = CCCommonUtils:getXmlPropById("skinBase", self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, "active")
        self:onInitSkinGearsData(self.m_mechaPageVec[self.m_index + 1].m_gearVec, useNumString)
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        local useNumString = CCCommonUtils:getXmlPropById("skinBase", self.m_cityPageVec[self.m_index + 1].m_citySkinId, "active")
        self:onInitSkinGearsData(self.m_cityPageVec[self.m_index + 1].m_gearVec, useNumString)
    end
end
function PictureBookView:onInitSkinGearsData(dataVec, useNumString)
    local isNotEnough = false
    local totalStr = ""
    local totalNum = 0
    local needNum = atoi(useNumString)
    local itemColorStr = ""
    for i=1,#dataVec do
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[i]))
        if toolInfo.type ~= mm.ItemType.ITEM_TYPE_SPECIFIED_SKIN then  --如果不是兑换券
            local toolInfo1 = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[2]))
            itemColorStr = PictureBookController:getInstance():getStringColorByColorId(toolInfo.color)
            if toolInfo1:getCNT() < needNum then  ----当专属碎片不足时 ，需要显示万能碎片的数量
                isNotEnough = true
                if i == 2 then  --1表示第二个，默认是专属碎片
                    totalStr = totalStr.._lang(CCCommonUtils:getXmlPropById("goods", dataVec[i], "name"))
                    totalStr = totalStr.._lang_1("3621035", CC_ITOA(toolInfo:getCNT()))
                else
                    totalStr = totalStr.._lang_1(itemColorStr, CC_ITOA(toolInfo:getCNT()))
                end
                totalNum = totalNum + toolInfo:getCNT()
            end
        end
    end
    for i=1,#self.m_gearsVec do
        self.m_gearsVec[i]:setVisible(self.m_isShowGear)
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[i]))
        if toolInfo.type == mm.ItemType.ITEM_TYPE_SPECIFIED_SKIN then
            needNum = 1;  --因为是兑换点卷所以所需数量是1
            if toolInfo:getCNT() >= needNum then  --当兑换卷充足是，字体颜色为绿色 否则为红色
                self.m_gearLabelVec[i]:setString(_lang(CCCommonUtils:getXmlPropById("goods", dataVec[i], "name")) .. _lang_1("3621035", CC_ITOA(toolInfo:getCNT())) .. _lang_1("3621036", CC_ITOA(1)))
            else
                self.m_gearLabelVec[i]:setString(_lang(CCCommonUtils:getXmlPropById("goods", dataVec[i], "name")) .. _lang_1("3621035", CC_ITOA(toolInfo:getCNT())) .. _lang_1("3621037", CC_ITOA(1)))
            end
        else
            needNum = atoi(useNumString)
            if isNotEnough then
                if totalNum < needNum then  --当所需碎片大于专属碎片和万能碎片总和时字体颜色显示为红色  否则为绿色
                    if i == #self.m_gearsVec then
                        totalStr = totalStr.._lang_1("3621037", CC_ITOA(needNum))
                    end
                    self.m_gearLabelVec[i]:setString(totalStr)
                else
                    if i == #self.m_gearsVec then
                        totalStr = totalStr.._lang_1("3621036", CC_ITOA(needNum))
                    end
                    self.m_gearLabelVec[i]:setString(totalStr)
                end
            else
                self.m_gearLabelVec[i]:setString(_lang(CCCommonUtils:getXmlPropById("goods", dataVec[i], "name")) .. _lang_1("3621035", CC_ITOA(toolInfo:getCNT())) .. _lang_1("3621036", CC_ITOA(needNum)))
            end
        end
    end
    local toolInfo2 = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[self.m_gear]))
    if toolInfo2.type == mm.ItemType.ITEM_TYPE_SPECIFIED_SKIN then  --如果是兑换券  否则是碎片
        needNum = 1
        if toolInfo2:getCNT() >= needNum then  --当兑换卷充足是，字体颜色为绿色 否则为红色
            self.m_menuText:setString(_lang(CCCommonUtils:getXmlPropById("goods", dataVec[self.m_gear], "name")) .. _lang_1("3621035", CC_ITOA(toolInfo2:getCNT())) .. _lang_1("3621036", CC_ITOA(needNum)))
        else
            self.m_menuText:setString(_lang(CCCommonUtils:getXmlPropById("goods", dataVec[self.m_gear], "name")) .. _lang_1("3621035", CC_ITOA(toolInfo2:getCNT())) .. _lang_1("3621037", CC_ITOA(needNum)))
        end
    else
        needNum = atoi(useNumString)
        if isNotEnough then
            --            if totalNum < needNum then --当所需碎片大于专属碎片和万能碎片总和时字体颜色显示为红色  否则为绿色
            --                totalStr = totalStr.._lang_1("3621037",CC_ITOA(needNum))
            --                self.m_menuText:setString(totalStr)
            --            }else
            --                totalStr = totalStr.._lang_1("3621036",CC_ITOA(needNum))
            self.m_menuText:setString(totalStr)
            --            end
        else
            self.m_menuText:setString(_lang(CCCommonUtils:getXmlPropById("goods", dataVec[self.m_gear], "name")) .. _lang_1("3621035", CC_ITOA(toolInfo2:getCNT())) .. _lang_1("3621036", CC_ITOA(needNum)))
        end
    end
    self.m_menuText:setDimensions(CCSize(500, 0))
    local language = LocalController:shared():getLanguageFileName()
    if language ~= "zh_CN" and language ~= "zh_TW" then
        self.m_menuText:setScaleX(300.0 / self.m_menuText:getContentSize().width)
    end
end

function PictureBookView:onCheckSkinEnoughData(dataVec, useNumString)
    local isNotEnough = false
    local totalNum = 0
    local needNum = atoi(useNumString)
    local itemId = ""
    for i=1,#dataVec do
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[i]))
        if toolInfo.type ~= mm.ItemType.ITEM_TYPE_SPECIFIED_SKIN then  --如果不是兑换券
            local toolInfo1 = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[1]))
            if toolInfo1:getCNT() < needNum then  ----当专属碎片不足时 ，需要显示万能碎片的数量
                isNotEnough = true
                totalNum = totalNum + toolInfo:getCNT()
            end
        end
    end
    local toolInfo2 = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[self.m_gear]))
    if toolInfo2.type == mm.ItemType.ITEM_TYPE_SPECIFIED_SKIN then  --如果是兑换券  否则是碎片
        needNum = 1
        if toolInfo2:getCNT() >= needNum then  --当兑换卷充足是，字体颜色为绿色 否则为红色
            itemId = dataVec[self.m_gear]
        else
            CCCommonUtils:flyHint("", "", _lang("102198"))
        end
    else
        needNum = atoi(useNumString)
        if isNotEnough then
            if totalNum < needNum then  --当所需碎片大于专属碎片和万能碎片总和时字体颜色显示为红色  否则为绿色
                CCCommonUtils:flyHint("", "", _lang("102198"))
            else
                itemId = dataVec[2]
            end
        else
            itemId = dataVec[2]
        end
    end
    return itemId
end

function PictureBookView:onSelectBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    local button = MMUtils:luaCast(pSender, "CCControlButton")
    self.m_gear = button:getTag()
    self:onUpdateGearsNodeState(false)
end

function PictureBookView:onUpdateViewData(obj)
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        self.m_heroPageVec = {}
        --        self.m_heroPageVec = PictureBookController:getInstance().m_heroPictureVec
        local m_heroPictureVec = PictureBookController:getInstance().m_heroPictureVec
        for i=1,#m_heroPictureVec do
            if m_heroPictureVec[i].m_show == true and self:isShowStartViewData(m_heroPictureVec[i]) then
                self.m_heroPageVec[#self.m_heroPageVec + 1] = m_heroPictureVec[i]
            end
        end
        self.m_useType = self.m_heroPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_heroPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        --        self.m_armyPageVec = PictureBookController:getInstance().m_armyPictureVec
        self.m_armyPageVec = {}
        local m_armyPictureVec = PictureBookController:getInstance().m_armyPictureVec
        for i=1,#m_armyPictureVec do
            if m_armyPictureVec[i].m_show == true and self:isShowStartViewData(m_armyPictureVec[i]) then
                self.m_armyPageVec[#self.m_armyPageVec + 1] = m_armyPictureVec[i]
            end
        end
        self.m_useType = self.m_armyPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_armyPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        self.m_mechaPageVec = {}
        --        self.m_mechaPageVec = PictureBookController:getInstance().m_mechaPictureVec
        local m_mechaPictureVec = PictureBookController:getInstance().m_mechaPictureVec
        for i=1,#m_mechaPictureVec do
            if m_mechaPictureVec[i].m_show == true and self:isShowStartViewData(m_mechaPictureVec[i]) then
                self.m_mechaPageVec[#self.m_mechaPageVec + 1] = m_mechaPictureVec[i]
            end
        end
        self.m_useType = self.m_mechaPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_mechaPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        self.m_cityPageVec = {}
        --        self.m_cityPageVec = PictureBookController:getInstance().m_cityPictureVec
        local m_cityPictureVec = PictureBookController:getInstance().m_cityPictureVec
        for i=1,#m_cityPictureVec do
            if m_cityPictureVec[i].m_show == true and self:isShowStartViewData(m_cityPictureVec[i]) then
                self.m_cityPageVec[#self.m_cityPageVec + 1] = m_cityPictureVec[i]
            end
        end
        self.m_useType = self.m_cityPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_cityPageVec[self.m_index + 1].m_skinAcitivate
    end
    self.m_tabView:reloadAndLocation()
    self:moveSkinView()
    self:onPropertyChange()
    self:onUpdateUpStartData()
    self:onUpdateBtnData()
    self:onStartData()
end

function PictureBookView:onUpdateUpOrDownData(obj)
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        self.m_heroPageVec = {}
        --        self.m_heroPageVec = PictureBookController:getInstance().m_heroPictureVec
        local m_heroPictureVec = PictureBookController:getInstance().m_heroPictureVec
        for i=1,#m_heroPictureVec do
            if m_heroPictureVec[i].m_show == true and self:isShowStartViewData(m_heroPictureVec[i]) then
                self.m_heroPageVec[#self.m_heroPageVec + 1] = m_heroPictureVec[i]
            end
        end
        self.m_useType = self.m_heroPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_heroPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        --        self.m_armyPageVec = PictureBookController:getInstance().m_armyPictureVec
        self.m_armyPageVec = {}
        local m_armyPictureVec = PictureBookController:getInstance().m_armyPictureVec
        for i=1,#m_armyPictureVec do
            if m_armyPictureVec[i].m_show == true and self:isShowStartViewData(m_armyPictureVec[i]) then
                self.m_armyPageVec[#self.m_armyPageVec + 1] = m_armyPictureVec[i]
            end
        end
        self.m_useType = self.m_armyPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_armyPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        self.m_mechaPageVec = {}
        --        self.m_mechaPageVec = PictureBookController:getInstance().m_mechaPictureVec
        local m_mechaPictureVec = PictureBookController:getInstance().m_mechaPictureVec
        for i=1,#m_mechaPictureVec do
            if m_mechaPictureVec[i].m_show == true and self:isShowStartViewData(m_mechaPictureVec[i]) then
                self.m_mechaPageVec[#self.m_mechaPageVec + 1] = m_mechaPictureVec[i]
            end
        end
        self.m_useType = self.m_mechaPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_mechaPageVec[self.m_index + 1].m_skinAcitivate
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        self.m_cityPageVec = {}
        --        self.m_cityPageVec = PictureBookController:getInstance().m_cityPictureVec
        local m_cityPictureVec = PictureBookController:getInstance().m_cityPictureVec
        for i=1,#m_cityPictureVec do
            if m_cityPictureVec[i].m_show == true and self:isShowStartViewData(m_cityPictureVec[i]) then
                self.m_cityPageVec[#self.m_cityPageVec + 1] = m_cityPictureVec[i]
            end
        end
        self.m_useType = self.m_cityPageVec[self.m_index + 1].m_skinType
        self.m_status = self.m_cityPageVec[self.m_index + 1].m_skinAcitivate
    end
    self.m_tabView:reloadAndLocation()
    self:onUpdateBtnData()
    self:onStartData()
    if PictureBookController:getInstance().m_starLevelPlay > 0 then
        if PictureBookController:getInstance().m_starLevelPlay == 1 then
            self:getAnimationManager():setAnimationCompletedCallback(handler(self, PictureBookView.onplayNext))
            self:getAnimationManager():runAnimationsForSequenceNamed("1star")
        elseif PictureBookController:getInstance().m_starLevelPlay == 2 then
            self:getAnimationManager():setAnimationCompletedCallback(handler(self, PictureBookView.onplayNext))
            self:getAnimationManager():runAnimationsForSequenceNamed("2star")
        elseif PictureBookController:getInstance().m_starLevelPlay == 3 then
            self:getAnimationManager():setAnimationCompletedCallback(handler(self, PictureBookView.onplayNext))
            self:getAnimationManager():runAnimationsForSequenceNamed("3star")
        elseif PictureBookController:getInstance().m_starLevelPlay == 4 then
            self:getAnimationManager():setAnimationCompletedCallback(handler(self, PictureBookView.onplayNext))
            self:getAnimationManager():runAnimationsForSequenceNamed("4star")
        elseif PictureBookController:getInstance().m_starLevelPlay == 5 then
            self:getAnimationManager():setAnimationCompletedCallback(handler(self, PictureBookView.onplayNext))
            self:getAnimationManager():runAnimationsForSequenceNamed("5star")
        elseif PictureBookController:getInstance().m_starLevelPlay == 6 then
            self:getAnimationManager():setAnimationCompletedCallback(handler(self, PictureBookView.onplayNext))
            self:getAnimationManager():runAnimationsForSequenceNamed("6star")
        end
    end
end

function PictureBookView:onplayNext()
    PictureBookController:getInstance().m_starLevelPlay = 0
    if self:getAnimationManager():getLastCompletedSequenceName() ~= "play" then
        self:getAnimationManager():runAnimationsForSequenceNamed("play")
    end
end
--#pragma mark 加载皮肤ccb
function PictureBookView:onPropertyChange()
    if self.m_useType == mm.skinUseType.EM_Forever_Skin_Type then
        self.m_startNode:setVisible(true)
        self.m_limitSprite:setVisible(false)
        self.m_fetterSprite:setVisible(true)
        --        self.m_timeLabel:setVisible(false)
    else
        self.m_startNode:setVisible(false)
        self.m_limitSprite:setVisible(true)
        self.m_fetterSprite:setVisible(false)
        --        self.m_timeLabel:setVisible(true)
    end
    self:onSkinEndTime(0)
    self.m_limitImg:setVisible(false)
    for i=1,#self.m_proNodeVec do
        self.m_proNodeVec[i]:setVisible(false)
        self.m_attrNodeVec[i]:setVisible(false)
    end
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        self.m_redPointSprite:setVisible(PictureBookController:getInstance():isCanActivateSkinId(self.m_heroPageVec[self.m_index + 1].m_heroSkinId))
        local itemId = atoi(CCCommonUtils:getXmlPropById("skinBase", self.m_heroPageVec[self.m_index + 1].m_heroSkinId, "skin_exclusive"))
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(itemId)
        local itemColorString = PictureBookController:getInstance():getColorStringColorByColorId(toolInfo.color)
        self.m_comDebris:setString(_lang_1(itemColorString, toolInfo:getName()))
        self.m_comDebrisValue:setString(CC_ITOA(toolInfo:getCNT()))
        local limitStr = CCCommonUtils:getXmlPropById("skinBase", self.m_heroPageVec[self.m_index + 1].m_heroSkinId, "limit_img")

        if limitStr ~= "" then
            limitStr = limitStr..".png"
            self.m_limitImg:setSpriteFrame(CCLoadSprite:loadResource(limitStr))
            self.m_limitImg:setVisible(true)
        end
        local bgPath = CCCommonUtils:getXmlPropById("skinBase", self.m_heroPageVec[self.m_index + 1].m_heroSkinId, "img_Base") .. ".png"
        self.m_skinBg:setSpriteFrame(CCLoadSprite:loadResource(bgPath))
        local iconPath = toolInfo.icon .. ".png"
        self.m_itemIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
        local colorString = PictureBookController:getInstance():getColorStringColorByColorId(self.m_heroPageVec[self.m_index + 1].m_skinColor)
        self.m_skinBigNameLabel:setString(_lang_1(colorString, self.m_heroPageVec[self.m_index + 1].m_skinName))
        self.m_skeletonNode:removeAllChildren()
        local skeletonNode = CCCommonUtils:createSkeletonOrSprite(self.m_heroPageVec[self.m_index + 1].m_skeletonPath)
        self.m_skeletonNode:addChild(skeletonNode)
        local pos = CCCommonUtils:getXmlPropById("skinBase", self.m_heroPageVec[self.m_index + 1].m_heroSkinId, "pos")
        if pos ~= "" then 
            skeletonNode:setPosition(ccp(CCCommonUtils:pointFromString(pos)))
        end
        local count = 1
        for k,v in pairs(self.m_heroPageVec[self.m_index + 1].m_effectValueMap) do
            local contentString = _lang(GeneralManager:getInstance():getEffectNameById(tostring(k))) .. _lang("3700000")
            self.m_attributeVec[count]:setString(contentString)
            local numType = GeneralManager:getInstance():getPercentById(tostring(k))
            local effectValue = v
            if numType == mm.RoldNumType.EM_Percent_Type then
                self.m_attributeValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            elseif numType == mm.RoldNumType.EM_Permillage_Type then
                effectValue = effectValue / 10
                self.m_attributeValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            else
                self.m_attributeValueVec[count]:setString(string.format("%.f", effectValue))
            end
            if self.m_useType ~= mm.skinUseType.EM_Forever_Skin_Type then
                self.m_attributeMaxValueVec[count]:setVisible(false)
            else
                for k1,v1 in pairs(self.m_heroPageVec[self.m_index + 1].m_maxValueMap) do
                    --当非限时皮肤没满星时显示满星数据
                    if k1 == k then
                        self.m_attributeMaxValueVec[count]:setVisible(v1 > v)
                        local numType = GeneralManager:getInstance():getPercentById(tostring(k))
                        local effectValue = v1
                        if numType == mm.RoldNumType.EM_Percent_Type then
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%0.1f", effectValue) .. "%)")
                        elseif numType == mm.RoldNumType.EM_Permillage_Type then
                            effectValue = effectValue / 10
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%0.1f", effectValue) .. "%)")
                        else
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%.f", effectValue) .. ")")
                        end
                        break
                    end
                end
            end
            self.m_proNodeVec[count]:setVisible(true)
            self.m_attrNodeVec[count]:setVisible(true)
            count = count + 1
        end
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        self.m_redPointSprite:setVisible(PictureBookController:getInstance():isCanActivateSkinId(self.m_armyPageVec[self.m_index + 1].m_armySkinId))
        local itemId = atoi(CCCommonUtils:getXmlPropById("skinBase", self.m_armyPageVec[self.m_index + 1].m_armySkinId, "skin_exclusive"))
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(itemId)
        local itemColorString = PictureBookController:getInstance():getColorStringColorByColorId(toolInfo.color)
        self.m_comDebris:setString(_lang_1(itemColorString, toolInfo:getName()))
        self.m_comDebrisValue:setString(CC_ITOA(toolInfo:getCNT()))
        local limitStr = CCCommonUtils:getXmlPropById("skinBase", self.m_armyPageVec[self.m_index + 1].m_armySkinId, "limit_img")

        if limitStr ~= "" then
            limitStr = limitStr..".png"
            self.m_limitImg:setSpriteFrame(CCLoadSprite:loadResource(limitStr))
            self.m_limitImg:setVisible(true)
        end
        local iconPath = toolInfo.icon .. ".png"
        self.m_itemIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
        local bgPath = CCCommonUtils:getXmlPropById("skinBase", self.m_armyPageVec[self.m_index + 1].m_armySkinId, "img_Base") .. ".png"
        self.m_skinBg:setSpriteFrame(CCLoadSprite:loadResource(bgPath))
        local colorString = PictureBookController:getInstance():getColorStringColorByColorId(self.m_armyPageVec[self.m_index + 1].m_skinColor)
        self.m_skinBigNameLabel:setString(_lang_1(colorString, self.m_armyPageVec[self.m_index + 1].m_skinName))
        self.m_skeletonNode:removeAllChildren()
        local skeletonNode = CCCommonUtils:createSkeletonOrSprite(self.m_armyPageVec[self.m_index + 1].m_skeletonPath)
        self.m_skeletonNode:addChild(skeletonNode)
        local pos = CCCommonUtils:getXmlPropById("skinBase", self.m_armyPageVec[self.m_index + 1].m_armySkinId, "pos")
        if pos ~= "" then 
            skeletonNode:setPosition(ccp(CCCommonUtils:pointFromString(pos)))
        end
        local count = 1
        for k,v in pairs(self.m_armyPageVec[self.m_index + 1].m_effectValueMap) do
            local contentString = _lang(GeneralManager:getInstance():getEffectNameById(tostring(k))) .. _lang("3700000")
            self.m_attributeVec[count]:setString(contentString)
            local numType = GeneralManager:getInstance():getPercentById(tostring(k))
            local effectValue = v
            if numType == mm.RoldNumType.EM_Percent_Type then
                self.m_attributeValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            elseif numType == mm.RoldNumType.EM_Permillage_Type then
                effectValue = effectValue / 10
                self.m_attributeValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            else
                self.m_attributeValueVec[count]:setString(string.format("%.f", effectValue))
            end
            if self.m_useType ~= mm.skinUseType.EM_Forever_Skin_Type then
                self.m_attributeMaxValueVec[count]:setVisible(false)
            else
                for k1,v1 in pairs(self.m_armyPageVec[self.m_index + 1].m_maxValueMap) do
                    --当非限时皮肤没满星时显示满星数据
                    if k1 == k then
                        self.m_attributeMaxValueVec[count]:setVisible(v1 > v)
                        local numType = GeneralManager:getInstance():getPercentById(tostring(k))
                        local effectValue = v1
                        if numType == mm.RoldNumType.EM_Percent_Type then
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%0.1f", effectValue) .. "%)")
                        elseif numType == mm.RoldNumType.EM_Permillage_Type then
                            effectValue = effectValue / 10
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%0.1f", effectValue) .. "%)")
                        else
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%.f", effectValue) .. ")")
                        end
                        break
                    end
                end
            end
            self.m_proNodeVec[count]:setVisible(true)
            self.m_attrNodeVec[count]:setVisible(true)
            count = count + 1
        end
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        self.m_redPointSprite:setVisible(PictureBookController:getInstance():isCanActivateSkinId(self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId))
        local itemId = atoi(CCCommonUtils:getXmlPropById("skinBase", self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, "skin_exclusive"))
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(itemId)
        local itemColorString = PictureBookController:getInstance():getColorStringColorByColorId(toolInfo.color)
        self.m_comDebris:setString(_lang_1(itemColorString, toolInfo:getName()))
        self.m_comDebrisValue:setString(CC_ITOA(toolInfo:getCNT()))
        local limitStr = CCCommonUtils:getXmlPropById("skinBase", self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, "limit_img")
        if limitStr ~= "" then
            limitStr = limitStr..".png"
            self.m_limitImg:setSpriteFrame(CCLoadSprite:loadResource(limitStr))
            self.m_limitImg:setVisible(true)
        end
        local iconPath = toolInfo.icon .. ".png"
        self.m_itemIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
        local bgPath = CCCommonUtils:getXmlPropById("skinBase", self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, "img_Base") .. ".png"
        self.m_skinBg:setSpriteFrame(CCLoadSprite:loadResource(bgPath))
        local colorString = PictureBookController:getInstance():getColorStringColorByColorId(self.m_mechaPageVec[self.m_index + 1].m_skinColor)
        self.m_skinBigNameLabel:setString(_lang_1(colorString, self.m_mechaPageVec[self.m_index + 1].m_skinName))

        self.m_skeletonNode:removeAllChildren()
        
        local cameraUIBg = CameraController:shared():createCamera(mm.CAMERA_TYPE.CAMERA_UI_BG)
        if self:getChildByTag(777) == nil then
            self:addChild(cameraUIBg, 0, 777)
        end
        self.m_uiBgNode:setCameraMaskAndPass(mm.CameraMasks[mm.CAMERA_TYPE.CAMERA_UI_BG])
        local camera3D = CameraController:shared():createCamera(mm.CAMERA_TYPE.CAMERA_UI_3D)
        if self:getChildByTag(888) == nil then
            self:addChild(camera3D, 0, 888)
        end
        self.m_skeletonNode:setCameraMaskAndPass(mm.CameraMasks[mm.CAMERA_TYPE.CAMERA_UI_3D])

        local mechInfo = MechController:getInstance():getMechInfo()
        --加机甲模型
        local modelNode = CCNode:create()
        modelNode:setAnchorPoint(ccp(0.5, 0))
        modelNode:setRotation3D(cc.vec3(0, 0, 0))
        modelNode:setScale(0.55)
        modelNode:setPosition3D(cc.vec3(self.m_skeletonNode:getContentSize().width / 2, self.m_skeletonNode:getContentSize().height / 4, self.m_skeletonNode:getContentSize().height / 2))
        local mech = Mech:createWithNode(mechInfo, modelNode, self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId)
        mech:setIsInMechView(true)
        local test = tolua.cast(mech, "cc.Node")
        modelNode:addChild(test)
        self.m_skeletonNode:addChild(modelNode)
        mech:playIdle()
        local pos = CCCommonUtils:getXmlPropById("skinBase", self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, "pos")
        if pos ~= "" then 
            modelNode:setPosition(ccp(CCCommonUtils:pointFromString(pos)))
        end
        local count = 1
        for k,v in pairs(self.m_mechaPageVec[self.m_index + 1].m_effectValueMap) do
            local contentString = _lang(GeneralManager:getInstance():getEffectNameById(tostring(k))) .. _lang("3700000")
            self.m_attributeVec[count]:setString(contentString)
            local numType = GeneralManager:getInstance():getPercentById(tostring(k))
            local effectValue = v
            if numType == mm.RoldNumType.EM_Percent_Type then
                self.m_attributeValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            elseif numType == mm.RoldNumType.EM_Permillage_Type then
                effectValue = effectValue / 10
                self.m_attributeValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            else
                self.m_attributeValueVec[count]:setString(string.format("%.f", effectValue))
            end
            if self.m_useType ~= mm.skinUseType.EM_Forever_Skin_Type then
                self.m_attributeMaxValueVec[count]:setVisible(false)
            else
                for k1,v1 in pairs(self.m_mechaPageVec[self.m_index + 1].m_maxValueMap) do
                    --当非限时皮肤没满星时显示满星数据
                    if k1 == k then
                        self.m_attributeMaxValueVec[count]:setVisible(v1 > v)
                        local numType = GeneralManager:getInstance():getPercentById(tostring(k))
                        local effectValue = v1
                        if numType == mm.RoldNumType.EM_Percent_Type then
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%0.1f", effectValue) .. "%)")
                        elseif numType == mm.RoldNumType.EM_Permillage_Type then
                            effectValue = effectValue / 10
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%0.1f", effectValue) .. "%)")
                        else
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%.f", effectValue) .. ")")
                        end
                        break
                    end
                end
            end
            self.m_proNodeVec[count]:setVisible(true)
            self.m_attrNodeVec[count]:setVisible(true)
            count = count + 1
        end
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        self.m_redPointSprite:setVisible(PictureBookController:getInstance():isCanActivateSkinId(self.m_cityPageVec[self.m_index + 1].m_citySkinId))
        local itemId = atoi(CCCommonUtils:getXmlPropById("skinBase", self.m_cityPageVec[self.m_index + 1].m_citySkinId, "skin_exclusive"))
        local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(itemId)
        local itemColorString = PictureBookController:getInstance():getColorStringColorByColorId(toolInfo.color)
        self.m_comDebris:setString(_lang_1(itemColorString, toolInfo:getName()))
        self.m_comDebrisValue:setString(CC_ITOA(toolInfo:getCNT()))
        local limitStr = CCCommonUtils:getXmlPropById("skinBase", self.m_cityPageVec[self.m_index + 1].m_citySkinId, "limit_img")
        if limitStr ~= "" then
            limitStr = limitStr..".png"
            self.m_limitImg:setSpriteFrame(CCLoadSprite:loadResource(limitStr))
            self.m_limitImg:setVisible(true)
        end
        local iconPath = toolInfo.icon .. ".png"
        self.m_itemIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
        local bgPath = CCCommonUtils:getXmlPropById("skinBase", self.m_cityPageVec[self.m_index + 1].m_citySkinId, "img_Base") .. ".png"
        self.m_skinBg:setSpriteFrame(CCLoadSprite:loadResource(bgPath))
        local colorString = PictureBookController:getInstance():getColorStringColorByColorId(self.m_cityPageVec[self.m_index + 1].m_skinColor)
        self.m_skinBigNameLabel:setString(_lang_1(colorString, self.m_cityPageVec[self.m_index + 1].m_skinName))
        self.m_skeletonNode:removeAllChildren()
        --主城装扮修改
        --读配置确定位置
        local iter1 = ToolController:getInstance():getCustomSkin(atoi(self.m_cityPageVec[self.m_index + 1].m_statusSkinId))
        local scale = 1.0
        local pointX = 0
        local pointY = 0
        local posStr = ""
        if iter1 then
            scale = atof(iter1.skinCityScale)
            posStr = iter1.skinCityPt
            local posVec = CCCommonUtils:splitString(posStr, ",")
            if #posVec > 0 then
                pointX = atoi(posVec[1])
            end
            if #posVec > 1 then
                pointY = atoi(posVec[2])
            end
        end
        -- scale = 0.45
        -- pointX = 0
        -- pointY = 0
        local skin = MainCitySkin:create(self.m_cityPageVec[self.m_index + 1].m_skeletonPath, "0")
        if skin then
            skin:setAnchorPoint(ccp(0.5, 0.5))
            self.m_skeletonNode:addChild(skin)
            -- skin:setScale(0.5)
            -- skin:setPosition(ccp(175, 285))
            skin:setScale(scale)
            skin:setPosition(ccp(pointX, pointY)) 
        else
            CCCommonUtils:flyHint("", "", _lang("2065"))
        end
        local count = 1
        for k,v in pairs(self.m_cityPageVec[self.m_index + 1].m_effectValueMap) do
            local contentString = _lang(GeneralManager:getInstance():getEffectNameById(tostring(k))) .. _lang("3700000")
            self.m_attributeVec[count]:setString(contentString)
            local numType = GeneralManager:getInstance():getPercentById(tostring(k))
            local effectValue = v
            if numType == mm.RoldNumType.EM_Percent_Type then
                self.m_attributeValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            elseif numType == mm.RoldNumType.EM_Permillage_Type then
                effectValue = effectValue / 10
                self.m_attributeValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            else
                self.m_attributeValueVec[count]:setString(string.format("%.f", effectValue))
            end

            if self.m_useType ~= mm.skinUseType.EM_Forever_Skin_Type then
                self.m_attributeMaxValueVec[count]:setVisible(false)
            else
                for k1,v1 in pairs(self.m_cityPageVec[self.m_index + 1].m_maxValueMap) do
                    --当非限时皮肤没满星时显示满星数据
                    if k1 == k then
                        self.m_attributeMaxValueVec[count]:setVisible(v1 > v)
                        local numType = GeneralManager:getInstance():getPercentById(tostring(k))
                        local effectValue = v1
                        if numType == mm.RoldNumType.EM_Percent_Type then
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%0.1f", effectValue) .. "%)")
                        elseif numType == mm.RoldNumType.EM_Permillage_Type then
                            effectValue = effectValue / 10
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%0.1f", effectValue) .. "%)")
                        else
                            self.m_attributeMaxValueVec[count]:setString("(" .. _lang("3800191") .. "+" .. string.format("%.f", effectValue) .. ")")
                        end
                        break
                    end
                end
            end
            self.m_proNodeVec[count]:setVisible(true)
            self.m_attrNodeVec[count]:setVisible(true)
            count = count + 1
        end
    end
    if self.m_skinBigNameLabel:getContentSize().width > 250 then
        self.m_skinBigNameLabel:setScaleX(250 / self.m_skinBigNameLabel:getContentSize().width)
    end
    self.m_comDebris:setDimensions(CCSize(300, 0))
    for i=1,#self.m_attributeValueVec do
        local y = self.m_attributeVec[i]:getPositionY() - self.m_attributeVec[i]:getContentSize().height / 2
        self.m_attributeValueVec[i]:setPositionY(self.m_attributeVec[i]:getPositionY() - self.m_attributeVec[i]:getContentSize().height / 2)
        self.m_attributeMaxValueVec[i]:setPositionY(self.m_attributeVec[i]:getPositionY() - self.m_attributeVec[i]:getContentSize().height / 2)
        self.m_attributeMaxValueVec[i]:setPositionX(self.m_attributeValueVec[i]:getPositionX() + self.m_attributeValueVec[i]:getContentSize().width)
    end
end

function PictureBookView:onStartData()
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        for i=1,#self.m_startShowVec do
            if i-1 < self.m_heroPageVec[self.m_index + 1].m_currStartLevel then
                self.m_startShowVec[i]:setColor(ccc3(255, 255, 255))
                self.m_startSpriteVec[i]:setColor(ccc3(255, 255, 255))
                self.m_showStarNodeVec[i]:setVisible(true)
                self.m_showStarNodeVec[i]:setOpacity(100)
            else
                self.m_startShowVec[i]:setColor(ccc3(0, 0, 0))
                self.m_startSpriteVec[i]:setColor(ccc3(0, 0, 0))
                self.m_showStarNodeVec[i]:setVisible(false)
            end
        end
        if self.m_heroPageVec[self.m_index + 1].m_currStartLevel == self.m_heroPageVec[self.m_index + 1].m_maxStartLevel then
            UIComponent:getInstance():setUiTitleVisible(true)
            self.m_goToUpBtn:setVisible(false)
            self.m_upNode:setVisible(false)
            self.m_needItemIcon:setVisible(false)

            self.m_numNeedTxt:setVisible(false)
            self.m_numLabel:setString(_lang("3621028"))
            self.m_needNode:setVisible(false)
        else
            self.m_needItemIcon:setVisible(true)
            self.m_numNeedTxt:setVisible(true)
        end
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        for i=1,#self.m_startShowVec do
            if i-1 < self.m_armyPageVec[self.m_index + 1].m_currStartLevel then
                self.m_startShowVec[i]:setColor(ccc3(255, 255, 255))
                self.m_startSpriteVec[i]:setColor(ccc3(255, 255, 255))
                self.m_showStarNodeVec[i]:setVisible(true)
            else
                self.m_startShowVec[i]:setColor(ccc3(0, 0, 0))
                self.m_startSpriteVec[i]:setColor(ccc3(0, 0, 0))
                self.m_showStarNodeVec[i]:setVisible(false)
            end
        end
        if self.m_armyPageVec[self.m_index + 1].m_currStartLevel == self.m_armyPageVec[self.m_index + 1].m_maxStartLevel then
            UIComponent:getInstance():setUiTitleVisible(true)
            self.m_goToUpBtn:setVisible(false)
            self.m_upNode:setVisible(false)
            self.m_needItemIcon:setVisible(false)
            self.m_numNeedTxt:setVisible(false)
            self.m_numLabel:setString(_lang("3621028"))
            self.m_needNode:setVisible(false)
        else
            self.m_needItemIcon:setVisible(true)
            self.m_numNeedTxt:setVisible(true)
        end
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        for i=1,#self.m_startShowVec do
            if i-1 < self.m_mechaPageVec[self.m_index + 1].m_currStartLevel then
                self.m_startShowVec[i]:setColor(ccc3(255, 255, 255))
                self.m_startSpriteVec[i]:setColor(ccc3(255, 255, 255))
                self.m_showStarNodeVec[i]:setVisible(true)
            else
                self.m_startShowVec[i]:setColor(ccc3(0, 0, 0))
                self.m_startSpriteVec[i]:setColor(ccc3(0, 0, 0))
                self.m_showStarNodeVec[i]:setVisible(false)
            end
        end
        if self.m_mechaPageVec[self.m_index + 1].m_currStartLevel == self.m_mechaPageVec[self.m_index + 1].m_maxStartLevel then
            UIComponent:getInstance():setUiTitleVisible(true)
            self.m_goToUpBtn:setVisible(false)
            self.m_upNode:setVisible(false)
            self.m_needItemIcon:setVisible(false)
            self.m_numNeedTxt:setVisible(false)
            self.m_numLabel:setString(_lang("3621028"))
            self.m_needNode:setVisible(false)
        else
            self.m_needItemIcon:setVisible(true)
            self.m_numNeedTxt:setVisible(true)
        end
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        for i=1,#self.m_startShowVec do
            if i-1 < self.m_cityPageVec[self.m_index + 1].m_currStartLevel then
                self.m_startShowVec[i]:setColor(ccc3(255, 255, 255))
                self.m_startSpriteVec[i]:setColor(ccc3(255, 255, 255))
                self.m_showStarNodeVec[i]:setVisible(true)
            else
                self.m_startShowVec[i]:setColor(ccc3(0, 0, 0))
                self.m_startSpriteVec[i]:setColor(ccc3(0, 0, 0))
                self.m_showStarNodeVec[i]:setVisible(false)
            end
        end
        if self.m_cityPageVec[self.m_index + 1].m_currStartLevel == self.m_cityPageVec[self.m_index + 1].m_maxStartLevel then
            UIComponent:getInstance():setUiTitleVisible(true)
            self.m_goToUpBtn:setVisible(false)
            self.m_upNode:setVisible(false)
            self.m_needItemIcon:setVisible(false)
            self.m_numNeedTxt:setVisible(false)
            self.m_numLabel:setString(_lang("3621028"))
            self.m_needNode:setVisible(false)
        else
            self.m_needItemIcon:setVisible(true)
            self.m_numNeedTxt:setVisible(true)
        end
    end
end

function PictureBookView:onUpdateUpStartData()
    local idLevelStr = ""
    local skinId = ""
    local iconPath = ""
    local colorString = ""
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        iconPath = self.m_heroPageVec[self.m_index + 1].m_skinBigIcon .. ".png"
        self.m_skinUpIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
        colorString = PictureBookController:getInstance():getColorStringColorByColorId(self.m_heroPageVec[self.m_index + 1].m_skinColor)
        self.m_skinNameLabel:setString(_lang_1(colorString, self.m_heroPageVec[self.m_index + 1].m_skinName))
        local count = 1
        for k,v in pairs(self.m_heroPageVec[self.m_index + 1].m_effectValueMap) do
            local contentString = _lang(GeneralManager:getInstance():getEffectNameById(tostring(k))) .. _lang("3700000")
            self.m_curVec[count]:setString(contentString)
            self.m_curVec[count]:setMaxScaleXByWidth(130)
            local numType = GeneralManager:getInstance():getPercentById(tostring(k))
            local effectValue = v
            if numType == mm.RoldNumType.EM_Percent_Type then
                self.m_curValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            elseif numType == mm.RoldNumType.EM_Permillage_Type then
                effectValue = v / 10
                self.m_curValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            else
                self.m_curValueVec[count]:setString(string.format("%.f", effectValue))
            end
            count = count + 1
        end
        local countT = 1
        for key,value in pairs(self.m_heroPageVec[self.m_index + 1].m_effectValueMap) do
            for nextKey,nextValue in pairs(self.m_heroPageVec[self.m_index + 1].m_nextValueMap) do
                if key == nextKey then
                    local numType = GeneralManager:getInstance():getPercentById(nextKey)
                    local nextEffectValue = nextValue
                    local effectValue = value
                    if numType == mm.RoldNumType.EM_Percent_Type then
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue) .. "%")
                        self.m_nextValueVec[countT]:setString(string.format("(+%0.1f", (nextEffectValue - effectValue)) .. "%)")
                    elseif numType == mm.RoldNumType.EM_Permillage_Type then
                        nextEffectValue = nextValue / 10
                        effectValue = value / 10
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue) .. "%")
                        self.m_nextValueVec[countT]:setString(string.format("(+%0.1f", (nextEffectValue - effectValue)) .. "%)")
                    else
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue))
                        self.m_nextValueVec[countT]:setString(string.format("(+%.f)", (nextEffectValue - effectValue)))
                    end
                    countT = countT + 1
                end
            end
        end
        idLevelStr = string.format("%s_%d", self.m_heroPageVec[self.m_index + 1].m_heroSkinId, MIN(self.m_heroPageVec[self.m_index + 1].m_currStartLevel + 1, self.m_heroPageVec[self.m_index + 1].m_maxStartLevel))
        skinId = self.m_heroPageVec[self.m_index + 1].m_heroSkinId
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        iconPath = self.m_armyPageVec[self.m_index + 1].m_skinBigIcon .. ".png"
        self.m_skinUpIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
        colorString = PictureBookController:getInstance():getColorStringColorByColorId(self.m_armyPageVec[self.m_index + 1].m_skinColor)
        self.m_skinNameLabel:setString(_lang_1(colorString, self.m_armyPageVec[self.m_index + 1].m_skinName))
        local count = 1
        for k,v in pairs(self.m_armyPageVec[self.m_index + 1].m_effectValueMap) do
            local contentString = _lang(GeneralManager:getInstance():getEffectNameById(tostring(k))) .. _lang("3700000")
            self.m_curVec[count]:setString(contentString)
            self.m_curVec[count]:setMaxScaleXByWidth(130)
            local numType = GeneralManager:getInstance():getPercentById(tostring(k))
            local effectValue = v
            if numType == mm.RoldNumType.EM_Percent_Type then
                self.m_curValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            elseif numType == mm.RoldNumType.EM_Permillage_Type then
                effectValue = v / 10
                self.m_curValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            else
                self.m_curValueVec[count]:setString(string.format("%.f", effectValue))
            end
            count = count + 1
        end
        local countT = 1
        for key,value in pairs(self.m_armyPageVec[self.m_index + 1].m_effectValueMap) do
            for nextKey,nextValue in pairs(self.m_armyPageVec[self.m_index + 1].m_nextValueMap) do
                if key == nextKey then
                    local numType = GeneralManager:getInstance():getPercentById(nextKey)
                    local nextEffectValue = nextValue
                    local effectValue = value
                    if numType == mm.RoldNumType.EM_Percent_Type then
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue) .. "%")
                        self.m_nextValueVec[countT]:setString(string.format("(+%0.1f", (nextEffectValue - effectValue)) .. "%)")
                    elseif numType == mm.RoldNumType.EM_Permillage_Type then
                        nextEffectValue = nextValue / 10
                        effectValue = value / 10
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue) .. "%")
                        self.m_nextValueVec[countT]:setString(string.format("(+%0.1f", (nextEffectValue - effectValue)) .. "%)")
                    else
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue))
                        self.m_nextValueVec[countT]:setString(string.format("(+%.f)", (nextEffectValue - effectValue)))
                    end
                    countT = countT + 1
                end
            end
        end
        idLevelStr = string.format("%s_%d", self.m_armyPageVec[self.m_index + 1].m_armySkinId, MIN(self.m_armyPageVec[self.m_index + 1].m_currStartLevel + 1, self.m_armyPageVec[self.m_index + 1].m_maxStartLevel))
        skinId = self.m_armyPageVec[self.m_index + 1].m_armySkinId
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        iconPath = self.m_mechaPageVec[self.m_index + 1].m_skinBigIcon .. ".png"
        self.m_skinUpIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
        colorString = PictureBookController:getInstance():getColorStringColorByColorId(self.m_mechaPageVec[self.m_index + 1].m_skinColor)
        self.m_skinNameLabel:setString(_lang_1(colorString, self.m_mechaPageVec[self.m_index + 1].m_skinName))
        local count = 1
        for k,v in pairs(self.m_mechaPageVec[self.m_index + 1].m_effectValueMap) do
            local contentString = _lang(GeneralManager:getInstance():getEffectNameById(tostring(k))) .. _lang("3700000")
            self.m_curVec[count]:setString(contentString)
            self.m_curVec[count]:setMaxScaleXByWidth(130)
            local numType = GeneralManager:getInstance():getPercentById(tostring(k))
            local effectValue = v
            if numType == mm.RoldNumType.EM_Percent_Type then
                self.m_curValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            elseif numType == mm.RoldNumType.EM_Permillage_Type then
                effectValue = v / 10
                self.m_curValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            else
                self.m_curValueVec[count]:setString(string.format("%.f", effectValue))
            end
            count = count + 1
        end
        local countT = 1
        for key,value in pairs(self.m_mechaPageVec[self.m_index + 1].m_effectValueMap) do
            for nextKey,nextValue in pairs(self.m_mechaPageVec[self.m_index + 1].m_nextValueMap) do
                if key == nextKey then
                    local numType = GeneralManager:getInstance():getPercentById(nextKey)
                    local nextEffectValue = nextValue
                    local effectValue = value
                    if numType == mm.RoldNumType.EM_Percent_Type then
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue) .. "%")
                        self.m_nextValueVec[countT]:setString(string.format("(+%0.1f", (nextEffectValue - effectValue)) .. "%)")
                    elseif numType == mm.RoldNumType.EM_Permillage_Type then
                        nextEffectValue = nextValue / 10
                        effectValue = value / 10
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue) .. "%")
                        self.m_nextValueVec[countT]:setString(string.format("(+%0.1f", (nextEffectValue - effectValue)) .. "%)")
                    else
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue))
                        self.m_nextValueVec[countT]:setString(string.format("(+%.f)", (nextEffectValue - effectValue)))
                    end
                    countT = countT + 1
                end
            end
        end
        idLevelStr = string.format("%s_%d", self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId, MIN(self.m_mechaPageVec[self.m_index + 1].m_currStartLevel + 1, self.m_mechaPageVec[self.m_index + 1].m_maxStartLevel))
        skinId = self.m_mechaPageVec[self.m_index + 1].m_mechaSkinId
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        iconPath = self.m_cityPageVec[self.m_index + 1].m_skinBigIcon .. ".png"
        self.m_skinUpIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
        colorString = PictureBookController:getInstance():getColorStringColorByColorId(self.m_cityPageVec[self.m_index + 1].m_skinColor)
        self.m_skinNameLabel:setString(_lang_1(colorString, self.m_cityPageVec[self.m_index + 1].m_skinName))
        local count = 1
        for k,v in pairs(self.m_cityPageVec[self.m_index + 1].m_effectValueMap) do
            local contentString = _lang(GeneralManager:getInstance():getEffectNameById(tostring(k))) .. _lang("3700000")
            self.m_curVec[count]:setString(contentString)
            self.m_curVec[count]:setMaxScaleXByWidth(130)
            local numType = GeneralManager:getInstance():getPercentById(tostring(k))
            local effectValue = v
            if numType == mm.RoldNumType.EM_Percent_Type then
                self.m_curValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            elseif numType == mm.RoldNumType.EM_Permillage_Type then
                effectValue = v / 10
                self.m_curValueVec[count]:setString(string.format("%0.1f", effectValue) .. "%")
            else
                self.m_curValueVec[count]:setString(string.format("%.f", effectValue))
            end
            count = count + 1
        end
        local countT = 1
        for key,value in pairs(self.m_cityPageVec[self.m_index + 1].m_effectValueMap) do
            for nextKey,nextValue in pairs(self.m_cityPageVec[self.m_index + 1].m_nextValueMap) do
                if key == nextKey then
                    local numType = GeneralManager:getInstance():getPercentById(nextKey)
                    local nextEffectValue = nextValue
                    local effectValue = value
                    if numType == mm.RoldNumType.EM_Percent_Type then
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue) .. "%")
                        self.m_nextValueVec[countT]:setString(string.format("(+%0.1f", (nextEffectValue - effectValue)) .. "%)")
                    elseif numType == mm.RoldNumType.EM_Permillage_Type then
                        nextEffectValue = nextValue / 10
                        effectValue = value / 10
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue) .. "%")
                        self.m_nextValueVec[countT]:setString(string.format("(+%0.1f", (nextEffectValue - effectValue)) .. "%)")
                    else
                        self.m_nextVec[countT]:setString(string.format("%0.1f", nextEffectValue))
                        self.m_nextValueVec[countT]:setString(string.format("(+%.f)", (nextEffectValue - effectValue)))
                    end
                    countT = countT + 1
                end
            end
        end
        idLevelStr = string.format("%s_%d", self.m_cityPageVec[self.m_index + 1].m_citySkinId, MIN(self.m_cityPageVec[self.m_index + 1].m_currStartLevel + 1, self.m_cityPageVec[self.m_index + 1].m_maxStartLevel))
        skinId = self.m_cityPageVec[self.m_index + 1].m_citySkinId
    end

    local useItemString = CCCommonUtils:getXmlPropById("attributeBase", idLevelStr, "use_item")
    local useNumString = CCCommonUtils:getXmlPropById("attributeBase", idLevelStr, "allexp")
    local idVec = CCCommonUtils:splitString(useItemString, ";")
    if self.m_useType ~= mm.skinUseType.EM_Limit_Skin_Type then
        self:onInitSkinStartData(idVec, useNumString)
    end
end

function PictureBookView:onInitSkinStartData(dataVec, useNumString)
    local isNotEnough = false
    local totalStr = ""
    local totalNum = 0
    local needNum = atoi(useNumString)
    local num1 = 0
    local num2 = 0
    local num3 = 0
    local itemId1 = ""
    local itemId2 = ""
    local itemId3 = ""
    local itemColorStr = ""
    local isCanUpColorStr = ""
    local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[1]))
    local iconPath = toolInfo.icon .. ".png"
    self.m_needItemIcon:setSpriteFrame(CCLoadSprite:loadResource(iconPath))
    for i=1,#dataVec do
        local toolInfo1 = ToolController:getInstance():getToolInfoByIdForLua(atoi(dataVec[i]))
        if toolInfo:getCNT() < needNum then  ----当专属碎片不足时 ，需要显示万能碎片的数量
            isNotEnough = true
            totalNum = totalNum + toolInfo1:getCNT()
        end
        if i == 1 then
            itemId1 = dataVec[1]
            num1 = toolInfo1:getCNT()
        elseif i == 2 then
            itemId2 = dataVec[2]
            num2 = toolInfo1:getCNT()
        elseif i == 3 then
            itemId3 = dataVec[3]
            num3 = toolInfo1:getCNT()
        end
    end
    if isNotEnough then
        if totalNum < needNum then  --当所需碎片大于专属碎片和万能碎片总和时字体颜色显示为红色  否则为绿色
            self.m_numStartLabel:setString(_lang("3621034") .. _lang_1("3700040", useNumString))
            self.m_numLabel:setString(_lang_1("3700040", useNumString))
            isCanUpColorStr = _lang_1("3700040", useNumString)
            self.m_isCanUpStart = false
        else
            self.m_numStartLabel:setString(_lang("3621034") .. _lang_1("3700039", useNumString))
            self.m_numLabel:setString(_lang_1("3700039", useNumString))
            isCanUpColorStr = _lang_1("3700039", useNumString)
            self.m_isCanUpStart = true
        end
    else
        self.m_numStartLabel:setString(_lang("3621034") .. _lang_1("3700039", useNumString))
        self.m_numLabel:setString(_lang_1("3700039", useNumString))
        isCanUpColorStr = _lang_1("3700039", useNumString)
        self.m_isCanUpStart = true
    end

    if self.m_myComDebrisValue:getContentSize().width > 450 then
        self.m_myComDebrisValue:setScaleX(450 / self.m_myComDebrisValue:getContentSize().width)
    end
    if self.m_myDebrisValue:getContentSize().width > 450 then
        self.m_myDebrisValue:setScaleX(450 / self.m_myDebrisValue:getContentSize().width)
    end
    if self.m_myNewDebrisValue:getContentSize().width > 450 then
        self.m_myNewDebrisValue:setScaleX(450 / self.m_myNewDebrisValue:getContentSize().width)
    end

    local toolInfoNeed1 = ToolController:getInstance():getToolInfoByIdForLua(atoi(itemId1))
    local toolInfoNeed2 = ToolController:getInstance():getToolInfoByIdForLua(atoi(itemId2))
    local itemColorStr1 = PictureBookController:getInstance():getColorStringColorByColorId(toolInfoNeed1.color)
    local itemColorStr2 = PictureBookController:getInstance():getColorStringColorByColorId(toolInfoNeed2.color)
    self.m_starNeedVec = {}
    self.m_starNeedVec[#self.m_starNeedVec + 1] = isCanUpColorStr --容器格式一定要这个顺序
    self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr1, toolInfoNeed1:getName()) .. _lang("3700000")
    self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr1, CC_ITOA(num1))
    self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr1, CC_ITOA(MAX(num1 - atoi(useNumString), 0)))
    self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr2, toolInfoNeed2:getName()) .. _lang("3700000")
    self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr2, CC_ITOA(num2))
    if num1 >= atoi(useNumString) then
        self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr2, CC_ITOA(num2))
    else
        self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr2, CC_ITOA(MAX(num2 + num1 - atoi(useNumString), 0)))
    end
    if #dataVec == 1 then
        self.m_myDebrisValue:setString(_lang_1(itemColorStr1, (toolInfoNeed1:getName() .. _lang("3700000") .. CC_ITOA(toolInfoNeed1:getCNT()))))
        self.m_myComDebrisValue:setString("")
        self.m_myNewDebrisValue:setString("")
    elseif #dataVec == 2 then
        self.m_myDebrisValue:setString(_lang_1(itemColorStr1, (toolInfoNeed1:getName() .. _lang("3700000") .. CC_ITOA(toolInfoNeed1:getCNT()))))
        self.m_myComDebrisValue:setString(_lang_1(itemColorStr2, (toolInfoNeed2:getName() .. _lang("3700000") .. CC_ITOA(toolInfoNeed2:getCNT()))))
        self.m_myNewDebrisValue:setString("")
    elseif #dataVec == 3 then
        if itemId3 ~= "" then
            local toolInfoNeed3 = ToolController:getInstance():getToolInfoByIdForLua(atoi(itemId3))
            local itemColorStr3 = PictureBookController:getInstance():getColorStringColorByColorId(toolInfoNeed3.color)
            self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr3, toolInfoNeed3:getName()) .. _lang("3700000")
            self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr3, CC_ITOA(num3))
            if num2 + num1 >= atoi(useNumString) then
                self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr3, CC_ITOA(num3))
            else
                self.m_starNeedVec[#self.m_starNeedVec + 1] = _lang_1(itemColorStr3, CC_ITOA(MAX(num3 + num2 + num1 - atoi(useNumString), 0)))
            end
            self.m_myDebrisValue:setString(_lang_1(itemColorStr1, (toolInfoNeed1:getName() .. _lang("3700000") .. CC_ITOA(toolInfoNeed1:getCNT()))))
            self.m_myComDebrisValue:setString(_lang_1(itemColorStr2, (toolInfoNeed2:getName() .. _lang("3700000") .. CC_ITOA(toolInfoNeed2:getCNT()))))
            self.m_myNewDebrisValue:setString(_lang_1(itemColorStr3, (toolInfoNeed3:getName() .. _lang("3700000") .. CC_ITOA(toolInfoNeed3:getCNT()))))
        end
    end
    self.m_skinNameLabel:setDimensions(CCSize(400, 0))
end

function PictureBookView:onUpdateBtnData()
    if self.m_status == mm.skinTimeType.EM_None_Skin_Type then
        self.m_goToUpBtn:setVisible(false)
        self.m_exchangeBtn:setVisible(true)
        self.m_useBtn:setVisible(false)
        CCCommonUtils:setButtonTitle(self.m_useBtn, _lang("501184"))
        CCCommonUtils:setButtonTitle(self.m_exchangeBtn, _lang("105244"))
        self.m_menuNode:setVisible(true)
        self.m_numLabel:setVisible(false)
        self.m_needNode:setVisible(false)
    elseif self.m_status == mm.skinTimeType.EM_Down_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Forever_Skin_Type then
            self.m_goToUpBtn:setVisible(true)
            self.m_exchangeBtn:setVisible(false)
            self.m_menuNode:setVisible(false)
            self.m_numLabel:setVisible(true)
            self.m_needNode:setVisible(true)
        else
            self.m_goToUpBtn:setVisible(false)
            self.m_exchangeBtn:setVisible(true)
            self.m_menuNode:setVisible(true)
            self.m_numLabel:setVisible(false)
            self.m_needNode:setVisible(false)
        end
        self.m_useBtn:setVisible(true)
        CCCommonUtils:setButtonTitle(self.m_useBtn, _lang("119003"))
        CCCommonUtils:setButtonTitle(self.m_exchangeBtn, _lang("128106"))
    elseif self.m_status == mm.skinTimeType.EM_Up_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Forever_Skin_Type then
            self.m_goToUpBtn:setVisible(true)
            self.m_exchangeBtn:setVisible(false)
            self.m_menuNode:setVisible(false)
            self.m_numLabel:setVisible(true)
            self.m_needNode:setVisible(true)
        else
            self.m_goToUpBtn:setVisible(false)
            self.m_exchangeBtn:setVisible(true)
            self.m_menuNode:setVisible(true)
            self.m_numLabel:setVisible(false)
            self.m_needNode:setVisible(false)
        end
        self.m_useBtn:setVisible(true)
        CCCommonUtils:setButtonTitle(self.m_useBtn, _lang("501184"))
        CCCommonUtils:setButtonTitle(self.m_exchangeBtn, _lang("128106"))
    end
end

function PictureBookView:onSkinEndTime(dt)
    if self.m_type == mm.skinType.EM_Hero_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Limit_Skin_Type then
            local entTime = self.m_heroPageVec[self.m_index + 1].m_timeOut
            local curTime = GlobalData:shared():getTimeStamp()
            local durationTime = entTime - curTime
            if durationTime > 0 then
                self.m_timeLabel:setString(CC_SECTOA(durationTime))
                self.m_timeLabel:setVisible(true)
            else
                self.m_timeLabel:setVisible(false)
            end
        else
            self.m_timeLabel:setVisible(false)
        end
    elseif self.m_type == mm.skinType.EM_Army_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Limit_Skin_Type then
            local entTime = self.m_armyPageVec[self.m_index + 1].m_timeOut
            local curTime = GlobalData:shared():getTimeStamp()
            local durationTime = entTime - curTime
            if durationTime > 0 then
                self.m_timeLabel:setString(CC_SECTOA(durationTime))
                self.m_timeLabel:setVisible(true)
            else
                self.m_timeLabel:setVisible(false)
            end
        else
            self.m_timeLabel:setVisible(false)
        end
    elseif self.m_type == mm.skinType.EM_Mecha_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Limit_Skin_Type then
            local entTime = self.m_mechaPageVec[self.m_index + 1].m_timeOut
            local curTime = GlobalData:shared():getTimeStamp()
            local durationTime = entTime - curTime
            if durationTime > 0 then
                self.m_timeLabel:setString(CC_SECTOA(durationTime))
                self.m_timeLabel:setVisible(true)
            else
                self.m_timeLabel:setVisible(false)
            end
        else
            self.m_timeLabel:setVisible(false)
        end
    elseif self.m_type == mm.skinType.EM_City_Skin_Type then
        if self.m_useType == mm.skinUseType.EM_Limit_Skin_Type then
            local entTime = self.m_cityPageVec[self.m_index + 1].m_timeOut
            local curTime = GlobalData:shared():getTimeStamp()
            local durationTime = entTime - curTime
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
end

function PictureBookView:onRuleData()
    self.m_ruleNode:setVisible(true)
    self.m_ruleNewDebris:setString("")
    self.m_beforeValue3:setString("")
    self.m_afterValue3:setString("")
    self.m_ruleTitle1:setString(_lang("3621144"))
    self.m_ruleTitle1:setMaxScaleXByWidth(260)
    self.m_ruleTitle2:setString(_lang("3621145"))
    self.m_ruleTitle2:setMaxScaleXByWidth(260)
    self.m_beforeNum:setString(_lang("3621146"))
    self.m_beforeNum:setMaxScaleXByWidth(120)
    self.m_afterNum:setString(_lang("3621147"))
    self.m_afterNum:setMaxScaleXByWidth(120)
    self.m_ruleNumTxt:setString(self.m_starNeedVec[1])
    self.m_ruleName:setString(self.m_starNeedVec[2])
    self.m_beforeValue1:setString(self.m_starNeedVec[3])
    self.m_afterValue1:setString(self.m_starNeedVec[4])
    self.m_ruleDebris:setString(self.m_starNeedVec[5])
    self.m_beforeValue2:setString(self.m_starNeedVec[6])
    self.m_afterValue2:setString(self.m_starNeedVec[7])
    if #self.m_starNeedVec > 7 then
        self.m_ruleNewDebris:setString(self.m_starNeedVec[8])
        self.m_beforeValue3:setString(self.m_starNeedVec[9])
        self.m_afterValue3:setString(self.m_starNeedVec[10])
    end
end

function PictureBookView:onInitSuccessViewData(obj)
    if #PictureBookController:getInstance().m_powerVec > 0 then
        PopupViewController:getInstance():addPopupView(PictureBookSuccessView:create(), true)
        if GuideController:share():isInTutorial() and self.m_guideBookTab then
            --开始下一步引导
            GuideController:share():next()
        end
    else
        PictureBookController:getInstance().m_successIndex = 0
    end
end

function PictureBookView:getGuideNode(_key)
    if _key == "Pick_IllustrateCell" and self.m_guideBookTab then
        return self.m_guideBookTab:getGuideNode()
    elseif _key == "Pick_exchangeBtn" then
        return self.m_exchangeBtn
    elseif _key == "Pick_useBtn" then
        return self.m_useBtn
    end
    return nil
end

return PictureBookView
