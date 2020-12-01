
function AllianceRankListCell:create(info, index, type)
    local ret = AllianceRankListCell:new(info, index, type)
    if ret and ret:init(info, index) then

    else
        CC_SAFE_DELETE(ret)
    end
    return ret
end

function AllianceRankListCell:init(info, index)
    local ret = true
    CCBLoadFile("AllianceRankCell", self, self)

    self:setData(info, index, self.m_type)
    return ret
end

function AllianceRankListCell:setData(info, index, type)
    if info == nil then
        return
    end
    self.m_info = info
    self.m_index = index
    self.m_type = type
    self.m_headNode:removeAllChildren()
    local pic = ""
    if self.m_info.icon == "" then
        pic = CCLoadSprite:createSprite("Allance_flay.png")
        --pic:setScale(0.5)
        self.m_headNode:addChild(pic)
    else

        local mpic = self.m_info.icon .. ".png"
        local flag = AllianceFlagPar:create(mpic)
        --        pic = CCLoadSprite:createSprite(mpic)
        --flag:setScale(0.5)
        self.m_headNode:addChild(flag)
    end
    self.m_headNode:setScale(0.4)

    self.m_numText:setVisible(false)
    self.m_numspr1:setVisible(false)
    self.m_numspr2:setVisible(false)
    self.m_numspr3:setVisible(false)

    self.m_firstNode:setVisible(false)
    self.m_secondNode:setVisible(false)
    self.m_thirdNode:setVisible(false)
    self.m_normalNode:setVisible(false)
    self.m_selfNode:setVisible(false)

    if self.m_index == 0 then
        self.m_numspr1:setVisible(true)
        self.m_firstNode:setVisible(true)
    elseif self.m_index == 1 then
        self.m_numspr2:setVisible(true)
        self.m_secondNode:setVisible(true)
    elseif self.m_index == 2 then
        self.m_numspr3:setVisible(true)
        self.m_thirdNode:setVisible(true)
    else
        self.m_numText:setVisible(true)

        self.m_numText:setString(CC_ITOA(self.m_index + 1))
        self.m_normalNode:setVisible(true)
    end
    if self.m_info.uid == GlobalData:shared():getPlayerInfo().allianceInfo.uid then
        self.m_selfNode:setVisible(true)
    end
    local name = self.m_info.alliancename
--[[
CPP2LUA:
empty()需要改写，字符串可以使用str == ""，table可以使用table.isempty(t)
--]]
    if not self.m_info.abbr.empty() then
        name = "(" .. self.m_info.abbr .. ")" .. self.m_info.alliancename
    end
    self.m_text1:setString(name)
    local leader = _lang("105403") + self.m_info.leader
    self.m_text2:setString(leader)
    if self.m_type == 1 then
        self.m_text3:setString(CC_CMDITOAL(self.m_info.fightpower))
    elseif self.m_type == 2 then
        self.m_text3:setString(CC_CMDITOAL(self.m_info.armyKill))
    elseif self.m_type == 3 then
        if self.m_info.holdTileNum == -1 then

        else
            self.m_text3:setString(CC_ITOA(self.m_info.holdTileNum))
        end
    elseif self.m_type == 4 then
        local text = (self.m_info.allianceSciencePower <= 0  and {"~" } or {CC_CMDITOAL(self.m_info.allianceSciencePower)})[1]
        self.m_text3:setString(text)
    elseif self.m_type == 5 or self.m_type == 6 or self.m_type == 7 then  --阵营
        local text = (self.m_info.score <= 0  and {"~" } or {CC_CMDITOAL(self.m_info.score)})[1]
        self.m_text3:setString(text)
    end
    self.m_mergeNode:setVisible(false)
    if self.m_index <= -1 then
        self.m_numText:setVisible(false)
        self:setSwallowsTouches(true)
        if GlobalData:shared().m_campSystemSwitch == ENUM_Is_Function_Open then
            local icon = GlobalData:shared():getCampPath(GlobalData:shared():getPlayerInfo().warCampId)
            local campName = CCCommonUtils:getXmlPropById("war_camp", string.format("war_camp_id_%s", CC_ITOA(GlobalData:shared():getPlayerInfo().warCampId)), "name")
