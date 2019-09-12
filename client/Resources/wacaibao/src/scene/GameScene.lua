GameScene = class("GameScene", LayerBase)

function GameScene:ctor()
    GameScene.super.ctor(self)

    AudioEngine.playMusic("wacaibao/res/common/sound/backgroundMusic.mp3", true) -- 播放背景音
    self.planetGap = 0 -- 星球间距
    self.matrix = {} -- 矩阵
    self.actives = {} -- 保存连成一片的星球
    self.srcPlanet = nil -- 当前触摸的星球
    self.destPlanet = nil -- 移动到哪个星球
    self.isTouchEnable = true -- 是否允许触摸监听 
    self.isRemoveLightning = false -- 是否正在消除闪电
    self.isRemoveFlame = false -- 是否正在消除火焰
    self.isRemoveMagicLamp = false -- 是否正在消除神灯
    self.avertRepeat = false -- 防止移动的时候重复触发onTouchMoved 
    self.isAnimationing = true -- 是否有星球在执行动画
    self.isNeedFillVacancies = false -- 是否需要填补空缺
    self.isRemoveFullScreen = false -- 是否清除全屏
    self.isNeedCheck = true -- 是否需要检查 
    self.scoreLab = nil -- 得分lab 
    self.scoreLabPos = nil -- 分数lab位置
    self.curTime = 0 -- 当前时间
    self.timeImg = nil -- 时间框节点
    self.lineImg = nil -- 横线节点
    self.progressBar = nil -- 进度条
    self.specialTab = {} -- 记录可消除的特殊宝石
    self.isCanRemove = false -- 是否能消除标志
    self.scoreTipFlag = false -- 提示分数不够开始游戏标志
    self.m_node = nil -- 存放闪电节点 
    self.node_planetPanel = nil -- 存放裁剪节点
    self.clippingNode = nil -- 裁剪节点 存放星球
    self.updateHandle = nil  -- 创建全局定时器的句柄
    self.pausedHandle = nil -- 暂停所有节点动作的句柄
    self.scoreTips = nil -- 提示分数不够节点
    self.impasseTips = nil -- 死局提示节点
    self.paraValueTab = {} -- 参数值表
    self.checkBox_mute = nil -- 静音复选框
    self.curDepth = 0 -- 当前深度
    self.gameState = E_GAME_STATE.RANDOM -- 游戏状态
    self.isCheckUpMove = true -- 是否检查上移
    self.isStopClocking = false -- 是否停止计时
    self.curScore = 0 -- 当前游戏分数
    self.keyt = 0 -- 游戏密钥 
    self.startScore = 0 -- 初始分数 加难阈值用
    self.isFirstInit = true -- 是否第一次初始化矩阵 第一次初始化不产生特殊加难宝石
    self.difficultPlanetCount = 0 -- 记录加难冰冻宝石数量
    self.difficultPlanetTotal = 2 -- 加难宝石最大数量
    self.fastForwardTime = 1 -- 快进的时间 
    self.cumulativeFastForwardTime = 0 -- 累计快进时间
    self.mudProbability = {} -- 泥块生成概率 
    self.tipNumLab = nil -- 剩余提示数量lab
    self.tipNum = 9 -- 提示数量
    self.removeTipsSprite = nil -- 消除提示精灵
    self.tipsFlag = false -- 是否已经提示标志
    self.rubyIndex = 1 -- 红宝石精灵帧索引
    self.randomNum = nil -- 加密用随机数
    self.encryptClock = 0 -- 加密计时用

    -- 初始化随机数种子
    math.randomseed(os.time()) 
end

function GameScene:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
    self.removeTipsSprite:setVisible(false) -- 消除提示设置隐藏
    self.tipsFlag = false 

    if self.scoreTipFlag or self.isRemoveLightning or self.isRemoveFlame or self.isRemoveMagicLamp or self.isTouchEnable == false or self.curTime == 0 then  -- 提示分数不够 或者正在消除闪电
        return false 
    end 
    
    self.srcPlanet = nil 
    self.destPlanet = nil  
    self.avertRepeat = true 

    if self.isTouchEnable == true then 
        local pos = cc.p(_touchX, _touchY)  --touch:getLocation()
        pos = self.node_planetPanel:convertToNodeSpace(pos)
        self.srcPlanet = self:planetOfPoint(pos)
    end 
    if self.srcPlanet == nil or self.srcPlanet:getIndex(self.randomNum) > 7  or self.srcPlanet.isMarkRemove == true or self.srcPlanet:getType() == PLANET_TYPE.FROZEN or self.srcPlanet:getNumberOfRunningActions() > 0 then 
        return false 
    end 
    return self.isTouchEnable 
end

function GameScene:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)
    if self.srcPlanet == nil or self.isTouchEnable == false or self.avertRepeat == false then 
        return 
    end 

    local x = self.srcPlanet.x  -- 横
    local y = self.srcPlanet.y  -- 竖
    local pos = cc.p(_touchX, _touchY) --touch:getLocation() -- 触摸位置
    pos = self.node_planetPanel:convertToNodeSpace(pos)

    local planet = self:planetOfPoint(pos)
    if planet == nil or planet:getIndex(self.randomNum) > 7 or planet.isMarkRemove == true or planet:getNumberOfRunningActions() > 0 or planet:getType() == PLANET_TYPE.FROZEN then  
        return  
    end

    if planet:getIndex(self.randomNum) ~= 7 and planet:getIndex(self.randomNum) == self.srcPlanet:getIndex(self.randomNum) then 
        return 
    end 
        
    local upRect = self:getRect(x, y+1) -- 当前星球上面星球的矩形
    local downRect = self:getRect(x, y-1) -- 当前星球下面星球的矩形
    local leftRect = self:getRect(x - 1, y) -- 当前星球左边星球的矩形
    local rightRect = self:getRect(x + 1, y) -- 当前星球右边星球的矩形

    if cc.rectContainsPoint(upRect, pos) then 
        y = y + 1 
        if y <= Y_COUNT[HORV] then 
            self.destPlanet = self.matrix[(y-1) * X_COUNT[HORV] + x]
        end 
    elseif cc.rectContainsPoint(downRect, pos) then 
        y = y - 1 
        if y >= 1 then 
            self.destPlanet = self.matrix[(y-1) * X_COUNT[HORV] + x]
        end 
    elseif cc.rectContainsPoint(leftRect, pos) then 
        x = x - 1 
        if x >= 1 then 
            self.destPlanet = self.matrix[(y-1) * X_COUNT[HORV] + x]
        end 
    elseif cc.rectContainsPoint(rightRect, pos) then 
        x = x + 1 
        if x <= X_COUNT[HORV] then 
            self.destPlanet = self.matrix[(y-1) * X_COUNT[HORV] + x]
        end 
    end 

    if self.destPlanet and self.destPlanet:getNumberOfRunningActions() < 1  and self.srcPlanet:getNumberOfRunningActions() < 1 then 
        self.avertRepeat = false 
        if self.srcPlanet:getType() == PLANET_TYPE.MAGIC_LAMP or self.destPlanet:getType() == PLANET_TYPE.MAGIC_LAMP then 
            if self.srcPlanet:getType() == PLANET_TYPE.MAGIC_LAMP and self.destPlanet:getType() == PLANET_TYPE.MAGIC_LAMP then
                -- 全屏消除
                self.isRemoveFullScreen = true -- 是否消除全屏标志
                self.specialTab = {} 
                table.insert(self.specialTab, self.srcPlanet)
                table.insert(self.specialTab, self.destPlanet)

                local startPlanetPos = self:positionOfPlanet(self.srcPlanet.x, self.srcPlanet.y)
                local endPlanetPos = self:positionOfPlanet(self.destPlanet.x, self.destPlanet.y)
                local len = self:calculationDistance(startPlanetPos, endPlanetPos)
                local angle = self:calculationAngle(self.srcPlanet, self.destPlanet)
                local scale = self:calculationScale(len)
                self:createLightning(startPlanetPos, scale, angle) -- 创建闪电

                self:removeSpecialPlanet(self.specialTab) 
            elseif self.srcPlanet:getType() == PLANET_TYPE.MAGIC_LAMP then
                    -- 消除神灯
                self.specialTab = {} 
                table.insert(self.specialTab, self.srcPlanet)
                self.srcPlanet:setIndexAndType(self.destPlanet:getIndex(self.randomNum), self.randomNum) 
                self:removeSpecialPlanet(self.specialTab) 
            elseif self.destPlanet:getType() == PLANET_TYPE.MAGIC_LAMP then 
                    -- 消除神灯
                self.specialTab = {} 
                table.insert(self.specialTab, self.destPlanet)
                self.destPlanet:setIndexAndType(self.srcPlanet:getIndex(self.randomNum), self.randomNum) 
                self:removeSpecialPlanet(self.specialTab) 
            end 
        else 
            self:swapPlanet() -- 交换星球
        end 
    end
end

function GameScene:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
    
end

-- 交换星球
function GameScene:swapPlanet()
    if self.srcPlanet == nil or self.destPlanet == nil then 
        return 
    end 

    self.isTouchEnable = false 

    -- 获取当前星球和目标星球的位置
    local srcPlanetPosX, srcPlanetPosY = self.srcPlanet:getPosition()
    local destPlanetPosX, destPlanetPosY = self.destPlanet:getPosition()

    -- 获取当前星球和目标星球的index值
    local srcIndex = self.srcPlanet:getIndex(self.randomNum) 
    local destIndex = self.destPlanet:getIndex(self.randomNum) 

    -- 交换两个星球在矩阵中的行号和列号
    self.matrix[(self.srcPlanet.y-1) * X_COUNT[HORV] + self.srcPlanet.x] = self.destPlanet 
    self.matrix[(self.destPlanet.y-1) * X_COUNT[HORV] + self.destPlanet.x] = self.srcPlanet 

    -- 交换两个星球在矩阵中x 和 y 的值
    self.srcPlanet.x, self.destPlanet.x =  self.destPlanet.x, self.srcPlanet.x
    self.srcPlanet.y, self.destPlanet.y =  self.destPlanet.y, self.srcPlanet.y

    -- 调整星球的index值
    self.srcPlanet:setIndexAndType(srcIndex, self.randomNum)
    self.destPlanet:setIndexAndType(destIndex, self.randomNum)

    -- 判断交换后的srcPlanet和destPlanet在横纵方向是否满足消除条件
    local src_isExistElement = self:checkPlanet(self.srcPlanet) 
    local dest_isExistElement = self:checkPlanet(self.destPlanet)

    self.planetActionCount = 0 -- 正在交换的星球的动画计数
    if src_isExistElement or dest_isExistElement then 
        self:swapPos(cc.p(destPlanetPosX, destPlanetPosY), self.srcPlanet)
        self:swapPos(cc.p(srcPlanetPosX, srcPlanetPosY), self.destPlanet)
    else 
        -- 交换两个星球在矩阵中的行号和列号
        self.matrix[(self.srcPlanet.y-1) * X_COUNT[HORV] + self.srcPlanet.x] = self.destPlanet 
        self.matrix[(self.destPlanet.y-1) * X_COUNT[HORV] + self.destPlanet.x] = self.srcPlanet 

        -- 交换两个星球在矩阵中x 和 y 的值
        self.srcPlanet.x, self.destPlanet.x =  self.destPlanet.x, self.srcPlanet.x
        self.srcPlanet.y, self.destPlanet.y =  self.destPlanet.y, self.srcPlanet.y

        -- 调整星球的index值
        self.srcPlanet:setIndexAndType(srcIndex, self.randomNum)
        self.destPlanet:setIndexAndType(destIndex, self.randomNum)

        -- 星球交换位置后返回到原来的位置
        self:swapedBack(cc.p(destPlanetPosX, destPlanetPosY), cc.p(srcPlanetPosX, srcPlanetPosY), self.srcPlanet)
        self:swapedBack(cc.p(srcPlanetPosX, srcPlanetPosY), cc.p(destPlanetPosX, destPlanetPosY), self.destPlanet)
    end 
