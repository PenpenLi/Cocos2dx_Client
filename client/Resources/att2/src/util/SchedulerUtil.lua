--定时器工具类
module("SchedulerUtil", package.seeall)

--启动
--参数：
--callback: 回调函数，Scheduler会传递给回调函数一个参数dt，表示距离上次回调所经过的时间
--delay:每次调用回调函数的时间间隔
--pause: 是否停住，一般设为false就行，否则定时器停住不执行
--返回：schedulerId
function start(scheduler, callback, delay, pause)
    return scheduler:scheduleScriptFunc(callback, delay, pause);
end

--停止
--参数：schedulerId
function stop(scheduler, schedulerId)
    scheduler:unscheduleScriptEntry(schedulerId);
end