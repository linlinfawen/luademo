

local scheduler = drequire("common.scheduler")
local ChapterQuestCell = drequire("view.popup.ChapterQuest.ChapterQuestCell")
local ChapterPreview = drequire("view.popup.ChapterQuest.ChapterPreview")
local ChapterQuestCommand = drequire("net.command.ChapterQuestCommand")
local ChapterNextQuestCommand = drequire("net.command.ChapterNextQuestCommand")

local ChapterCellSize = Size(579, 80)

-- 章节任务到430之前的版本做兼容
local isVersionOf451After = function()
    local a = "0.1.451"
    local b = "0.1.451"
    -- local b = CCUserDefault:getInstance():getStringForKey("reg_Version")
    local aStrVec = CCCommonUtils:splitString(a, ".")
    local aStr = ""
    for i=1,#aStrVec do
        aStr = aStr..aStrVec[i]
    end

    local bStrVec = CCCommonUtils:splitString(b, ".")
    local bStr = ""
    for i=1,#bStrVec do
        bStr = bStr..bStrVec[i]
    end

    return (atoi(bStr) - atoi(aStr)) > 0
end

-- local logonVersion = GlobalData:shared().m_logonVersion

local print_name_ = "ChapterQuestView"
local start_time_ = 0
local function logRuntime_SetStartTime()
    start_time_ = os.clock()
end
local function logRuntime_ChapterQuestView(str)
    dlog("%s-clockTime-%s: %f", print_name_, str, ((os.clock() - start_time_) / 1000))
end

local ChapterQuestView = class("ChapterQuestView", function()
    return PopupBaseView:create()
end)

function ChapterQuestView:onEnter()
    logRuntime_ChapterQuestView("enter")

    -- self:setTouchEnabled(true)
    -- self:setSwallowsTouches(false)
    MMUtils:setTouchEnabled(self.m_baseNode,true)

    local cmd = ChapterQuestCommand:create()
    if cmd then
        cmd:send()
    end

    MMUtils:registerScriptObserver(self, self.resetUI, mm.QUEST_STATE_UPDATE)

    if self.m_backNameTexture then
        if not self.m_bgScreenShoot then
            self.m_bgScreenShoot = self.m_backNameTexture:getSprite()
            self.m_bgScreenShoot:setAnchorPoint(cc.p(0.5, 0.5))
            self.m_bgScreenShoot:setPosition(SCREEN_SIZE.width * 0.5, SCREEN_SIZE.height * 0.5)
            self.m_bgScreenShoot:setFlippedY(true)
            self.m_bgScreenShoot:retain()
            self.m_bgScreenShoot:removeFromParent()
            self:addChild(self.m_bgScreenShoot, -100)
            self.m_bgScreenShoot:release()
            UIComponent:getInstance():setVisible(false)
            local imperialScene = SceneController:getInstance():getImperialScene()
            if imperialScene then
                imperialScene:setVisible(false)
            end
        end
        self.m_backNameTexture:removeFromParent()
        self.m_backNameTexture = nil
    end
    if self.m_bgScreenShoot then
        self.m_bgScreenShoot:setVisible(true)
    end
    logRuntime_ChapterQuestView("enterEnd")
end
function ChapterQuestView:onExit()
    MMUtils:unregisterScriptObserver(self, mm.QUEST_STATE_UPDATE)
    UIComponent:getInstance():setVisible(true)
    local imperialScene = SceneController:getInstance():getImperialScene()
    if imperialScene then
        imperialScene:setVisible(true)
    end
    if self.m_bgScreenShoot then
        self.m_bgScreenShoot:setVisible(false)
    end
    self:setTouchEnabled(false)
end
function ChapterQuestView:ctor()
    self.m_tabView = nil
    self.m_backNameTexture = nil
    self.m_bgScreenShoot = nil
end

function ChapterQuestView:dtor()
    if self.m_bgScreenShoot then
        self.m_bgScreenShoot:removeFromParent()
        self.m_bgScreenShoot = nil
    end
end

function ChapterQuestView:create(background)
    local ret = ChapterQuestView.new()
    if ret and ret:initView(background) then
    end
    return ret