end 

-- 星球交换位置
function GameScene:swapPos(pos, planet)
    local moveTo = cc.MoveTo:create(0.15, pos) 
    local callFunc = cc.CallFunc:create(function()
        self.planetActionCount = self.planetActionCount + 1
        if self.planetActionCount == 2 then 
            planet:stopAllActions()
            self:swapAfter() -- 交换后处理
            self.isTouchEnable = true 
        end 
    end)
    planet:runAction(cc.Sequence:create(moveTo, callFunc, nil)) -- 目标星球动画
end 

-- 星球交换位置后返回到原来的位置
function GameScene:swapedBack(swapPos, backPos, planet)
    local moveTo_1 = cc.MoveTo:create(0.15, swapPos) 
    local moveTo_2 = cc.MoveTo:create(0.15, backPos) 
    local callFunc = cc.CallFunc:create(function()
        self.planetActionCount = self.planetActionCount + 1
        if self.planetActionCount == 2 then 
            self.isTouchEnable = true 
        end 
    end )
    planet:runAction(cc.Sequence:create(moveTo_1, moveTo_2, callFunc, nil)) -- 目标星球动画
end

-- 定时器 消除、掉落星球、时间
function GameScene:removedAndDropUpdate()
    function update(dt)
        self:encrypt(dt) -- 矩阵加密
        self:updateTime(dt) -- 更新时间和进度条
        
        self.isAnimationing = self:judgeIsAnimation() -- 判断是否有星球在执行动画 
        
        if self.isAnimationing == false then
            self.isNeedFillVacancies = false  
            for i = 1 , X_COUNT[HORV] * Y_COUNT[HORV] do 
                local planet = self.matrix[i] 
                if planet == nil then 
                    self.isNeedFillVacancies = true 
                    break 
                end 
            end 
            if self.isNeedFillVacancies then 
                if self.isRemoveFullScreen then -- 清除全屏标志  
                    self.isRemoveFullScreen = false 
                    self.curDepth = self.curDepth + 30 -- 当前深度 
                    self:setMudWeight() --   设置泥块权重 
                    self:initMartix()  
                else 
                    self:dropPlanet()
                end 
            else 
                -- 检查是否有消除的星球
                self.isCanRemove = self:checkAndRemove()
                if self.isCanRemove == false then
                    self:moveUp() -- 往上移动
                end 
            end 
        end
    end 
    self.updateHandle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(update, 0.02 , false) -- false表示无限循环
end

-- 检查星球并且消除
function GameScene:checkAndRemove() 
    if self.isNeedCheck == false then 
        return false
    end 

    self.isNeedCheck = false -- 只检查一次 防止重复检查

    print("on chcek")
    -- 1、复位忽略检查标记以及高亮标记、是否是交点标记 复位所有星球和泥块的标记
    self:resetSign() -- 

    local flag = false -- 是否有星球可以消除的标志 
    -- 2、检查
    for i = 1, X_COUNT[HORV] * Y_COUNT[HORV] do 
        local planet = self.matrix[i]
        if planet and planet.isIgnoreCheck == false  then 
            self.actives = {}
            self:activeNeighbor(planet) -- 检测连成一片的星球
            local tab = self:excludePlanet(self.actives) -- 排除多余的
            if #tab > 0 then 
                flag = true 
            end 
            self:seekIntersection(tab) -- 找交点 然后执行消除动画
        end 
    end 
    return flag 
end 

-- 排除不能3个以上连成一条线的星球
function GameScene:excludePlanet(checkTab)
    local resultTab = {}
    if #checkTab < 3 then
        return resultTab
    end 
    local index = 1 
    for i = 1, #checkTab do
        if checkTab[i].isIgnoreCheck == false then 
            local tempTab = self:horizontalCheck(checkTab[i]) -- 首先水平方向检查 检查到就返回 不需要再次检查垂直方向
            table.insert(tempTab,checkTab[i])
            if #tempTab >= 3 then
                resultTab[index] = tempTab
                self:setIgnoreCheck(tempTab)  -- 设置忽略检查
                index = index + 1
            else 
                local tempTab_1 = self:verticallyCheck(checkTab[i]) -- 再次检查垂直方向
                table.insert(tempTab_1,checkTab[i])
                if #tempTab_1 >= 3 then 
                    resultTab[index] = tempTab_1
                    self:setIgnoreCheck(tempTab_1)  -- 设置忽略检查
                    index = index + 1
                else 
                    checkTab[i].isIgnoreCheck = true 
                end 
            end 
        end 
    end 
    return resultTab 
end 

-- 找出交点
function GameScene:seekIntersection(tab) 
    if #tab == 0 then 
        return 
    end 

    local length = #tab 
    local tempTab = {} -- 记录有焦点的表  
    local mergeTab = {} -- 保存合并的表  
    local mergeTabIndex = 1 
    self.specialTab = {} -- 记录特殊星球  每次进来要清空  

    for i = 1, length do 
        for j = i + 1, length do 
            local intersection = self:checkSameElement(tab[i], tab[j]) -- 查找两个表中是否有相同的元素  
            if intersection ~= nil then  
                tempTab[i] = true 
                tempTab[j] = true 
               
                -- 还是需要合并两个表,合并的时候 把交点放在表的最后面  还要考虑合成的表中有交点  一条线的交点  
                mergeTab[mergeTabIndex] = self:mergeIntersection(tab[i], tab[j], intersection)
                mergeTabIndex = mergeTabIndex + 1 
            end 
        end 
    end 

    -- 没有交点的和有交点的单个表处理  
    for i = 1, length do 
        local len = #tab[i]
        if tempTab[i] ~= true then -- 表示没有交点的表
            if len < 4 then
                self:nomalRemoveTabPlanet(tab[i]) -- 正常消除 三消
            else
                local planetType = self:calculationTypeWithLen(len) 
                self:composite(tab[i], planetType) -- 合成宝石 
            end
        else  --有交点的表 跟没有交点的表区别是 如果这个表元素小于4个 也不能正常消除
            if len > 3 then 
                -- 把L形或者T形交点从表中排除出去
                for j=len, 1, -1 do 
                    if tab[i][j].isIntersection then 
                        table.remove(tab[i],j) 
                    end 
                end 

                -- 这里面有一个直线的交点 标识出来  
                local len_1 = #tab[i]
                tab[i][len_1].isIntersection = true 
                local lineIntersection =  tab[i][len_1]  -- 直线交点

                -- 把直线交点从合成的交点L形或者T形表中排除出去 
                for k = 1, #mergeTab  do 
                    tableRemoveElement(mergeTab[k], lineIntersection)
                end 
                
                local planetType = self:calculationTypeWithLen(len) 
                self:composite(tab[i], planetType) -- 合成宝石
            end 
        end  
    end 

    -- 合并后的表处理
    for i = 1, #mergeTab do 
        self:composite(mergeTab[i], PLANET_TYPE.LIGHTNING) -- 合成宝石
    end 

    -- 消除特殊宝石
    self:removeSpecialPlanet(self.specialTab) 
end

-- 合成宝石
function GameScene:composite(tab, planetType)
    local length = #tab
    local planet = tab[length]
    if tab[length]:getType() ~= PLANET_TYPE.NORMAL and tab[length]:getType() ~= PLANET_TYPE.FROZEN then --  如果交点是特殊宝石类型 那么就把离交点最近的正常类型宝石设为特殊宝石
        local key = self:seekNear(tab)
        if key == nil then -- 这种情况说明 交点是特殊宝石 但是合成的表中其他宝石也都是特殊宝石  那么这个特殊交点宝石也需要立即消除
            table.insert(self.specialTab, planet) -- 记录特殊宝石
        else
            planet = tab[key]
        end 
    end 

    if tab[length]:getType() == PLANET_TYPE.FROZEN then 
        self.difficultPlanetCount = self.difficultPlanetCount - 1 
    end 

    self:setPlanetTypeWithLen(planet, planetType) -- 设置宝石的类型
    planet.isForthwithRemove = false  -- 设置不立即消除 新产生的特殊星球  本轮不消除

    for i = 1, length do
        if tab[i] ~= planet then 
            tab[i].isMarkRemove = true -- 标记删除
            local moveTo_1 = cc.MoveTo:create(ACTION_TIME, cc.p(tab[length]:getPosition()))
            local scaleTo_1 = cc.ScaleTo:create(ACTION_TIME, 0) 
            local spawn_1 = cc.Spawn:create(moveTo_1, scaleTo_1)
            local callFunc_1 = cc.CallFunc:create(function()
                self.matrix[(tab[i].y - 1) * X_COUNT[HORV] + tab[i].x] = nil
                if tab[i]:getType() == PLANET_TYPE.FROZEN then 
                    self.difficultPlanetCount = self.difficultPlanetCount - 1 
                end 
                tab[i]:removeFromParent()
            end) 
   
            if tab[i]:getType()  == PLANET_TYPE.NORMAL or tab[i]:getType()  == PLANET_TYPE.FROZEN then 
                if tab[i].isIntersection == false then  -- 如果是交点宝石 不执行动画
                    tab[i]:stopAllActions() 
                    tab[i]:runAction(cc.Sequence:create(spawn_1,callFunc_1, nil ))
                end 
            else
                table.insert(self.specialTab, tab[i]) -- 记录特殊宝石
            end 
            self:removePlanetAroundMud(tab[i]) -- 寻找宝石周围是否有泥块 如果有泥块就要消除泥块
        end 
    end 

    local num = self.paraValueTab.four 
    if planetType == PLANET_TYPE.MAGIC_LAMP or planetType == PLANET_TYPE.LIGHTNING then 
        num = self.paraValueTab.five 
    end 
    local pos = cc.p(tab[length]:getPosition())
    self:addScoreNun(pos, num) -- 加分
    self:sendRemoveMSG(num) -- 发送消除消息
    self:createParticleEff(pos)  

    -- 寻找宝石周围是否有泥块 如果有泥块就要消除泥块 交点宝石也需要寻找宝石周围是否有泥块
    self:removePlanetAroundMud(planet)
end 


-- 查找交点宝石最近的不是交点的宝石
function GameScene:seekNear(tab)
    local len = #tab
    local intersection = tab[len]
    local key = nil 
    local min = 10 
    local result = nil 
    for i = 1, len-1 do 
        if tab[i]:getType() == PLANET_TYPE.NORMAL or tab[i]:getType() == PLANET_TYPE.FROZEN then 
            if tab[i].x == intersection.x then 
                result = math.abs(tab[i].y - intersection.y)
            elseif tab[i].y == intersection.y then
                result = math.abs(tab[i].x - intersection.x)
            end 
            if result < min then 
                min = result
                key = i
            end 
        end  
    end 
    return key
end 

