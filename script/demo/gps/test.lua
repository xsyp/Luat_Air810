module(...,package.seeall)

--[[
模块名称：“GPS应用”测试
模块功能：测试gps.lua的接口
模块最后修改时间：2017.02.16
]]

require"gps"
require"agps"


--[[
函数名：print
功能  ：打印接口，此文件中的所有打印都会加上gpsapp前缀
参数  ：无
返回值：无
]]
local function print(...)
	_G.print("testgps",...)
end

--[[
判断是否定位成功  gps.isfix()
获取经纬度信息      gps.getgpslocation()
]]

local function test1cb(cause)
  print("test1cb",cause,gps.isfix())
  print("test1cb",cause,gps.isfix(),gps.getgpslocation())
end

local function test2cb(cause)
  print("test2cb",cause,gps.isfix())
  print("test2cb",cause,gps.isfix(),gps.getgpslocation())
end

local function test3cb(cause)
  print("test3cb",cause,gps.isfix())
  print("test3cb",cause,gps.isfix(),gps.getgpslocation())
end

--测试代码开关，取值1,2
local testidx = 1

local function gps_open(typ)
  --第1种测试代码
  if typ==1 then
    --执行完下面三行代码后，GPS就会一直开启，永远不会关闭
    --因为gps.open(gps.DEFAULT,{cause="TEST1",cb=test1cb})，这个开启，没有调用gps.close关闭
    gps.open(gps.DEFAULT,{cause="TEST1",cb=test1cb})
    
    --10秒内，如果gps定位成功，会立即调用test2cb，然后自动关闭这个“GPS应用”
    --10秒时间到，没有定位成功，会立即调用test2cb，然后自动关闭这个“GPS应用”
    gps.open(gps.TIMERORSUC,{cause="TEST2",val=10,cb=test2cb})
    
    --300秒时间到，会立即调用test3cb，然后自动关闭这个“GPS应用”
    gps.open(gps.TIMER,{cause="TEST3",val=300,cb=test3cb})
  --第2种测试代码
  elseif typ==2 then
    gps.open(gps.DEFAULT,{cause="TEST1",cb=test1cb})
    sys.timer_start(gps.close,30000,gps.DEFAULT,{cause="TEST1"})
    gps.open(gps.TIMERORSUC,{cause="TEST2",val=10,cb=test2cb})
    gps.open(gps.TIMER,{cause="TEST3",val=60,cb=test3cb}) 
  end
end

gps.init()
gps_open(testidx)
