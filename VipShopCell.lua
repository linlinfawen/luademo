--[[
    author:{zhujiangkun}
    time:2020-06-11 21:04:51
]]

--[[***************华丽的分割线*************--]]
local VipShopCellDepth ={
    VipShopCell_LeftBg = 0,
    VipShopCell_LeftBg2 = 1,
    VipShopCell_LeftIconBg = 2,
    VipShopCell_UnderLeftSpr = 3,
    VipShopCell_LeftName = 4,
    VipShopCell_LeftVipName = 5,
    VipShopCell_LeftVipBuy = 6,
    VipShopCell_LeftHotSpr = 7,
    VipShopCell_RightHotSpr = 8,
    VipShopCell_LeftHotDes = 9,
    VipShopCell_LeftBtn = 10,
    VipShopCell_LeftDinamSpr = 11,
    VipShopCell_OldPrice = 12,
    VipShopCell_NowPrice = 13,
    VipShopCell_LeftLineSpr = 14,
}
local VipBuyCommand = drequire("net.command.VipBuyCommand")
local StoreNewView = drequire("view.storeNew.StoreNewView")
local VipShopCell = class("VipShopCell", function()
    return CCTableViewTouchIFCell:create()
end)
function VipShopCell:create(index)
    local ret = VipShopCell.new(index)
    if ret and ret:initView(index) then
        return ret
    end
    return nil
end

function VipShopCell:initView(index)
    if not self:initBase() then
        return false
    end
    CCBLoadFile("VipShopCell", self, self)
    self.leftInfo = nil
    self.rightInfo = nil
    self.m_richLeftVipBuy = CCCommonUtils:createRichLabel(self.m_leftVipBuy)
    self.m_richRightVipBuy = CCCommonUtils:createRichLabel(self.m_rightVipBuy)
    self.m_leftBtn:setSwallowsTouches(false)
    self.m_rightBtn:setSwallowsTouches(false)
    self.m_index = index + 1
    self:setData(self.m_index)

    self.m_leftBg:setRenderDepth(VipShopCellDepth.VipShopCell_LeftBg)
    self.m_leftBg2:setRenderDepth(VipShopCellDepth.VipShopCell_LeftBg2)
    self.m_underLeftSpr:setRenderDepth(VipShopCellDepth.VipShopCell_UnderLeftSpr)
    self.m_leftName:setRenderDepth(VipShopCellDepth.VipShopCell_LeftName)
    self.m_leftVipName:setRenderDepth(VipShopCellDepth.VipShopCell_LeftVipName)
    self.m_leftVipBuy:setRenderDepth(VipShopCellDepth.VipShopCell_LeftVipBuy)
    self.m_leftHotSpr:setRenderDepth(VipShopCellDepth.VipShopCell_LeftHotSpr)
    self.m_leftHotDes:setRenderDepth(VipShopCellDepth.VipShopCell_LeftHotDes)
    self.m_leftBtn:setRenderDepth(VipShopCellDepth.VipShopCell_LeftBtn)
    self.m_leftDinamSpr:setRenderDepth(VipShopCellDepth.VipShopCell_LeftDinamSpr)
    self.m_leftNowPrice:setRenderDepth(VipShopCellDepth.VipShopCell_NowPrice)
    self.m_leftOldPrice:setRenderDepth(VipShopCellDepth.VipShopCell_OldPrice)
    self.m_leftLineSpr:setRenderDepth(VipShopCellDepth.VipShopCell_LeftLineSpr)

    self.m_rightBg:setRenderDepth(VipShopCellDepth.VipShopCell_LeftBg)
    self.m_rightBg2:setRenderDepth(VipShopCellDepth.VipShopCell_LeftBg2)
    self.m_underRightSpr:setRenderDepth(VipShopCellDepth.VipShopCell_UnderLeftSpr)
    self.m_rightName:setRenderDepth(VipShopCellDepth.VipShopCell_LeftName)
    self.m_rightVipName:setRenderDepth(VipShopCellDepth.VipShopCell_LeftVipName)
    self.m_rightVipBuy:setRenderDepth(VipShopCellDepth.VipShopCell_LeftVipBuy)
    self.m_rightHotSpr:setRenderDepth(VipShopCellDepth.VipShopCell_RightHotSpr)
    self.m_rightHotDes:setRenderDepth(VipShopCellDepth.VipShopCell_LeftHotDes)
    self.m_rightBtn:setRenderDepth(VipShopCellDepth.VipShopCell_LeftBtn)
    self.m_rightDinamSpr:setRenderDepth(VipShopCellDepth.VipShopCell_LeftDinamSpr)
    self.m_rightNowPrice:setRenderDepth(VipShopCellDepth.VipShopCell_NowPrice)
    self.m_rightOldPrice:setRenderDepth(VipShopCellDepth.VipShopCell_OldPrice)
    self.m_rightLineSpr:setRenderDepth(VipShopCellDepth.VipShopCell_LeftLineSpr)
    return true