-- 消除特殊星球
function GameScene:removeSpecialPlanet(tab) 
    while #tab > 0 do 
        local planet = table.remove(tab, 1) 
       
        -- 消除特殊星球本身
        if planet:getType() == PLANET_TYPE.FLAME then -- 火焰
            self:removeFlame(planet) 
        elseif planet:getType() == PLANET_TYPE.LIGHTNING then -- 闪电
            self:removeLightning(planet)
        elseif planet:getType() == PLANET_TYPE.MAGIC_LAMP then -- 神灯
            self:removeMagicLamp(planet) 
        end 
    end 
end

-- 计算两个星球之间的距离
function GameScene:calculationDistance(startPos, endPos)
    return cc.pGetDistance(startPos, endPos)
end

-- 计算从A星球到B星球之间连线的角度   math.abs
function GameScene:calculationAngle(planet_1, planet_2)
    local x = planet_2.x - planet_1.x
    local y = planet_2.y - planet_1.y
    local angle = math.deg(math.atan(y/x))
    
    if x < 0  then 
        angle = 180 - angle
    else
        angle =  - angle
    end 

    return angle
end  

-- 计算缩放系数
function GameScene:calculationScale(length)
    local scale = length / LIGHTNING_PICTURE_WIDTH  
    return scale
end  

-- 设置宝石类型
function GameScene:setPlanetTypeWithLen(planet, planetType)
    if planetType == PLANET_TYPE.MAGIC_LAMP then -- 神灯
        planet:setMagicLampType(self.randomNum)
    elseif planetType == PLANET_TYPE.FLAME then -- 火焰
        planet:setFlameType(self.randomNum)
    elseif planetType == PLANET_TYPE.LIGHTNING then -- 闪电
        planet:setLightningType(self.randomNum)
    end 
end 

-- 根据长度计算需要设置的宝石的类型
function GameScene:calculationTypeWithLen(len)
    if len >= 5 then -- 神灯
        return PLANET_TYPE.MAGIC_LAMP
    elseif len >= 4 then -- 火焰
        return PLANET_TYPE.FLAME
    end 
end 

-- 根据特殊宝石的类型计算它周围宝石的消除模式
function GameScene:modeWithSpecialPlanet(specialPlanet)
    local mode = nil 
    if specialPlanet:getType() == PLANET_TYPE.FLAME then -- 火焰
        mode = REMOVE_MODE.BLAST
    elseif specialPlanet:getType() == PLANET_TYPE.LIGHTNING then -- 闪电
        mode = REMOVE_MODE.LIGHTNING
    elseif specialPlanet:getType() == PLANET_TYPE.MAGIC_LAMP then -- 神灯
        mode = REMOVE_MODE.MAGIC_LAMP
    end 
    return mode 
end 

-- 正常消除表中的星球
function GameScene:nomalRemoveTabPlanet(tab)
    AudioEngine.playEffect("wacaibao/res/common/sound/particle.mp3")

    for i = 1, #tab  do
        if tab[i] then 
            if tab[i]:getType()  == PLANET_TYPE.NORMAL then -- 正常类型
                self:nomalRemove(tab[i]) --正常的方式消除宝石
            elseif tab[i]:getType()  == PLANET_TYPE.FROZEN then -- 冰冻类型 
                self:frozenRemove(tab[i]) --消除冰冻宝石
            else 
                table.insert(self.specialTab, tab[i]) -- 记录特殊宝石
            end 
             -- 寻找宝石周围是否有泥块 如果有泥块就要消除泥块
            self:removePlanetAroundMud(tab[i])
        end 
    end 
    
    self:addScoreNun(cc.p(tab[1]:getPosition()), self.paraValueTab.three) -- 得分
    self:sendRemoveMSG(self.paraValueTab.three) -- 发送消除消息
end 

-- 消除单个星球 根据消除方式消除  
function GameScene:removePlanetWithMode(planet, mode)
    if planet == nil then 
        return 
    end 
    if mode == REMOVE_MODE.NORMAL then -- 正常方式消除
        self:nomalRemove(planet)
        self:removePlanetAroundMud(planet) -- 寻找宝石周围是否有泥块 如果有泥块就要消除泥块
    elseif mode == REMOVE_MODE.BLAST then -- 爆炸方式消除
        self:blastRemove(planet)
    elseif mode == REMOVE_MODE.LIGHTNING then -- 闪电方式消除
        self:lightningRemove(planet)
    elseif mode == REMOVE_MODE.MAGIC_LAMP then -- 神灯方式消除
        self:magicLampRemove(planet)
        self:removePlanetAroundMud(planet) -- 寻找宝石周围是否有泥块 如果有泥块就要消除泥块
    end 
end 

-- 消除星球周围的泥块
function GameScene:removePlanetAroundMud(planet)
    if planet.y <= PLANET_JUDGE_INDEX[HORV] and planet:getIndex(self.randomNum) < 9 then -- 只需要判断y小于5的星球,以及planet.planetIndex小于9的星球
        local tab = self:seekPlanetAroundMud(planet) 
        for i = 1, #tab do 
            self:mudRemove(tab[i])
        end 
    end 
end 

-- 消除泥块
function GameScene:mudRemove(mud, mandatory)
    if mud == nil then 
        return 
    end 

    mud.HP  = mud.HP - 1
    
    -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_5.plist") 

    local index = mud:getIndex(self.randomNum)
    if mandatory or mud.HP < 1 then -- mandatory为true 表示需要强制消除 
        if index > 10 then 
            AudioEngine.playEffect("wacaibao/res/common/sound/getTreasure.mp3")
            self:addScoreNun(cc.p(mud:getPosition()), self.paraValueTab[index]) -- 加分
            self:sendRemoveMSG(self.paraValueTab[index]) -- 发送消除消息
        else 
            AudioEngine.playEffect("wacaibao/res/common/sound/removeMud.mp3")
        end 
        mud.isMarkRemove = true -- 标记删除
        local action = createWithSingleFrameName("mudBlast_", 0.1, 1)
        local callFunc_1 = cc.CallFunc:create(function()
            self.matrix[(mud.y - 1) * X_COUNT[HORV] + mud.x] = nil
            mud:removeFromParent()
        end)
        mud:stopAllActions() 
        mud:runAction(cc.Sequence:create(action,callFunc_1, nil ))
    else
        AudioEngine.playEffect("wacaibao/res/common/sound/removeMud.mp3")
        local sp = cc.Sprite:create() 
        local posX, posY = mud:getPosition()
        sp:setPosition(cc.p(posX, posY))
        self.node_planetPanel:addChild(sp, 10)
        local action = createWithSingleFrameName("stoneBlast_", 0.1, 1)
        if index == 10 then 
            mud:setIndexAndType(9, self.randomNum)
            mud:setSpriteFrame("icon_"  .. 9 .. ".png")
        elseif index == 14 then 
            action = createWithSingleFrameName("iceBlast_", 0.1, 1)
            mud:setSpriteFrame("icon_14_"  .. self.rubyIndex .. ".png")
            if self.rubyIndex < 3 then 
                self.rubyIndex = self.rubyIndex + 1 
            end 
        end 
        local callFunc = cc.CallFunc:create(function()
            sp:removeFromParent()
        end)
        sp:runAction(cc.Sequence:create(action,callFunc, nil ))
    end 
end 

-- 消除冰冻宝石
function GameScene:frozenRemove(frozenPlanet)
    frozenPlanet.HP  = frozenPlanet.HP - 1
    self.difficultPlanetCount = self.difficultPlanetCount - 1 
    if frozenPlanet.HP < 1 or self.isRemoveFullScreen then -- 血量不够或者清除清除全屏 
        self:nomalRemove(frozenPlanet) -- 正常的方式消除宝石 
    else 
        AudioEngine.playEffect("wacaibao/res/common/sound/removeMud.mp3")
        local pos = cc.p(frozenPlanet:getPosition())
        local sp = cc.Sprite:create() 
        local posX, posY = frozenPlanet:getPosition()
        sp:setPosition(cc.p(posX, posY))
        self.node_planetPanel:addChild(sp, 50)
         -- 加载资源
        cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_5.plist")
        local action = createWithSingleFrameName("iceBlast_", 0.1, 1)
        local callFunc = cc.CallFunc:create(function()
            self:addScoreNun(pos, self.paraValueTab.iec) -- 加分 iec
            self:sendRemoveMSG(self.paraValueTab.iec) -- 发送消除消息
            sp:removeFromParent()
        end)
        sp:runAction(cc.Sequence:create(action,callFunc, nil ))

        frozenPlanet:setType(PLANET_TYPE.NORMAL ) 
        frozenPlanet:removeAllChildren()
        frozenPlanet:setEyeAnimation(self.randomNum) -- 设置眨眼睛动画
    end 
end 

-- 寻找消除宝石周围可消除的泥块
function GameScene:seekPlanetAroundMud(planet)
    local tab = {}
    local NeighborIndex = { --
            [1] = {planet.x - 1, planet.y}, -- 左
            [2] = {planet.x + 1, planet.y}, -- 右
            [3] = {planet.x , planet.y - 1}, -- 下
        } 

    for i = 1, 3 do 
        if NeighborIndex[i][1] <= X_COUNT[HORV] and NeighborIndex[i][1] >= 1 and NeighborIndex[i][2] >= 1 and NeighborIndex[i][2] <= Y_COUNT[HORV] then
            local n_planet = self.matrix[(NeighborIndex[i][2] - 1) * X_COUNT[HORV] + NeighborIndex[i][1]]
            if n_planet ~= nil and n_planet:getIndex(self.randomNum) > 8 and n_planet.isMarkRemove == false then 
                table.insert(tab, n_planet)
            end 
        end 
    end 
    return tab
end 

function GameScene:removeMe(planet)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_8.plist") -- 加载资源
    local action = createWithSingleFrameName("removeEff_" .. planet:getIndex(self.randomNum) .. "_", 0.04, 1)
    local callFunc = cc.CallFunc:create(function()
        self.matrix[(planet.y - 1) * X_COUNT[HORV] + planet.x] = nil
        local pos = cc.p(planet:getPosition())
        self:createParticleEff(pos)
        planet:removeFromParent()
    end)
    planet:stopAllActions() 
    planet:removeAllChildren()
    planet:runAction(cc.Sequence:create(action,callFunc, nil ))
end 

function GameScene:createParticleEff(starPos)
    local c_pos = self.node_planetPanel:convertToWorldSpace(starPos) -- 宝石坐标转世界坐标
    c_pos = self.background:convertToNodeSpace(c_pos) -- 世界坐标转self.backgroun的本地坐标
    local bulidNum = math.random(8, 15) -- 3, 8 
    for i = 1, bulidNum do 
        local particle = ParticleEff.new(c_pos)
        self.background:addChild(particle, 200)

        local distance = cc.pGetDistance(cc.p(particle.posX, particle.posY), self.scoreLabPos) -- 计算距离
        local moveTime = distance / PARTICLE_MOVE_SPEED
        local moveTo = cc.MoveTo:create(moveTime, self.scoreLabPos)
        local callFunc = cc.CallFunc:create(function () 
            self:setScoreLab() -- 设置分数lab
            particle:removeFromParent() 
        end) 
        particle:runAction(cc.Sequence:create(cc.EaseSineIn:create(moveTo), callFunc, nil))

    end 
end 

-- 正常消除的方式消除普通宝石  
function GameScene:nomalRemove(planet)
    if planet == nil then 
        return 
    end 
    planet.isMarkRemove = true -- 标记删除

    self:removeMe(planet) 
end 