end

function ChapterQuestView:initView(background)
    logRuntime_SetStartTime()

    self:initBase()
    self:setModelLayerOpacity(180)

    self.m_backNameTexture = MMUtils:dynamicCast(background,"cc.RenderTexture")

    CCLoadSprite:doResourceByCommonIndex(1064, true, true)
    self:setCleanFunction(function ()
        CCLoadSprite:doResourceByCommonIndex(1064, false, true)
    end)

    logRuntime_ChapterQuestView("res")

    self.m_baseNode = cc.Node:create()
    for _, v in pairs(self:getChildren()) do
        self:removeChild(v, false)
        self.m_baseNode:addChild(v)
    end
    self.m_baseNode:setContentSize(SCREEN_SIZE)
    self.m_baseNode.onTouchBegan = function(n, t, e) return self:onTouchBegan(t, e) end
    self.m_baseNode.onTouchEnded = function(n, t, e) self:onTouchEnded(t, e) end
    self:addChild(self.m_baseNode, 10)
    CCBLoadFile("ChapterQuest", self.m_baseNode, self,self)
    -- CCBLoadFile("ChapterQuest", self, self)
    self.m_nameLabel = MMUtils:collectCCBNode(self, "m_nameLabel")

    self.m_node = MMUtils:collectCCBNode(self, "m_node")
    self.m_itemNode = MMUtils:collectCCBNode(self, "m_itemNode")
    self.m_itemNum = MMUtils:collectCCBNode(self, "m_itemNum")
    self.m_boxEffect = MMUtils:collectCCBNode(self, "m_boxEffect")
    self.m_lockNode = MMUtils:collectCCBNode(self, "m_lockNode")

    self.m_btnLab1:setString(_lang("700969"))
    self.m_btnLab2:setString(_lang("700970"))

    self:setContentSize(SCREEN_SIZE)

    logRuntime_ChapterQuestView("ccb")

    --章节任务到430之前的版本
    if isVersionOf451After() then
        self.m_bottomNode:setVisible(true)
        CCCommonUtils:setButtonTitle(self.m_btnReward, _lang("10005016"));  --领取
    else
        self.m_bottomNode2:setVisible(true)    
    end

    local allCellH = 0
    local chapterQuest = ChapterQuestController:shared()
    local questInfos = chapterQuest:getQuestInChapter()
    for _, it in pairs(questInfos) do
        if it then
            allCellH = allCellH + self:getAdjustHeight(it.itemId)
        end
    end
    local chapterState = chapterQuest:getState()   
    if chapterState == 0 then
        self.m_bottomNode:setPositionY(0)
        self.m_listNode:setContentSize(Size(self.m_listNode:getContentSize().width, allCellH))
        self.m_listNode:setPositionY(self.m_bottomNode:getContentSize().height)
        self.m_topNode:setPositionY(self.m_listNode:getPositionY() + self.m_listNode:getContentSize().height + 5)
    else
        self.m_lockNode[1]:setPositionY(0)
        self.m_topNode:setPositionY(self.m_lockNode[1]:getContentSize().height + 5)
    end

    self.m_bgSp:setContentSize(Size(self.m_bgSp:getContentSize().width, 
                                    self.m_topNode:getPositionY() + self.m_topNode:getContentSize().height - 5))
    self.m_mainNode:setContentSize(self.m_bgSp:getContentSize())

    local s = 1.0
    if SCREEN_SIZE.height < self.m_mainNode:getContentSize().height then
        s = SCREEN_SIZE.height * 1.0 / 1136
        self.m_mainNode:setScale(s)
    end
    self.m_mainNode:setPositionY((SCREEN_SIZE.height - self.m_mainNode:getContentSize().height * s) / 2)
    
    --spineNode
    local chapterIndex = chapterQuest:getChapterIndex()
    local chapterSum = chapterQuest:getChapterTaskSum()

    local titleName = chapterQuest:getChapterNum(chapterIndex) .. chapterQuest:getChapterName(chapterIndex)
    self.m_nameLabel[1]:setString(titleName)
    self.m_nameLabel[2]:setString(_lang("700025"))
    self.m_nameLabel[3]:setString(_lang("700169"))
    self.m_nameLabel[4]:setString(chapterQuest:getProgressRewardTip());  --章节进度提示
    self.m_textName:setString(_lang("700975"))

    local m_richLab = CCRichLabelTTF:create()
    m_richLab:setFontName(self.m_nameLabel[5]:getFontName())
    m_richLab:setFontSize(self.m_nameLabel[5]:getFontSize())
    m_richLab:setDimensions(Size(526, 0))
    m_richLab:setAnchorPoint(Vec2(0.5, 0.5))
    m_richLab:setPosition(0, 0)
    m_richLab:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    m_richLab:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)
    self.m_nameLabel[5]:addChild(m_richLab)
    m_richLab:setString(_lang("700140"))

    self.m_richLblDes = CCCommonUtils:createRichLabel(self.m_giftLab)
    self.m_richLblDes:setAnchorPoint(Vec2(0.5, 0.5))
    self.m_richLblDes:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    self.m_richLblDes:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)

    local isOpen = CCPlayerDefault:getInstance():getBoolForKey("ChapterFirstOpen")
    if chapterIndex == 0 and not isOpen then
        CCPlayerDefault:getInstance():setBoolForKey("ChapterFirstOpen", true)
    end

    self:onSpineNode(chapterIndex)
    self:resetUI()

    local isOpenChapter2 = CCPlayerDefault:getInstance():getBoolForKey("ChapterFirstOpen2")
    if chapterIndex == 3 and not isOpenChapter2 then  --TODO:首次进行进度引导
        CCPlayerDefault:getInstance():setBoolForKey("ChapterFirstOpen2", true)
        local scheduleHandler
        scheduleHandler = scheduler.scheduleGlobal(function (dt)
            local isPlaying = VideoController:shared():getIsPlaying()
            dlogw(isPlaying)
            if not isPlaying then
                scheduler.unscheduleGlobal(scheduleHandler)
                GuideController:share():setGuide("4000161")
            end
        end, 0.5)
    end

    logRuntime_ChapterQuestView("initEnd")
    return true
