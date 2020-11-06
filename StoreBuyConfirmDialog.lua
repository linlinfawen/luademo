--类定义
local StoreBuyConfirmDialog = class("StoreBuyConfirmDialog", function() return PopupBaseView:create() end)

function StoreBuyConfirmDialog:dtor(void)

end

function StoreBuyConfirmDialog:ctor()
	self.m_effNodePos = CCPointZero
	self.m_effNodeSize = CCSizeZero
	self.m_waitInterface = nil
	self.m_onClose = nil
	self.m_numCurrent = 1
	self.m_numAll = 1
	self.m_numNode = nil
	self.m_price = 0
	self.m_priceType = 0
end

function StoreBuyConfirmDialog:show(url, title, desc, price, color, func, startPos, priceType, cCount)
    local dialog = StoreBuyConfirmDialog:create(url, title, desc, price, color, func, startPos, priceType, cCount)
    -- dialog:setYesCallback(func)
    self.m_onYes = func
    self.m_onYes:retain()
    self.m_startPos = startPos
    -- dialog:setStartPos(startPos)
    PopupViewController:getInstance():addPopupView(dialog, false)
    -- dialog:release()
    return dialog
end
function StoreBuyConfirmDialog:create(url, title, desc, price, color, func, startPos, priceType, cCount)
    local pRet = StoreBuyConfirmDialog.new()
    if pRet and pRet:initView(url, title, desc, price, color, func, startPos, priceType, cCount) then
    else
        CC_SAFE_DELETE(pRet)
    end
    return pRet
end