-- 爆炸消除的方式消除普通宝石
function GameScene:blastRemove(planet)
    if planet == nil then 
        return 
    end
    planet.isMarkRemove = true -- 标记删除
    if  planet:getIndex(self.randomNum) > 8 then -- 表示这是泥块
        self:mudRemove(planet) -- 消除泥块  
    else 
        self:removeMe(planet)
    end 
end 

-- 神灯消除的方式消除普通宝石  
function GameScene:magicLampRemove(planet) 
    if planet == nil then 
        return 
    end 
    
    planet.isMarkRemove = true -- 标记删除

    self:removeMe(planet)
end

-- 闪电消除的方式消除普通宝石   
function GameScene:lightningRemove(planet) 
    if planet == nil then 
        return 
    end
    planet.isMarkRemove = true -- 标记删除
    if  planet:getIndex(self.randomNum) > 8 then -- 表示这是泥块
        self:mudRemove(planet) -- 消除泥块  
    else 
        self:removeMe(planet)
    end 
end

-- 单个可消除的特殊宝石 寻找他周围可消除的
function GameScene:seekAround(planet)
    local tab = {} 
    if planet:getType() == PLANET_TYPE.FLAME then -- 火焰
        tab = self:seekFlameAround(planet)
    elseif planet:getType() == PLANET_TYPE.LIGHTNING then -- 闪电
        tab = self:seekLightningAround(planet)
    elseif planet:getType() == PLANET_TYPE.MAGIC_LAMP then -- 神灯
        tab = self:seekMagicLampAround(planet) 
    end 
    return tab
end 

-- 寻找火焰星球周围的星球或者泥块
function GameScene:seekFlameAround(planet)
    local tab = {} -- 
    local NeighborIndex = { -- 爆炸相邻范围索引
            [1] = {planet.x - 1, planet.y}, -- 左
            [2] = {planet.x + 1, planet.y}, -- 右
            [3] = {planet.x , planet.y + 1}, -- 上
            [4] = {planet.x , planet.y - 1}, -- 下
            [5] = {planet.x - 1, planet.y + 1}, -- 左上
            [6] = {planet.x + 1, planet.y + 1}, -- 右上
            [7] = {planet.x - 1, planet.y - 1}, -- 左下
            [8] = {planet.x + 1, planet.y - 1}, -- 右下
    } 

    for i = 1, 8 do 
        if NeighborIndex[i][1] <= X_COUNT[HORV] and NeighborIndex[i][1] >= 1 and NeighborIndex[i][2] >= 1 and NeighborIndex[i][2] <= Y_COUNT[HORV] then 
            local n_planet = self.matrix[(NeighborIndex[i][2] - 1) * X_COUNT[HORV] + NeighborIndex[i][1]]
            if n_planet ~= nil and n_planet.isForthwithRemove and n_planet.isMarkRemove == false and n_planet:getNumberOfRunningActions() < 1 then
                n_planet.isMarkRemove = true -- 标记删除 2018-4-11   
                table.insert(tab, n_planet)
            end 
        end 
    end 

    return tab 
end 

-- 寻找闪电周围的星球或者泥块 
function GameScene:seekLightningAround(planet)
    local tab = {} -- 
    local n_planet
    for i = 1, X_COUNT[HORV] do 
        n_planet = self.matrix[(planet.y - 1) * X_COUNT[HORV] + i]
        if n_planet ~= nil and n_planet.isMarkRemove == false and n_planet:getNumberOfRunningActions() < 1 then
            n_planet.isMarkRemove = true -- 标记删除 2018-4-11  
            table.insert(tab, n_planet)
        end 
    end 

    for i = Y_COUNT[HORV], 1, -1 do 
        n_planet = self.matrix[(i - 1) * X_COUNT[HORV] + planet.x]
        if n_planet ~= nil and n_planet.isMarkRemove == false and n_planet:getNumberOfRunningActions() < 1 then 
            n_planet.isMarkRemove = true -- 标记删除 2018-4-11 
            table.insert(tab, n_planet)
        end 
    end 

    return tab 
end

-- 寻找神灯周围的星球或者泥块  
function GameScene:seekMagicLampAround(planet)
    local tab = {} 
    local n_planet
    if self.isRemoveFullScreen then 
        for i = 1, X_COUNT[HORV] * Y_COUNT[HORV] do 
            n_planet = self.matrix[i]
            if n_planet and n_planet.isMarkRemove == false then 
                if n_planet ~= planet then -- 神灯自己不需要添加进入
                    n_planet.isMarkRemove = true -- 标记删除 以免引起消除神灯时，播放雷电特效这段时间，被神灯消除的星球 被再次消除  引起bug
                    table.insert(tab, n_planet)
                end 
            end 
        end
    else 
        for i = 1, X_COUNT[HORV] * Y_COUNT[HORV] do 
            n_planet = self.matrix[i]
            if n_planet and n_planet:getIndex(self.randomNum) == planet:getIndex(self.randomNum) and n_planet.isMarkRemove == false and n_planet:getNumberOfRunningActions() < 1 then 
                if n_planet ~= planet then -- 神灯自己不需要添加进入
                    n_planet.isMarkRemove = true -- 标记删除 以免引起消除神灯时，播放雷电特效这段时间，被神灯消除的星球 被再次消除  引起bug
                    table.insert(tab, n_planet)
                end 
            end 
        end 
    end 
    return tab 
end

-- 消除火焰星球
function GameScene:removeFlame(planet) 
    AudioEngine.playEffect("wacaibao/res/common/sound/blast.mp3")
    
    local special = {} -- 保存特殊宝石
    local tempTab = {} -- 保存特殊宝石周围需要被消除的宝石

     -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_1.plist")

    self.isRemoveFlame = true -- 消除火焰 触摸无效

    local sp = cc.Sprite:createWithSpriteFrameName("flameBlast_1.png")
    sp:setPosition(cc.p(50, 50))
    sp:setScale(2.5)
    planet:addChild(sp, 3)
    local action = createWithSingleFrameName("flameBlast_", 0.035, 1)  
    local callFunc_1 = cc.CallFunc:create(function()
        tempTab = self:seekAround(planet) -- 查找特殊宝石周围待消除的宝石 
        local removeTotalScore = 0 -- 消除总分
        for i = 1, #tempTab do 
            if tempTab[i].getType ~= nil then
                if tempTab[i]:getType() == PLANET_TYPE.NORMAL then 
                    local index = tempTab[i]:getIndex(self.randomNum)
                    if index > 7 then 
                        self:mudRemove(tempTab[i])
                    else 
                        local mode = self:modeWithSpecialPlanet(planet)
                        self:removePlanetWithMode(tempTab[i], mode)
                        self:addScoreNun(cc.p(tempTab[i]:getPosition()), self.paraValueTab.flame)
                        removeTotalScore = removeTotalScore + self.paraValueTab.flame
                    end 
                elseif tempTab[i]:getType() == PLANET_TYPE.FROZEN then 
                    self:frozenRemove(tempTab[i])
                else 
                    if tempTab[i]:getType() == PLANET_TYPE.MAGIC_LAMP then -- 如果是神灯
                        tempTab[i]:setIndexAndType(planet:getIndex(self.randomNum), self.randomNum)
                    end 
                    table.insert(special, tempTab[i])
                end
            end 
        end 
        self:sendRemoveMSG(removeTotalScore) -- 发送消除消息
        self.isRemoveFlame = false -- 火焰消除结束  恢复触摸标志
        self.matrix[(planet.y - 1) * X_COUNT[HORV] + planet.x] = nil
        planet:removeFromParent()
        self:removeSpecialPlanet(special)
    end)
    planet.isMarkRemove = true -- 标记删除
    planet:setLocalZOrder(15)
    sp:setBlendFunc(gl.SRC_ALPHA,gl.ONE) -- gl.SRC_COLOR,gl.ONE 
    sp:runAction(cc.Sequence:create(action,callFunc_1, nil ))
end

-- 消除闪电星球 
function GameScene:removeLightning(planet) 
    AudioEngine.playEffect("wacaibao/res/common/sound/lightningRemove.mp3")

    local special = {} -- 保存特殊宝石
    local tempTab = {} -- 保存特殊宝石周围需要被消除的宝石

    -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_7.plist")

    local vertical_pos, horizontal_pos = self:calculationStripLightningPos(planet) -- 计算条形闪电的坐标
    local index = planet:getIndex(self.randomNum)
    self:createStripLightning(vertical_pos, STRIP_LIGHTNING_SCALE[HORV].vertical, 90) -- 创建垂直闪电
    self:createStripLightning(horizontal_pos, STRIP_LIGHTNING_SCALE[HORV].horizontal)  -- 创建水平闪电

    self.isRemoveLightning = true -- 标识正在消除闪电 触摸无效

    local delayTime = cc.DelayTime:create(1) 
    local callFunc_1 = cc.CallFunc:create(function()
        tempTab = self:seekAround(planet) -- 查找特殊宝石周围待消除的宝石 
        local removeTotalScore = 0 -- 消除总分
        for i = 1, #tempTab do 
            if tempTab[i].getType ~= nil then
                if tempTab[i]:getType() == PLANET_TYPE.NORMAL then 
                    local index = tempTab[i]:getIndex(self.randomNum)
                    if index > 7 then 
                        if index == 14 then 
                            self:mudRemove(tempTab[i])
                        else
                            self:mudRemove(tempTab[i], true)
                        end 
                    else 
                        local mode = self:modeWithSpecialPlanet(planet)
                        self:removePlanetWithMode(tempTab[i], mode)
                        self:addScoreNun(cc.p(tempTab[i]:getPosition()), self.paraValueTab.lightning)
                        removeTotalScore = removeTotalScore + self.paraValueTab.lightning
                    end 
                elseif tempTab[i]:getType() == PLANET_TYPE.FROZEN then 
                    self:frozenRemove(tempTab[i])
                else 
                    if tempTab[i]:getType() == PLANET_TYPE.MAGIC_LAMP then -- 如果是神灯
                        tempTab[i]:setIndexAndType(planet:getIndex(self.randomNum), self.randomNum)
                    end 
                    table.insert(special, tempTab[i])
                end 
            end 
        end 
        self:sendRemoveMSG(removeTotalScore) -- 发送消除消息
        self.isRemoveLightning = false -- 消除闪电结束  触摸恢复有效
        self.matrix[(planet.y - 1) * X_COUNT[HORV] + planet.x] = nil
        planet:removeFromParent()
        self:removeSpecialPlanet(special)
    end)
    planet.isMarkRemove = true -- 标记删除
    planet:runAction(cc.Sequence:create(delayTime,callFunc_1, nil ))
end

