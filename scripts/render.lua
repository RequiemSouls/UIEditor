imgui.ShowTestWindow(true)

-- imgui.SetNextWindowSize(550, 680, ImGuiSetCond_Once);
imgui.Begin("test", false, 0)
if imgui.Button("newConfig") then
    NewConfig("/Users/zhe/uiconfig.json")
end
if imgui.Button("loadConfig") then
    LoadConfig("/Users/zhe/uiconfig.json")
end
if imgui.Button("saveConfig") then
    SaveConfig()
end
if imgui.Button("Add Node on selected") then
    AddNodeAtSelected(CompBase)
end
if imgui.Button("Add Image on selected") then
    AddNodeAtSelected(Image)
end
if imgui.Button("Add Button on selected") then
    AddNodeAtSelected(Button)
end

ShowDisplayPanel()
ShowProperty()
ShowScenePanel()

if not SaveFilePath then
    ShowSavePathPanel()
end
if not ResourceRootPath then
    ShowSelectResRootPanel()
end

for k,v in pairs(imgui) do
    if string.find(k, "Draw") then
        imgui.Text(k)
    end
end
imgui.End()
