
SCENE_KIND_1_TRACNENUM=210;
SCENE_KIND_2_TRACNENUM=200 + 7 * 2;
SCENE_KIND_3_TRACNENUM=(50 + 40 + 30 + 1) * 2;
SCENE_KIND_4_TRACNENUM=8 * 8;
SCENE_KIND_5_TRACNENUM=(40 + 40 + 24 + 13 + 1) * 2;

scene_kind_1_trace_ = {}
scene_kind_2_trace_ = {}
scene_kind_3_trace_ = {}
scene_kind_4_trace_ = {}
scene_kind_5_trace_ = {}

function ChangToGLPos(p)
  return cc.Director:getInstance():convertToGL(p)
end

function BuildSceneKind1Trace(screen_width, screen_height)
  local kVScale = screen_height / kRESOLUTIONHEIGHT
  local kRadius = (screen_height - (240*kVScale))/2
  local kSpeed = 1.5 * screen_width / kRESOLUTIONWIDTH
  local center = cc.p(screen_width + kRadius+50, kRadius + 120 * kVScale)
  local center1 = ChangToGLPos(center)
  local fish_pos = math.buildCircleStatic(center1, kRadius, 100)
  scene_kind_1_trace_.speed = kSpeed*30
  for i=1,100 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp = ChangToGLPos(sp)
    ep = ChangToGLPos(ep)
    scene_kind_1_trace_[i] = {sp,ep}
  end

  local kRotateRadian1 = 45 * math.pi / 180;
  local kRotateRadian2 = 135 * math.pi / 180;
  local kRadiusSmall = kRadius / 2;
  local kRadiusSmall1 = kRadius / 3;
  local center_small = {}
  center_small[1] = ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(-kRotateRadian2), center.y + kRadiusSmall * math.sin(-kRotateRadian2)))
  center_small[2] = ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(-kRotateRadian1), center.y + kRadiusSmall * math.sin(-kRotateRadian1)))
  center_small[3] = ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(kRotateRadian2), center.y + kRadiusSmall * math.sin(kRotateRadian2)))
  center_small[4] = ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(kRotateRadian1), center.y + kRadiusSmall * math.sin(kRotateRadian1)))
  fish_pos = math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
  for i=1,17 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    table.insert(scene_kind_1_trace_, {sp, ep})
  end
  fish_pos = math.buildCircleStatic(center_small[2], kRadiusSmall1, 17)
  for i=1,17 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    table.insert(scene_kind_1_trace_, {sp, ep})
  end
  fish_pos = math.buildCircleStatic(center_small[3], kRadiusSmall1, 30)
  for i=1,30 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    table.insert(scene_kind_1_trace_, {sp, ep})
  end
  fish_pos = math.buildCircleStatic(center_small[4], kRadiusSmall1, 30)
  for i=1,30 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    table.insert(scene_kind_1_trace_, {sp, ep})
  end
  fish_pos = math.buildCircleStatic(center1, kRadiusSmall/2, 15)
  for i=1,15 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    table.insert(scene_kind_1_trace_, {sp, ep})
  end
  table.insert(scene_kind_1_trace_, {center, cc.p(-2*kRadius, center.y)})
end