-- 消除神灯星球 
function GameScene:removeMagicLamp(planet) 
    local special = {} -- 保存特殊宝石
    local tempTab = {} -- 保存特殊宝石周围需要被消除的宝石
    local actionTime = 1 
    local addTime = 0.05 -- 0.05 
    if self.isRemoveFullScreen then 
        actionTime = 2
        addTime = 0.015  
    end 

    self.isRemoveMagicLamp = true -- 消除神灯的时候 禁止触摸

    local delayTime = cc.DelayTime:create(actionTime) 
    local callFunc_1 = cc.CallFunc:create(function()
        self.m_node:removeAllChildren()
        self:removePlanetAroundMud(planet)  -- 寻找神灯周围是否有泥块 如果有泥块就要消除泥块
        local removeTotalScore = 0 -- 消除总分
        for i = 2, #tempTab do -- 第一个是神灯 所以从2开始
            if tempTab[i].getType ~= nil then
                if tempTab[i]:getType() == PLANET_TYPE.NORMAL then 
                    local index = tempTab[i]:getIndex(self.randomNum)
                    if index > 8 then 
                        self:mudRemove(tempTab[i], true)
                    else 
                        local mode = self:modeWithSpecialPlanet(planet)
                        self:removePlanetWithMode(tempTab[i], mode)
                        self:addScoreNun(cc.p(tempTab[i]:getPosition()), self.paraValueTab.magicLamp)
                        removeTotalScore = removeTotalScore + self.paraValueTab.magicLamp
                    end
                elseif tempTab[i]:getType() == PLANET_TYPE.FROZEN then 
                    self:frozenRemove(tempTab[i])
                else 
                    table.insert(special, tempTab[i])
                end 
            end 
        end
        self:sendRemoveMSG(removeTotalScore) -- 发送消除消息
        self.isRemoveMagicLamp = false -- 神灯消除完后 恢复触摸
        self.matrix[(planet.y - 1) * X_COUNT[HORV] + planet.x] = nil 
        planet:removeFromParent()
        self:removeSpecialPlanet(special)
    end)
    planet:runAction(cc.Sequence:create(delayTime,callFunc_1, nil )) 
    planet.isMarkRemove = true -- 标记删除
    tempTab = self:seekAround(planet) -- 查找特殊宝石周围待消除的宝石 

    -- 从神灯开始 创建闪电
    table.insert(tempTab, 1, planet) -- 神灯插入到表的最前面 从神灯开始创建闪电
    
    local time = 0.05 
    for i = 1, #tempTab - 1 do 
        local startPlanetPos = self:positionOfPlanet(tempTab[i].x, tempTab[i].y)
        local endPlanetPos = self:positionOfPlanet(tempTab[i+1].x, tempTab[i+1].y)
        local len = self:calculationDistance(startPlanetPos, endPlanetPos)
        local angle = self:calculationAngle(tempTab[i], tempTab[i+1])
        local scale = self:calculationScale(len)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(time), 
                                            cc.CallFunc:create(function() 
                                            -- 创建闪电
                                            self:createLightning(startPlanetPos, scale, angle)
                                            end ), nil))
        time = time + addTime
    end 
    print("========================",time)
end

-- 水平方向检查星球 HORIZONTAL
function GameScene:horizontalCheck(planet)
    local checkTab = {} 
    -- 向左检查同类型的星球
    local leftNeighborX = planet.x - 1 
    while leftNeighborX >= 1 do 
        local leftPlanet = self.matrix[(planet.y - 1) * X_COUNT[HORV] + leftNeighborX]
        if leftPlanet and leftPlanet:getIndex(self.randomNum) == planet:getIndex(self.randomNum) and leftPlanet.isMarkRemove == false and leftPlanet:getNumberOfRunningActions() < 1 then
            table.insert(checkTab, leftPlanet)
            leftNeighborX = leftNeighborX - 1 
        else 
            break 
        end
    end 

    -- 向右检查同类型的星球
    local rightNeighborX = planet.x + 1 
    while rightNeighborX <= X_COUNT[HORV] do 
        local rightPlanet = self.matrix[(planet.y - 1) * X_COUNT[HORV] + rightNeighborX]
        if rightPlanet and rightPlanet:getIndex(self.randomNum) == planet:getIndex(self.randomNum) and rightPlanet.isMarkRemove == false and rightPlanet:getNumberOfRunningActions() < 1 then
            table.insert(checkTab, rightPlanet)
            rightNeighborX = rightNeighborX + 1 
        else 
            break 
        end
    end 

    return checkTab
end 

-- 垂直方向检查星球 
function GameScene:verticallyCheck(planet)
    local checkTab = {} 
     -- 向上检查同类型的星球 
    local upNeighborY = planet.y + 1 
    while upNeighborY <= Y_COUNT[HORV] do 
        local upPlanet = self.matrix[(upNeighborY - 1) * X_COUNT[HORV] + planet.x]
        if upPlanet and upPlanet:getIndex(self.randomNum) == planet:getIndex(self.randomNum) and upPlanet.isMarkRemove == false and upPlanet:getNumberOfRunningActions() < 1 then
            table.insert(checkTab, upPlanet)
            upNeighborY = upNeighborY + 1 
        else 
            break 
        end
    end 

    -- 向下检查同类型的星球
    local downNeighborY = planet.y - 1 
    while downNeighborY >= 1 do 
        local downPlanet = self.matrix[(downNeighborY - 1) * X_COUNT[HORV] + planet.x]
        if downPlanet and downPlanet:getIndex(self.randomNum) == planet:getIndex(self.randomNum) and downPlanet.isMarkRemove == false and downPlanet:getNumberOfRunningActions() < 1 then
            table.insert(checkTab, downPlanet)
            downNeighborY = downNeighborY - 1 
        else 
            break 
        end
    end 
    return checkTab
end 

-- 检查是否满足消除条件
function GameScene:checkPlanet(planet) 
    
    local isExistElement = false -- 是否存在可消除的元素

    local colPlanet = self:verticallyCheck(planet) --  垂直方向检查星球

    if #colPlanet >= 2 then  -- 判断所有能消除的纵向星球数量
        isExistElement = true
    end

    if isExistElement == false then 
        local rowPlanet = self:horizontalCheck(planet) --  水平方向检查星球
        if #rowPlanet >= 2 then -- 判断能消除的横向水果数量
            isExistElement = true
        end 
    end 
    return isExistElement
end 

-- 合并有交点的表 把交点放到表的最后
function GameScene:mergeIntersection(t1, t2, intersection)
    local tempTab = {} 
    local index = 1
    for i = 1, #t1 do 
        if t1[i] ~= intersection then 
            tempTab[index] = t1[i]
            index = index + 1 
        end 
    end 

    for i = 1, #t2 do 
        if t2[i] ~= intersection then 
            tempTab[index] = t2[i]
            index = index + 1 
        end 
    end

    table.insert(tempTab, intersection)

    return tempTab
end 

-- 查找两个表中是否有相同的元素
function GameScene:checkSameElement(t1, t2)
    for i = 1, #t1 do 
        for j = 1, #t2 do 
            if t1[i] == t2[j] then 
                t1[i].isIntersection = true  -- 设置交点标识
                t2[j].isIntersection = true 
                return t1[i] -- 找到直接返回
            end 
        end 
    end 
    return nil 
end 

-- 设置忽略检测
function GameScene:setIgnoreCheck(checkTab)
    for i = 1, #checkTab do
        checkTab[i].isIgnoreCheck = true 
    end 
end 


-- 掉落星球
function GameScene:dropPlanet() 
    print("drop planet")
    self.isAnimationing = true 
    self.isNeedCheck = true -- 是否允许检查
    self.isCheckUpMove = true -- 是否检查上升

    local emptyInfo = {} -- 记录每个x轴的最终空缺数

    -- 1、掉落已经存在的星球 一列一列的处理
    for x = 1, X_COUNT[HORV] do 
        local removedPlanets = 0 
        local newY = 0 

        -- 从下往上处理
        for y = 1, Y_COUNT[HORV] do 
            local temp = self.matrix[(y-1) * X_COUNT[HORV] + x] 
            if temp == nil then -- 星球已经被移除
                removedPlanets = removedPlanets + 1 
            else 
                -- 如果星球下面有空缺  向下移动空缺个位置
                if removedPlanets > 0 then 
                    local index = temp:getIndex(self.randomNum)
                    newY = y - removedPlanets
                    self.matrix[(newY-1) * X_COUNT[HORV] +x ] = temp 
                    temp.y = newY
                    temp:setIndexAndType(index, self.randomNum)

                    self.matrix[(y-1) * X_COUNT[HORV] + x] = nil 

                    local endPosition = self:positionOfPlanet(x, newY)
                    local speed = (temp:getPositionY() - endPosition.y) / PLANET_MOVE_SPEED
                    temp:stopAllActions() --停止之前的动画
                    temp:runAction(cc.MoveTo:create(speed, endPosition)) -- 
                end 
            end 
        end 
        -- 记录本列最终空缺星球数
        emptyInfo[x] = removedPlanets 
    end 

    -- 2、掉落的新的星球 补全空缺
    for x = 1, X_COUNT[HORV] do 
        for y = Y_COUNT[HORV] - emptyInfo[x] + 1, Y_COUNT[HORV] do 
            self:createAndDropPlanet(x, y)
        end 
    end 
end 

-- 创建星球并且掉落
function GameScene:createAndDropPlanet(x, y, planetIndex)
    local planetIndex = planetIndex or self:getIntRandom(1, 6)

    local value = 0 
    if self.gameState == E_GAME_STATE.DIFFICULT then -- 加难状态
        value = 30 -- 10
    else 
        value = 2 -- 2
    end
   
    local newPlanet = PlanetItem.new(x, y, planetIndex, self.randomNum)
    
    local temp = self:getIntRandom(0, 100)
    if temp <= value and self.difficultPlanetCount < self.difficultPlanetTotal and self.isFirstInit == false then 
        newPlanet:setFrozenType()
        self.difficultPlanetCount = self.difficultPlanetCount + 1 
    end 

    local endPosition = self:positionOfPlanet(x, y)
    local startPosition = cc.p(endPosition.x, endPosition.y + PLANET_START_OFFSET_Y)
    newPlanet:setPosition(startPosition)
    newPlanet:runAction(cc.MoveTo:create(PLANET_MOVE_TIME, endPosition)) -- 
    self.matrix[(y - 1) * X_COUNT[HORV] + x] = newPlanet
    self.node_planetPanel:addChild(newPlanet)
end

-- 获取整形随机数 闭区间 包括min和max
function GameScene:getIntRandom(min, max)
    local modNum = max - min + 1
    local randomNum = math.random(10000000) 
    randomNum = math.random(randomNum) % modNum + min 
    return randomNum
end 

-- 创建闪电
function GameScene:createLightning(pos, scale, angle)
    AudioEngine.playEffect("wacaibao/res/common/sound/maglcLampRemove.mp3")
    local actionTimes = 1 
    if self.isRemoveFullScreen then 
        actionTimes = 3 
    end 

     -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_4.plist")

    local linhtning = cc.Sprite:createWithSpriteFrameName("lightning_1.png")
    linhtning:setAnchorPoint(cc.p(0, 0.5))
    linhtning:setPosition(pos)
    linhtning:setScaleX(scale)
    linhtning:setRotation(angle)
    linhtning:setBlendFunc(gl.SRC_ALPHA,gl.ONE) -- gl.SRC_COLOR,gl.ONE
    self.m_node:addChild(linhtning)
    local action = createWithSingleFrameName("lightning_", 0.08, actionTimes)
    linhtning:runAction(cc.Sequence:create(action, cc.CallFunc:create(function() 
            linhtning:removeFromParent() 
        end ))) 
end 

-- 交换后处理星球
function GameScene:swapAfter()

    self:resetSignWithNotMarkRemove() -- 复位没有被标记删除的星球和泥块标记

    self.actives = {}
    self:activeNeighbor(self.srcPlanet) -- 检测连成一片的星球
    local tab = self:excludePlanet(self.actives) -- 排除多余的
    self:seekIntersection(tab) -- 找交点 然后执行消除动画
    print(self.srcPlanet.x )
   
    self.actives = {}
    self:activeNeighbor(self.destPlanet) -- 检测连成一片的星球
    local tab_1 = self:excludePlanet(self.actives) -- 排除多余的
    self:seekIntersection(tab_1) -- 找交点 然后执行消除动画
end 

