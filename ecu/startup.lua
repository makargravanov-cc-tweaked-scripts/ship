--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]

local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file, ...)
    if ____moduleCache[file] then
        return ____moduleCache[file].value
    end
    if ____modules[file] then
        local module = ____modules[file]
        ____moduleCache[file] = { value = (select("#", ...) > 0) and module(...) or module(file) }
        return ____moduleCache[file].value
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
["ship.pid"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end
-- End of Lua Library inline imports
local ____exports = {}
____exports.Pid = __TS__Class()
local Pid = ____exports.Pid
Pid.name = "Pid"
function Pid.prototype.____constructor(self, o)
    self.integral = 0
    self.prevErr = 0
    self.prevD = 0
    self.first = true
    self.kp = o.kp
    self.ki = o.ki
    self.kd = o.kd
    self.iMin = o.iMin or -1000000000
    self.iMax = o.iMax or 1000000000
    self.oMin = o.oMin or -1000000000
    self.oMax = o.oMax or 1000000000
    self.dAlpha = o.dAlpha or 0.35
end
function Pid.prototype.reset(self)
    self.integral = 0
    self.prevErr = 0
    self.prevD = 0
    self.first = true
end
function Pid.prototype.step(self, sp, pv, dt)
    if not (dt > 0) then
        dt = 0.05
    end
    local err = sp - pv
    self.integral = self.integral + err * dt
    if self.integral > self.iMax then
        self.integral = self.iMax
    end
    if self.integral < self.iMin then
        self.integral = self.iMin
    end
    local d = 0
    if not self.first then
        local raw = (err - self.prevErr) / dt
        d = self.dAlpha * raw + (1 - self.dAlpha) * self.prevD
    end
    self.first = false
    self.prevErr = err
    self.prevD = d
    local out = self.kp * err + self.ki * self.integral + self.kd * d
    if out > self.oMax then
        out = self.oMax
    end
    if out < self.oMin then
        out = self.oMin
    end
    return out
end
--- 3-axis vector PID built from 3 scalar Pids.
____exports.Pid3 = __TS__Class()
local Pid3 = ____exports.Pid3
Pid3.name = "Pid3"
function Pid3.prototype.____constructor(self, o)
    self.x = __TS__New(____exports.Pid, o)
    self.y = __TS__New(____exports.Pid, o)
    self.z = __TS__New(____exports.Pid, o)
end
function Pid3.prototype.reset(self)
    self.x:reset()
    self.y:reset()
    self.z:reset()
end
function Pid3.prototype.step(self, sp, pv, dt)
    local ox = self.x:step(sp.x, pv.x, dt)
    local oy = self.y:step(sp.y, pv.y, dt)
    local oz = self.z:step(sp.z, pv.z, dt)
    return vector.new(ox, oy, oz)
end
return ____exports
 end,
["ship.proto"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.CH_CMD = 100
____exports.CH_STATUS = 101
____exports.CH_MISSION = 102
return ____exports
 end,
["ecu.setup"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.SIDES = {
    "left",
    "right",
    "top",
    "bottom",
    "front",
    "back"
}
____exports.STATE_PATH = "ecu_state.json"
____exports.PERIPH_PATH = "ecu_periph.json"
____exports.HOVER_FALLBACK_TIMEOUT = 5
function ____exports.loadJson(self, path)
    if not fs.exists(path) then
        return nil
    end
    local h = fs.open(path, "r")
    if h == nil then
        return nil
    end
    local raw = h.readAll()
    h.close()
    local v = textutils.unserializeJSON(raw)
    local ____v_0 = v
    if ____v_0 == nil then
        ____v_0 = nil
    end
    return ____v_0
end
function ____exports.saveJson(self, path, v)
    local h = fs.open(path, "w")
    if h == nil then
        printError("ecu: cannot write " .. path)
        return
    end
    h.write(textutils.serializeJSON(v))
    h.close()
end
function ____exports.findPeripherals(self, cfg)
    if cfg.modemSide ~= nil and cfg.thrusterSide ~= nil then
        local m = {modemSide = cfg.modemSide, thrusterSide = cfg.thrusterSide, thrusterName = cfg.thrusterSide}
        ____exports.saveJson(nil, ____exports.PERIPH_PATH, m)
        return m
    end
    local saved = ____exports.loadJson(nil, ____exports.PERIPH_PATH)
    if saved ~= nil then
        return saved
    end
    local modemSide = cfg.modemSide
    local thrusterSide = cfg.thrusterSide
    for ____, s in ipairs(____exports.SIDES) do
        do
            local __continue10
            repeat
                if not peripheral.isPresent(s) then
                    __continue10 = true
                    break
                end
                if modemSide == nil and peripheral.hasType(s, "modem") then
                    modemSide = s
                end
                if thrusterSide == nil and peripheral.hasType(s, "liquid_vector_thruster") then
                    thrusterSide = s
                end
                __continue10 = true
            until true
            if not __continue10 then
                break
            end
        end
    end
    if modemSide == nil then
        error("ecu: wired modem not found", 0)
    end
    if thrusterSide == nil then
        error("ecu: liquid_vector_thruster not found", 0)
    end
    local m = {modemSide = modemSide, thrusterSide = thrusterSide, thrusterName = thrusterSide}
    ____exports.saveJson(nil, ____exports.PERIPH_PATH, m)
    return m
end
return ____exports
 end,
["ecu.main"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local proto = require("ship.proto")
local setup = require("ecu.setup")
local rawCfg = setup:loadJson("ecu.json")
local label = os.getComputerLabel() or ""
local ____temp_2 = rawCfg ~= nil and rawCfg.ecuId or (label ~= "" and label or "ECU-00")
local ____temp_3 = rawCfg ~= nil and rawCfg.role or "up"
local ____temp_0
if rawCfg ~= nil then
    ____temp_0 = rawCfg.modemSide
else
    ____temp_0 = nil
end
local ____temp_1
if rawCfg ~= nil then
    ____temp_1 = rawCfg.thrusterSide
else
    ____temp_1 = nil
end
local cfg = {ecuId = ____temp_2, role = ____temp_3, modemSide = ____temp_0, thrusterSide = ____temp_1}
local pm = setup:findPeripherals(cfg)
local modem = peripheral.wrap(pm.modemSide)
local thr = peripheral.wrap(pm.thrusterSide)
if modem == nil or thr == nil then
    error("ecu: wrap failed", 0)
end
modem.open(proto.CH_CMD)
modem.open(proto.CH_MISSION)
modem.open(proto.CH_STATUS)
local st = setup:loadJson(setup.STATE_PATH)
if st == nil then
    st = {
        ecuId = cfg.ecuId,
        role = cfg.role,
        lastThrottle = 0,
        lastVecX = 0,
        lastVecY = 0,
        mission = nil
    }
end
st.ecuId = cfg.ecuId
st.role = cfg.role
local function persist(self)
    setup:saveJson(setup.STATE_PATH, st)
end
thr.setThrustNormalized(0)
thr.setVector(0, 0)
local lastSeq = 0
local lastClock = os.clock()
local applied = 0
print((((((("ecu " .. cfg.ecuId) .. " role=") .. cfg.role) .. " modem=") .. pm.modemSide) .. " thr=") .. pm.thrusterSide)
while true do
    do
        local __continue5
        repeat
            local ev, ____, ch, ____, msg = os.pullEvent("modem_message")
            if ev ~= "modem_message" then
                __continue5 = true
                break
            end
            local now = os.clock()
            if now - lastClock > setup.HOVER_FALLBACK_TIMEOUT and st.mission ~= nil and applied == 0 and st.lastThrottle > 0 then
                thr.setThrustNormalized(st.lastThrottle)
                applied = st.lastThrottle
                print((("ecu " .. cfg.ecuId) .. ": FC silent, fallback ") .. tostring(st.lastThrottle))
            end
            if ch == proto.CH_CMD then
                local c = msg
                if c == nil or c.kind ~= "force_cmd" then
                    __continue5 = true
                    break
                end
                if c.seq <= lastSeq then
                    __continue5 = true
                    break
                end
                lastSeq = c.seq
                lastClock = now
                local t = math.max(
                    0,
                    math.min(1, c.throttle)
                )
                thr.setThrustNormalized(t)
                thr.setVector(
                    math.max(
                        -1,
                        math.min(1, c.vecX)
                    ),
                    math.max(
                        -1,
                        math.min(1, c.vecY)
                    )
                )
                applied = t
                st.lastThrottle = t
                st.lastVecX = c.vecX
                st.lastVecY = c.vecY
                persist(nil)
                local tanks = thr.tanks()
                local fuel = 0
                for k in pairs(tanks) do
                    local x = tanks[k]
                    if x ~= nil then
                        fuel = fuel + x.amount
                    end
                end
                modem.transmit(proto.CH_STATUS, proto.CH_STATUS, {
                    kind = "ecu_status",
                    ecuId = cfg.ecuId,
                    seq = c.seq,
                    power = t,
                    obstruction = 1,
                    fuelMb = fuel,
                    fuelCapMb = 1000
                })
            elseif ch == proto.CH_MISSION then
                local m = msg
                if m == nil or m.kind == nil then
                    __continue5 = true
                    break
                end
                if m.kind == "abort" then
                    thr.setThrustNormalized(0)
                    thr.setVector(0, 0)
                    applied = 0
                    st.lastThrottle = 0
                    st.mission = nil
                    persist(nil)
                    print(("ecu " .. cfg.ecuId) .. ": abort")
                else
                    st.mission = m
                    persist(nil)
                    print((("ecu " .. cfg.ecuId) .. ": latched ") .. m.kind)
                end
            end
            __continue5 = true
        until true
        if not __continue5 then
            break
        end
    end
end
return ____exports
 end,
}
return require("ecu.main", ...)