--[[
CPP2LUA:
strcmp()需要改写，可以使用str == "123"
--]]
            if strcmp(icon, ".png") ~= 0 then
                self.m_mergeNode:setVisible(true)
                self.m_mergeFromSpr:setSpriteFrame(CCLoadSprite:loadResource(icon))
                self.m_mergeLab:setString(_lang(campName))
                self.m_text2:setPositionX(-90)
            else
                self.m_text2:setPositionX(-128)
            end
        else
            self.m_text2:setPositionX(-128)
        end
    end
    --头像上组标志
    local geneGroup = GeneController:getInstance():getGroupByGeneId(self.m_info.geneId)
    local geneStage = GeneController:getInstance().m_currentStage
    if geneGroup ~= 0 then
        self.m_geneGroupNode:setVisible(true)
        local isSame = (geneGroup == GeneController:getInstance().self.m_currentGroup)
        local markSprite = MMUtils:luaCast(self.m_geneGroupNode:getChildByTag(0), "CCSprite")
        if markSprite then
            local spriteStr = (isSame  and {"mark_1.png" } or {"mark_2.png"})[1]
            markSprite:setSpriteFrame(spriteStr)
        end
        local groupSprite = MMUtils:luaCast(self.m_geneGroupNode:getChildByTag(1), "CCSprite")
        if groupSprite then
            groupSprite:setSpriteFrame(GeneController:getInstance():getStageSpriteFrameSpr(geneStage, isSame))
        end
        local label = MMUtils:luaCast(self.m_geneGroupNode:getChildByTag(2), "Label")
        if label then
            label:setString(GeneController:getInstance():getRomanStageDes(geneGroup))
        end
    else
        self.m_geneGroupNode:setVisible(false)
    end
    local noEffect = GlobalData:shared():getPlayerInfo().isNowInCOA() or GlobalData:shared():getPlayerInfo().isInClockWar() or GlobalData:shared():getPlayerInfo().isInExtremisWar()
    if GlobalData:shared().m_campSystemSwitch == ENUM_Is_Function_Open then
        if self.m_index > -1 then
            if GlobalData:shared():getPlayerInfo().crossFightSrcServerId > -1 and not noEffect then
                self.m_mergeNode:setVisible(true)
                self.m_mergeFromSpr:setSpriteFrame(CCLoadSprite:loadResource("z_hostile.png"))
                self.m_mergeLab:setString(_lang("ZYA00001"))
                self.m_text2:setPositionX(-90)
            else
                local icon = GlobalData:shared():getCampPath(self.m_info.warCampId)
                local campName = CCCommonUtils:getXmlPropById("war_camp", string.format("war_camp_id_%s", CC_ITOA(self.m_info.warCampId)), "name")
--[[
CPP2LUA:
strcmp()需要改写，可以使用str == "123"
--]]
                if strcmp(icon, ".png") ~= 0 then
                    self.m_mergeNode:setVisible(true)
                    self.m_mergeFromSpr:setSpriteFrame(CCLoadSprite:loadResource(icon))
                    self.m_mergeLab:setString(_lang(campName))
                    self.m_text2:setPositionX(-90)
                else
                    self.m_text2:setPositionX(-128)
                end
            end
        end
    else
        self.m_text2:setPositionX(-128)
    end
end

function AllianceRankListCell:onEnter()

    self:setTouchMode(Touch:DispatchMode.ONE_BY_ONE)
    self:setTouchEnabled(true)
    --    Director:sharedDirector():getTouchDispatcher():addTargetedDelegate(self, Touch_Default, false);--
end

function AllianceRankListCell:onExit()
    self:setTouchEnabled(false)
    --    cc.Director:getInstance():getTouchDispatcher():removeDelegate(self)
end

function AllianceRankListCell:refreashData(obj)
end



function AllianceRankListCell:onTouchBegan(pTouch, pEvent)
    if isTouchInside(self.m_hintBGNode, pTouch) then
        self.m_startPoint = pTouch:getLocation()
        return true
    end
    return false
end

function AllianceRankListCell:onTouchEnded(pTouch, pEvent)
    if self.m_index < 0 then
        return
    end

    if fabs(pTouch:getLocation().y - self.m_startPoint.y) > 20 or fabs(pTouch:getLocation().x - self.m_startPoint.x) > 20 then
        return
    end
    if isTouchInside(m_hintBGNode, pTouch) then
        if not GlobalData:shared():getPlayerInfo().isInExtremisWar() then
            local cmd = GetAllianceListCommand:new(self.m_info.alliancename, 1, 1)
            cmd:setSuccessCallback(self, AllianceRankListCell.showAllianceInfo)
            cmd:send()
        end
    end
end

function AllianceRankListCell:showAllianceInfo(data)
--[[
CPP2LUA:
该类型不支持
--]]
    local result = MMUtils:luaCast(data, "NetResult")
    local params = _dict(result:getData())
    local arr = params:objectForKey("list")
    local num = arr:count()
--[[
CPP2LUA:
没有++/--/+=/-=/*=等语法
for/while语句需要改写
--]]
    for (local i = 0; i < num; i++)
        local dicAlliance = arr:objectAtIndex(i)

        local alliance = AllianceInfo:new()
        alliance:updateAllianceInfo(dicAlliance)
        if alliance.name == self.m_info.alliancename then
            local view = LuaHelper:createViewFromLua("popup.alliance.CheckAllianceInfoView", alliance)
            PopupViewController:getInstance():addPopupInView(view)
            --            PopupViewController:getInstance():addPopupInView(CheckAllianceInfoView:create(alliance))
            alliance:release()
            break
        end
        alliance:release()
    end
end