function StoreBuyConfirmDialog:initView(url, title, desc, price, color, func, startPos, priceType, cCount)
    if (self:initBase() == false) then
        return false
    end

    -- self:setIsHDPanel(true)
    local bRet = false
    self:setModelLayerOpacity(220)
    CCLoadSprite:doResourceByCommonIndex(11, true)
    self:setCleanFunction(function ()
        --        CCLoadSprite:doResourceByCommonIndex(11, false)
    end)

    if CCBLoadFile("StoreBuyConfirmDialog", self, self) then
        local size = cc.Director:getInstance():getWinSize()
        self:setContentSize(size)
        local maxWidth = self.m_subNode:getContentSize().width
        local maxHeight = self.m_subNode:getContentSize().height
        --label可滑动，放在scrollview上
        local label = CCLabelIF:create()
        label:setDimensions(CCSize(maxWidth, 0))
        label:setString(desc)
        label:setColor(ccc3(169, 132, 71))
        label:setFontSize(24)
        label:setVerticalAlignment(kCCVerticalTextAlignmentTop)
        label:setHorizontalAlignment(kCCTextAlignmentLeft)
        local totalHeight = label:getContentSize().height * label:getOriginScaleY()
        if totalHeight > maxHeight then
            local scroll = CCScrollView:create(CCSize(maxWidth, maxHeight))
            scroll:setContentSize(CCSize(maxWidth, totalHeight))
            scroll:addChild(label)
            self.m_subNode:addChild(scroll)
            scroll:setPosition(CCPointZero)
            scroll:setDirection(kCCScrollViewDirectionVertical)
            scroll:setAnchorPoint(ccp(0, 0))
            scroll:setContentOffset(ccp(0, maxHeight - totalHeight))
        else
            self.m_subNode:addChild(label)
            label:setAnchorPoint(ccp(0, 1))
            label:setPosition(ccp(0, maxHeight))
        end
        local iconSize = self.m_sprIconBG:getContentSize()
        iconSize.width = iconSize.width - 20
        iconSize.height = iconSize.height -20
        local scale = 1
        if color >= 0 then
            local picBG = CCLoadSprite:createSprite(CCCommonUtils:getToolBgByColor(color))
            CCCommonUtils:setSpriteMaxSize(picBG, mm.ITEM_BG_SIZE_2)
            self.m_nodeIcon:addChild(picBG)
            picBG:setPosition(self.m_sprIconBG:getPosition())
        end
        local pic = CCLoadSprite:createSprite(url, true, mm.CCLoadSpriteType.CCLoadSpriteType_GOODS)
        CCCommonUtils:setSpriteMaxSize(pic, mm.ITEM_SIZE_2)
        self.m_nodeIcon:addChild(pic)

        pic:setPosition(self.m_sprIconBG:getPosition())
        self.m_lblTitle:setString(title)
        self.m_lblDesc:setString(_lang("104919"))
        self.isShowConfirm = true
        if priceType == -1 then
            self.m_lblDesc:setString(_lang_1("115817", title))
        end
        -- self.m_btnOk:setTouchPriority(1)

        self.m_costNode:removeAllChildren()
        if priceType == -1 then
            local costIcon = CCLoadSprite:createSprite("Contribution_icon1.png")
            costIcon:setScale(0.7)
            if costIcon then
                self.m_costNode:addChild(costIcon)
            end

            self.m_costNode:setZOrder(2)
        elseif priceType < mm.WorldResourceType.WorldResource_Max then
            local costIcon = CCLoadSprite:createSprite(CCCommonUtils:getResourceIconByType(priceType))
            if priceType == mm.WorldResourceType.Gold then
                costIcon:setScale(0.9)
            elseif priceType == mm.WorldResourceType.TowerPro then --Extramis_Point
                costIcon:setScale(0.4)
            elseif priceType == mm.WorldResourceType.SeasonAimPoint then
                costIcon:setScale(0.4)
            end
            if costIcon then
                self.m_costNode:addChild(costIcon)
            end
        else
            local priceNode = CCNode:create()
            local priceSpr = CCLoadSprite:createSprite("Items_icon_kuang.png")
            priceSpr:setVisible(false)
            priceNode:addChild(priceSpr)
            local priceSize = priceSpr:getContentSize()
            CCCommonUtils:createGoodsIcon(priceType, priceNode,CCSize(priceSize.width - 20, priceSize.height - 20))
            local scale = 38.0 / priceSize.width
            priceNode:setScale(scale)
            --            priceNode:setPositionY(-5)
            self.m_costNode:addChild(priceNode)
        end

        self.m_sprBG:setVisible(false)
        if priceType == -1 then
            self.m_lblEffect:setString(_lang("104900"))
        else
            self.m_lblEffect:setString(_lang("104901"))
        end
        self.m_lblEffect:setVisible(false)
        self.m_lblEffect:setOpacity(0)
        self.m_sprEffect:setOpacity(0)
        self.m_sprEffect1:setOpacity(0)

        self.m_price = price
        self.m_priceType = priceType

        self.m_numNode:setVisible(false)
        self:setCostString()
        if cCount > 0 then
            local numBG = CCLoadSprite:createScale9Sprite("BG_quatnity.png")
            numBG:setColor(CCCommonUtils:getItemColor(color))
            numBG:setOpacity(200)
            local numIF = CCLabelBMFont:create(CC_ITOA_K(cCount), "fonts/pve_fnt_boss.fnt")
            local numSize = numIF:getContentSize()
            local constScale = 0.3
            local defSize = self.m_sprIconBG:getContentSize()
            local scale = defSize.height * constScale / numSize.height
            if (numSize.width * scale) > defSize.width then
                scale = defSize.width / numSize.width
            end
            numIF:setScale(scale)
            numSize.height = numSize.height *scale
            numBG:setPreferredSize(CCSize(defSize.width, defSize.height * constScale))
            self.m_nodeIcon:addChild(numBG)
            self.m_nodeIcon:addChild(numIF)
            numIF:setPositionY(defSize.height * constScale * 0.5)
            numBG:setPosition(numIF:getPosition())
        end
        bRet = true
    end
    return bRet
end
function StoreBuyConfirmDialog:setEffNodeRect(rect)
    self.m_effNodePos = self.m_sprEffect:getParent():convertToNodeSpace(rect.origin)
    self.m_effNodeSize = rect.size
    local size = self.m_sprEffect:getContentSize()
    local fScale = 1.0;  --size.width / self.m_effNodeSize.width
    if CCCommonUtils:isIosAndroidPad() then
        fScale = 1.9
    end
    self.m_sprEffect:setScale(fScale)
    self.m_effNodeSize = CCSizeMake(self.m_effNodeSize.width * fScale, self.m_effNodeSize.height * fScale)
    self.m_sprEffect:setPosition(self.m_effNodePos)
    if CCCommonUtils:isIosAndroidPad() then
        self.m_sprEffect1:setPosition(ccp(self.m_effNodePos.x, self.m_effNodePos.y + 65))
    else
        self.m_sprEffect1:setPosition(ccp(self.m_effNodePos.x, self.m_effNodePos.y + 33))
    end
    self.m_lblEffect:setPosition(self.m_effNodePos)
    self.m_effNodePos = self.m_nodeIcon:getParent():convertToNodeSpace(rect.origin)
