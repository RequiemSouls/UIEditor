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
if ShowSavePath then
    ShowSavePathPanel()
end
ShowProperty()
-- imgui.SameLine()
-- if imgui.TreeNode("Test trees") then
--     for i=1, 5 do
--         if (imgui.TreeNode(i, "Child %d", i)) then
--             imgui.Text("blabla")
--             imgui.TreePop()
--         end
--     end
--     imgui.TreePop()
-- end
imgui.End()