end

function VipShopCell:onEnter()
    self:setTouchEnabled(true)
end

function VipShopCell:onExit()
    self:setTouchEnabled(true)
end


function VipShopCell:onTouchBegan(pTouch, pEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
    if isTouchInside(self.m_leftIconBg, pTouch) then
        PopupViewController:getInstance():addPopupView(CommonTipsView:create(_lang(self.leftInfo.des), self.leftInfo:getName(),kCCTextAlignmentCenter))
    end
    if isTouchInside(self.m_rightIconBg, pTouch) then
        PopupViewController:getInstance():addPopupView(CommonTipsView:create(_lang(self.rightInfo.des), self.rightInfo:getName(),kCCTextAlignmentCenter))
    end

    return false
end

function VipShopCell:onTouchEnded(touch, event)

end


function VipShopCell:setData(index)
    local vipinfoLeft = VipController:shared().VipShopInfoMap[index]
    if vipinfoLeft and vipinfoLeft.normal_price > 0 then  --有价格表示有数据
        self.m_LeftNode:setVisible(true)
        local tool = ToolController:getInstance():getToolInfoByIdForLua(atoi(vipinfoLeft.itemId))
        self.leftInfo = tool
        self.m_leftName:setString(tool:getName())
        self.m_leftVipName:setString(_lang_1("102702", CCString:create(string.format("%d", vipinfoLeft.level)):getCString()))
        self.m_richLeftVipBuy:setString(_lang_2("102703", CCString:create(string.format("%d", vipinfoLeft.max_num - vipinfoLeft.bought)):getCString(), CCString:create(string.format("%d", vipinfoLeft.max_num)):getCString()))
        self.m_leftHotDes:setString(_lang_1("151020", CCString:create(string.format("%d", (vipinfoLeft.vip_price / vipinfoLeft.normal_price * 10))):getCString()))
        self.m_leftNowPrice:setString(CCString:create(string.format("%d", vipinfoLeft.vip_price)):getCString())
        self.m_leftOldPrice:setString(CCString:create(string.format("%d", vipinfoLeft.normal_price)):getCString())
        self:showIcon(self.m_leftIconBg, vipinfoLeft.itemId)

        if vipinfoLeft.bought >= vipinfoLeft.max_num then
            self:recursionGraySprite(self.m_LeftNode)
            self.m_leftBtn:setEnabled(false)
            self.m_leftBtn:setTitleForState(_lang("102705"), cc.CONTROL_STATE_DISABLED)
            self.m_leftBtnSome:setVisible(false)
        end

        if vipinfoLeft.pay_type == 1 then
            self.m_leftDinamSpr:setSpriteFrame("com1001_goldlittle.png")
        elseif vipinfoLeft.pay_type == 2 then
            self.m_leftDinamSpr:setSpriteFrame("RmbPoint.png")
        end
    else
        self.m_LeftNode:setVisible(false)
    end

    local vipinfoRight = VipController:shared().VipShopInfoMap[index + 1]
    if vipinfoRight and vipinfoRight.normal_price > 0 then  --有价格表示有数据

        self.m_RightNode:setVisible(true)
        local tool = ToolController:getInstance():getToolInfoByIdForLua(atoi(vipinfoRight.itemId))
        self.rightInfo = tool
        self.m_rightName:setString(tool:getName())
        self.m_rightVipName:setString(_lang_1("102702", CCString:create(string.format("%d", vipinfoRight.level)):getCString()))
        self.m_richRightVipBuy:setString(_lang_2("102703", CCString:create(string.format("%d", vipinfoRight.max_num - vipinfoRight.bought)):getCString(), CCString:create(string.format(vipinfoRight.max_num)):getCString()))
        self.m_rightHotDes:setString(_lang_1("151020", CCString:create(string.format("%d", (vipinfoRight.vip_price / vipinfoRight.normal_price * 10))):getCString()))
        self.m_rightNowPrice:setString(CCString:create(string.format("%d", vipinfoRight.vip_price)):getCString())
        self.m_rightOldPrice:setString(CCString:create(string.format("%d", vipinfoRight.normal_price)):getCString())
        self:showIcon(self.m_rightIconBg, vipinfoRight.itemId)

        if vipinfoRight.bought >= vipinfoRight.max_num then
            self:recursionGraySprite(self.m_RightNode)
            self.m_rightBtn:setEnabled(false)
            self.m_rightBtn:setTitleForState(_lang("102705"), cc.CONTROL_STATE_DISABLED)
            self.m_rightBtnSome:setVisible(false)
        end

        if vipinfoRight.pay_type == 1 then --钻石
            self.m_rightDinamSpr:setSpriteFrame("com1001_goldlittle.png")
        elseif vipinfoRight.pay_type == 2 then--点卷
            self.m_rightDinamSpr:setSpriteFrame("RmbPoint.png")
        end
    else
        self.m_RightNode:setVisible(false)
    end
end

function VipShopCell:showIcon(kuangSprite, itemid)
    --    local kuangSprite = CCLoadSprite:createSprite("icon_kuang.png")
    --    CCCommonUtils:setSpriteMaxSize(kuangSprite, 116,true)
    --    kuangSprite:setPosition(bg:getContentSize().width/2, bg:getContentSize().height/2)
    --    bg:addChild(kuangSprite)

    local color = CCCommonUtils:getPropById(itemid, "color")
    local pic = CCLoadSprite:createSprite(CCCommonUtils:getToolBgByColor(atoi(color)))
    CCCommonUtils:setSpriteMaxSize(pic, mm.ITEM_BG_SIZE_3)
    pic:setPosition(kuangSprite:getContentSize().width / 2 + 2, kuangSprite:getContentSize().height / 2 - 2)
    kuangSprite:addChild(pic)

    pic = CCLoadSprite:createSprite((CCCommonUtils:getPropById(itemid, "icon") .. ".png"))
    CCCommonUtils:setSpriteMaxSize(pic, mm.ITEM_SIZE_3)
    pic:setPosition(kuangSprite:getContentSize().width / 2, kuangSprite:getContentSize().height / 2)
    kuangSprite:addChild(pic)
end

function VipShopCell:onLeftBuyBtn(pSender, pCCControlEvent)
    
    local vipinfoLeft = VipController:shared().VipShopInfoMap[self.m_index]
    if vipinfoLeft.itemId ~= "" then
        if vipinfoLeft.pay_type == 2 then
            if not CCCommonUtils:isEnoughResourceByType(mm.WorldResourceType.RmbPoint, vipinfoLeft.vip_price) then
                local dialog = YesNoDialog:show(_lang("123243"),cc.CallFunc:create(handler(self, function()
                    PopupViewController:getInstance():addPopupInView(StoreNewView:create(mm.StoreTabType.StoreTabTypeRmbPoint))
                end)))
                if dialog then
                    dialog:showCancelButton()
                end
                return
            end
        end
        SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
        YesNoDialog:showButtonAndPriceType(_lang("104919"), cc.CallFunc:create(function () 
            GameController:getInstance():showWaitInterface()
            local cmd = VipBuyCommand.VipShopBuy.new(vipinfoLeft.vid, 1)
            cmd:setCallback(self, VipShopCell.onLeftCallback)
            cmd:send()  
        end), _lang("102148")
        , (vipinfoLeft.pay_type == 2 and mm.PRICE_TYPE.RMBPOINT_COIN or mm.PRICE_TYPE.COST_GOLD)
        , vipinfoLeft.vip_price)
        
        -- GameController:getInstance():showWaitInterface()
        -- local cmd = VipBuyCommand.VipShopBuy.new(vipinfoLeft.vid, 1)
        -- cmd:setCallback(self, VipShopCell.onLeftCallback)
        -- cmd:send()  
    end
end

function VipShopCell:onRightBuyBtn(pSender, pCCControlEvent)
    local vipinfoRight = VipController:shared().VipShopInfoMap[self.m_index + 1]
    if vipinfoRight.itemId ~= "" then
        if vipinfoRight.pay_type == 2 then
            if not CCCommonUtils:isEnoughResourceByType(mm.WorldResourceType.RmbPoint, vipinfoRight.vip_price) then
                if vipinfoRight.pay_type == 2 then
                    if not CCCommonUtils:isEnoughResourceByType(mm.WorldResourceType.RmbPoint, vipinfoRight.vip_price) then
                        local dialog = YesNoDialog:show(_lang("123243"),cc.CallFunc:create(handler(self, function()
                            PopupViewController:getInstance():addPopupInView(StoreNewView:create(mm.StoreTabType.StoreTabTypeRmbPoint))
                        end)))
                        if dialog then
                            dialog:showCancelButton()
                        end
                        return
                    end
                end
                return
            end
        end
        SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)

        YesNoDialog:showButtonAndPriceType(_lang("104919"), cc.CallFunc:create(function () 
            GameController:getInstance():showWaitInterface()
            local cmd = VipBuyCommand.VipShopBuy.new(vipinfoRight.vid, 1)
            cmd:setCallback(self, VipShopCell.onRightCallback)
            cmd:send()  
        end), _lang("102148")
        , (vipinfoRight.pay_type == 2 and mm.PRICE_TYPE.RMBPOINT_COIN or mm.PRICE_TYPE.COST_GOLD)
        , vipinfoRight.vip_price)
        -- GameController:getInstance():showWaitInterface()
        -- local cmd = VipBuyCommand.VipShopBuy.new(vipinfoRight.vid, 1)
        -- cmd:setCallback(self, VipShopCell.onRightCallback)
        -- cmd:send() 
    end