end

function StoreBuyConfirmDialog:setCloseCallback(callFunc)
    self.m_onClose = callFunc
    self.m_onClose:retain()
end

function StoreBuyConfirmDialog:onEnter()
    -- self:setTouchMode(Touch:DispatchMode.ONE_BY_ONE)
    self:setTouchEnabled(true)

    CCSafeNotificationCenter:sharedNotificationCenter():registerScriptObserver(self, StoreBuyConfirmDialog.removeWaitInter, "msg.alliance.buy.fail", nil)
    if self:getParent() and (self:getParent():getChildByTag(5000) or self:getParent():getChildByTag(5001)) then
    else
        self:setTag(5001)
    end
    self:showDialog()
end

function StoreBuyConfirmDialog:onExit()
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.MSG_ALLIANCE_BUY_FAIL)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.MSG_BUY_CONFIRM_OK_WITHOUT_TWEEN)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.MSG_BUY_CONFIRM_OK)
    self:setTouchEnabled(false)

    if self.m_waitInterface then
        self.m_waitInterface:remove()
        self.m_waitInterface = nil
    end

    self.m_onYes:release()
end

function StoreBuyConfirmDialog:removeWaitInter(obj)
    if self.m_waitInterface then
        self.m_waitInterface:remove()
        self.m_waitInterface = nil
    end
end
function StoreBuyConfirmDialog:showDialog()

    local endPos = cc.p(self.m_nodeIcon:getPosition())
    local endScale = self.m_nodeIcon:getScale()
    local nodeSize = CCSizeMake(150, 150)
    self.m_nodeIcon:setScale(0.8)
    if CCCommonUtils:isIosAndroidPad() then
        self.m_nodeIcon:setScale(0.8 * endScale)
    end
    self.m_startPos = self.m_nodeIcon:getParent():convertToNodeSpace(self.m_startPos)
    if self.m_priceType ~= -1 then
        self.m_startPos.x = self.m_startPos.x + nodeSize.width * 0.4
        self.m_startPos.y = self.m_startPos.y + nodeSize.height * 0.4
    end
    self.m_nodeIcon:setPosition(self.m_startPos)
    self.m_nodeIcon:runAction(cc.Sequence:create(CCEaseExponentialOut:create(cc.MoveTo:create(0.5, endPos)), nil))
    self.m_nodeIcon:runAction(cc.Sequence:create(cc.ScaleTo:create(0.25, endScale), nil))
    self.m_nodeIcon:runAction(cc.Sequence:create(cc.DelayTime:create(0.15), cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.showBG)), nil))
end
function StoreBuyConfirmDialog:showBG()
    self.m_sprBG:setVisible(true)
    self.m_sprBG:runAction(cc.Sequence:create(cc.FadeIn:create(0.1), nil))
end
function StoreBuyConfirmDialog:closeDialog()
    print("closeDialog===========closeDialog")
    SoundController:sharedSound():playEffects(Music_Sfx_button_click_cancel)
    if self.m_sprBG then
        self.m_sprBG:stopAllActions()
        self.m_nodeIcon:stopAllActions()
        self.m_sprEffect:stopAllActions()
        self.m_sprEffect1:stopAllActions()
        self:closeSelf()
        if self.m_onClose then
            self.m_onClose:execute()
            self.m_onClose:release()
            self.m_onClose = nil
        end
    end
end
function StoreBuyConfirmDialog:onTouchBegan(pTouch, pEvent)
    if isTouchInside(self.m_touchNode, pTouch) then
        return false
    end
    self.m_touchNode:getParent():runAction(cc.Sequence:create(cc.ScaleTo:create(0.25, 0), cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.closeDialog)), nil))
    return true
end

function StoreBuyConfirmDialog:onTouchEnded(pTouch, pEvent)

