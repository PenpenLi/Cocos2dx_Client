--桌面数据类
module("DeskData", package.seeall)
--组牌游戏状态
GAME_STATUS_WAIT_BET = 0;
GAME_STATUS_WAIT_START = 1;
GAME_STATUS_WAIT_DISCARD_FIRST = 2;
GAME_STATUS_WAIT_CHANGE = 3;
GAME_STATUS_WAIT_DISCARD_SECOND = 4;
GAME_STATUS_WAIT_RESULT = 5;

--比牌游戏状态
GAME_COMPARE_WAIT_BET = 0;
GAME_COMPARE_WAIT_SELECT_SIZE = 1;
GAME_COMPARE_WAIT_DISCARD_SELECT_SIZE = 2;

coin = 0; --游戏币
exchangeScale = 0; --倍率
credit = 0; --信用
totalBet = 0; --全部的押注
bet = 0; --押注
isBet = false;
isOldBet = false;
oldBet = 0;
gameStatus = GAME_STATUS_WAIT_BET; --游戏状态
gameCompareStatus = GAME_COMPARE_WAIT_BET; --比倍游戏状态

score5K = 5000;
scoreRS = 2000;
scoreSF = 500;
score4K = 200;

deskCards = {} --桌面的牌
newDeskCards = {} --新的桌面的牌
holdCards = { false, false, false, false, false }
winHoldCards = { false, false, false, false, false } --获胜hold牌
deskCardsType = 0; --桌面牌的类型

rewards = {}; --奖励列表

winRank = 0; --赢的级别（初、中、高）

isGuessBig = 0 --押大小-得分=0-小=1-大=2

automatic = flase --是否自动

compareNum = 0; --比倍次数
compareMultiple = 1; --比倍倍数
isCompareSuccess = true; --是否比倍成功

--初始化
function init(_coin, _exchangeScale)
    coin = _coin;
    exchangeScale = _exchangeScale;
    totalBet = math.floor(coin / exchangeScale);
    credit = totalBet;
    bet = 0;
    oldBet = 0;

    gameStatus = GAME_STATUS_WAIT_BET;
    gameCompareStatus = GAME_COMPARE_WAIT_BET;

    deskCards = {} --桌面的牌
    newDeskCards = {} --新的桌面的牌
    holdCards = { false, false, false, false, false }
    winHoldCards = { false, false, false, false, false }
    deskCardsType = 0; --桌面牌的类型

    winRank = 0; --赢的级别
end

--得分
function getScore()
    -- if deskCardsType>0 then
    --     totalBet = credit + bet
    -- else
    --     totalBet = credit
    -- end
    totalBet=coin
    credit = totalBet
    bet = 0
end

--初始化比倍
function initCompare()
    compareNum = 0;
    compareMultiple = 1;
    isCompareSuccess = true;
end

--进入下一个比倍状态
function nextCompareStatus()
    isCompareSuccess = false;
    if compareNum == 0 then
        compareNum = compareNum + 1;
        -- compareMultiple = 1
        compareMultiple = 2
    elseif compareNum == 1 then
        compareNum = compareNum + 1;
        -- compareMultiple = 2
        compareMultiple = 5
    elseif compareNum == 2 then
        compareNum = compareNum + 1;
        -- compareMultiple = 5
        compareMultiple = 15
    elseif compareNum == 3 then
        compareNum = compareNum + 1;
        -- compareMultiple = 15
        compareMultiple = 50
    elseif compareNum == 4 then
        compareNum = compareNum + 1;
        -- compareMultiple = 50
        compareMultiple = 200
    elseif compareNum == 5 then
        compareNum = compareNum + 1;
--        compareMultiple = 200
    end
end

function computeCompareResult()
    print("比倍结果：isCompareSuccess=", isCompareSuccess, "coin=", coin, "totalBet=", totalBet, "credit=", credit, "bet=", bet, "compareNum=", compareNum, "compareMultiple=", compareMultiple)
    if isCompareSuccess == true then
        totalBet = credit + bet * compareMultiple;
        credit = totalBet
    else
        if isGuessBig==0 then
            totalBet = credit + bet * compareMultiple;
            credit = totalBet
        else
            totalBet = credit
            credit = totalBet
        end
    end
    bet = 0
end

function setRewards(_socreK5, _socreRS, _socreSF, _socreK4)
    rewards = { _socreK5, _socreRS, _socreSF, _socreK4 }
end

--计算下一个bet
function nextBet()
    print("current coin:", coin, "totalBet：", totalBet, "credit：", credit, "bet：", bet, "exchangeScale：", exchangeScale);
    if isBet == true then --上一轮已下注，本轮继续使用上一轮的下注结果
        bet = oldBet
        if totalBet - bet>=0 then
            credit = totalBet - bet
        else
            bet=0
        end
        isBet = false
    else
        if bet == 0 then
            if totalBet - 100 >= 0 then
                bet = 100
            end
        else
            if bet == 100 then
                if totalBet - 1000 >= 0 then
                    bet = 1000
                end
            elseif bet == 1000 then
                if totalBet - 10000 >= 0 then
                    bet = 10000
                else
                    bet = 100
                end
            elseif bet == 10000 then
                bet = 100
            end
        end

        if bet > 0 then
            credit = totalBet - bet;
        end
    end

    return bet;
end

--进入下一个游戏状态
function nextGameStatus(_status)
    if _status == nil then
        gameStatus = gameStatus + 1;
    else
        gameStatus = _status;
    end

    --数据修正
    if gameStatus > 5 then
        gameStatus = 0
    end
    if gameStatus < 0 then
        gameStatus = 0
    end
end

--进入下一个比倍游戏状态
function nextGameCompare(_status)
    if _status == nil then
        gameCompareStatus = gameCompareStatus + 1;
    else
        gameCompareStatus = _status;
    end

    --数据修正
    if gameCompareStatus > 1 then
        gameCompareStatus = 0
    end
    if gameCompareStatus < 0 then
        gameCompareStatus = 0
    end
end

--获取游戏状态描述
function getGameStatusDescribe()
    if gameStatus == GAME_STATUS_WAIT_BET then
        return LocalLanguage:getLanguageString("L_33da669fb0664e87")
    elseif gameStatus == GAME_STATUS_WAIT_START then
        return LocalLanguage:getLanguageString("L_2c9483db90617872")
    elseif gameStatus == GAME_STATUS_WAIT_DISCARD_FIRST then
        return LocalLanguage:getLanguageString("L_9c52727bd9f72277")
    elseif gameStatus == GAME_STATUS_WAIT_CHANGE then
        return LocalLanguage:getLanguageString("L_ebca54f06149b23c")
    elseif gameStatus == GAME_STATUS_WAIT_DISCARD_SECOND then
        return LocalLanguage:getLanguageString("L_fcc4c6f532c617b6")
    elseif gameStatus == GAME_STATUS_WAIT_RESULT then
        return LocalLanguage:getLanguageString("L_2f46b5731eda9b8e")
    end
end

--获取比倍游戏状态描述
function getGameCompareDescribe()
    if gameCompareStatus == GAME_STATUS_WAIT_BET then
        return LocalLanguage:getLanguageString("L_0529be8840b54279")
    elseif gameCompareStatus == GAME_COMPARE_WAIT_SELECT_SIZE then
        return LocalLanguage:getLanguageString("L_2d3274a4174f90c5")
    elseif gameCompareStatus == GAME_COMPARE_WAIT_DISCARD_SELECT_SIZE then
        return LocalLanguage:getLanguageString("L_acc50604a86e7f08")
    end
end