function BuildSceneKind2Trace(screen_width, screen_height)
  local kHScale = screen_width/kRESOLUTIONWIDTH
  local kVScale = screen_height/kRESOLUTIONHEIGHT
  local kStopExcursion = 180 * kVScale
  local kHExcursion = 27 * kHScale / 2
  local kSmallFishInterval = (screen_width - kHExcursion*2)/100
  local kSmallFishHeight = 65 * kVScale
  local kSpeed = 3 * kHScale

  scene_kind_2_trace_.speed = kSpeed*30
  scene_kind_2_trace_.small_middle_delay = 1616/30
  math.randomseed(0)
  local small_height = math.floor(kSmallFishHeight * 3)
  for i=0,199 do
    local sp,mp,ep = cc.p(0,0), cc.p(0, 0), cc.p(0,0)
    sp.x = kHExcursion + (i%100)* kSmallFishInterval
    mp.x = sp.x
    ep.x = mp.x
    local excursion = math.random(0, 32767) % small_height
    if i < 100 then --上排
      sp.y = -65 - excursion
      mp.y = kStopExcursion
      ep.y = screen_height + 65
    else --下排
      sp.y = screen_height + 65 + excursion
      mp.y = screen_height - kStopExcursion
      ep.y = -65
    end
    sp = ChangToGLPos(sp)
    mp = ChangToGLPos(mp)
    ep = ChangToGLPos(ep)
    table.insert(scene_kind_2_trace_, {sp,mp,ep})
  end

  scene_kind_2_trace_.big_begin_delay = 147/30
  local big_fish_width = {[0] = 270 * kHScale, 226 * kHScale, 375 * kHScale, 420 * kHScale, 540 * kHScale, 454 * kHScale, 600 * kHScale}
  local big_fish_excursion = {}
  for i=0,6 do
    big_fish_excursion[i] = big_fish_width[i]
    for j=0,i-1 do
      big_fish_excursion[i] = big_fish_excursion[i] + big_fish_width[j]
    end
  end
  local y_excursoin = 250 * kVScale / 2
  for i=0,13 do
    local sp, ep = cc.p(0,0), cc.p(0, 0), cc.p(0,0)
    if i < 7 then
      sp.y = screen_height/2 - y_excursoin
      ep.y = sp.y
      sp.x = -big_fish_excursion[i%7]
      ep.x = screen_width + big_fish_width[i%7]
    else
      sp.y = screen_height/2 + y_excursoin
      ep.y = sp.y
      sp.x = screen_width + big_fish_excursion[i%7]
      ep.x = -big_fish_width[i%7]      
    end
    sp = ChangToGLPos(sp)
    ep = ChangToGLPos(ep)
    table.insert(scene_kind_2_trace_, {sp,ep})
  end
end

function BuildSceneKind3Trace(screen_width, screen_height)
  local kVScale = screen_height/kRESOLUTIONHEIGHT
  local kRadius = (screen_height-(240*kVScale))/2
  local kSpeed = 1.5 * screen_width / kRESOLUTIONWIDTH
  local center = cc.p(screen_width+kRadius, kRadius+120*kVScale)
  local fish_pos = math.buildCircleStatic(center, kRadius, 50)
  scene_kind_3_trace_.speed = kSpeed*30
  for i=1,50 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp = ChangToGLPos(sp)
    ep = ChangToGLPos(ep)
    scene_kind_3_trace_[i] = {sp, ep}
  end

  fish_pos = math.buildCircleStatic(center, kRadius*40/50, 40)
  for i=1,40 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp = ChangToGLPos(sp)
    ep = ChangToGLPos(ep)
    table.insert(scene_kind_3_trace_, {sp, ep})
  end

  fish_pos = math.buildCircleStatic(center, kRadius*30/50, 30)
  for i=1,30 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp = ChangToGLPos(sp)
    ep = ChangToGLPos(ep)
    table.insert(scene_kind_3_trace_, {sp, ep})
  end 

  table.insert(scene_kind_3_trace_, {ChangToGLPos(center), ChangToGLPos(cc.p(-2*kRadius, center.y))})

  center.x = -kRadius
  fish_pos = math.buildCircleStatic(center, kRadius, 50)
  for i=1,50 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp = ChangToGLPos(sp)
    ep = ChangToGLPos(ep)
    table.insert(scene_kind_3_trace_, {sp, ep})
  end

  fish_pos = math.buildCircleStatic(center, kRadius*40/50, 40)
  for i=1,40 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp = ChangToGLPos(sp)
    ep = ChangToGLPos(ep)
    table.insert(scene_kind_3_trace_, {sp, ep})
  end

  fish_pos = math.buildCircleStatic(center, kRadius*30/50, 30)
  for i=1,30 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp = ChangToGLPos(sp)
    ep = ChangToGLPos(ep)
    table.insert(scene_kind_3_trace_, {sp, ep})
  end

  table.insert(scene_kind_3_trace_, {ChangToGLPos(center), ChangToGLPos(cc.p(screen_width+2*kRadius, center.y))})
end