end

function StoreBuyConfirmDialog:onOkBuyResource()
    if self.m_priceType < mm.WorldResourceType.WorldResource_Max and self.m_priceType >= 0 then
        if self.m_priceType == mm.WorldResourceType.Gold then
            PopupViewController:getInstance():addPopupView(GoldExchangeView:create(), false)
        elseif self.m_priceType == mm.WorldResourceType.RmbPoint then
            PopupViewController:getInstance():addPopupView(ConfirmRmbPointView:create())
        else
            PopupViewController:getInstance():addPopupInView(LuaHelper:createUseResToolView(self.m_priceType))
        end
    end
end

function StoreBuyConfirmDialog:keyPressedBtnOk(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if self.m_waitInterface then
        return
    end

    dlog("-~-~-~-~-self:keypressedBtnOk-~-~-~-~-~-~-~")
    local price = self.m_price * self.m_numCurrent
    if self.m_priceType == -1 then
        if GlobalData:shared():getPlayerInfo().allianceInfo.alliancepoint < price then
            CCCommonUtils:flyHint("", "", _lang("115827"))
            return
        end
    elseif self.m_priceType < mm.WorldResourceType.WorldResource_Max then
        if not CCCommonUtils:isEnoughResourceByType(self.m_priceType, price) then
            if self.m_priceType < mm.WorldResourceType.WorldResource_Max and self.m_priceType >= 0 then
                if self.m_priceType ==  mm.WorldResourceType.Gold then
                    self:retain()
                    self:closeSelf()
                    YesNoDialog:gotoPayTips()
                    if self.m_onClose then
                        self.m_onClose:execute()
                        self.m_onClose = nil
                    end
                    self:release()
                elseif self.m_priceType == mm.WorldResourceType.RmbPoint then
                    self:retain()
                    self:closeSelf()
                    --点券不足
                    PopupViewController:getInstance():addPopupView(ConfirmRmbPointView:create())
                    if self.m_onClose then
                        self.m_onClose:execute()
                        self.m_onClose = nil
                    end
                    self:release()
                elseif self.m_priceType == mm.WorldResourceType.TowerPro then
                    CCCommonUtils:flyHint("", "", _lang("EX00140"))
                elseif self.m_priceType ==  mm.WorldResourceType.LongJing then
                    local res = CCCommonUtils:getResourceNameByType(self.m_priceType)
                    local showString = _lang_1("111656", res)
                    local dialog = YesNoDialog:showYesDialog(showString, false, nil, false)
                    dialog:setYesButtonTitle(_lang("101274"));  --确定
                    self:closeDialog()
                else
                    local res = CCCommonUtils:getResourceNameByType(self.m_priceType)
                    local showString = _lang_2("104943", res, res)
                    local dialog = YesNoDialog:showYesDialog(showString, false, cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.onOkBuyResource)), false)
                    dialog:setYesButtonTitle(_lang_1("104944", res))
                    self:closeDialog()
                end
            end
            return
        end

    else
        local tInfo = ToolController:getInstance():getToolInfoByIdForLua(self.m_priceType)
        if tInfo.getCNT() < price then
            YesNoDialog:showYesDialog(_lang_2("104957", tInfo.getName(), self.m_lblTitle:getString()))
            self:closeDialog()
            return
        end
    end

    if self.m_numCurrent > 1 and self.isShowConfirm then
        local des = self.m_lblTitle:getString() .. " x " .. CC_ITOA(self.m_numCurrent)
        local showString = _lang_1("104954", des)
        if self.m_priceType == -1 then
            showString = _lang_1("115817", des)
        end
        YesNoDialog:showYesDialog(showString, false, cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.onOKBuy)), false)
    else
        self:onOKBuy()
    end
end

function StoreBuyConfirmDialog:onOKBuy()
    if self.m_onYes then
        -- self.m_waitInterface = GameController:getInstance():showWaitInterface(self)
        CCSafeNotificationCenter:sharedNotificationCenter():registerScriptObserver(self, StoreBuyConfirmDialog.playBuyEffect, mm.MSG_BUY_CONFIRM_OK, nil)
        CCSafeNotificationCenter:sharedNotificationCenter():registerScriptObserver(self, StoreBuyConfirmDialog.playBuyWithoutEffect, mm.MSG_BUY_CONFIRM_OK_WITHOUT_TWEEN, nil)
        local callObj = CCInteger:create(self.m_numCurrent)
        self.m_onYes:setObject(callObj)
        self.m_onYes:execute()
    end
