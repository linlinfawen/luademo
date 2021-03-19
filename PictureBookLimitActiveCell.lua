
local LuaHeroToolCell = drequire("view.popup.HeroToolCell")

local PictureBookLimitActiveCell = class("PictureBookLimitActiveCell", function (  )
    return CCTableViewTouchIFCell:create()
end)

function PictureBookLimitActiveCell:ctor()
	
end
function PictureBookLimitActiveCell:create()
    local ret = PictureBookLimitActiveCell.new()
    if ret and ret:initView() then
        return ret
    end
    CC_SAFE_DELETE(ret)
    return nil
end

function PictureBookLimitActiveCell:initView()
    self:initBase()
    local node = CCBLoadFile("PictureBookLimitActiveCell", self, self)
    self:setContentSize(self.m_mainNode:getContentSize())
    CCCommonUtils:setButtonTitle(self.m_gotoBtn, _lang("128106"))
    CCCommonUtils:setButtonTitle(self.m_activationBtn, _lang("3621005"))
    return true
end

function PictureBookLimitActiveCell:onEnter()
    self:setTouchEnabled(true)
end

function PictureBookLimitActiveCell:onExit()
    self:setTouchEnabled(false)
end

function PictureBookLimitActiveCell:onTouchBegan(pTouch, pEvent)
    return false
end

function PictureBookLimitActiveCell:onTouchMoved(pTouch, pEvent)
end

function PictureBookLimitActiveCell:onTouchEnded(pTouch, pEvent)
end

function PictureBookLimitActiveCell:onCloseBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    PopupViewController:getInstance():removeLastPopupView()
    -- CCSafeNotificationCenter:sharedNotificationCenter():postNotification(mm.STONE_SELECT_TOUCH, CCString:create(""))

end

function PictureBookLimitActiveCell:setData(toolID,Parent)
    self.Parent = Parent
    self.toolID = toolID
    self.m_activationBtn:setVisible(false)
    self.m_gotoBtn:setVisible(false)
    local toolInfo = ToolController:getInstance():getToolInfoByIdForLua(atoi(toolID))
    if toolInfo then
        local scale = 0.7
        local needNum = 1

        local data = {}
        data.value = {}
        data.type = mm.RewardType.R_GOODS
        data.value.id = toolID
        data.value.num = toolInfo:getCNT()
        
        local cell = LuaHeroToolCell:create(data,false)
        cell:hideName()
        cell:setSelectVisible(false)
        cell:setIsTopTips(false)
        cell:setScale(scale, scale)
        cell:showNum()
        cell:setAnchorPoint(ccp(0.5, 0.5))
        cell:setPosition(-108*scale / 2 ,-157*scale / 2)
        self.m_picTureBookNode:addChild(cell)
        self.m_nameTxt:setString(toolInfo:getName())

        if toolInfo:getCNT() >= needNum then  
            local numTxt = _lang_1("3621035", CC_ITOA(toolInfo:getCNT()))
            numTxt = numTxt..(_lang_1("3621036", CC_ITOA(needNum)))
            self.m_debrisLabel:setString(numTxt)
            self.m_activationBtn:setVisible(true)
        else
            local numTxt = _lang_1("3621035", CC_ITOA(toolInfo:getCNT()))
            numTxt = numTxt..(_lang_1("3621037", CC_ITOA(needNum)))
            self.m_debrisLabel:setString(numTxt)
            self.m_gotoBtn:setVisible(true)
        end    
    end
end

function PictureBookLimitActiveCell:onGoToShopBtnCilck(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if self.Parent then
        self.Parent:onGoToShop()
    end
end

function PictureBookLimitActiveCell:onClicActivationBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if self.Parent then
        self.Parent:Activation(self.toolID)
    end
end

return PictureBookLimitActiveCell