end

function ChapterQuestView:resetUI(pObj)
    self.m_chapters = ChapterQuestController:shared():getQuestInChapter()  --获取当前章节任务列表
    local chapterIndex = ChapterQuestController:shared():getChapterIndex()

    self.m_nameLabel[4]:setColor(cc.WHITE)

    self:setChapterGift()

    
    local rewardStr = ChapterQuestController:shared():getChapterReward()
    self.m_chapterReward = CCCommonUtils:splitString(rewardStr, ",")

    if isVersionOf451After() then
        for _, it in pairs(self.m_node) do
            it:setVisible(false)
        end

        for i = 1, #self.m_chapterReward / 3 do
            if i > 5 then
                break
            end
            self.m_itemNode[i]:removeAllChildren()
            self.m_node[i]:setVisible(true)
            local itemSize = CCSize(mm.ITEM_BG_SIZE_4, mm.ITEM_BG_SIZE_4)
    
            local idx = (i - 1) * 3 + 1
            local id = self.m_chapterReward[idx]
            local num = self.m_chapterReward[idx + 1]
            local type = self.m_chapterReward[idx + 2]
    
            self.m_itemNum[i]:setString(num)
    
            if atoi(type) == mm.RewardType.R_GOODS then
                CCCommonUtils:createGoodsIcon(atoi(id), self.m_itemNode[i], Size(mm.ITEM_BG_SIZE_4, mm.ITEM_SIZE_4 + 42))
            else
    
                local bgSpr = CCLoadSprite:createSprite("tool_1.png")
                CCCommonUtils:setSpriteMaxSize(bgSpr, mm.ITEM_BG_SIZE_4, true)
                self.m_itemNode[i]:addChild(bgSpr)
    
                local iconName = RewardController:getInstance():getPicByType(atoi(type), atoi(num))
                local iconSpr = CCLoadSprite:createSprite(iconName)
                CCCommonUtils:setSpriteMaxSize(iconSpr, mm.ITEM_SIZE_4, true)
                self.m_itemNode[i]:addChild(iconSpr)
            end
        end
    end    


    if self.m_tabView == nil then
        self.m_tabView = cc.TableView:create(self.m_listNode:getContentSize())
        self.m_tabView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.m_tabView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);  --从上到下
        self.m_tabView:setTouchEnabled(false)
        self.m_tabView:setClippingToBounds(false)
        self.m_tabView:registerScriptHandler(handler(self, self.tableCellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_tabView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
        self.m_tabView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_listNode:addChild(self.m_tabView)
        -- self.m_listNode:enableManualBatch()
    end

    self.m_boxNode:removeAllChildren()
    for _, v in pairs(self.m_boxEffect) do
        v:stopSystem()
    end

    local chapterState = ChapterQuestController:shared():getState()
    if chapterState == 1 then  --只有最终礼包没有领取
        self.m_nameLabel[3]:setVisible(false)
        self.m_lockNode[1]:setVisible(true)
        self.m_listNode:setVisible(false)
        self.m_bottomNode:setVisible(false)
        self.m_bottomNode2:setVisible(false)

        for _, v in pairs(self.m_boxEffect) do
            v:resetSystem()
        end

        local effectBox = CCBLoadFile("ChapterBoxEffect", self.m_boxNode)
        effectBox:setPosition(Vec2(-308.5, -346))
    elseif chapterState == -1 then
        self.m_nameLabel[3]:setVisible(true)
        self.m_lockNode[1]:setVisible(true)
        self.m_lockNode[2]:setVisible(false)
        self.m_listNode:setVisible(false)
        self.m_bottomNode:setVisible(false)
        self.m_bottomNode2:setVisible(false)
    else
        self.m_tabView:reloadData()
        self.m_lockNode[1]:setVisible(false)
    end

    local limit = CCCommonUtils:getXmlPropById("function_link", "go_effects", "chapterReward")

    local isChapterEnd = true
    local taskLeftCount = 0
    for _, it in pairs(self.m_chapters) do
        if it then
            if it.state == mm.QuestState.ACCEPT then  --0进行中的任务
                isChapterEnd = false
                taskLeftCount = taskLeftCount + 1
            elseif it.state == mm.QuestState.COMPLETE then
                taskLeftCount = taskLeftCount + 1
                -- isChapterEnd = false
            end
        end
    end
    
    if isVersionOf451After() then
        --章节任务到430之前的版本
        if isChapterEnd and  taskLeftCount <= 1 then
            self.m_btnReward:setEnabled(true)
            local EffectNode = CCBLoadFile("Effect/EffectIcon_23", self.m_btnReward)
            EffectNode:setName("EffectIcon_23")
            local size = self.m_btnReward:getContentSize()
            EffectNode:setPosition(size.width * 0.5, size.height * 0.5)
        else
            self.m_btnReward:setEnabled(false)    
        end
    else

        if self.m_corpseBtn:getChildByName("EffectIcon_6") then
            self.m_corpseBtn:removeChildByName("EffectIcon_6")
        end

        if isChapterEnd and chapterIndex >= atoi(limit) then
            local node = CCBLoadFile("Effect/EffectIcon_6", self.m_corpseBtn)
            node:setName("EffectIcon_6")
            local size = self.m_corpseBtn:getContentSize()
            node:setPosition(size.width * 0.5, size.height * 0.5)
            node:setRenderDepthAndPass(2001)
        end
    end
end

function ChapterQuestView:setChapterGift()

    --[[
     如果是初章，不显示
     判断当前进度，当前进度之前有可领奖的 chapter ，显示对应章节的奖励
     当前进度之前没有，显示下一个奖励和下一个奖励对应的章节
     --]]

    self.m_richLblDes:setString(ChapterQuestController:shared():getProgressRewardTip());  --章节进度提示

    local gift_index = ChapterQuestController:shared():getCurIndexProgressReward()
    self.m_getBMLab:setString(CC_ITOA(gift_index))
    --是否显示特效

    local progressRewardInfo = ChapterQuestController:shared():getProgressRewardInfo(gift_index)
    if progressRewardInfo == nil then
        self.m_giftNode:setVisible(false)
    else
        self.m_giftNode:setVisible(true)
        self.m_giftParticNode:removeAllChildren()
        if progressRewardInfo.heroId ~= "" then
            local heroColor = CCCommonUtils:getXmlPropById("heroesBase", progressRewardInfo.heroId, "Adjutant_color")
            local heroName = CCCommonUtils:getXmlPropById("heroesBase", progressRewardInfo.heroId, "Adjutant_name")

            local probg = heroColor == "1" and "tool_4.png" or (heroColor == "2" and "tool_5.png" or (heroColor == "3"  and {"tool_6.png" } or ""))
            local proIcon = "small_" .. CCCommonUtils:getXmlPropById("heroesBase", progressRewardInfo.heroId, "smallIcon") .. ".png"

            local bg_spr = CCLoadSprite:createSprite(("com1001_renwudi.png"))
            local bg_icon = CCLoadSprite:createSprite((proIcon))

            bg_spr:setScale(0.66)
            bg_icon:setScale(0.85)

            self.m_giftParticNode:addChild(bg_spr)
            self.m_giftParticNode:addChild(bg_icon)

        elseif progressRewardInfo.goodsId ~= "" then
            local toolID = tonumber(progressRewardInfo.goodsId)
            local info = ToolController:getInstance():getToolInfoByIdForLua(toolID)
            if info ~= nil and info.itemId > 0 then
                local bg_spr = CCLoadSprite:createSprite(("com1001_renwudi.png"))
                local bg_icon = CCLoadSprite:createSprite((CCCommonUtils:getIcon(CC_ITOA(info.itemId))))

                CCCommonUtils:setNodeMaxSize(bg_spr, 80)
                CCCommonUtils:setNodeMaxSize(bg_icon, 70)

                self.m_giftParticNode:addChild(bg_spr)
                self.m_giftParticNode:addChild(bg_icon)
            end
        end
        local str = "x"
        str = str .. (CC_ITOA(progressRewardInfo.goodsNum))
        self.m_giftNum:setString(str)
        if progressRewardInfo.goodsNum == 1 then
            self.m_giftNum:setVisible(false)
        end
    end

    local isCanGet = ChapterQuestController:shared():isGetProgressReward(gift_index)
    if isCanGet then
        if self.m_giftParticNode:getChildByName("EffectIcon_20") then
            self.m_giftParticNode:removeChildByName("EffectIcon_20")
        end
        local node = CCBLoadFile("Effect/EffectIcon_20", self.m_giftParticNode)
        node:setName("EffectIcon_20")
        node:setLocalZOrder(-1)
    else
        if self.m_giftParticNode:getChildByName("EffectIcon_20") then
            self.m_giftParticNode:removeChildByName("EffectIcon_20")
        end
    end
end

function ChapterQuestView:onSpineNode(index)
    self.m_spineNode:removeAllChildren()
    local iconStr = ChapterQuestController:shared():getChapterBgIconName(index)

    local icon = string.format("%s.png", iconStr)
    local chapterBgSpr = CCLoadSprite:createScale9Sprite(icon)
    chapterBgSpr:setAnchorPoint(cc.p(0, 0))
    chapterBgSpr:setPosition(0, 0)
    self.m_spineNode:addChild(chapterBgSpr)
end

function ChapterQuestView:getAdjustHeight(taskId)
    if self.m_txtCell == nil then
        return 0
    end
    local task = ChapterQuestController:shared():getChapterQuestInfoById(taskId)
    self.m_txtCell:setString(task.name)

    local offestH = self.m_txtCell:getContentSize().height + 45
    return math.max(offestH, ChapterCellSize.height)
end

function ChapterQuestView:tableCellSizeForIndex(table, idx)
    return ChapterCellSize.width, self:getAdjustHeight(self.m_chapters[idx + 1].itemId)
end

function ChapterQuestView:numberOfCellsInTableView(table)
    return #self.m_chapters
end

function ChapterQuestView:tableCellAtIndex(table, idx)
    local cell = MMUtils:dynamicCast(table:dequeueCell(), "ChapterQuestCell")
    if cell == nil then
        cell = ChapterQuestCell:create()
    end

    cell:setIndex(idx)
    cell:setDelegate(self)
    cell:setData(self.m_chapters[idx + 1].itemId)
    cell:setZOrder(#self.m_chapters - 1 - idx)
    
    return cell
end

function ChapterQuestView:onItemBtnClick(pSender, pCCControlEvent)
    local index = MMUtils:dynamicCast(pSender, "cc.ControlButton"):getTag()
    local rewardSize = #self.m_chapterReward
    if rewardSize == 0 or index > rewardSize / 3 then
        return
    end
    local id = self.m_chapterReward[index * 3 + 1]
    if atoi(id) ~= 0 then
        local type = atoi(self.m_chapterReward[index * 3 + 3])
        local pos = string.format("%f,%f", SCREEN_SIZE.width / 2, self.m_bottomNode:getPositionY() + self.m_bottomNode:getContentSize().height + 150)
        PopupViewController:getInstance():addPopupView(EveryGiftTipsNode:create(id, type, pos))
    end
end

function ChapterQuestView:onTouchBegan(pTouch, pEvent)
    if self.m_tabView and self.m_tabView:isDragging() then
        return false
    end

    return true
end

function ChapterQuestView:onTouchEnded(pTouch, pEvent)
    if not isTouchInside(self.m_mainNode, pTouch) then  --点击到空白区域关闭窗口
        SoundController:sharedSound():playEffects(mm.Music_Sfx_button_click_cancel)
        self:closeSelf()
    end
end

function ChapterQuestView:onRewardBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_button_click_reward)

    local chapterIndex = ChapterQuestController:shared():getChapterIndex()
    local taskIds = ""
    local haveHeroMarchTaskId = false;  --是否含有触发武将行军引导的任务
    for _, it in pairs(self.m_chapters) do
        if it and it.state == mm.QuestState.COMPLETE then
            -- C++ 代码，意义不明
            -- taskIds += StringUtils::format(taskIds == "" ? "%s" : ";%s", taskIds.c_str());
            if it.itemId == "2510312" then
                haveHeroMarchTaskId = true
            end
        end
    end
    local startguideType = CCCommonUtils:getXmlPropById("querst_chapter", CC_ITOA(chapterIndex), "startguide");  --1-关闭当前界面

    local cmd = ChapterNextQuestCommand:create(chapterIndex, taskIds)
    if cmd then
        cmd:send()
    end

    if startguideType == "1" then
        self:onCloseView()
    end
    if haveHeroMarchTaskId then
    end
end

function ChapterQuestView:onBoxBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_button_click_reward)

    local isProgressEnd = ChapterQuestController:shared():isProgressRewardEnd()
    local chapterIndex = ChapterQuestController:shared():getChapterIndex()
    local cmd = ChapterNextQuestCommand:create(chapterIndex, "")
    cmd:send()
    if isProgressEnd then
        self:onCloseView()
    end
end

function ChapterQuestView:onLookBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)

    MMUtils:postNotification(mm.GUIDE_INDEX_CHANGE, CCString:create("Chapter_goProgress"))

    -- self:setVisible(false)
    self.m_baseNode:setVisible(false)

    local preview = ChapterPreview:create()
    -- preview:setPreViewNode(self)
    preview:setPreViewNode(self.m_baseNode)
    PopupViewController:getInstance():addPopupView(preview, true)