end

function StoreBuyConfirmDialog:playBuyWithoutEffect(ccObj)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.MSG_BUY_CONFIRM_OK_WITHOUT_TWEEN)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.MSG_BUY_CONFIRM_OK)
    if self.m_waitInterface then
        self.m_waitInterface:remove()
        self.m_waitInterface = nil
    end

    self:closeDialog()
    return

    self:hideEffect()
end

function StoreBuyConfirmDialog:playBuyEffect(ccObj)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.MSG_BUY_CONFIRM_OK_WITHOUT_TWEEN)
    CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.MSG_BUY_CONFIRM_OK)

    if self.m_waitInterface then
        self.m_waitInterface:remove()
        self.m_waitInterface = nil
    end

    self:closeDialog()
    return

--     if not self.m_sprBG then
--         self:hideEffect()
--         return
--     end
--     self.m_sprBG:setVisible(false)
-- --[[
-- CPP2LUA:
-- 注意getPosition返回的是x, y两个变量
-- --]]
--     local centrePos = self.m_sprBG:getPosition()
--     if CCCommonUtils:isIosAndroidPad() then
--         self.m_nodeIcon:runAction(cc.Sequence:create(cc.ScaleTo:create(1.4, 1 * 1.9), nil))
--     else
--         self.m_nodeIcon:runAction(cc.Sequence:create(cc.ScaleTo:create(1.4, 1), nil))
--     end
--     self.m_nodeIcon:runAction(cc.Sequence:create(CCEaseExponentialOut:create(cc.MoveTo:create(1, centrePos)), nil))
--     self.m_nodeIcon:runAction(handler(cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(self, StoreBuyConfirmDialog.showEffect)), nil))
--     self.m_nodeIcon:runAction(handler(cc.Sequence:create(cc.DelayTime:create(2.5), cc.CallFunc:create(self, StoreBuyConfirmDialog.flyIcon)), nil))
end
function StoreBuyConfirmDialog:showEffect()
    SoundController:sharedSound():playEffects(mm.Music_Sfx_UI_secret )

    local centrePos = cc.p(self.m_sprBG:getPosition())
    local particle = ParticleController:createParticle("MallBag_1")
    self.m_sprBG:getParent():addChild(particle, self.m_nodeIcon:getZOrder() - 1)
    particle:setPosition(centrePos)
    local particle1 = ParticleController:createParticle("MallBag_2")
    self.m_sprBG:getParent():addChild(particle1, self.m_nodeIcon:getZOrder() - 1)
    particle1:setPosition(centrePos)
    local particle2 = ParticleController:createParticle("MallBag_3")
    self.m_sprBG:getParent():addChild(particle2, self.m_nodeIcon:getZOrder() - 1)
    particle2:setPosition(centrePos)
    if self.m_effNodeSize.equals(CCSizeZero) == false or self.m_effNodePos.equals(CCPointZero) == false then
        self.m_lblEffect:setVisible(true)
        self.m_sprEffect:runAction(cc.Sequence:create(cc.FadeIn:create(1), nil))
        self.m_sprEffect1:runAction(cc.Sequence:create(cc.FadeIn:create(1), nil))
        --        self.m_nodeIcon:setZOrder(self.m_sprEffect1:getZOrder()+1)
    end
end
function StoreBuyConfirmDialog:flyIcon()
    if self.m_effNodePos.equals(CCPointZero) == true and self.m_effNodeSize.equals(CCSizeZero) == true then
        self.m_nodeIcon:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3, 0), cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.hideEffect)), nil))
    else
        if CCCommonUtils:isIosAndroidPad() then
            self.m_nodeIcon:runAction(cc.Sequence:create(cc.ScaleTo:create(0.6, 0.4 * 1.9), nil))
        else
            self.m_nodeIcon:runAction(cc.Sequence:create(cc.ScaleTo:create(0.6, 0.4), nil))
        end
        local pos = ccp(self.m_effNodePos.x - 20, self.m_effNodePos.y + self.m_effNodeSize.height + self.m_nodeIcon:getContentSize().height)
        self.m_nodeIcon:runAction(cc.Sequence:create(CCEaseExponentialOut:create(cc.MoveTo:create(0.6, pos)), cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.flyIcon1)), nil))
    end
