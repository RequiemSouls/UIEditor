function LoadConfig(filepath)
    NeedReload = false
    if not ResourceRootPath then
        return
    end
    local f, errorMsg, errorCode = io.open(ResourceRootPath .. filepath, "r")
    if not f then
        -- Error(string.format("load config file [ %s ] error : %s", filepath, errorMsg))
        return false
    end

    SaveFilePath = filepath
    local configstr = f:read("*all")
    f:close()
    DisplayTree = JSON:decode(configstr)
    if DisplayTree == nil then
        NewConfig()
    end
    return true
end

function NewConfig()
    NeedReload = false
    DisplayTree = CreateNode(CompBase)
end

function GetUUID()
    if not DisplayTree then
        return 1
    end
    DisplayTree.id = DisplayTree.id + 1
    return DisplayTree.id - 1
end

function SaveConfig()
    if not SaveFilePath or not ResourceRootPath then
        return
    end
    local f, errorMsg, errorCode = io.open(ResourceRootPath .. SaveFilePath, "w")
    if not f then
        Error(string.format("save config file [ %s ] error : %s", SaveFilePath, errorMsg))
        return
    end

    local configstr = JSON:encode_pretty(DisplayTree)
    f:write(configstr)
    f:close()
end