end

function VipShopCell:onLeftCallback(pObj)
    -- local result = tolua.cast(pObj, "NetResult")
    GameController:getInstance():removeWaitInterface()
    local dict = tolua.cast(pObj, "CCDictionary")
    if dict == nil then
        return
    end
    -- local dict = tolua.cast(result:getData(), "CCDictionary")
    if dict ~= nil then
        local vip_shop_bought = dict:valueForKey("bought"):intValue()
        local vipinfo = VipController:shared().VipShopInfoMap[self.m_index]
        vipinfo.bought = vip_shop_bought
        if dict:objectForKey("remainGold") then
            local tmpInt = dict:valueForKey("remainGold"):intValue()
            UIComponent:getInstance():updateGold(tmpInt)
        end
        if dict:objectForKey("remainPoint") then
            local tmpInt = dict:valueForKey("remainPoint"):intValue()
            UIComponent:getInstance():updateRmbPoint(tmpInt)
        end

        local item = _dict(dict:objectForKey("item"))
        local itemId = item:valueForKey("itemId"):intValue()
        local info = ToolController:getInstance():getToolInfoByIdForLua(itemId)
        info:SetInfoFromServer(item, false)
        --        local name = info.getName()
        self:setData(self.m_index)

        local items = {}
        local nums = {}

        items[#items + 1] = itemId
        nums[#nums + 1] = 1

        if #items > 0 and #nums > 0 then
            PortActController:getInstance():flyItems(items, nums, true, true)
        end
    end
end

function VipShopCell:onRightCallback(pObj)
    GameController:getInstance():removeWaitInterface()
    -- local result = tolua.cast(pObj, "NetResult")
    local dict = tolua.cast(pObj, "CCDictionary")
    if dict == nil then
        return
    end
    -- local dict = tolua.cast(result:getData(), "CCDictionary")
    if dict ~= nil then
        local vip_shop_bought = dict:valueForKey("bought"):intValue()
        local vipinfo = VipController:shared().VipShopInfoMap[self.m_index + 1]
        vipinfo.bought = vip_shop_bought
        if dict:objectForKey("remainGold") then
            local tmpInt = dict:valueForKey("remainGold"):intValue()
            UIComponent:getInstance():updateGold(tmpInt)
        end
        if dict:objectForKey("remainPoint") then
            local tmpInt = dict:valueForKey("remainPoint"):intValue()
            UIComponent:getInstance():updateRmbPoint(tmpInt)
        end
        local item = _dict(dict:objectForKey("item"))
        local itemId = item:valueForKey("itemId"):intValue()
        local info = ToolController:getInstance():getToolInfoByIdForLua(itemId)
        info:SetInfoFromServer(item, false)
        --        local name = info.getName()

        self:setData(self.m_index)

        local items = {}
        local nums = {}

        items[#items + 1] = itemId
        nums[#nums + 1] = 1
        if #items > 0 and #nums > 0 then
            PortActController:getInstance():flyItems(items, nums, true, true)
        end
    end
end

function VipShopCell:recursionGraySprite(node)
    local nodeVec = node:getChildren()
    for i=1,#nodeVec do
        local temp = nodeVec[i]
        -- local icon = tolua.cast(nodeVec[i], "CCSprite")
        -- local scale9Icon = tolua.cast(nodeVec[i], "CCScale9Sprite")
        -- local color = tolua.cast(nodeVec[i], "CCLayerColor")
        -- local labelText = tolua.cast(nodeVec[i], "Label")
        repeat
            if temp and iskindof(temp, "cc.LayerColor") then
                temp:setColor(ccc3(0, 0, 0))
                self:recursionGraySprite(temp)
                break
            end
            if temp and iskindof(temp, "ccui.Scale9Sprite") then
                temp:setState(ccui.Scale9Sprite.State.GRAY)
                self:recursionGraySprite(temp)
                break
            end

            if temp and iskindof(temp, "cc.Sprite") then
                CCCommonUtils:setSpriteGray(temp, true)

                self:recursionGraySprite(temp)
                break
            end

            if temp and iskindof(temp, "cc.Label") then
                temp:setColor( ccc3(0x7e, 0x7e, 0x7e))
                break
            end
            self:recursionGraySprite(nodeVec[i])
        until true

        
    end
end

return VipShopCell