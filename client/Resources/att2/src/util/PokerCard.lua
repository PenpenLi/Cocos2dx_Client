module("PokerCard", package.seeall)

allCards = {};

--产生扑克牌
function _buildAllCards()
    local cards = {};
    for i = 1, 4 do -- 各4张牌
        for j = 2, 14 do --2-9、10、J、Q、K、A
            cards[#cards + 1] = i * 100 + j;
        end
    end
    cards[#cards + 1] = 516;
    cards[#cards + 1] = 517;

    allCards = cards;
    return cards;
end

--牌的数值
function getValue(card)
    return card % 100;
end

--牌的花色
function getSuit(card)
    return math.floor(card / 100);
end

--第一次获取牌
function getFirstCards()
    local cards = _buildAllCards();
    --获取随机数
    local randomList = {};
    CommonUtil.randFetch(randomList, 5, #cards);
    --根据随机数获取桌面牌
    local deskCards = {};
    --print("抽取牌数量：" .. #randomList);
    for i = 1, #randomList do
        deskCards[#deskCards + 1] = cards[randomList[i]];
    end
    --删除已经选取的牌
    for i = #randomList, 1, -1 do
        table.remove(cards, randomList[i]);
    end

    local deskCardsSort = copyCards(deskCards);
    sortCards(deskCardsSort);

    print("剩余扑克牌的数量：", #cards)
    return deskCards;
end

function _printCardNum(_cardsNum)
    for i = 1, #_cardsNum do
        print("扑克牌数量" .. i, _cardsNum[i]);
    end
end

function _printCard(_cards)
    for i = 1, #_cards do
        print("扑克牌" .. i, _cards[i]);
    end
end

function _printTable(_table)
    local result = "";
    for i = 1, #_table do
        result = result, tostring(_table[i]);
    end
    print("table:" .. result);
end

--换牌
--参数：_deskCards-桌面牌，_holdCards需要换的牌
function switchCard(_deskCards, _holdCards)
    local deskCards = copyCards(_deskCards);
    local switchCardsNum = 0; --需要换的牌的数量
    for i = 1, #_holdCards do
        if _holdCards[i] == false then
            switchCardsNum = switchCardsNum + 1;
        end
    end

    if switchCardsNum > 0 then
        --获取随机数
        local randomList = {};
        CommonUtil.randFetch(randomList, switchCardsNum, #allCards);
        local k = 1;
        for i = 1, #_holdCards do
            if _holdCards[i] == false then
                deskCards[i] = allCards[randomList[k]];
                k = k + 1;
            end
        end
    end

    return deskCards;
end

function _compareFunc(c1, c2)
    if getValue(c1) == getValue(c2) then
        return getSuit(c1) > getSuit(c2)
    end
    return getValue(c1) > getValue(c2)
end

--对牌进行排序 包括花色的排序
function sortCards(_cards)
    table.sort(_cards, _compareFunc)
end

-- 自定义复制table函数
function copyCards(_cards)
    local tab = {}
    for k, v in pairs(_cards or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = copyCards(v)
        end
    end
    return tab
end

--统计牌的数量
function computeCardsNum(_cards)
    local deskCardsNum = {};
    for i = 1, 17 do
        deskCardsNum[i] = 0;
    end
    for i = 1, #_cards do
        local value = getValue(_cards[i])
        deskCardsNum[value] = deskCardsNum[value] + 1;
    end
    return deskCardsNum;
end

--计算牌的类型
function computeCardsType(_deskCards)
    local deskCards = copyCards(_deskCards);
    sortCards(deskCards);
    local deskCardsNum = computeCardsNum(deskCards)
    local type = CardTypeUtil.getType(deskCards, deskCardsNum);
    --print("计算牌面类型：", _printCard(_deskCards), _printCardNum(deskCardsNum), type);
    return type;
end

--计算选中的牌
function computeSwitchCards(_cards)
    local targetCards = copyCards(_cards);
    sortCards(targetCards);
    local targetCardsNum = computeCardsNum(targetCards)

    --判断是否已经是中了其中一种类型
    local cardType = CardTypeUtil.getType(targetCards, targetCardsNum);
    --返回全选的牌
    print("computeSwitchCards，cardType：", cardType)
    if cardType == 0 then
        return { false, false, false, false, false };
    elseif cardType == 10 or cardType == 9 or cardType == 8 or cardType == 6 or cardType == 5 or cardType == 4 then --类型为五条（10）、同花大顺（9）、同花顺（8）、葫芦（6）、同花（5）、顺子（4）
        return { true, true, true, true, true };
    end

    local result = { false, false, false, false, false };
    local targetCardsChoose = { false, false, false, false, false };
    local totalChooseKing = 0; --选中的王牌的数量
    local totalChooseNotKing = 0; --王以外的选中的牌的数量

    --计算王牌
    for i = 1, 2 do
        if targetCards[i] == 516 or targetCards[i] == 517 then --大小王必选
            targetCardsChoose[i] = true
            totalChooseKing = totalChooseKing + 1;
        end
    end

    --选择相同的牌，本地方法
    local function chooseSameCards(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose)
        --print("chooseSameCards start：", totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose)
        local preEqualValue = 0;
        local currentValue = 0;
        for i = totalChooseKing + 1, #targetCards - 1 do
            currentValue = getValue(targetCards[i]);
            if currentValue == getValue(targetCards[i + 1]) then --相邻的值相等必选
                targetCardsChoose[i] = true;
                targetCardsChoose[i + 1] = true;

                if preEqualValue == currentValue then --数据修正，如果是第一次选中牌，则+1
                    totalChooseNotKing = totalChooseNotKing + 1;
                else
                    preEqualValue = currentValue;
                    totalChooseNotKing = totalChooseNotKing + 2;
                end
            end
        end
        --print("chooseSameCards end：", totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose)
        return totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose;
    end

    --选择一次相同的牌，本地方法
    local function chooseSameCardsOnce(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose)
        local preEqualValue = 0;
        local currentValue = 0;
        for i = totalChooseKing + 1, #targetCards - 1 do
            currentValue = getValue(targetCards[i]);
            if currentValue == getValue(targetCards[i + 1]) then --相邻的值相等必选
                targetCardsChoose[i] = true;
                targetCardsChoose[i + 1] = true;

                if preEqualValue == currentValue then --数据修正，如果是第一次选中牌，则+1
                    totalChooseNotKing = totalChooseNotKing + 1;
                else
                    preEqualValue = currentValue;
                    totalChooseNotKing = totalChooseNotKing + 2;
                end
                break;
            end
        end
        return totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose;
    end

    if cardType == 7 then --四条（7）
        --print("四条开始计算前：", totalChooseKing, totalChooseNotKing)
        totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose = chooseSameCards(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose);
        --print("四条开始计算后：", totalChooseKing, totalChooseNotKing)
        if totalChooseKing + totalChooseNotKing ~= 4 then
            print("错误！！！！！！！！！！！！！！！！！！4条判断失误，不相等：", targetCards[1], targetCards[2], targetCards[3], targetCards[4], targetCards[5])
            print("错误！！！！！！！！！！！！！！！！！！判断失误，不相等：totalChooseKing + totalChooseNotKing=", totalChooseKing + totalChooseNotKing, totalChooseKing, totalChooseNotKing)
        end
    else
        if cardType == 3 then --3条（3）
            if totalChooseKing == 0 then --如果没有王牌
                --选择相同的牌
                totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose = chooseSameCards(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose);
                if totalChooseKing + totalChooseNotKing ~= 3 then
                    print("错误！！！！！！！！！！！！！！！！！！3条判断失误，不相等：", targetCards[1], targetCards[2], targetCards[3], targetCards[4], targetCards[5])
                    print("错误！！！！！！！！！！！！！！！！！！判断失误，不相等：totalChooseKing + totalChooseNotKing=", totalChooseKing + totalChooseNotKing, totalChooseKing, totalChooseNotKing)
                end
            elseif totalChooseKing == 1 then --如果有1张王牌
                --选择一对牌
                totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose = chooseSameCardsOnce(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose);
                if totalChooseKing + totalChooseNotKing ~= 3 then
                    print("错误！！！！！！！！！！！！！！！！！！3条判断失误，不相等：", targetCards[1], targetCards[2], targetCards[3], targetCards[4], targetCards[5])
                    print("错误！！！！！！！！！！！！！！！！！！判断失误，不相等：totalChooseKing + totalChooseNotKing=", totalChooseKing + totalChooseNotKing, totalChooseKing, totalChooseNotKing)
                end
            elseif totalChooseKing == 2 then --如果有2张王牌
                --选中最大的一张牌
                targetCardsChoose[3] = true
                totalChooseNotKing = totalChooseNotKing + 1;
            end
        elseif cardType == 2 then --两对（2）
            if totalChooseKing == 0 then --如果没有王牌
                --选择相同的牌
                totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose = chooseSameCards(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose);
                if totalChooseKing + totalChooseNotKing ~= 4 then
                    print("错误！！！！！！！！！！！！！！！！！！两对判断失误，不相等：", targetCards[1], targetCards[2], targetCards[3], targetCards[4], targetCards[5])
                    print("错误！！！！！！！！！！！！！！！！！！判断失误，不相等：totalChooseKing + totalChooseNotKing=", totalChooseKing + totalChooseNotKing, totalChooseKing, totalChooseNotKing)
                end
            elseif totalChooseKing == 1 then --如果有1张王牌
                --选择一对牌
                totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose = chooseSameCardsOnce(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose);
                --选中没选择的最大一张牌
                for i = 1, 5 do
                    if targetCardsChoose[i] == false then
                        targetCardsChoose[i] = true;
                        totalChooseNotKing = totalChooseNotKing + 1;
                        break
                    end
                end
                if totalChooseKing + totalChooseNotKing ~= 4 then
                    print("错误！！！！！！！！！！！！！！！！！！两对判断失误，不相等：", targetCards[1], targetCards[2], targetCards[3], targetCards[4], targetCards[5])
                    print("错误！！！！！！！！！！！！！！！！！！判断失误，不相等：totalChooseKing + totalChooseNotKing=", totalChooseKing + totalChooseNotKing, totalChooseKing, totalChooseNotKing)
                end
            elseif totalChooseKing == 2 then --如果有2张王牌
                --选择一对牌
                totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose = chooseSameCardsOnce(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose);
                if totalChooseKing + totalChooseNotKing ~= 4 then
                    print("错误！！！！！！！！！！！！！！！！！！两对判断失误，不相等：", targetCards[1], targetCards[2], targetCards[3], targetCards[4], targetCards[5])
                    print("错误！！！！！！！！！！！！！！！！！！判断失误，不相等：totalChooseKing + totalChooseNotKing=", totalChooseKing + totalChooseNotKing, totalChooseKing, totalChooseNotKing)
                end
            end
        elseif cardType == 1 then --一对（1）
            if totalChooseKing == 0 then --如果没有王牌
                --选择一对牌
                totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose = chooseSameCardsOnce(totalChooseKing, totalChooseNotKing, targetCards, targetCardsChoose);
                for i = #targetCards, 1, -1 do --需要判断牌是否大于10
                    if targetCardsChoose[i] == true and getValue(targetCards[i]) < 10 then
                        targetCardsChoose[i] = false
                        targetCardsChoose[i - 1] = false
                        totalChooseNotKing = totalChooseNotKing - 2;
                        break;
                    end
                end
            elseif totalChooseKing == 1 then --如果有1张王牌
                --选择最大一张牌，判断牌是否大于10
                if getValue(targetCards[2]) < 10 then
                    targetCardsChoose[1] = false; --取消选中的王牌
                    totalChooseKing = 0;
                else
                    targetCardsChoose[2] = true;
                    totalChooseNotKing = totalChooseNotKing + 1;
                end
            elseif totalChooseKing == 2 then --如果有2张王牌
                --全部选中
            end
        end
    end

    --返回正确的选中的下标
    for i = 1, #targetCardsChoose do
        if targetCardsChoose[i] == true then --相邻的值相等必选
            for j = 1, #_cards do
                if _cards[j] == targetCards[i] then
                    result[j] = true;
                end
            end
        end
    end
    return result;
end

--计算发牌的相关值
function computeDealCard(param)
    DeskData.deskCards = {}
    for i = 1, 5 do
        DeskData.deskCards[i] = buildCardFromDecimal(param.cbCard[i]);
    end

    --服务器hold牌有问题，本地处理
    local holdCard = computeSwitchCards(DeskData.deskCards);
    for i=1,#param.bBarter do
        if param.bBarter[i]==0 then
            DeskData.holdCards[i]=true
        else
            DeskData.holdCards[i]=false
        end
       
    end
    --DeskData.holdCards = computeSwitchCards(DeskData.deskCards);
    print("remote holdCards：", param.bBarter[1], param.bBarter[2], param.bBarter[3], param.bBarter[4], param.bBarter[5]);
    print("local holdCards：", holdCard[1], holdCard[2], holdCard[3], holdCard[4], holdCard[5]);

    DeskData.winRank = param.peiLvType+1;
    -- if param.peiLvType == 2 then
    --     DeskData.winRank = 3;
    -- elseif param.peiLvType == 1 then
    --     DeskData.winRank = 2;
    -- elseif param.peiLvType == 0 then
    --     DeskData.winRank = 1;
    -- end

    DeskData.score5K = param.score5K;
    DeskData.scoreRS = param.scoreRS;
    DeskData.scoreSF = param.scoreSF;
    DeskData.score4K = param.score4K;

    DeskData.coin = param.currentScore;
end

--计算换牌的相关值
function computeSwitchCard(param)
    DeskData.newDeskCards = {}
    for i = 1, 5 do
        DeskData.newDeskCards[i] = buildCardFromDecimal(param.cbCard[i]);
    end

    --服务器hold牌有问题，本地处理
    local winHoldCard = computeSwitchCards(DeskData.newDeskCards);
    for i=1,#param.bBarter do
        if param.bBarter[i]==0 then
            DeskData.winHoldCards[i]=true
        else
            DeskData.winHoldCards[i]=false
        end       
    end
    --DeskData.winHoldCards = computeSwitchCards(DeskData.newDeskCards);
    print("remote holdCards：", param.bBarter[1], param.bBarter[2], param.bBarter[3], param.bBarter[4], param.bBarter[5]);
    print("local holdCards：", winHoldCard[1], winHoldCard[2], winHoldCard[3], winHoldCard[4], winHoldCard[5]);

    local cardsNum = computeCardsNum(DeskData.newDeskCards);
    print("remote cardType：", param.cardType);
    print("local cardType：", CardTypeUtil.getType(DeskData.newDeskCards, cardsNum));

    DeskData.deskCardsType = param.cardType;

    DeskData.score5K = param.score5K;
    DeskData.scoreRS = param.scoreRS;
    DeskData.scoreSF = param.scoreSF;
    DeskData.score4K = param.score4K;

    DeskData.coin = param.currentScore;
end

--计算换牌的相关值
function computeCompareCard(param)
    DeskData.CompareCard = buildCardFromDecimal(param.carddata);
    DeskData.isCompareSuccess = false;
    -- if param.result == 2 and DeskData.isGuessBig == true then
    --     DeskData.isCompareSuccess = true;
    -- elseif param.result == 1 and DeskData.isGuessBig == false then
    --     DeskData.isCompareSuccess = true;
    -- end
    if param.result == DeskData.isGuessBig then
        DeskData.isCompareSuccess = true;
    end
end

--从十进制数据中创建卡牌
function buildCardFromDecimal(val)
    local result = 0
    if val == 78 then --78即是516
        result = 516
    elseif val == 79 then --79即是517
        result = 517
    elseif val == 1 then --1即是414，方块A
        result = 414
    elseif val == 17 then --17即是114，梅花A
        result = 314
    elseif val == 33 then --33即是214，红桃A
        result = 214
    elseif val == 49 then --49即是314，黑桃A
        result = 114
    else
       if val > 49 then
            result = 100 + val- 48; --2即是102，黑桃2
        elseif val > 33 then
            result = 200 + val - 32; --18即是202，红桃2
        elseif val > 17 then
            result = 300 + val - 16; --34即是302，梅花2            
        elseif val > 1 then
            result = 400 + val ; --50即是402，方块2            
        end
    end
    print("buildCardFromDecimal：", val, result);
    --print("getDecimalFromCard：", result, getDecimalFromCard(result));
    return result;
end

--从卡牌中获取十进制数值
function getDecimalFromCard(val)
    local result = 0
    if val == 516 then --78即是516
        result = 78
    elseif val == 517 then --79即是517
        result = 79
    elseif val == 414 then --414即是1，方块A
        result = 1
    elseif val == 314 then --314即是17，梅花A
        result = 17
    elseif val == 214 then --214即是33，红桃A
        result = 33
    elseif val == 114 then --114即是49，黑桃A
        result = 49
    else
        if val > 400 then
            result = val - 400; --402即是2，方块2
        elseif val > 300 then
            result = val - 300 + 48; --302即是50，梅花2
        elseif val > 200 then
            result = val - 200 + 32; --202即是34，红桃2
        elseif val > 100 then
            result = val - 100 + 16; --102即是18，黑桃2
        end
    end
    print("getDecimalFromCard：", val, result);
    return result;
end