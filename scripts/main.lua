JSON = dofile("./scripts/JSON.lua")
dofile("./scripts/util/functionutils.lua")

FrameCount = 0
Components = {}

SaveFilePath = nil
ResourceRootPath = nil
ResourceCache = {}
DisplayTree = nil
SelectNode = nil
LogData = {}

function __G__TRACKBACK__(errorMsg)
    local slice = "\n------------------------------------------------"
    local preEx = ""
    local str = preEx ..errorMsg .. "\n " .. debug.traceback() .. slice
    Error(str)
end

function renderRoot()
    dofile("./scripts/util/functionutils.lua")

    dofile("./scripts/panel/displaypanel.lua")
    dofile("./scripts/panel/scenepanel.lua")
    dofile("./scripts/panel/propertypanel.lua")
    dofile("./scripts/panel/commonpanel.lua")
    ShowLogPanel()

    dofile("./scripts/component/compbase.lua")
    dofile("./scripts/data/datamgr.lua")
    dofile("./scripts/data/resmgr.lua")
    FrameCount = FrameCount + 1

    ShowReload()

    dofile("./scripts/render.lua")
end

function renderFromC()
    xpcall(renderRoot, __G__TRACKBACK__)
end