function BuildSceneKind4Trace(screen_width, screen_height)
  local kHScale = screen_width/kRESOLUTIONWIDTH
  local kVScale = screen_height/kRESOLUTIONHEIGHT
  local kSpeed = 3*kHScale
  scene_kind_4_trace_.speed = kSpeed*30
  local kFishWidth = 512*kHScale
  local kFishHeight = 304*kVScale
  --左下
  local start_pos = cc.p(0, screen_height - kFishHeight/2)
  local target_pos = cc.p(screen_width - kFishHeight/2, 0)
  local angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  local radius = kFishWidth*4
  local length = radius + kFishWidth/2
  local center_pos = cc.p(-length*math.cos(angle), start_pos.y + length*math.sin(angle))

  local ep = ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y - kFishHeight))
  local sp
  for i=1,8 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    end
    sp = ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    table.insert(scene_kind_4_trace_, {sp, ep})
    radius = radius - kFishWidth
  end

  start_pos.x = kFishHeight/2
  start_pos.y = screen_height
  target_pos.x = screen_width
  target_pos.y = kFishHeight/2
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)

  ep = ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y - kFishHeight))
  for i=1,8 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    end
    sp = ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    table.insert(scene_kind_4_trace_, {sp, ep})
    radius = radius - kFishWidth
  end

  --右下
  start_pos.x = screen_width - kFishHeight/2
  start_pos.y = screen_height
  target_pos.x = 0
  target_pos.y = kFishHeight/2
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)

  ep = ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y - kFishHeight))
  for i=1,8 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    end
    sp = ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    table.insert(scene_kind_4_trace_, {sp, ep})
    radius = radius - kFishWidth
  end

  start_pos.x = screen_width
  start_pos.y = screen_height - kFishHeight/2
  target_pos.x = kFishHeight/2
  target_pos.y = 0
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)

  ep = ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y - kFishHeight))
  for i=1,8 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    end
    sp = ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    table.insert(scene_kind_4_trace_, {sp, ep})
    radius = radius - kFishWidth
  end

  --右上
  start_pos.x = screen_width
  start_pos.y = kFishHeight/2
  target_pos.x = kFishHeight/2
  target_pos.y = screen_height
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y + kFishHeight))
  for i=1,8 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(-angle-math.pi), center_pos.y + radius*math.sin(-angle-math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(-angle), center_pos.y - radius*math.sin(-angle))
    end
    sp = ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    table.insert(scene_kind_4_trace_, {sp, ep})
    radius = radius - kFishWidth
  end

  start_pos.x = screen_width - kFishHeight/2
  start_pos.y = 0
  target_pos.x = 0
  target_pos.y = screen_height - kFishHeight/2
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y + kFishHeight))
  for i=1,8 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(-angle-math.pi), center_pos.y + radius*math.sin(-angle-math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(-angle), center_pos.y - radius*math.sin(-angle))
    end
    sp = ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    table.insert(scene_kind_4_trace_, {sp, ep})
    radius = radius - kFishWidth
  end  

  --左上
  start_pos.x = kFishHeight/2
  start_pos.y = 0
  target_pos.x = screen_width
  target_pos.y = screen_height - kFishHeight/2
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y + kFishHeight))
  for i=1,8 do
    if radius < 0 then
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y - radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y + radius*math.sin(angle))
    end
    sp = ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    table.insert(scene_kind_4_trace_, {sp, ep})
    radius = radius - kFishWidth
  end

  start_pos.x = 0
  start_pos.y = kFishHeight/2
  target_pos.x = screen_width - kFishHeight/2
  target_pos.y = screen_height
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y + kFishHeight))
  for i=1,8 do
    if radius < 0 then
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y - radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y + radius*math.sin(angle))
    end
    sp = ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    table.insert(scene_kind_4_trace_, {sp, ep})
    radius = radius - kFishWidth
  end
end