-- 初始化矩阵
function GameScene:initMartix()
    local index = 0 
    local isNeedCreateAgain 
    
    for y = 1, Y_COUNT[HORV] do
        for x = 1, X_COUNT[HORV] do
            if y <= MUD_MAX_Y[HORV] then -- 创建泥土
                if y == MUD_MAX_Y[HORV] then 
                    index = self:getIntRandom(9, 10) --(产生9到10的数 包括9和10)
                else 
                    index = self:calculateMudIndex() -- 计算泥块索引值 
                end 
                self:createMud(x,y,index)
            else -- 创建星球
                repeat
                    index = self:getIntRandom(1, 6) --(产生1到6的数 包括1和6) 
                    isNeedCreateAgain = self:checkLeftAndDwonFruits(x,y,index)
                until not isNeedCreateAgain; -- 为真跳出循环
                
                self:createAndDropPlanet(x, y, index)
            end 
        end
    end
    self.isFirstInit = false 

--    self.matrix[34]:setFlameType(self.randomNum)
--    self.matrix[33]:setFlameType(self.randomNum)
--    self.matrix[42]:setLightningType(self.randomNum)
--    self.matrix[43]:setFlameType(self.randomNum)
--    self.matrix[44]:setMagicLampType(self.randomNum)
--    self.matrix[45]:setMagicLampType(self.randomNum)
--    self.matrix[53]:setFlameType(self.randomNum)
--    self.matrix[56]:setLightningType(self.randomNum)
--    self.matrix[54]:setFrozenType()
end

-- 计算泥块索引值
function GameScene:calculateMudIndex()
    local index = 9 
    local interval = self:calculationInterval() -- 计算泥块生成区间
    local total = self:totalIntervalValue()  -- 区间总值
    local result = self:getIntRandom(0, total) 
    print("随机数为:", total,result)
    if result >= 0 and result < interval[9] then 
        index = 9 
    elseif result >= interval[9] and result < interval[10] then 
        index = 10 
    elseif result >= interval[10] and result < interval[11] then 
        index = 11 
    elseif result >= interval[11] and result < interval[12] then 
        index = 12 
    elseif result >= interval[12] and result < interval[13] then 
        index = 13 
    elseif result >= interval[13] and result < interval[14] then 
        index = 14 
    end 

    return index
end 

-- 创建泥块
function GameScene:createMud(x, y, index)
    local newPlanet = PlanetItem.new(x, y, index, self.randomNum)
    local endPosition = self:positionOfPlanet(x, y)
    local startPosition = cc.p(endPosition.x, endPosition.y - PlanetItem.getWidth() * MOVE_UP_NUM[HORV])
    newPlanet:setPosition(startPosition)
    newPlanet:runAction(cc.MoveTo:create(UP_SPEED, endPosition))
    self.matrix[(y - 1) * X_COUNT[HORV] + x] = newPlanet
    self.node_planetPanel:addChild(newPlanet)
end

-- 检查连成一片的星球
function GameScene:activeNeighbor(planet)
    if planet == nil then 
        return 
    end 
    -- 首先高亮自己
    if false == planet.isActive then 
        planet:setActive(true)
        table.insert(self.actives, planet)
    end 
   
    -- 检查planet左边的星球 isMarkRemove
    if (planet.x - 1) >= 1 then
        local leftNeighbor = self.matrix[(planet.y - 1) * X_COUNT[HORV] + planet.x - 1]
        if leftNeighbor and (leftNeighbor.isActive == false) and (leftNeighbor:getIndex(self.randomNum) == planet:getIndex(self.randomNum)) and (leftNeighbor.isMarkRemove == false) and (leftNeighbor:getNumberOfRunningActions() < 1) then
            leftNeighbor:setActive(true)
            table.insert(self.actives, leftNeighbor)
            self:activeNeighbor(leftNeighbor)
        end
    end

    -- 检查planet右边的星球
    if (planet.x + 1) <= X_COUNT[HORV] then
        local rightNeighbor = self.matrix[(planet.y - 1) * X_COUNT[HORV] + planet.x + 1]
        if rightNeighbor and (rightNeighbor.isActive == false) and (rightNeighbor:getIndex(self.randomNum) == planet:getIndex(self.randomNum)) and (rightNeighbor.isMarkRemove == false) and (rightNeighbor:getNumberOfRunningActions() < 1) then
            rightNeighbor:setActive(true)
            table.insert(self.actives, rightNeighbor)
            self:activeNeighbor(rightNeighbor)
        end
    end

    -- 检查planet上边的星球
    if (planet.y + 1) <= Y_COUNT[HORV] then
        local upNeighbor = self.matrix[planet.y * X_COUNT[HORV] + planet.x]
        if upNeighbor and (upNeighbor.isActive == false) and (upNeighbor:getIndex(self.randomNum) == planet:getIndex(self.randomNum)) and (upNeighbor.isMarkRemove == false) and (upNeighbor:getNumberOfRunningActions() < 1) then
            upNeighbor:setActive(true)
            table.insert(self.actives, upNeighbor)
            self:activeNeighbor(upNeighbor)
        end
    end

    -- 检查planet下边的星球
    if (planet.y - 1) >= 1 then
        local downNeighbor = self.matrix[(planet.y - 2) * X_COUNT[HORV] + planet.x]
        if downNeighbor and (downNeighbor.isActive == false) and (downNeighbor:getIndex(self.randomNum) == planet:getIndex(self.randomNum)) and (downNeighbor.isMarkRemove == false) and (downNeighbor:getNumberOfRunningActions() < 1) then
            downNeighbor:setActive(true)
            table.insert(self.actives, downNeighbor)
            self:activeNeighbor(downNeighbor)
        end
    end
end 

-- 给出x和y 获取当前方块上面的星球
function GameScene:planetOfPoint(pos)
    local x = math.ceil((pos.x) / PlanetItem.getWidth()) -- ceil 向上取整
    local y = math.ceil((pos.y) / PlanetItem.getWidth())

    if x > X_COUNT[HORV] or y > Y_COUNT[HORV] or x < 1 or y < 1 then 
        return nil 
    end 

--    print(x, y)
--    if self.matrix[(y - 1) * X_COUNT[HORV] + x] ~= nil then 
--        print(self.matrix[(y - 1) * X_COUNT[HORV] + x]:getIndex(self.randomNum))
--    end 

    return self.matrix[(y - 1) * X_COUNT[HORV] + x]
end 

-- 给出x和y 计算当前方块的中心位置坐标
function GameScene:positionOfPlanet(x, y)
    local px = (PlanetItem.getWidth() + self.planetGap) * (x - 1) + PlanetItem.getWidth() / 2
    local py = (PlanetItem.getWidth() + self.planetGap) * (y - 1) + PlanetItem.getWidth() / 2

    return cc.p(px, py)
end

-- 根据x和y检查当前方块左边以及下面星球
function GameScene:checkLeftAndDwonFruits(x,y,planetIndex)
    local leftCount = 0
    local downCount = 0

    -- 向左检查同类型的星球
    local leftNeighborX = x - 1 
    while leftNeighborX >= 1 do 
        local leftPlanet = self.matrix[(y - 1) * X_COUNT[HORV] + leftNeighborX]
        if leftPlanet and leftPlanet:getIndex(self.randomNum) == planetIndex then
            leftNeighborX = leftNeighborX - 1 
            leftCount = leftCount + 1 
        else 
            break 
        end
    end 

    -- 向下检查同类型的星球
    local downNeighborY = y - 1 
    while downNeighborY >= 1 do 
        local downPlanet = self.matrix[(downNeighborY - 1) * X_COUNT[HORV] + x]  
        if downPlanet and downPlanet:getIndex(self.randomNum) == planetIndex then
            downNeighborY = downNeighborY - 1 
            downCount = downCount + 1
        else 
            break 
        end
    end 

    if leftCount >= 2 or downCount >= 2 then 
        return true 
    end 

    return false 
end 

-- 加分数字
function GameScene:addScoreNun(pos, num)

    local str = "+" .. num
    local addNumber = cc.LabelAtlas:_create(str , ADD_SCORE_ROOT , 48, 52, string.byte("+") )
    addNumber:setAnchorPoint(cc.p(0.5, 0.5))
    addNumber:setPosition(pos)
    addNumber:setScale(0)
    self.node_planetPanel:addChild(addNumber, 50)

    local scaleTo = cc.ScaleTo:create(0.5, 1)
    local moveBy = cc.MoveBy:create(0.5, cc.p(0, 80))
    local fadeOut = cc.FadeOut:create(0.5)

    callFunc = cc.CallFunc:create(function() 
       addNumber:removeFromParent()
    end)
    local action = cc.Sequence:create(cc.EaseBounceOut:create(scaleTo), cc.EaseSineInOut:create(moveBy), fadeOut, callFunc, NULL);
    addNumber:runAction(action)
end 

-- 根据横和列计算矩形区域
function GameScene:getRect(x, y)
    return cc.rect((x - 1) * PlanetItem.getWidth() , 
            (y - 1) * PlanetItem.getWidth() , 
            PlanetItem.getWidth() ,
            PlanetItem.getWidth() )

end 

-- 往上移动
function GameScene:moveUp() 
    if self.isCheckUpMove == false then 
        return 
    end 
    self.isCheckUpMove = false -- 是否需要判断上升

    -- 检查是否需要上升
    local moveFlag = true  -- 移动标志
    for i = X_COUNT[HORV] + 1, X_COUNT[HORV] * 2 do -- 判断第2行是否还有泥块  有泥块不能上升
        local planet = self.matrix[i] 
        if planet and planet:getIndex(self.randomNum) > 8 then 
            moveFlag = false  
            break 
        end 
    end 

    if moveFlag then -- 上移
        self.isCheckUpMove = true -- 是否检查上移
        print("=========shang yi") 

        AudioEngine.playEffect("wacaibao/res/common/sound/moveUp.mp3")

        self.curDepth = self.curDepth + 20 -- 当前深度 
        self:setMudWeight() --   设置泥块权重 

        for i = 1 , X_COUNT[HORV] * Y_COUNT[HORV] do 
            local planet = self.matrix[i] 
            if planet then 
                local endPosition = self:positionOfPlanet(planet.x, planet.y + MOVE_UP_NUM[HORV])
                local action = cc.MoveTo:create(UP_SPEED, endPosition) 
                if planet.y > Y_COUNT[HORV] - MOVE_UP_NUM[HORV] then -- 最上面两行星球 会移动出去  最后需要删除掉
                    if planet:getType() == PLANET_TYPE.FROZEN then 
                        self.difficultPlanetCount = self.difficultPlanetCount - 1 
                    end 
                    action = cc.Sequence:create(action, cc.CallFunc:create(function () 
                            planet:removeFromParent() 
                        end))
                end 
                planet:runAction(action)
                local index = planet:getIndex(self.randomNum)
                planet.y = planet.y + MOVE_UP_NUM[HORV]  -- 修改星球y的值 
                planet:setIndexAndType(index, self.randomNum)
            end 
        end

        -- 矩阵重新赋值
        for i = X_COUNT[HORV] * Y_COUNT[HORV] , X_COUNT[HORV] * MOVE_UP_NUM[HORV] + 1 , -1 do  
            self.matrix[i] = self.matrix[i - MOVE_UP_NUM[HORV] * X_COUNT[HORV]]
        end 

        -- 创建新的泥块
        for y = 1, MOVE_UP_NUM[HORV] do
            for x = 1, X_COUNT[HORV] do
                local index = self:calculateMudIndex() -- 计算泥块索引值
                self:createMud(x,y,index)
            end
        end
    else 
        local resultIndex = self:isImpasse()  -- 检查死局 
        if resultIndex == -1 then 
            self:impasseAfterReset()  -- 死局后重置
        end  
    end 
