function ReloadData()
    if not CurrentUIFile then
        return
    end

    LoadConfig(CurrentUIFile)
end

function LoadConfig(filepath)
    NeedReload = false
    local f, errorMsg, errorCode = io.open(filepath, "r")
    if not f then
        CurrentUIFile = nil
        Error(string.format("load config file [ %s ] error : %s", filepath, errorMsg))
        return
    end

    CurrentUIFile = filepath
    local configstr = f:read("*all")
    f:close()
    DisplayTree = JSON:decode(configstr)
end

function NewConfig(filepath)
    NeedReload = false
    CurrentUIFile = filepath
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
    if CurrentUIFile == nil then
        ShowSavePath = true
        return
    end
    local f, errorMsg, errorCode = io.open(CurrentUIFile, "w")
    if not f then
        Error(string.format("save config file [ %s ] error : %s", CurrentUIFile, errorMsg))
        return
    end

    local configstr = JSON:encode_pretty(DisplayTree)
    f:write(configstr)
    f:close()
end