function BuildSceneKind5Trace(screen_width, screen_height)
  local kVScale = screen_height / kRESOLUTIONHEIGHT
  local kRadius = (screen_height - (200*kVScale))/2
  local kRotateSpeed = 1.5*math.pi/180
  local kSpeed = 5 * screen_width / kRESOLUTIONWIDTH
  local lcenter = ChangToGLPos(cc.p(screen_width/4, kRadius + 100 * kVScale))
  local rcenter = ChangToGLPos(cc.p(screen_width - screen_width/4, kRadius + 100 * kVScale))

  local kLFish1Rotate = 720 --* math.pi / 180;
  local kRFish2Rotate = (720 + 90) --* math.pi / 180;
  local kRFish5Rotate = (720 + 180) --* math.pi / 180;
  local kLFish3Rotate = (720 + 180 + 45) --* math.pi / 180;
  local kLFish4Rotate = (720 + 180 + 90) --* math.pi / 180;
  local kRFish6Rotate = (720 + 180 + 90 + 30) --* math.pi / 180;
  local kRFish7Rotate = (720 + 180 + 90 + 60) --* math.pi / 180;
  local kLFish6Rotate = (720 + 180 + 90 + 60 + 30) --* math.pi / 180;
  local kLFish18Rotate = (720 + 180 + 90 + 60 + 60) --* math.pi / 180;
  local kRFish17Rotate = (720 + 180 + 90 + 60 + 60 + 30) --* math.pi / 180;

  scene_kind_5_trace_.speed = kSpeed*30
  --左外1
  local cell_angle = 360 / 40;
  local away_begin = math.buildCircleDynamic(lcenter, kRadius, 40, kLFish1Rotate * math.pi / 180, 0)
  local away_end = math.buildCircleDynamic(lcenter, screen_width, 40, kLFish1Rotate * math.pi / 180, 0)
  for i=1,40 do
    table.insert(scene_kind_5_trace_, 
      {first={centerPoint=lcenter, startAngle=cell_angle*(i-1), endAngle=cell_angle*(i-1)+kLFish1Rotate, radius=kRadius, speedSec=kRotateSpeed*kRadius*30},
       second={away_begin[i], away_end[i]}})
  end
  --右外1
  cell_angle = 360 / 40;
  away_begin = math.buildCircleDynamic(rcenter, kRadius, 40, kRFish2Rotate * math.pi / 180, 0)
  away_end = math.buildCircleDynamic(rcenter, screen_width, 40, kRFish2Rotate * math.pi / 180, 0)
  for i=1,40 do
    table.insert(scene_kind_5_trace_, 
      {first={centerPoint=rcenter, startAngle=cell_angle*(i-1), endAngle=cell_angle*(i-1)+kRFish2Rotate, radius=kRadius, speedSec=kRotateSpeed*kRadius*30},
       second={away_begin[i], away_end[i]}})
  end
  --右外2
  cell_angle = 360 / 40;
  away_begin = math.buildCircleDynamic(rcenter, kRadius-34.5*kVScale, 40, kRFish5Rotate * math.pi / 180, 0)
  away_end = math.buildCircleDynamic(rcenter, screen_width, 40, kRFish5Rotate * math.pi / 180, 0)
  for i=1,40 do
    table.insert(scene_kind_5_trace_, 
      {first={centerPoint=rcenter, startAngle=cell_angle*(i-1), endAngle=cell_angle*(i-1)+kRFish5Rotate, radius=kRadius-34.5*kVScale, speedSec=kRotateSpeed*(kRadius-34.5*kVScale)*30},
       second={away_begin[i], away_end[i]}})
  end
  --左外2
  cell_angle = 360 / 40;
  away_begin = math.buildCircleDynamic(lcenter, kRadius-36*kVScale, 40, kLFish3Rotate * math.pi / 180, 0)
  away_end = math.buildCircleDynamic(lcenter, screen_width, 40, kLFish3Rotate * math.pi / 180, 0)
  for i=1,40 do
    table.insert(scene_kind_5_trace_, 
      {first={centerPoint=lcenter, startAngle=cell_angle*(i-1), endAngle=cell_angle*(i-1)+kLFish3Rotate, radius=kRadius-36*kVScale, speedSec=kRotateSpeed*(kRadius-36*kVScale)*30},
       second={away_begin[i], away_end[i]}})
  end  
  --左外3
  cell_angle = 360 / 24;
  away_begin = math.buildCircleDynamic(lcenter, kRadius-36*kVScale-56*kVScale, 24, kLFish4Rotate * math.pi / 180, 0)
  away_end = math.buildCircleDynamic(lcenter, screen_width, 24, kLFish4Rotate * math.pi / 180, 0)
  for i=1,24 do
    table.insert(scene_kind_5_trace_, 
      {first={centerPoint=lcenter, startAngle=cell_angle*(i-1), endAngle=cell_angle*(i-1)+kLFish4Rotate, radius=kRadius-36*kVScale-56*kVScale, speedSec=kRotateSpeed*(kRadius-36*kVScale-56*kVScale)*30},
       second={away_begin[i], away_end[i]}})
  end
  --右外3
  cell_angle = 360 / 24;
  away_begin = math.buildCircleDynamic(rcenter, kRadius-34.5*kVScale-58.5*kVScale, 24, kRFish6Rotate * math.pi / 180, 0)
  away_end = math.buildCircleDynamic(rcenter, screen_width, 24, kRFish6Rotate * math.pi / 180, 0)
  for i=1,24 do
    table.insert(scene_kind_5_trace_, 
      {first={centerPoint=rcenter, startAngle=cell_angle*(i-1), endAngle=cell_angle*(i-1)+kRFish6Rotate, radius=kRadius-34.5*kVScale-58.5*kVScale, speedSec=kRotateSpeed*(kRadius-34.5*kVScale-58.5*kVScale)*30},
       second={away_begin[i], away_end[i]}})
  end
  --右外4
  cell_angle = 360 / 13;
  away_begin = math.buildCircleDynamic(rcenter, kRadius-34.5*kVScale-58.5*kVScale-65*kVScale, 13, kRFish7Rotate * math.pi / 180, 0)
  away_end = math.buildCircleDynamic(rcenter, screen_width, 13, kRFish7Rotate * math.pi / 180, 0)
  for i=1,13 do
    table.insert(scene_kind_5_trace_, 
      {first={centerPoint=rcenter, startAngle=cell_angle*(i-1), endAngle=cell_angle*(i-1)+kRFish7Rotate, radius=kRadius-34.5*kVScale-58.5*kVScale-65*kVScale, speedSec=kRotateSpeed*(kRadius-34.5*kVScale-58.5*kVScale-65*kVScale)*30},
       second={away_begin[i], away_end[i]}})
  end
  --左外4
  cell_angle = 360 / 13;
  away_begin = math.buildCircleDynamic(lcenter, kRadius-36*kVScale-56*kVScale-68*kVScale, 13, kLFish6Rotate * math.pi / 180, 0)
  away_end = math.buildCircleDynamic(lcenter, screen_width, 13, kLFish6Rotate * math.pi / 180, 0)
  for i=1,13 do
    table.insert(scene_kind_5_trace_, 
      {first={centerPoint=lcenter, startAngle=cell_angle*(i-1), endAngle=cell_angle*(i-1)+kLFish6Rotate, radius=kRadius-36*kVScale-56*kVScale-68*kVScale, speedSec=kRotateSpeed*(kRadius-36*kVScale-56*kVScale-68*kVScale)*30},
       second={away_begin[i], away_end[i]}})
  end

  --左大鱼
  local end_x = lcenter.x + screen_width * math.cos(180+kLFish18Rotate)
  local end_y = lcenter.y + screen_width * math.sin(180+kLFish18Rotate)
  table.insert(scene_kind_5_trace_, 
      {first={centerPoint=lcenter, startAngle=180, endAngle=180+kLFish18Rotate, speedSec=1.5*30},
       second={lcenter, cc.p(end_x, end_y)}})

  --右大鱼
  local end_x = rcenter.x + screen_width * math.cos(180+kRFish17Rotate)
  local end_y = rcenter.y + screen_width * math.sin(180+kRFish17Rotate)
  table.insert(scene_kind_5_trace_, 
      {first={centerPoint=rcenter, startAngle=180, endAngle=180+kRFish17Rotate, speedSec=1.5*30},
       second={rcenter, cc.p(end_x, end_y)}})
end