end

function ChapterQuestView:onCloseBtnClick(pSender, pCCControlEvent)
    MMUtils:postNotification(mm.GUIDE_INDEX_CHANGE,CCString:create("Chapter_close"))

    SoundController:sharedSound():playEffects(mm.Music_Sfx_button_click_cancel)
    self:onCloseView()
end

--使用代理关闭当前窗口
function ChapterQuestView:onCloseView()
    self:closeSelf()
end

function ChapterQuestView:getGuideNode(key)
    if key == "goProgress" then
        return self.m_btnLook
    elseif key == "close" then
        return self.m_closeBtn
    elseif key == "reward" then
        return self.m_rewardBtn
    elseif key == "corpse" then
        return self.m_corpseBtn
    else
        local cells = self.m_tabView:getContainer():getChildren()
        for _, it in pairs(cells) do
            local cell = MMUtils:dynamicCast(it, "ChapterQuestCell")
            if cell and cell:getIndex() == 0 then
                return cell:getGuideNode(key)
            end
        end
    end
    return nil
end

function ChapterQuestView:onCorpseClick(pSender ,pCCControlEvent)
    
    local ChapterCorpseView = drequire("view.popup.ChapterQuest.ChapterCorpseView")
    PopupViewController:getInstance():addPopupView(ChapterCorpseView:create())
    CCSafeNotificationCenter:sharedNotificationCenter():postNotification(mm.GUIDE_INDEX_CHANGE, CCString:create("Chapter_corpse"))
    return true
