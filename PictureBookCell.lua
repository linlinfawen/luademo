local PictureBookCell = class("PictureBookCell", function (  )
    return CCTableViewTouchIFCell:create()
end)

local cellHeight = 198
local cellDesHeight = 167

function PictureBookCell:dtor()
    -- CCSafeNotificationCenter:sharedNotificationCenter():unregisterScriptObserver(self, mm.HIDE_PICTUREBOOK_SELECT_STATUS)
end

function PictureBookCell:create(infos,touchNode,selectIndex)
    local ret = PictureBookCell.new()
    if ret and ret:initView(infos,touchNode,selectIndex) then
        return ret
    end
    CC_SAFE_DELETE(ret)
    return nil
end

function PictureBookCell:initView(infos,touchNode,selectIndex)
    self:initBase()
    self.ccbNode = CCBLoadFile("PictureBookCell", self, self)
    self:setContentSize(SCREEN_SIZE.width,cellHeight)
    self.m_touchNode = touchNode
    self.m_infoNodes = {self.m_infoNode1, self.m_infoNode2, self.m_infoNode3, self.m_infoNode4}
    self:setData(infos,selectIndex)
    -- CCSafeNotificationCenter:sharedNotificationCenter():registerScriptObserver(self, PictureBookCell.hideSelectStatus, mm.HIDE_PICTUREBOOK_SELECT_STATUS, nil)
    return true
end

function PictureBookCell:setData(infos,selectIndex)
    if not infos then
        return
    end
    self:restoreCell()
    self.selectIndex = selectIndex
    self.infos = infos
    for i,info in ipairs(infos) do
        local m_infoNode = self.m_infoNodes[i]
        if info and m_infoNode then
            self:refreshCell(m_infoNode,info)
            --选中状态
            if self.selectIndex == i then
                self:showSelectDesNode(m_infoNode)
                self:addSelectEffect(m_infoNode:getChildByTag(6))
            else
                self:addSelectEffect(m_infoNode:getChildByTag(6),true)
            end
        end
    end
end

function PictureBookCell:restoreCell()

    self.selectIndex = -1
    self:setContentSize(SCREEN_SIZE.width,cellHeight)
    self.ccbNode:setPosition(0, 0)
    self.m_desNode:setVisible(false)

    --图鉴相关按钮
    self.m_activationBtn:setVisible(false)
    self.m_useBtn:setVisible(false)
    self.m_UnsnatchBtn:setVisible(false)
    self.m_exchangeBtn:setVisible(false)
    self.m_strengthenBtn:setVisible(false)
    self.m_picTureBookNode:removeAllChildren(true)

    for i,m_infoNode in ipairs(self.m_infoNodes) do
        m_infoNode:setVisible(false)
        m_infoNode:getChildByTag(13):setVisible(false)
        m_infoNode:getChildByTag(14):setVisible(false)
        m_infoNode:getChildByTag(12):setVisible(false)
        m_infoNode:getChildByTag(6):removeAllChildren(true)
    end
end

function PictureBookCell:refreshCell(node,info)
    local currentSkinId = ""
    if info.m_heroSkinId then
        currentSkinId = info.m_heroSkinId
    elseif info.m_armySkinId then
        currentSkinId = info.m_armySkinId
    elseif info.m_mechaSkinId then
        currentSkinId = info.m_mechaSkinId
    elseif info.m_citySkinId then
        currentSkinId = info.m_citySkinId
    end

    node:setVisible(true)
    self:setIconState(node,info)
    self:setPictureBookState(node,info)
end

function PictureBookCell:setIconState(node,info)
    --图鉴头像
    local iconPath = info.m_skinBigIcon .. ".png"
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

    --永久和限定 标签                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    if info.m_skinType == mm.skinUseType.EM_Limit_Skin_Type then
        --限时 0
        node:getChildByTag(13):setVisible(true)
    else
        --永久 1
        node:getChildByTag(14):setVisible(true)
    end

end

function PictureBookCell:setPictureBookState(node,info)
    
    --0 未激活    
    if info.m_skinAcitivate == mm.skinTimeType.EM_None_Skin_Type then 
        self.m_activationBtn:setVisible(true)
    --1 脱下状态  发给服务器表示要穿皮肤 也表示已激活    
    elseif info.m_skinAcitivate == mm.skinTimeType.EM_Up_Skin_Type then    
        self.m_useBtn:setVisible(true)

    --2 使用中状态 发给服务器表示要卸下皮肤    
    elseif info.m_skinAcitivate == mm.skinTimeType.EM_Down_Skin_Type then    
        node:getChildByTag(12):setVisible(true)
        self.m_UnsnatchBtn:setVisible(true)
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
                    -- CCSafeNotificationCenter:sharedNotificationCenter():postNotification(mm.HIDE_PICTUREBOOK_SELECT_STATUS)
                    self(skinInfo)
                    -- self.selectIndex = i
                    -- self:addSelectEffect(infoNode:getChildByTag(6))
                    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)
                end
                return
            end
        end
    end
    return
end

--激活
function PictureBookView:onClicActivationBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)

end

--获取
function PictureBookView:onClickExchangeBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)

end

--使用
function PictureBookView:onClickUseBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)

end

--卸下
function PictureBookView:onClickUseBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)

end

--强化
function PictureBookView:onClickStrengthenBtnClick(pSender, pCCControlEvent)
    SoundController:sharedSound():playEffects(mm.Music_Sfx_click_button)

end



return PictureBookCell
