if self.m_updateHangingTime then

            self:getScheduler():unscheduleScriptEntry(self.m_updateHangingTime)
        end
        -- unschedule(handler(self, ShowMainCitySkinView.updateHangingTime))

        if self.m_updateMarchTime then
            self:getScheduler():unscheduleScriptEntry(self.m_updateMarchTime)
        end
        -- unschedule(handler(self, ShowMainCitySkinView.updateMarchTime))

        if self.m_updateTitleTime then
            self:getScheduler():unscheduleScriptEntry(self.m_updateTitleTime)
        end
        -- unschedule(handler(self, ShowMainCitySkinView.updateTitleTime))
        self.m_useBtn:setVisible(true)
        self.m_hangingNode:setVisible(false)
        self.m_marchBgNode:setVisible(false)
        self.m_titleBgNode:setVisible(false)
        self.m_bottomNode:setVisible(false)
        self.m_bigPicNode:setVisible(true)
        self:setTitleName(_lang("3800184"))
        if self.m_skinGroupInfo == nil then
            return
        end
        if self.m_skinGroupInfo:count() == 0 then  --全部激活

            self.m_skilldesc:setString(_lang("2073"))
            --        m_howToGetDesc:setString(_lang("2073"))
            self.m_btnRight:setVisible(false)
            self.m_btnLeft:setVisible(false)
            --        m_noActivationName:setString(_lang("2074"))
            self.m_name:setString("")
            return
        end

        local dictInfo = _dict(self.m_skinGroupInfo:objectAtIndex(self.m_chooseIndex))
        if dictInfo then
            self.m_bottomNode:setVisible(true)
            local skinName = dictInfo:valueForKey("skinName"):getCString()
            self.m_name:setString(_lang(skinName))
            local skillName = dictInfo:valueForKey("skillName"):getCString()
            -- self.m_skillName:setString(_lang(skillName))
            self.m_useSkinLabel:setString(_lang(skillName))
            
            local skillIcon = dictInfo:valueForKey("skillIcon"):getCString()
            local skinId = dictInfo:valueForKey("id"):getCString()
            skillIcon = skillIcon..".png"
            self.m_skillIcon:setSpriteFrame(CCLoadSprite:getSF(skillIcon))
            if dictInfo:objectForKey("ccbName") then

                if not self.m_bigPicNode:getChildByTag(self.m_chooseIndex + 100) then
                    self.m_bigPicNode:setPosition(self.m_bigPicNodePos)
                    self.m_bigPicNode:removeAllChildren()
                --    主城装扮修改
                   local scale = 0.5
                   local pointX = 0;
                   local pointY = 0;
                   local toolScale = ToolController:getInstance():getCustomSkin(atoi(skinId))
                --    local temp = ToolController:getInstance():m_customSkinGroupForLua()
                --    local toolScale = temp[atoi(skinId)]
                   if toolScale then
                       scale = tonumber(toolScale.dressCityScale)
                       local posStr = toolScale.dressCityPt
                       local posVec = CCCommonUtils:splitString(posStr,",")
                       local posTableCount = table.nums(posVec)
                       if posTableCount > 0 then
                           pointX = atoi(posVec[1]);
                       end
                       if posTableCount > 1 then
                           pointY = atoi(posVec[2]);
                       end
                   end
                    -- scale = 0.5
                    -- pointX = 0
                    -- pointY = 0

                    local ccbname = dictInfo:valueForKey("ccbName"):getCString()
                    local skin = MainCitySkin:create(ccbname, "0")
                    if skin then
                        skin:setAnchorPoint(ccp(0.5, 0.5))
                        skin:setScale(scale)
                        self.m_bigPicNode:setPosition(self.m_bigPicNodePos.x + pointX, self.m_bigPicNodePos.y + pointY)
                        if "WorldCastlaSkin1_1_face" == ccbname then  --火箭
    
                            skin:doWhenAnimationEndCallBack()
                            -- skin:setScale(0.6)
                            -- self.m_bigPicNode:setPosition(ccp(self.m_bigPicNodePos.x-175 ,self.m_bigPicNodePos.y-20))
                        elseif "StarFortress_4_face" == ccbname then  --浮空
    
                            -- skin:setScale(0.45)
                            -- self.m_bigPicNode:setPosition(ccp(self.m_bigPicNodePos.x-110 ,self.m_bigPicNodePos.y-50))
                        elseif "WorldCastlaSkin3_1_face" == ccbname then  --玩具城特效位置
    
                            -- skin:setScale(0.5)
                            -- self.m_bigPicNode:setPosition(ccp(self.m_bigPicNodePos.x-110,self.m_bigPicNodePos.y-50))
                        elseif "WorldCastlaSkin5_1_face" == ccbname then  --红包城特效位置
                            skin:circulation()
                            -- skin:setScale(0.5)
                            -- self.m_bigPicNode:setPosition(ccp(self.m_bigPicNodePos.x-110,self.m_bigPicNodePos.y-50))
                        elseif "WorldCastlaSkin6_1_face" == ccbname then  --爱心城
                            skin:doWhenAnimationEndCallBack()
                            -- skin:setScale(0.5)
                            -- self.m_bigPicNode:setPosition(ccp(self.m_bigPicNodePos.x-130,self.m_bigPicNodePos.y-60))
                        elseif "WorldCastlaSkin7_1_face" == ccbname then  --小丑城
                            skin:doWhenAnimationEndCallBack()
                            -- skin:setScale(0.5)
                            -- self.m_bigPicNode:setPosition(ccp(self.m_bigPicNodePos.x-110,self.m_bigPicNodePos.y-45))
                        elseif "WorldCastlaSkin2_1_face" == ccbname then  --超时空城
                            skin:doWhenAnimationEndCallBack()
                            -- skin:setScale(0.5)
                            -- self.m_bigPicNode:setPosition(ccp(self.m_bigPicNodePos.x-140,self.m_bigPicNodePos.y-20))
                        else  --超时空
                            skin:doWhenAnimationEndCallBack()
                            -- skin:setScale(0.5)
                            -- self.m_bigPicNode:setPosition(ccp(self.m_bigPicNodePos.x-110,self.m_bigPicNodePos.y-50))
                        end
                        skin:setTag(self.m_chooseIndex + 100)
                        self.m_bigPicNode:addChild(skin) 
                    else
                        CCCommonUtils:flyHint("", "", _lang("2065"))
                    end
                end

            else
                self.m_bigPicNode:setPosition(self.m_bigPicNodePos)
                self.m_bigPicNode:removeAllChildren()
                local effectart = dictInfo:valueForKey("effectart"):getCString()

                local pos = string.find(effectart,";")

                local skin1 = string.sub(effectart,1, pos)

                local skin2 = string.sub(effectart,pos + 1)
                -- local skin1 = string.sub(effectart,pos + 1)

                DynamicResourceController:getInstance():loadNameTypeResource(skin2, false)
                local pngName = skin2..".png"
                local castleSp = CCLoadSprite:createSprite(pngName)
                castleSp:setAnchorPoint(ccp(0, 0))

                --            CCSprite *castleSp1 = CCLoadSprite:createSprite("color_white_com_1.png")
                self.m_bigPicNode:addChild(castleSp)
                castleSp:setPosition(ccp(-210, -100))
                castleSp:setScale(0.5)

                local defPos = string.find(skin2,"_")

                local defaultStr = string.sub(skin2,0, defPos)
                if defaultStr == "pic400000" then
                    castleSp:setPosition(ccp(-215, -100))
                elseif defaultStr == "Halloween" then
                    castleSp:setPosition(ccp(-220, -120))
                end
                --            self.m_bigPicNode:addChild(castleSp1)
            end
            local skilldesc = dictInfo:valueForKey("skillDes"):getCString()
            local matchId = CCCommonUtils:getXmlPropById("status", skinId, "cityskin1")
            local item3Type = tonumber(CCCommonUtils:getXmlPropById("status", skinId, "type3"))
            local isShow = skillName == ""
            self.m_skilldesc:setVisible(not isShow)
            self.m_skillTips:setVisible(isShow)

            self.m_skillIcon:setVisible(not isShow and not (skillIcon == ".png"))
            self.m_skillBg:setVisible(not isShow and not (skillIcon == ".png"))
            local txtDes = ""
            if not isShow then
                self.m_skilldesc:setString(_lang_1(skilldesc, _lang("3800421")))
                for k,v in pairs(CityGroupSkinController:getInstance().matchingUidTable) do
                    if matchId == mm.CityGroupSkinPhoenixPavilion then
                        if v.matchingName ~= "" then
                            self.m_skilldesc:setString(_lang_1(skilldesc, v.matchingName))
                        end
                    end
                end
                txtDes = self.m_skilldesc:getString()
            else
                self.m_skillTips:setString(_lang_1(skilldesc, _lang("3800421")))
                for k,v in pairs(CityGroupSkinController:getInstance().matchingUidTable) do
                    if matchId == mm.CityGroupSkinPhoenixPavilion then
                        if v.matchingName ~= "" then
                            self.m_skillTips:setString(_lang_1(skilldesc, v.matchingName))
                        end
                    end
                end
                txtDes = self.m_skillTips:getString()
            end
            self.m_skinDesListNode:removeAllChildren(true)
            if self.m_skilldesc:getContentSize().height > 100 or self.m_skillTips:getContentSize().height > 100 then
                local viewSzie = cc.size(480, 100)
                self.m_scrollView = CCScrollView:create(viewSzie)
                self.m_scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
                self.m_scrollView:setAnchorPoint(ccp(0, 0))
                self.m_skinDesListNode:addChild(self.m_scrollView)
                
                local newDesLabel = cc.Label:create(txtDes, "Helvetica", 20)
                newDesLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
                newDesLabel:setVerticalAlignment(kCCVerticalTextAlignmentTop)
                newDesLabel:setAnchorPoint(ccp(0, 0))
                newDesLabel:setDimensions(CCSize(480, 0))
                self.m_scrollView:setContentSize(self.m_skilldesc:getContentSize())
                self.m_scrollView:addChild(newDesLabel)
                self.m_scrollView:jumpToTop()
                self.m_skillTips:setVisible(false)
                self.m_skilldesc:setVisible(false)
                self.m_skinDesListNode:setVisible(true)
            else
                self.m_skinDesListNode:setVisible(false)
            end
            
            

            local howToGetDesc = dictInfo:valueForKey("howToGetTxt"):getCString()
            self.m_getTips:setString(_lang(howToGetDesc))
            self.m_getTips:setMaxScaleXByWidth(610)

            if self.m_updateSkinTime then
                self:getScheduler():unscheduleScriptEntry(self.m_updateSkinTime)
            end
            -- unschedule(handler(self, ShowMainCitySkinView.updateSkinTime))
            self.m_currSkinId = dictInfo:valueForKey("id"):getCString()
            if self.m_currSkinId == DefaulSkin then
                self.m_skinTime:setString(_lang_1("3800183", _lang("2062")))
            else
                local haveCitySkin= GlobalData:shared():getPlayerInfo():haveCitySkinForLua()
                self.m_skinEndtime = haveCitySkin[self.m_currSkinId]
                if self.m_skinEndtime and self.m_skinEndtime > 0 then
                    local lastTime = self.m_skinEndtime - GlobalData:shared():getTimeStamp()
                    if lastTime > 31536000 * 3 then  --大于3年就永久算（策划大佬的意思）

                        self.m_skinTime:setString(_lang_1("3800183", _lang("2062")))
                    else
                        if lastTime > 0 then
                            self.m_skinTime:setString(_lang_1("3800183", CC_SECTOA(lastTime)))

                            self.m_updateSkinTime = self:getScheduler():scheduleScriptFunc(handler(self, self.updateSkinTime),1.0, false)
                            -- schedule(handler(self, ShowMainCitySkinView.updateSkinTime), 1.0)
                        else
                            self.m_skinTime:setVisible(false)
                            self.m_skillTimeBg:setVisible(false)
                            self:CancelSkin(self.m_currSkinId)
                        end
                    end
                else
                    self.m_skinTime:setVisible(false)
                    self.m_skillTimeBg:setVisible(false)
                end
            end

            local buttonName = _lang("2054")
            local btnBg = "btn_blue.png"
            self.m_useBtn:setEnabled(true)
            if GlobalData:shared():getPlayerInfo().inUseCitySkin == atoi(self.m_currSkinId) 
                or (GlobalData:shared():getPlayerInfo().inUseCitySkin == 0 and self.m_currSkinId == DefaulSkin) then --默认皮肤
                --使用中
                buttonName = _lang("2055")
                btnBg = "MainCity_Base_03.png"
                self.m_useBtn:setEnabled(false)
                self.m_useBtn:setBackgroundSpriteForState(CCLoadSprite:createScale9Sprite(btnBg), cc.CONTROL_STATE_DISABLED)
                self.m_useBtn:setTitleForState(buttonName, cc.CONTROL_STATE_DISABLED)
            end
            self.m_useBtn:setBackgroundSpriteForState(CCLoadSprite:createScale9Sprite(btnBg), cc.CONTROL_STATE_NORMAL)
            self.m_useBtn:setBackgroundSpriteForState(CCLoadSprite:createScale9Sprite(btnBg), cc.CONTROL_STATE_SELECTED)
            self.m_useBtn:setTitleForState(buttonName, cc.CONTROL_STATE_NORMAL)

            local citySkin = dictInfo:valueForKey("id"):intValue()
            if citySkin > 0 then
                local pathStr = CCCommonUtils:getXmlPropById("status", self.m_currSkinId, "Tag_Pic")

                if not isempty(pathStr) then
                    pathStr = pathStr..".png"
                    self.m_limitSprite:setSpriteFrame(CCLoadSprite:loadResource(pathStr))
                    self.m_limitSprite:setVisible(true)
                end
            end
        end