end

function ChapterQuestView:getTowerDataCallback(pObj)
    GameController:getInstance():removeWaitInterface()
    if pObj then
        local dictData = pObj.params
        local tower_data = MMData.DefenseData:getTowerDataById(pObj)
        if dictData and dictData.star == "0" then
            MMData.DefenseData.curId = tower_data.id

            local tamp = {}
            tamp.type = MMData.DefenseData.PveGoToType.ENUM_LIMIT_VIEW
            local limitData = string.split(tower_data.buiding_limit, ";")
            if tower_data.buiding_limit then
                local m_info = FunBuildController:getInstance():getFunbuildById_2(tonumber(limitData[2]))
                local isShow = FunBuildController:getInstance():isExistBuildByTypeLv(tonumber(limitData[2])/1000,tonumber(limitData[1]))
                if ((isShow and tonumber(limitData[1]) > 1) or (tonumber(limitData[1]) == 1 and not m_info.lockstate)) then

                    if not m_info.lockstate and limitData[2] == 418000002 then
                        CCCommonUtils:flyHint("", "", _lang("tafang61"))
                    elseif not m_info.lockstate and limitData[2] == 418000003 then
                        CCCommonUtils:flyHint("", "", _lang("tafang62"))
                    end

                    if not isShow and tonumber(limitData[1]) > 1 then
                        local layer = MMUtils:luaCast(SceneController:getInstance():getCurrentLayerByLevel(mm.LEVEL_SCENE), "ImperialScene")
                        if layer then
                            layer:onMoveToBuildAndOpen(limitData[2])
                        end
                        self:closeSelf()
                        return
                    else
                        local layer = MMUtils:luaCast(SceneController:getInstance():getCurrentLayerByLevel(mm.LEVEL_SCENE), "ImperialScene")
                        if layer then
                            layer:onMoveToBuildAndPlay(limitData[2])
                        end
                        self:closeSelf()
                        return
                    end
                end
            
            end
        
            PopupViewController:getInstance():addPopupInView(PvePrepareView:create())
            self:closeSelf()
        else
            --已经通关
            local tower_type = MMUtils:getXmlPropById("defense_level_config",tower_data.id,"towerType")
            if tower_type and atoi(tower_type) == MMData.DefenseData.TowerType.ENUM_TASK_CHAPTER then
                ChapterQuestController:shared():goNextChapter()
            end
            self:closeSelf()
        end
    end
end

function ChapterQuestView:onRewordClick(pSender ,pCCControlEvent)
    --查看奖励
    local chapterIndex = ChapterQuestController:shared():getChapterIndex()
    local arr = ChapterQuestController:shared():getAllChapterReward()[chapterIndex]
    if arr then
        local ItemListView = drequire("view.popup.ItemListView")
        local box = ItemListView:create()
        box:setData(arr)
        box:setTitleStr(_lang("700025"))
        box:resetUI()
        PopupViewController:getInstance():addPopupView(box)
    else
        self.m_isClick = true
        local ChapterRewardShowCommand = drequire("net.command.ChapterRewardShowCommand")
        local cmd = ChapterRewardShowCommand:create(chapterIndex, 0, 0)
        cmd:send()
    end


end


return ChapterQuestView