end 

-- 复位所有星球和泥块标记
function GameScene:resetSign() 
    for i = 1, X_COUNT[HORV] * Y_COUNT[HORV] do 
        local planet = self.matrix[i] 
        if planet then 
            if planet:getIndex(self.randomNum) > 7 then 
                planet.isIgnoreCheck = true
            else 
                planet.isIgnoreCheck = false
            end 
            planet:setActive(false) 
            planet.isMarkRemove = false 
            planet.isIntersection = false 
            planet.isForthwithRemove = true 
        end 
    end 
end 

-- 复位没有被标记删除的星球和泥块标记
function GameScene:resetSignWithNotMarkRemove() 
    local count = 0 
    for i = 1, X_COUNT[HORV] * Y_COUNT[HORV] do 
        local planet = self.matrix[i] 
        if planet and planet.isMarkRemove == false then 
            count = count + 1
            if planet:getIndex(self.randomNum) > 7 then 
                planet.isIgnoreCheck = true
            else 
                planet.isIgnoreCheck = false
            end 
            planet:setActive(false) 
            planet.isMarkRemove = false 
            planet.isIntersection = false 
            planet.isForthwithRemove = true 
        end 
    end 
    print("fu wei = " .. count)
end 

-- 判断是否有星球在执行动画
function GameScene:judgeIsAnimation()
    local flag = false 
    for i = 1 , X_COUNT[HORV] * Y_COUNT[HORV] do 
        local planet = self.matrix[i] 
        if planet ~= nil then 
            if  planet:getNumberOfRunningActions() > 0 then 
                flag = true 
                break  
            end  
        end 
    end 
    return flag
end 

-- 更新时间和进度条
function GameScene:updateTime(dt)
    if self.curTime > 0 and self.isStopClocking == false then 
        local singleFastForwardTime = 0 -- 单次快进的时间
        if self.gameState == E_GAME_STATE.DIFFICULT then -- 加难状态
            if self.cumulativeFastForwardTime < self.fastForwardTime then 
                local result = math.random(100) 
                if result < 30 then 
                    singleFastForwardTime = 0.01 
                    self.cumulativeFastForwardTime = self.cumulativeFastForwardTime + singleFastForwardTime
                end 
            end 
        end

        self.curTime = self.curTime - dt - singleFastForwardTime
        if self.curTime <= 0 then 
            self.curTime = 0 
            self:sendRequestStartMSG() -- 向服务端请求开始
        end 
        local precent = self.curTime / self.paraValueTab.playtime
        self.progressBar:setPercent(precent * 100)
        local xx = TIME_MOVE_END_X[HORV] + precent * TIME_MOVE_DISTANCE[HORV]
        self.timeImg:setPositionX(TIME_MOVE_END_X[HORV] + precent * TIME_MOVE_DISTANCE[HORV]) 
    end 
end 

-- 发送请求开始消息
function GameScene:sendRequestStartMSG()
   gamesvr.sendRequestStart(self.keyt) -- 发送请求开始游戏  
end 

-- 发送消除消息
function GameScene:sendRemoveMSG(num)
    local effMd5 = self.keyt * num + self.keyt * 2017
    gamesvr.sendRemoveData(num, self.keyt, effMd5) -- 发送消除数据 
end 
 

-- 创建条形闪电特效
function GameScene:createStripLightning(pos, scale, roteta) 
     
    local stripLightning = cc.Sprite:createWithSpriteFrameName("strip_1.png")
    stripLightning:setPosition(pos)
    stripLightning:setBlendFunc(gl.SRC_ALPHA,gl.ONE) -- gl.SRC_COLOR,gl.ONE  gl.SRC_ALPHA,gl.ONE
    self.node_planetPanel:addChild(stripLightning,100) 

    if scale then 
        stripLightning:setScaleX(scale)
    end 

    if roteta then 
        stripLightning:setRotation(roteta)
    end 

    local action = createWithSingleFrameName("strip_" , 0.02, 4)
    local callFunc_1 = cc.CallFunc:create(function()
        stripLightning:removeFromParent()
    end)
    stripLightning:runAction(cc.Sequence:create(action,callFunc_1, nil ))
end 

-- 计算条形闪电特效坐标 
function GameScene:calculationStripLightningPos(planet) 
    local vertical_x = planet.x *  PlanetItem.getWidth() - (PlanetItem.getWidth()/2) -- 垂直
    local vertical_y = PlanetItem.getWidth() * Y_COUNT[HORV] / 2
    local horizontal_x = PlanetItem.getWidth() * X_COUNT[HORV] / 2 -- 水平
    local horizontal_y = planet.y *  PlanetItem.getWidth() - (PlanetItem.getWidth()/2) 

    return cc.p(vertical_x, vertical_y) , cc.p(horizontal_x, horizontal_y)
end

-- 判断是否死局
function GameScene:isImpasse()
    local resultIndex = -1
    for i = 1 , X_COUNT[HORV] * Y_COUNT[HORV] do 
        local planet = self.matrix[i] 
        if planet and planet:getIndex(self.randomNum) < 8  and planet:getType() ~= PLANET_TYPE.FROZEN then 
            if planet:getIndex(self.randomNum) == 7 then -- 如果是神灯 那么一定不会是死局
                flag = false
                resultIndex = i
                break 
            else 
                if planet.x - 1 >= 1 then 
                    local leftPlanet = self.matrix[(planet.y-1) * X_COUNT[HORV] + planet.x - 1]
                    if leftPlanet and self:isCanRemovePlanet(planet, leftPlanet) == true then -- 判断是否可消除
                        flag = false 
                        resultIndex = i
                        break 
                    end 
                end  
                if planet.x + 1 <= X_COUNT[HORV] then 
                    local rightPlanet = self.matrix[(planet.y-1) * X_COUNT[HORV] + planet.x + 1]
                    if rightPlanet and self:isCanRemovePlanet(planet, rightPlanet) == true then -- 判断是否可消除
                        flag = false 
                        resultIndex = i
                        break 
                    end 
                end 
                if planet.y - 1 >= 1 then 
                    local downPlanet = self.matrix[(planet.y - 2) * X_COUNT[HORV] + planet.x]
                    if downPlanet and self:isCanRemovePlanet(planet, downPlanet) == true then -- 判断是否可消除
                        flag = false 
                        resultIndex = i
                        break 
                    end 
                end
                if planet.y + 1 <= Y_COUNT[HORV] then 
                    local upPlanet = self.matrix[(planet.y) * X_COUNT[HORV] + planet.x]
                    if upPlanet and self:isCanRemovePlanet(planet, upPlanet) == true then -- 判断是否可消除
                        flag = false
                        resultIndex = i 
                        break 
                    end
                end 
            end 
        end 
    end 
    return resultIndex
end 

-- 死局后重置
function GameScene:impasseAfterReset()
    self.isTouchEnable = false -- 出现死局的时候 禁止移动
    self.isStopClocking = true -- 是否停止计时

    self.impasseTips:setVisible(true) --显示死局提示

    local delay = cc.DelayTime:create(5)
    callFunc = cc.CallFunc:create(function() 
        self.impasseTips:setVisible(false) -- 隐藏死局提示

        self.isTouchEnable = true -- 恢复移动
        self.isStopClocking = false -- 是否停止计时
        self.difficultPlanetCount = 0 -- 加难宝石数清0 

        -- 清除所有宝石
        for i = 1 , X_COUNT[HORV] * Y_COUNT[HORV] do 
            local planet = self.matrix[i] 
            if planet and planet:getIndex(self.randomNum) < 9  then 
                self.matrix[i] = nil 
                planet:removeFromParent()
            end 
        end 

        -- 创建新的宝石
        local index = 1 
        for y = 1, Y_COUNT[HORV] do
            for x = 1, X_COUNT[HORV] do
                local planet = self.matrix[(y - 1) * X_COUNT[HORV] + x]
                if planet == nil then 
                     repeat
                        index = self:getIntRandom(1, 6) --(产生1到6的数 包括1和6) 
                        isNeedCreateAgain = self:checkLeftAndDwonFruits(x,y,index)
                    until not isNeedCreateAgain; -- 为真跳出循环
                    self:createAndDropPlanet(x, y, index)
                end 
            end 
        end  
    end)
    local action = cc.Sequence:create(delay, callFunc, NULL);
    self.impasseTips:runAction(action)
end 

-- 判断单个宝石 是否移动一步后跟周围的宝石消除
function GameScene:isCanRemovePlanet(srcPlanet, destPlanet)
    if destPlanet:getIndex(self.randomNum) > 7 or destPlanet:getType() == PLANET_TYPE.FROZEN then 
        return false 
    end 
    local destPlanetIndex = destPlanet:getIndex(self.randomNum)
    local srcPlanetIndex = srcPlanet:getIndex(self.randomNum)
    destPlanet:setIndexAndType(srcPlanetIndex, self.randomNum) 
    srcPlanet:setIndexAndType(destPlanetIndex, self.randomNum) 

    local flag = self:checkPlanet(destPlanet)  -- 判断是否可消除
    destPlanet:setIndexAndType(destPlanetIndex, self.randomNum)
    srcPlanet:setIndexAndType(srcPlanetIndex, self.randomNum)
    if flag then 
        return true  
    end 

    return false   
end 

-- 设置游戏运行状态 是否需要加难
function GameScene:setState()
    local rate = 1 
    local result = self:getIntRandom(1, 10) --(产生1到10的数 包括1和10)
    if result == 1 then 
        rate = 1.1 
    elseif result == 2 then 
        rate = 1.2
    elseif result == 3 then
        rate = 1.3
    elseif result == 4 then
        rate = 1.4
    elseif result == 5 then
        rate = 1.5
    elseif result == 6 then
        rate = 1.6
    elseif result == 7 then
        rate = 1.7
    elseif result == 8 then
        rate = 1.8
    elseif result == 9 then
        rate = 1.9
    elseif result == 10 then
        rate = 2.0
    end 
    if  self.curScore >= self.startScore * rate then 
        self.gameState = E_GAME_STATE.DIFFICULT  -- DIFFICULT
    else 
        self.gameState = E_GAME_STATE.RANDOM 
    end 
    
    local time = self:getIntRandom(5, 29) --(产生5到29的数 包括5和29)
    local delay = cc.DelayTime:create(time)

    local callFunc = cc.CallFunc:create(function()
        self:setState()
    end) 
    
    self:runAction(cc.Sequence:create(delay,callFunc, nil ))
end 

