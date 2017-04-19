function LoadConfig(filepath)
    NeedReload = false
    local f, errorMsg, errorCode = io.open(filepath, "r")
    if not f then
        Error(string.format("load config file [ %s ] error : %s", filepath, errorMsg))
        return
    end

    SaveFilePath = filepath
    local configstr = f:read("*all")
    f:close()
    DisplayTree = JSON:decode(configstr)
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
    if not SaveFilePath then
        return
    end
    local f, errorMsg, errorCode = io.open(SaveFilePath, "w")
    if not f then
        Error(string.format("save config file [ %s ] error : %s", SaveFilePath, errorMsg))
        return
    end

    local configstr = JSON:encode_pretty(DisplayTree)
    f:write(configstr)
    f:close()
end

