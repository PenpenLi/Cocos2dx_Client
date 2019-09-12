--扑克牌类型工具类
module("CardTypeUtil", package.seeall)

--判断牌的类型
function getType(_cards, cardsNum)
    local cards = PokerCard.copyCards(_cards);
    PokerCard.sortCards(cards);
    local kingNum = computeKingNum(cardsNum);

    if kingNum ~= 0 then
        local result = is5K(cards, cardsNum, kingNum)
        if result == true then
            return 10;
        end
    end

    if isRS(cards, cardsNum, kingNum) then
        return 9;
    elseif isSF(cards, cardsNum, kingNum) then
        return 8;
    elseif is4K(cards, cardsNum, kingNum) then
        return 7;
    elseif isFH(cards, cardsNum, kingNum) then
        return 6;
    elseif isFL(cards, cardsNum, kingNum) then
        return 5;
    elseif isST(cards, cardsNum, kingNum) then
        return 4;
    elseif is3K(cards, cardsNum, kingNum) then
        return 3;
    elseif is2P(cards, cardsNum, kingNum) then
        return 2;
    elseif is1P(cards, cardsNum, kingNum) then
        return 1;
    end

    return 0;
end

--计算满足条件的相同的牌的数量（不统计大小王）
--参数：cardsNum-牌面统计列表,num-牌的数量
function computeSameCardsNum(cardsNum, num)
    local count = 0;
    for i = 2, 14 do
        if cardsNum[i] == num then
            count = count + 1
        end
    end
    return count;
end

--计算大小王的数量
function computeKingNum(cardsNum)
    local count = 0;
    if cardsNum[16] == 1 then
        count = count + 1
    end
    if cardsNum[17] == 1 then
        count = count + 1
    end
    return count;
end

--判断所有牌的花色是否相同（不统计大小王）
--参数：cards-牌列表
function isSameSuitCards(cards, cardsNum, kingNum)
    local result = true;

    local _cards = PokerCard.copyCards(cards);
    --排除2次大小王
    if _cards[1] == 516 or _cards[1] == 517 then
        table.remove(_cards, 1);
    end
    if _cards[1] == 516 then
        table.remove(_cards, 1);
    end
    --计算其他牌是否同花
    local suit = PokerCard.getSuit(_cards[1]); --拿第一张牌的花色

    for i = 2, #_cards do
        if PokerCard.getSuit(_cards[i]) ~= suit then
            result = false;
            break;
        end
    end

    return result;
end

--计算牌是否数字相连
--参数：cards-牌列表，cardsNum-牌面统计列表
function isStraight(cards, cardsNum, kingNum)
    local result = true;
    local _cards = PokerCard.copyCards(cards);
    --排除2次大小王
    if _cards[1] == 516 or _cards[1] == 517 then
        table.remove(_cards, 1);
    end
    if _cards[1] == 516 then
        table.remove(_cards, 1);
    end
    if computeSameCardsNum(cardsNum, 1) == #_cards then
        if kingNum == 0 then
            for i = 1, #_cards - 1 do
                if PokerCard.getValue(_cards[i]) ~= PokerCard.getValue(_cards[i + 1]) + 1 then
                    result = false;
                    break;
                end
            end
        else
            --计算剩余牌的差值
            local sum = 0;
            for i = 1, #_cards - 1 do
                sum = sum + PokerCard.getValue(_cards[i]) - PokerCard.getValue(_cards[i + 1]);
            end
            if kingNum == 1 then
                if sum == 3 or sum == 4 then
                    result = true
                else
                    result = false;
                end

            else
                if sum == 2 or sum == 4 then
                    result = true
                else
                    result = false;
                end
            end
        end
    else
        result = false;
    end

    return result;
end

--是否一对（必须大于或等于10）
function is1P(cards, cardsNum, kingNum)
    local result = false;

    if kingNum == 2 then
        return true;
    elseif kingNum == 1 then
        if PokerCard.getValue(cards[2]) >= 10 then --王以外最大的牌
            result = true;
        end
    else
        for i = 1, #cards - 1 do
            if PokerCard.getValue(cards[i]) == PokerCard.getValue(cards[i + 1]) then
                if PokerCard.getValue(cards[i]) >= 10 then
                    result = true;
                    break;
                end
            end
        end
    end

    return result
end


--是否两对
function is2P(cards, cardsNum, kingNum)
    if computeSameCardsNum(cardsNum, 2) == 2 then
        return true;
    end

    if computeSameCardsNum(cardsNum, 2) == 1 and kingNum > 0 then
        return true
    end

    if kingNum == 2 then
        return true
    end

    return false
end

--是否三条
function is3K(cards, cardsNum, kingNum)
    if computeSameCardsNum(cardsNum, 3) == 1 then
        return true;
    end

    if computeSameCardsNum(cardsNum, 2) >= 1 and kingNum > 0 then
        return true;
    end

    if kingNum == 2 then
        return true
    end

    return false
end

--是否顺子
function isST(cards, cardsNum, kingNum)
    return isStraight(cards, cardsNum, kingNum)
end

--是否同花
function isFL(cards, cardsNum, kingNum)
    return isSameSuitCards(cards, cardsNum, kingNum)
end

--是否葫芦
function isFH(cards, cardsNum, kingNum)
    local _3KNum = computeSameCardsNum(cardsNum, 3);
    local _2KNum = computeSameCardsNum(cardsNum, 2);

    if kingNum == 1 then
        if _2KNum == 2 then --有两对牌
            return true;
        end
    elseif kingNum == 2 then
        if _3KNum == 1 or _2KNum == 1 then --有三张一样的牌或两张一样的牌
            return true;
        end
    else
        if _3KNum == 1 and _2KNum == 1 then --有三张一样的牌加一对牌
            return true;
        end
    end
    return false;
end

--是否四条
function is4K(cards, cardsNum, kingNum)
    local result = false;
    if kingNum == 0 then
        if computeSameCardsNum(cardsNum, 4) == 1 then
            result = true;
        end
    elseif kingNum == 1 then
        if computeSameCardsNum(cardsNum, 3) == 1 then
            result = true;
        end
    else
        if computeSameCardsNum(cardsNum, 2) == 1 then
            result = true;
        end
    end
    return result;
end

--是否同花顺（不包含同花大顺）
function isSF(cards, cardsNum, kingNum)
    local result = false;
    if isSameSuitCards(cards, cardsNum, kingNum) == true and isStraight(cards, cardsNum, kingNum) == true then
        result = true;
    end
    return result;
end

--是否同花大顺
function isRS(cards, cardsNum, kingNum)
    local result = false;
    if PokerCard.getValue(cards[#cards]) >= 10 then --最小的那张牌必须大于或者等于10
        if isStraight(cards, cardsNum, kingNum) == true and isSameSuitCards(cards, cardsNum, kingNum) == true then
            result = true;
        end
    end
    return result;
end

--是否五条
function is5K(cards, cardsNum, kingNum)
    local result = false;
    if kingNum == 1 then
        if computeSameCardsNum(cardsNum, 4) == 1 then
            result = true;
        end
    elseif kingNum == 2 then
        if computeSameCardsNum(cardsNum, 3) == 1 then
            result = true;
        end
    end
    return result;
end