function GameScene:initUI()
    local root = ccs.GUIReader:getInstance():widgetFromJsonFile(JSON_SCENE_ROOT[HORV])
    root:setClippingEnabled(true)
    self:addChild(root, 10)
    self.root = root

    self.background = ccui.Helper:seekWidgetByName(root, "background")
    self.scoreLab = ccui.Helper:seekWidgetByName(root, "lab_score") -- 得分lab 
    self:setScoreLab() -- 设置分数lab
    self.scoreLabPos = cc.p(self.scoreLab:getPosition()) -- 分数lab位置
    self.timeImg = ccui.Helper:seekWidgetByName(root, "image_time") -- 时间框节点
    self.lineImg = ccui.Helper:seekWidgetByName(root, "image_line") -- 横线节点
    self.progressBar = ccui.Helper:seekWidgetByName(root, "progressBar") -- 进度条
    self.node_planetPanel = ccui.Helper:seekWidgetByName(root, "node_planetPanel") -- 存放星球节点  
    self.impasseTips = ccui.Helper:seekWidgetByName(root, "image_impasseTips") -- 死局提示节点
    self.impasseTips:setVisible(false)
    self.tipNumLab = ccui.Helper:seekWidgetByName(root, "lab_tipNum") -- 剩余提示数量lab
    self.tipNumLab:setString(tostring(self.tipNum))
    self.scoreTips = ccui.Helper:seekWidgetByName(root, "image_scoreTip") -- 提示投钱节点 Image_26_2
    self.scoreTips:setVisible(false)

    -- menu按钮
    local button_menu = ccui.Helper:seekWidgetByName(root, "button_menu")
    button_menu:addTouchEventListener(makeClickHandler(self,self.onMenuButton))

    -- 提示按钮
    local button_tips = ccui.Helper:seekWidgetByName(root, "button_tips")
    button_tips:addTouchEventListener(makeClickHandler(self,self.onTipButton))

    -- 帮助按钮
    local button_help = ccui.Helper:seekWidgetByName(root, "button_help")
    button_help:addTouchEventListener(makeClickHandler(self,self.onHelpButton))

    -- 静音复选框
    self.checkBox_mute = ccui.Helper:seekWidgetByName(root, "checkBox_mute")
    self.checkBox_mute:addEventListener(handler(self, self.onCheckBoxMute))

    -- 存放闪电节点
    self.m_node = cc.Node:create() 
    self.node_planetPanel:addChild(self.m_node, 100)

     -- 加载资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("wacaibao/res/common/plist/resources_3.plist")
    -- 消除提示精灵
    self.removeTipsSprite = cc.Sprite:createWithSpriteFrameName("removeTips_1.png")
    self.removeTipsSprite:setBlendFunc(gl.SRC_ALPHA,gl.ONE) -- gl.SRC_COLOR,gl.ONE 
    self.removeTipsSprite:setVisible(false)
    self.node_planetPanel:addChild(self.removeTipsSprite, 200)
    local action = createWithSingleFrameName("removeTips_", 0.03, 100000000) 
    self.removeTipsSprite:runAction(action)

end

-- 根据难度设置泥块出现概率
function GameScene:setMudProbability()
    if self.paraValueTab.difficultNum == 0 then 
        self.mudProbability[9] = 300
        self.mudProbability[10] = 500
        self.mudProbability[11] = 100
        self.mudProbability[12] = 100
        self.mudProbability[13] = 60
        self.mudProbability[14] = 40
        self.difficultPlanetTotal = 1
    elseif self.paraValueTab.difficultNum == 1 then 
        self.mudProbability[9] = 300
        self.mudProbability[10] = 500
        self.mudProbability[11] = 100
        self.mudProbability[12] = 50
        self.mudProbability[13] = 30
        self.mudProbability[14] = 20
        self.difficultPlanetTotal = 2
    elseif self.paraValueTab.difficultNum == 2 then
        self.mudProbability[9] = 300
        self.mudProbability[10] = 500
        self.mudProbability[11] = 100
        self.mudProbability[12] = 50
        self.mudProbability[13] = 25
        self.mudProbability[14] = 10
        self.difficultPlanetTotal = 3
    end 
end 

-- 计算泥块生成的区间
function GameScene:calculationInterval()
    local tempTab = {} 

    tempTab[9] = self.mudProbability[9]
    tempTab[10] = self.mudProbability[9] + self.mudProbability[10]
    tempTab[11] = self.mudProbability[9] + self.mudProbability[10] + self.mudProbability[11]
    tempTab[12] = self.mudProbability[9] + self.mudProbability[10] + self.mudProbability[11] + self.mudProbability[12]
    tempTab[13] = self.mudProbability[9] + self.mudProbability[10] + self.mudProbability[11] + self.mudProbability[12] + self.mudProbability[13]
    tempTab[14] = self.mudProbability[9] + self.mudProbability[10] + self.mudProbability[11] + self.mudProbability[12] + self.mudProbability[13] + self.mudProbability[14]

    return tempTab
end 

-- 设置泥块权重
function GameScene:setMudWeight()
    -- if self.curDepth <= 200 then 
    --     self.mudProbability[12] = self.mudProbability[12] + 15  -- 后面可以加一个随机数
    --     self.mudProbability[13] = self.mudProbability[13] + 10
    --     self.mudProbability[14] = self.mudProbability[14] + 5
    -- end 
end 

-- 保留小数点精度
function GameScene:numberFormatWithDecimal(num, n)
    n = n or 0
    local fmt = '%.' .. n .. 'f'
    return string.format(fmt, num)
end

-- 计算区间总值
function GameScene:totalIntervalValue() 
    local total = 0 
    for k, v in pairs(self.mudProbability) do 
        total = total + v
    end 
    return total
end 

-- 矩阵加密
function GameScene:encrypt(dt)
    self.encryptClock = self.encryptClock + dt
    if self.encryptClock >= 1000 then 
        self.encryptClock = 0 
        local temRandomNum = self.randomNum
        self.randomNum = self:getIntRandom(2, 225)
        print("ju zheng ji mi", self.randomNum)
        for i = 1, X_COUNT[HORV] * Y_COUNT[HORV] do 
            local planet = self.matrix[i]
            if planet then 
                planet:setIndexAndType(planet:getIndex(temRandomNum), self.randomNum)
            end 
        end 
    end 
end 

function GameScene:setScoreLab()
    local scale = 1
    if self.curScore > 99999999 then 
        scale = SCORE_SCALE[HORV][1]
    elseif self.curScore > 9999999 then 
        scale = SCORE_SCALE[HORV][2]
    elseif self.curScore > 99999 then 
        scale = SCORE_SCALE[HORV][3]
    end 

    self.scoreLab:setString(tostring(self.curScore)) -- 设置当前分数
    self.scoreLab:setScale(scale + 0.3) 
    local scaleTo = cc.ScaleTo:create(0.4, scale)
    self.scoreLab:runAction(cc.EaseBackOut:create(scaleTo)) 
end 

-- menu按钮回调   
function GameScene:onMenuButton(...) 
    self.isStopClocking = true -- 是否停止计时
    PopUpView.showPopUpView(ExitView)
end 

-- 提示按钮回调  
function GameScene:onTipButton(...) 
    if self.tipNum > 0 and self.tipsFlag == false and self:judgeIsAnimation() == false then -- 死局  暂停 不能提示  有星球在执行动画
        local resultIndex = self:isImpasse() -- 死局检测 返回一个能消除的矩阵索引
        if resultIndex ~= -1 then 
            local posX, posY = self.matrix[resultIndex]:getPosition()
            self.removeTipsSprite:setPosition(cc.p(posX, posY)) -- 设置消除提示光圈的位置
            self.removeTipsSprite:setVisible(true) -- 设置显示

            self.tipsFlag = true 
            self.tipNum = self.tipNum - 1 
            self.tipNumLab:setString(tostring(self.tipNum))
        end 
    end 
end 

-- 帮助按钮回调 
function GameScene:onHelpButton(...) 
    self.isStopClocking = true -- 是否停止计时
    PopUpView.showPopUpView(HelpView)
end 

-- 退出游戏
function GameScene:onGameExit(...) 
    local scheduleId
    local function onClose()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)

        if self.updateHandle then 
            AudioEngine.playEffect("wacaibao/res/common/sound/click.mp3")
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateHandle)
            self.updateHandle = nil 
            gamesvr.sendStandup() -- 发送玩家起立消息
            exit_wacaibao()
        end 
    end
    scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onClose, 0.5, false) -- 延迟退出
end 

-- 静音复选框按钮回调
function GameScene:onCheckBoxMute(sender, eventType)
    AudioEngine.playEffect("wacaibao/res/common/sound/click.mp3")
    if eventType == ccui.CheckBoxEventType.selected then 
        AudioEngine.setMusicVolume(0)
        AudioEngine.setEffectsVolume(0)
    elseif eventType == ccui.CheckBoxEventType.unselected then 
        local musicVolume = global.g_mainPlayer:getMusicVolume()
        local effectVolume = global.g_mainPlayer:getEffectVolume()
        AudioEngine.setMusicVolume(musicVolume)
        AudioEngine.setEffectsVolume(effectVolume)
    end 
end 

-- 参数获取
function GameScene:onGameOption(paraTab)
    self.paraValueTab = paraTab
    
    self.curScore = self.paraValueTab.curScore + self.paraValueTab.modifyScore -- 当前游戏分数
    self.startScore = self.curScore -- 初始分数 加难阈值用
    self.keyt = self.paraValueTab.keyt -- 游戏密钥
    self.randomNum = self:getIntRandom(2, 225) -- 加密用随机数

    self:initUI() -- 初始化UI 
    self:setMudProbability() -- 根据难度设置泥块出现概率
    self:initMartix()  -- 初始化矩阵
    self:removedAndDropUpdate()-- 定时器
    self:setState()-- 设置状态

    self:sendRequestStartMSG() -- 向服务端请求开始
end

-- 客户端请求开始游戏 服务端返回消息
function GameScene:onGameStartBack(paraTab)
    self.keyt = paraTab.keyt -- 游戏密钥

    if paraTab.isCanBegin  == 1 then -- 是否能开始
        self.curScore = paraTab.curScore +  paraTab.modifyScore -- 当前分数
        self:setScoreLab() -- 设置分数lab

        self.curTime = self.paraValueTab.playtime
        self.progressBar:setPercent(100)
        self.timeImg:setPositionX(TIME_MOVE_START_X[HORV])

        self.fastForwardTime = math.random() + 0.5  -- 快进的总时间
        self.cumulativeFastForwardTime = 0 -- 累计快进的时间
    else
        self.scoreTipFlag = true -- 提示分数不够
        self.scoreTips:setVisible(true) 
    end 
    
    print("onGameStartBack", paraTab.keyt, paraTab.isCanBegin ,paraTab.curScore, paraTab.modifyScore)
end

-- 客户端发送消除消息 服务端返回的消息
function GameScene:onGameEatBack(paraTab)
    self.curScore = paraTab.curScore +  paraTab.modifyScore -- 当前分数
    self.keyt = paraTab.keyt -- 游戏密钥

    print("服务端返回消除命令", self.keyt )
end     

-- 开始计时
function GameScene:onStartCountTime()
    self.isStopClocking = false -- 是否停止计时标志
end 

 --  订阅消息
function GameScene:onStartEnterTransition()
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_OPTION, self, self.onGameOption)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_STARTBACK, self, self.onGameStartBack)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_EATBACK, self, self.onGameEatBack)
    global.g_gameDispatcher:addMessageListener(GAME_WCB_GAME_EXIT, self, self.onGameExit)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_START_COUNTTIME, self, self.onStartCountTime)
end

function GameScene:onStartExitTransition()
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_OPTION, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_STARTBACK, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_EATBACK, self)
    global.g_gameDispatcher:removeMessageListener(GAME_WCB_GAME_EXIT, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_START_COUNTTIME, self)

    -- 被动退出时 需要这样处理
    if self.updateHandle then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateHandle)
        self.updateHandle = nil 
        AudioEngine.stopAllEffects()
        AudioEngine.stopMusic(true)
        AudioEngine.playMusic("fullmain/res/music/background.mp3", true)
    end 
end

