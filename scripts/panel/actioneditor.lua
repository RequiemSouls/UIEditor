function Move_action_tostring(action)
    return string.format("[%s %d]: %.2f_%.2f,%f", action.type, action.id, action.position[1], action.position[2], action.time)
end

function Scale_action_tostring(action)
    return string.format("[%s %d]: %.2f_%.2f,%f", action.type, action.id, action.scale[1], action.scale[2], action.time)
end

function Rotate_action_tostring(action)
    return string.format("[%s %d] : %.2f,%f", action.type, action.id, action.rotate, action.time)
end

function FadeIn_action_tostring(action)
    return string.format("[%s %d] : %.2f", action.type, action.id, action.time)
end

function FadeOut_action_tostring(action)
    return string.format("[%s %d] : %.2f", action.type, action.id, action.time)
end

function Delay_action_tostring(action)
    return string.format("[%s %d] : %.2f", action.type, action.id, action.time)
end

function CallFunc_action_tostring(action)
    return string.format("[%s %d] : %s", action.type, action.id, action.event)
end

local function ShowAction(action)
    local isOpen = imgui.TreeNodeEx(_G[action.type .. "_tostring"](action),
                                    action == SelectAction and SelectFlag or UnSelectFlag)
    if imgui.IsItemClicked() then
        if action == SelectAction then
            SelectAction = nil
        else
            SelectAction = action
        end
    end
    if isOpen then
        for i, child in ipairs(action.children) do
            ShowAction(child)
        end
        imgui.TreePop()
    end
end

local function ShowActionMenu(parent)
    if SelectAction ~= nil then
        parent = SelectAction.children
    end
    if imgui.Button("Add Move") then
        table.insert(parent, CreateNode(Move_action))
    end
    imgui.SameLine()
    if imgui.Button("Add Scale") then
        table.insert(parent, CreateNode(Scale_action))
    end
    imgui.SameLine()
    if imgui.Button("Add FadeIn") then
        table.insert(parent, CreateNode(FadeIn_action))
    end
    imgui.SameLine()
    if imgui.Button("Add FadeOut") then
        table.insert(parent, CreateNode(FadeOut_action))
    end
    imgui.SameLine()
    if imgui.Button("Add Rotate") then
        table.insert(parent, CreateNode(Rotate_action))
    end
    imgui.SameLine()
    if imgui.Button("Add Delay") then
        table.insert(parent, CreateNode(Delay_action))
    end
    imgui.SameLine()
    if imgui.Button("Add CallFunc") then
        table.insert(parent, CreateNode(CallFunc_action))
    end

    local isEdit, id =  imgui.DragInt("MoveAction###ActionMove", -1)
    if SelectAction then
        if isEdit then
            if imgui.IsKeyPressed(257) then
                MoveAction(SelectAction, id)
            end
        end
    end
end

local function ShowCommonMenu(data)
    if imgui.Button("Close") then
        SelectAction = nil
        data.isOpen = false
    end
    imgui.SameLine()
    if imgui.Button("Delete Action") then
        DeleteAction(SelectAction)
        SelectAction = nil
    end

end

function ShowActionEditor(node, key)
    local data = node[key]
    if not data then
        return
    end
    imgui.Begin("Action Editor")
    ShowCommonMenu(data)
    ShowActionMenu(data)
    for _, action in pairs(data) do
        if type(action) == "table" then
            ShowAction(action)
        end
    end
    imgui.End()
end

