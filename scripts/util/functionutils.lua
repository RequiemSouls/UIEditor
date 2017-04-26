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
    if parent ~= DisplayTree then
        node.parent = parent.id
    end
    table.insert(parent.children, node)
end

function MoveAction(action, parentId)
    local parent = FindNode(parentId)
    if parent then
        DeleteAction(action)
        table.insert(parent.children, action)
    end
end

function DeleteActionInChildren(parent, action)
    for index, child in ipairs(parent.children) do
        if child == action then
            table.remove(parent.children, index)
            return true
        end
        if DeleteActionInChildren(child, action) then
            return true
        end
    end
end

function DeleteAction(action)
    if SelectNode == nil then
        return
    end

    for k, v in pairs(SelectNode.inAction) do
        if v == action then
            table.remove(SelectNode.inAction, k)
        elseif type(v) == "table" then
            DeleteActionInChildren(v, action)
        end
    end
    for k, v in pairs(SelectNode.outAction) do
        if v == action then
            table.remove(SelectNode.outAction, k)
        elseif type(v) == "table" then
            DeleteActionInChildren(v, action)
        end
    end
end

function DeleteNode(node)
    local parent = nil
    if node.parent == -1 then
        parent = DisplayTree
    else
        parent = FindNode(node.parent)
        if parent == nil then
            Error("Delete error node : " .. node.name .. " id : " .. node.id)
            return
        end
    end
    for k, v in pairs(parent.children) do
        if v == node then
            table.remove(parent.children, k)
        end
    end
end

function FindNode(id, root)
    root = root or DisplayTree
    if id == -1 then
        return DisplayTree
    end
    if id == root.id then
        return root
    end
    for _,child in ipairs(root.children) do
        local node = FindNode(id, child)
        if node then
            return node
        end
    end
    if root.inAction ~= nil then
        for _,child in pairs(root.inAction) do
            if type(child) == "table" then
                local node = FindNode(id, child)
                if node then
                    return node
                end
            end
        end
    end
    if root.outAction ~= nil then
        for _,child in pairs(root.outAction) do
            if type(child) == "table" then
                local node = FindNode(id, child)
                if node then
                    return node
                end
            end
        end
    end
    return nil
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
