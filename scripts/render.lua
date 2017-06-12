imgui.ShowTestWindow(true)

-- imgui.SetNextWindowSize(550, 680, ImGuiSetCond_Once);
imgui.Begin("test", false, 0)
-- if imgui.Button("newConfig") then
--     NewConfig("res/ui/uiconfig.json")
-- end
-- imgui.SameLine()
-- if imgui.Button("loadConfig") then
--     LoadConfig("res/ui/uiconfig.json")
-- end
-- imgui.SameLine()
if imgui.Button("saveConfig") then
    SaveConfig()
end
if imgui.Button("Add Node") then
    AddNodeAtSelected(CompBase)
end
if imgui.Button("Add Image") then
    AddNodeAtSelected(Image)
end
if imgui.Button("Add Button") then
    AddNodeAtSelected(Button)
end
if imgui.Button("Add Label") then
    AddNodeAtSelected(Label)
end
if imgui.Button("Add TTFLabel") then
    AddNodeAtSelected(TTFLabel)
end
if imgui.Button("Add Image9") then
    AddNodeAtSelected(Image9)
end
if imgui.Button("Delete selected") then
    DeleteNode(SelectNode)
end
ShowDisplayPanel()
ShowProperty(SelectNode)
if SelectAction then
    ShowProperty(SelectAction)
end
ShowScenePanel()

if ResourceRootPath and not SaveFilePath then
    ShowOpenFilePanel()
end
if not ResourceRootPath then
    ShowSelectResRootPanel()
end

imgui.Separator()
_, FunFilter = imgui.CreateInput("filter", FunFilter)
for k,v in pairs(imgui) do
    if string.find(k, FunFilter) then
        imgui.Text(k)
    end
end
imgui.End()
