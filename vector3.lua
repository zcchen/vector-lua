-- vector3
-- CHEN, Zhechuan
-- https://github.com/zcchen/vector-lua.git
-- MIT License

local calc = {}

local vec3, quat

local esp = 0.0001
local function atan2(a, b)
    if math.abs(b) < esp then
        if a > 0 then
            return math.pi / 2
        else
            return -math.pi / 2
        end
    else
        if b > 0 then
            return math.atan(a / b)
        else
            return math.atan(a / b) - math.pi
        end
    end
end

vec3 = {
    __add = function(v, u) return v:add(u) end,
    __sub = function(v, u) return v:sub(u) end,
    __mul = function(v, u)
        if type(u) == "number" then
            return v:scale(u)
        elseif calc.isvec3(u) then
            return v:dot(u)
        else
            error("vec3 can only scale with number or dot-multiply with vec3 at operator mul.")
        end
    end,
    __div = function(v, u)
        if type(u) == "number" then
            return v:scale(1 / u)
        else
            error("vec3 can only be divided by a number.")
        end
    end,
    __len = function(v) return v:length() end,
    __unm = function(v) return v:scale(-1) end,
    __tostring = function(v) return string.format("(%f, %f, %f)", v.x, v.y, v.z) end,

    __call = function(_, x, y, z)
        return setmetatable({
            x = x or 0,
            y = y or 0,
            z = z or 0,
        }, vec3)
    end,

    __index = {
        unpack = function(v)
            return v.x, v.y, v.z
        end,

        set = function(v, x, y, z)
            v.x = x
            v.y = y
            v.z = z
            return v
        end,

        add = function(v, u)
            if not calc.isvec3(u) then error('vec3 can only be added by another vec3.') end
            local out = vec3()
            out.x = v.x + u.x
            out.y = v.y + u.y
            out.z = v.z + u.z
            return out
        end,

        sub = function(v, u)
            if not calc.isvec3(u) then error('vec3 can only be sub by another vec3.') end
            local out = vec3()
            out.x = v.x - u.x
            out.y = v.y - u.y
            out.z = v.z - u.z
            return out
        end,

        dot = function(v, u)
            if not calc.isvec3(u) then
                error('vec3 can only be dot multiplied by another vec3.')
            end
            return v.x * u.x + v.y * u.y + v.z * u.z
        end,

        cross = function(v, u)
            if not calc.isvec3(u) then
                error('vec3 can only be cross multiplied by another vec3.')
            end
            local out = vec3()
            out.x = v.y * u.z - v.z * u.y
            out.y = v.z * u.x - v.x * u.z
            out.z = v.x * u.y - v.y * u.x
            return out
        end,

        scale = function(v, s)
            if type(s) ~= "number" then
                error("vec3 can only be scaled by a number.")
            end
            local out = vec3()
            out.x = v.x * s
            out.y = v.y * s
            out.z = v.z * s
            return out
        end,

        length = function(v)
            return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
        end,

        iszero = function(v)
            return v.x == 0 and v.y == 0 and v.z == 0
        end,

        norm = function(v)
            local len = v:length()
            if len == 0 then
                return vec3(v.x, v.y, v.z)
            else
                return v:scale(1 / len)
            end
        end,

        distance = function(v, u)
            if not calc.isvec3(u) then
                error('distance can ONLY be calculated by vec3s.')
            end
            return v:sub(v, u):length()
        end,

        angle = function(v, u)
            if not calc.isvec3(u) then
                error('angle can ONLY be calculated by vec3s.')
            end
            return atan2(v.y, v.x) - atan2(u.y, u.x)
        end,

        project = function(v, u)
            if not calc.isvec3(u) then
                error('The projected target must be another vec3..')
            end
            local out = vec3()
            local unorm = u:norm()
            local dot = v:dot(unorm)
            out.x = unorm.x * dot
            out.y = unorm.y * dot
            out.z = unorm.z * dot
            return out
        end,
    },
}
setmetatable(vec3, vec3)

function calc.vec3(x, y, z)
    return vec3(x, y, z)
end
function calc.isvec3(v)
    return getmetatable(v) == vec3
end
function calc.vector3(x, y, z)
    return vec3(x, y, z)
end
function calc.isvector3(v)
    return getmetatable(v) == vec3
end

-- TODO: add quaternions object

return calc