end
function StoreBuyConfirmDialog:flyIcon1()
    self.m_nodeIcon:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3, 0), nil))
    local pos = ccp(self.m_effNodePos.x, self.m_effNodePos.y - self.m_effNodeSize.height * 0.2)
    if CCCommonUtils:isIosAndroidPad() then
        pos = ccp(pos.x + 0, pos.y + 30)
    end
    self.m_nodeIcon:runAction(cc.Sequence:create(CCEaseExponentialOut:create(cc.MoveTo:create(0.3, pos)), cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.hideEffect)), nil))
    self.m_nodeIcon:getParent():setZOrder(self.m_sprEffect:getZOrder() - 1)
end
function StoreBuyConfirmDialog:hideEffect()
    if (self.m_effNodeSize.equals(CCSizeZero) == false or self.m_effNodePos.equals(CCPointZero) == false) and self.m_lblEffect and self.m_sprEffect and self.m_sprEffect1 then
        self.m_lblEffect:setVisible(false)
        self.m_sprEffect:runAction(cc.Sequence:create(cc.FadeOut:create(1), cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.closeDialog)), nil))
        self.m_sprEffect1:runAction(cc.Sequence:create(cc.FadeOut:create(1), cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.closeDialog)), nil))
    else
        self:closeDialog()
    end
end

function StoreBuyConfirmDialog:setShowConfirm(isShow)
    self.isShowConfirm = isShow
end   

