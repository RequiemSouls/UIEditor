function ShowReload()
    imgui.Begin(" reloading..... ")
    imgui.SetWindowSize(200, 1)
    imgui.End()
end

function ShowLogPanel()
    if #LogData > 0 and type(LogData[#LogData].msg) == "string" then
        imgui.Begin("Log " .. string.sub(LogData[#LogData].msg, 1, 60) .. "###LOG")
    else
        imgui.Begin("Log###LOG")
    end
    local overCount = ( #LogData > 10 ) and ( #LogData - 10 ) or 1
    for i = overCount, #LogData do
        local log = LogData[i]
        if log.type == LogType.error then
            imgui.PushStyleColor(0, 0.8,0.3,0.3,1.0)
        elseif log.type == LogType.debug then
            imgui.PushStyleColor(0, 0.5,0.5,0.5,1.0);
        end
        imgui.TextWrapped(string.format("[fi:%d count:%d] %s", log.frameCount, log.count, log.msg));
        imgui.PopStyleColor();
    end
    imgui.End()
end

function ShowSavePathPanel()
    imgui.Begin("Save Config")
    local _, str = imgui.CreateInput("save path", SaveFilePath or "")
    if imgui.IsKeyPressed(257) then
        SaveFilePath = str
        SaveConfig()
    end
    imgui.End()
end

function ShowSelectResRootPanel()
    imgui.Begin("Select Resource Root Path")
    local _, str = imgui.CreateInput("res root path", ResourceRootPath or "/Users/zhe/Documents/qile/trunk/Poker/res/ui/")
    if imgui.IsKeyPressed(257) then
        ResourceRootPath = str
    end
    imgui.End()
end
