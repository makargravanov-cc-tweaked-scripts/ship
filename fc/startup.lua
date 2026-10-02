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
["fc.control"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__StringEndsWith(self, searchString, endPosition)
    if endPosition == nil or endPosition > #self then
        endPosition = #self
    end
    return string.sub(self, endPosition - #searchString + 1, endPosition) == searchString
end
-- End of Lua Library inline imports
local ____exports = {}
____exports.FC_STATE = "fc_state.json"
____exports.LOOP_HZ = 10
____exports.VMAX = 8
____exports.ARRIVE_R = 2.5
____exports.CRUISE_ALT = 400
--- 16 ECU: порядок [FLup,FLfwd,FLaft,FLside, FRup,... BL..., BR...].
____exports.ECU_IDS = {
    "FL-up",
    "FL-fwd",
    "FL-aft",
    "FL-side",
    "FR-up",
    "FR-fwd",
    "FR-aft",
    "FR-side",
    "BL-up",
    "BL-fwd",
    "BL-aft",
    "BL-side",
    "BR-up",
    "BR-fwd",
    "BR-aft",
    "BR-side"
}
--- Ось тяги каждого мотора в body frame (unit). up=(0,1,0) fwd=(0,0,1) aft=(0,0,-1) side=(+-1,0,0).
function ____exports.axisOf(self, id)
    if __TS__StringEndsWith(id, "up") then
        return vector.new(0, 1, 0)
    end
    if __TS__StringEndsWith(id, "fwd") then
        return vector.new(0, 0, 1)
    end
    if __TS__StringEndsWith(id, "aft") then
        return vector.new(0, 0, -1)
    end
    if string.sub(id, 2, 2) == "L" then
        return vector.new(-1, 0, 0)
    end
    return vector.new(1, 0, 0)
end
--- Распределить desired force body (Fx,Fy,Fz) + yaw torque Tz по 16 дросселям.
function ____exports.mix(self, f, yaw, hover)
    local out = {}
    for ____, id in ipairs(____exports.ECU_IDS) do
        local t
        if __TS__StringEndsWith(id, "up") then
            t = hover + f.y / 4
        elseif __TS__StringEndsWith(id, "fwd") then
            t = math.max(0, f.z / 4) + yaw * 0.05
        elseif __TS__StringEndsWith(id, "aft") then
            t = math.max(0, -f.z / 4) - yaw * 0.05
        else
            local ax = ____exports.axisOf(nil, id)
            t = math.max(0, f.x * ax.x / 4) + math.abs(yaw) * 0.03
        end
        if t > 1 then
            t = 1
        end
        if t < 0 then
            t = 0
        end
        out[#out + 1] = t
    end
    return out
end
--- Повернуть мировой вектор в body через conjugate(orientation).
function ____exports.worldToBody(self, q, w)
    local inv = q:conjugate()
    return inv:mul(w)
end
--- Вытащить yaw-ошибку из кватернионов: угол между текущей и целевой ориентацией вокруг Y.
function ____exports.yawError(self, qCur, qTgt)
    local dq = qTgt:mul(qCur:conjugate())
    local ____, yaw = dq:toEuler()
    return yaw
end
return ____exports
 end,
["fc.boot"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local proto = require("ship.proto")
local ctl = require("fc.control")
function ____exports.loadJson(self, p)
    if not fs.exists(p) then
        return nil
    end
    local h = fs.open(p, "r")
    if h == nil then
        return nil
    end
    local r = h.readAll()
    h.close()
    local v = textutils.unserializeJSON(r)
    local ____v_0 = v
    if ____v_0 == nil then
        ____v_0 = nil
    end
    return ____v_0
end
function ____exports.saveJson(self, p, v)
    local h, e = fs.open(p, "w")
    if h == nil then
        printError("fc: write fail " .. (e or ""))
        return
    end
    h.write(textutils.serializeJSON(v))
    h.close()
end
function ____exports.openModem(self)
    for ____, s in ipairs({
        "right",
        "left",
        "back",
        "top",
        "bottom",
        "front"
    }) do
        if peripheral.hasType(s, "modem") then
            local m = peripheral.wrap(s)
            m.open(proto.CH_CMD)
            m.open(proto.CH_STATUS)
            m.open(proto.CH_MISSION)
            return m
        end
    end
    error("fc: no modem", 0)
end
function ____exports.bootState(self, modem)
    local fc = ____exports.loadJson(nil, ctl.FC_STATE)
    if fc == nil then
        fc = {
            subUuid = nil,
            phase = "idle",
            target = nil,
            waypoints = {},
            cruiseAlt = ctl.CRUISE_ALT
        }
    end
    if not sublevel.isInPlotGrid() then
        print("fc: NOT on sublevel — SAFE")
    end
    do
        local i = 0
        while i < 10 do
            modem.transmit(proto.CH_CMD, proto.CH_STATUS, {
                kind = "force_cmd",
                seq = 0,
                throttle = 0,
                vecX = 0,
                vecY = 0
            })
            sleep(0.05)
            i = i + 1
        end
    end
    local uuid = ""
    local idU = sublevel.getUniqueId()
    if idU ~= nil then
        uuid = idU
    end
    if fc.subUuid == nil then
        fc.subUuid = uuid
        ____exports.saveJson(nil, ctl.FC_STATE, fc)
    end
    if uuid ~= "" and fc.subUuid ~= uuid then
        print("fc: new hull, HOLD")
        fc.phase = "hold"
        fc.target = nil
        fc.waypoints = {}
        ____exports.saveJson(nil, ctl.FC_STATE, fc)
    elseif fc.phase == "cruise" then
        print("fc: RESUME cruise")
    end
    return fc
end
return ____exports
 end,
["fc.main"] = function(...) 
--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end
-- End of Lua Library inline imports
local ____exports = {}
local proto = require("ship.proto")
local pid = require("ship.pid")
local ctl = require("fc.control")
local boot = require("fc.boot")
local modem = boot:openModem()
local fc = boot:bootState(modem)
local function saveFc(self)
    boot:saveJson(ctl.FC_STATE, fc)
end
local posPid = __TS__New(pid.Pid3, {
    kp = 0.6,
    ki = 0.02,
    kd = 0.25,
    iMin = -3,
    iMax = 3,
    oMin = -ctl.VMAX,
    oMax = ctl.VMAX
})
local velPid = __TS__New(pid.Pid3, {
    kp = 0.8,
    ki = 0.05,
    kd = 0.15,
    iMin = -2,
    iMax = 2,
    oMin = -1,
    oMax = 1
})
local yawPid = __TS__New(pid.Pid, {
    kp = 0.8,
    ki = 0.02,
    kd = 0.2,
    iMin = -0.5,
    iMax = 0.5,
    oMin = -0.5,
    oMax = 0.5
})
local qHold = quaternion.identity()
local seq = 1
local lastLoop = os.clock()
local function setpoint(self)
    local pose = sublevel.getLogicalPose().position
    if fc.phase == "cruise" and #fc.waypoints > 0 then
        local wp = fc.waypoints[1]
        local d = vector.new(wp.x - pose.x, wp.y - pose.y, wp.z - pose.z)
        if d:length() < ctl.ARRIVE_R then
            table.remove(fc.waypoints, 1)
            saveFc(nil)
            if #fc.waypoints == 0 then
                fc.phase = "hold"
                saveFc(nil)
                print("fc: arrived HOLD")
            end
        end
        local t = #fc.waypoints > 0 and fc.waypoints[1] or ({x = pose.x, y = pose.y, z = pose.z})
        return vector.new(t.x, t.y, t.z)
    end
    if fc.target ~= nil then
        return vector.new(fc.target.x, fc.target.y, fc.target.z)
    end
    return vector.new(pose.x, pose.y, pose.z)
end
local function loop(self)
    while true do
        local t0 = os.clock()
        local dt = math.max(
            0.02,
            math.min(0.5, t0 - lastLoop)
        )
        lastLoop = t0
        local pose = sublevel.getLogicalPose()
        local linV = sublevel.getLinearVelocity()
        local mass = math.max(
            1,
            sublevel.getMass()
        )
        local grav = aero.getGravity()
        local hoverBase = math.min(
            0.9,
            math.max(
                0.05,
                mass * math.abs(grav.y) / 1000 / 4
            )
        )
        local sp = setpoint(nil)
        local velCmd = posPid:step(sp, pose.position, dt)
        local forceW = velPid:step(velCmd, linV, dt)
        local ff = vector.new(0, -grav.y * mass / 1000, 0)
        local fB = ctl:worldToBody(
            pose.orientation,
            forceW:add(ff)
        )
        local yawE = ctl:yawError(pose.orientation, qHold)
        local yawT = yawPid:step(0, -yawE, dt)
        local th = ctl:mix(fB, yawT, hoverBase)
        if fc.phase == "idle" then
            do
                local i = 0
                while i < #th do
                    th[i + 1] = 0
                    i = i + 1
                end
            end
        end
        seq = seq + 1
        do
            local i = 0
            while i < #ctl.ECU_IDS do
                modem.transmit(proto.CH_CMD, proto.CH_STATUS, {
                    kind = "force_cmd",
                    seq = seq,
                    throttle = th[i + 1] or 0,
                    vecX = 0,
                    vecY = 0
                })
                i = i + 1
            end
        end
        sleep(math.max(
            0.02,
            1 / ctl.LOOP_HZ - (os.clock() - t0)
        ))
    end
end
local function console_(self)
    while true do
        term.write("fc> ")
        local line = read()
        local cmd = {}
        local it = string.gmatch(line, "%S+")
        while true do
            local w = it()
            if w == nil then
                break
            end
            cmd[#cmd + 1] = w
        end
        local c = cmd[1] or ""
        if c == "hold" then
            fc.phase = "hold"
            fc.target = nil
            fc.waypoints = {}
            saveFc(nil)
            modem.transmit(proto.CH_MISSION, proto.CH_MISSION, {kind = "hold", to = "all"})
            print("fc: HOLD")
        elseif c == "hover" then
            local y = tonumber(cmd[2] or "") or 400
            local p = sublevel.getLogicalPose().position
            fc.phase = "hold"
            fc.target = {x = p.x, y = y, z = p.z}
            fc.waypoints = {}
            saveFc(nil)
            modem.transmit(proto.CH_MISSION, proto.CH_MISSION, {kind = "hover_alt", altY = y, to = "all"})
            print("fc: HOVER y=" .. tostring(y))
        elseif c == "goto" then
            local x = tonumber(cmd[2] or "")
            local y = tonumber(cmd[3] or "")
            local z = tonumber(cmd[4] or "")
            if x == nil or y == nil or z == nil then
                print("usage: goto x y z")
            else
                local p = sublevel.getLogicalPose().position
                fc.phase = "cruise"
                fc.waypoints = {{x = p.x, y = fc.cruiseAlt, z = p.z}, {x = x, y = fc.cruiseAlt, z = z}, {x = x, y = y, z = z}}
                fc.target = {x = x, y = y, z = z}
                saveFc(nil)
                modem.transmit(proto.CH_MISSION, proto.CH_MISSION, {
                    kind = "goto",
                    x = x,
                    y = y,
                    z = z,
                    to = "all"
                })
                print((((((("fc: GOTO " .. tostring(x)) .. " ") .. tostring(y)) .. " ") .. tostring(z)) .. " via ") .. tostring(fc.cruiseAlt))
            end
        elseif c == "abort" then
            fc.phase = "idle"
            fc.target = nil
            fc.waypoints = {}
            saveFc(nil)
            modem.transmit(proto.CH_MISSION, proto.CH_MISSION, {kind = "abort", to = "all"})
            print("fc: ABORT")
        elseif c == "status" then
            local p = sublevel.getLogicalPose().position
            print((((((((("pos " .. tostring(p.x)) .. " ") .. tostring(p.y)) .. " ") .. tostring(p.z)) .. " phase=") .. fc.phase) .. " wp=") .. tostring(#fc.waypoints))
        elseif c == "help" or c == "?" or c == "" then
            print("hold | hover [y] | goto x y z | route .. | abort | status")
        elseif c == "route" then
            if (#cmd - 1) % 3 ~= 0 then
                print("usage: route x1 y1 z1 [x2 y2 z2 ...]")
            else
                local pts = {}
                do
                    local i = 1
                    while i < #cmd do
                        pts[#pts + 1] = {
                            x = tonumber(cmd[i + 1]) or 0,
                            y = tonumber(cmd[i + 1 + 1]) or 0,
                            z = tonumber(cmd[i + 2 + 1]) or 0
                        }
                        i = i + 3
                    end
                end
                fc.phase = "cruise"
                fc.waypoints = pts
                fc.target = pts[#pts]
                saveFc(nil)
                modem.transmit(proto.CH_MISSION, proto.CH_MISSION, {kind = "route", points = pts, to = "all"})
                print("fc: ROUTE " .. tostring(#pts))
            end
        else
            print("unknown: " .. c)
        end
    end
end
parallel.waitForAny(loop, console_)
return ____exports
 end,
}
return require("fc.main", ...)