function StoreBuyConfirmDialog:showSliderBar(max,isSliderMax)
    self.m_numAll = max
    self.m_numCurrent = 1
    
    local size = self.m_barNode:getContentSize()
    local m_sliderBg = CCLoadSprite:createScale9Sprite("huadongtiao3.png")
    m_sliderBg:setInsetBottom(5)
    m_sliderBg:setInsetLeft(5)
    m_sliderBg:setInsetRight(5)
    m_sliderBg:setInsetTop(5)
    m_sliderBg:setAnchorPoint(ccp(0.5, 0.5))
    m_sliderBg:setContentSize(CCSize(size.width, 25))
    m_sliderBg:setPosition(ccp(size.width * 0.5 - 5, size.height * 0.5 + 16))

    local proSp = CCLoadSprite:createSprite("huadongtiao2.png")
    local thuSp = CCLoadSprite:createSprite("huadongtiao1.png")

    self.m_slider = CCSliderBar:createSlider(m_sliderBg, proSp, thuSp)
    if CCCommonUtils:isIosAndroidPad() then
        local __ThumbSprite = self.m_slider:getThumbSprite()
        __ThumbSprite:setScaleX(0.7)
        --         __ThumbSprite:setScaleY(0.5)
    end
    local minVal = self.m_numCurrent * 1.0 / self.m_numAll
    self.m_slider:setMinimumValue(minVal)
    self.m_slider:setMaximumValue(1.0)
    if isSliderMax then
        self.m_slider:setValue(1.0)
        self.m_numCurrent = self.m_numAll
        self:setCostString()
    else
        self.m_slider:setValue(minVal)
    end
    
    self.m_slider:setProgressScaleX(size.width / proSp:getContentSize().width)
    self.m_slider:setTag(1)
    self.m_slider:setLimitMoveValue(20)
    self.m_slider:setPosition(ccp(size.width * 0.5, size.height * 0.5))
    self.m_slider:registerControlEventHandler(handler(self, StoreBuyConfirmDialog.moveSlider), cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
    self.m_barNode:addChild(self.m_slider)

    local editSize = self.m_editNode:getContentSize()
    local editpic = CCLoadSprite:createScale9Sprite("frame_text2.png")
    editpic:setInsetBottom(8)
    editpic:setInsetTop(8)
    editpic:setInsetRight(10)
    editpic:setInsetLeft(10)
    editpic:setPreferredSize(editSize)
    self.m_editBox = CCEditBox:create(editSize, editpic)
    self.m_editBox:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
   
    self.m_editBox:setText(CC_CMDITOA(self.m_numCurrent))
    -- self.m_editBox:setDelegate()
    -- self.m_editBox:setTouchPriority(Touch_Popup)
    self.m_editBox:setMaxLength(12)
    self.m_editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self.m_editBox:setPosition(ccp(editSize.width / 2, editSize.height / 2))
    self.m_editBox:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    --self.m_editBox:setTouchPriority(Touch_Default)
    self.m_editNode:addChild(self.m_editBox)
    self.m_numNode:setVisible(true)
end
function StoreBuyConfirmDialog:moveSlider(pSender, pCCControlEvent)
    local percent = MAX(self.m_slider:getValue(), self.m_slider:getMinimumValue())
    percent = MIN(percent, self.m_slider:getMaximumValue())
    local num = math.round(percent * self.m_numAll)
    self.m_numCurrent = num
    local tmp = CC_CMDITOA(self.m_numCurrent)
    self.m_editBox:setText(tmp)
    self:setCostString()
end
function StoreBuyConfirmDialog:setCostString()
    local costVal = self.m_price * self.m_numCurrent
    self.m_costNum:setString(CC_CMDITOA(costVal))
    if self.m_priceType == -1 then
        if GlobalData:shared():getPlayerInfo().allianceInfo.alliancepoint < costVal then
            self.m_costNum:setColor(ccc3(255,   0,   0))
        else
            self.m_costNum:setColor(ccc3(255, 225, 0 ))
        end
    elseif self.m_priceType < mm.WorldResourceType.WorldResource_Max then
        if not CCCommonUtils:isEnoughResourceByType(self.m_priceType, costVal) then
            self.m_costNum:setColor(ccc3(255,   0,   0))
        else
            self.m_costNum:setColor(ccc3(255, 255, 255))
        end
    else
        local info = ToolController:getInstance():getToolInfoByIdForLua(self.m_priceType)
        if info.getCNT() < costVal then
            self.m_costNum:setColor(255,   0,   0)
        else
            self.m_costNum:setColor(255, 255, 255)
        end
    end
end
function StoreBuyConfirmDialog:editBoxTextChanged(editBox, text)
    local lv = atoi(string.sub(text,1, string.find(text, '1234567890')))
    lv = lv <= 0 and 1 or lv
    if lv == 0 then
        editBox:setText("")
    else
        editBox:setText(CC_ITOA(lv))
    end
    editBox:setText(aaaa)
end
function StoreBuyConfirmDialog:editBoxReturn(editBox)
    local lv = atoi(string.sub(text,1, string.find(text, '1234567890')))
    lv = lv <= 0 and 1 or lv
    local num = lv
    self.m_numCurrent = MAX(MIN(num, self.m_numAll), 1)
    local percent = self.m_numCurrent * 1.0 / self.m_numAll
    self.m_slider:setValue(percent)
    self:setCostString()
end
function StoreBuyConfirmDialog:onAddClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)

    self.m_numCurrent = self.m_numCurrent + 1
    self.m_numCurrent = MAX(MIN(self.m_numCurrent, self.m_numAll), 1)
    local percent = self.m_numCurrent * 1.0 / self.m_numAll
    self.m_slider:setValue(percent)
    local tmp = CC_CMDITOA(self.m_numCurrent)
    self.m_editBox:setText(tmp)
    self:setCostString()
end
function StoreBuyConfirmDialog:onSubClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    self.m_numCurrent = self.m_numCurrent -1
    self.m_numCurrent = MAX(MIN(self.m_numCurrent, self.m_numAll), 1)
    local percent = self.m_numCurrent * 1.0 / self.m_numAll
    self.m_slider:setValue(percent)
    local tmp = CC_CMDITOA(self.m_numCurrent)
    self.m_editBox:setText(tmp)
    self:setCostString()
end

function StoreBuyConfirmDialog:onCloseBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    self.m_touchNode:getParent():runAction(cc.Sequence:create(cc.ScaleTo:create(0.25, 0), cc.CallFunc:create(handler(self, StoreBuyConfirmDialog.closeDialog)), nil))
end


return StoreBuyConfirmDialog