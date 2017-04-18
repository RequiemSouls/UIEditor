function Setter(node, key, value)
    node[key] = value
end

function Getter(node, key)
     return node[key]
end

function AddNodeAtSelected(base)
    if SelectNode == nil then
        Debug("select node is nil")
        return
    end
    local node = CreateNode(base)
    AddChild(SelectNode, node)
end

function AddChild(parent, node)
    table.insert(parent.children, node)
end

function CreateNode(base)
    local node = {}
    for k,v in pairs(base) do
        node[k] = v.d
    end
    node.id = GetUUID()
    node.children = {}
    return node
end

--/////////////////////////////////////////////////// LOG
LogType = {
    [ "error" ] = 1,
    [ "debug" ] = 2,
}

function Log(logType, ...)
    local msg = ""
    for _, v in ipairs({ ... }) do
        print(v)
        msg = string.format("%s %s", msg, v)
    end
    local len = #LogData
    if len > 0 and LogData[len].msg == msg and LogData[len].type == logType then
        LogData[len].count = LogData[len].count + 1
    else
        table.insert(LogData, {msg = msg, type = logType, count = 1, frameCount = FrameCount})
    end
    if logType == LogType["error"] then
        print(string.format("[%s fi:%d] %s", "LUA ERROR", FrameCount, msg))
    elseif logType == LogType["debug"] then
        print(string.format("[%s fi:%d] %s", "LUA DEBUG", FrameCount, msg))
    end
end

function Error(...)
    Log(LogType.error, ...)
end

function Debug(...)
    Log(LogType.debug, ...)
end
--///////////////////////////////////////////////////// END LOG

function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function extends(super)
    local result = {}
    setmetatable(result, {__index = super})
    result.super = super
    return result
end

function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
            cls.ctor = function() end
        end

        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = {}
            setmetatable(cls, {__index = super})
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end
