-- enum ImGuiTreeNodeFlags_
-- {
--     ImGuiTreeNodeFlags_Selected             = 1 << 0,   // Draw as selected
--     ImGuiTreeNodeFlags_Framed               = 1 << 1,   // Full colored frame (e.g. for CollapsingHeader)
--     ImGuiTreeNodeFlags_AllowOverlapMode     = 1 << 2,   // Hit testing to allow subsequent widgets to overlap this one
--     ImGuiTreeNodeFlags_NoTreePushOnOpen     = 1 << 3,   // Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
--     ImGuiTreeNodeFlags_NoAutoOpenOnLog      = 1 << 4,   // Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
--     ImGuiTreeNodeFlags_DefaultOpen          = 1 << 5,   // Default node to be open
--     ImGuiTreeNodeFlags_OpenOnDoubleClick    = 1 << 6,   // Need double-click to open node
--     ImGuiTreeNodeFlags_OpenOnArrow          = 1 << 7,   // Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
--     ImGuiTreeNodeFlags_Leaf                 = 1 << 8,   // No collapsing, no arrow (use as a convenience for leaf nodes). 
--     ImGuiTreeNodeFlags_Bullet               = 1 << 9,   // Display a bullet instead of arrow
--     //ImGuITreeNodeFlags_SpanAllAvailWidth  = 1 << 10,  // FIXME: TODO: Extend hit box horizontally even if not framed
--     //ImGuiTreeNodeFlags_NoScrollOnOpen     = 1 << 11,  // FIXME: TODO: Disable automatic scroll on TreePop() if node got just open and contents is not visible
--     ImGuiTreeNodeFlags_CollapsingHeader     = ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoAutoOpenOnLog
-- };
SelectFlag = 64 + 32 + 1--1100001
UnSelectFlag = 64 + 32--1100000
local function ShowNode(node)
    local flag = UnSelectFlag
    if node == SelectNode then
        flag = SelectFlag
    end
    local isOpen = imgui.TreeNodeEx(string.format("%s : %d", node.name, node.id), flag)
    if imgui.IsItemClicked() then
        Debug("select node id :" .. node.id)
        SelectNode = node
        SelectAction = nil
    end
    if isOpen then
        for i,child in ipairs(node.children) do
            ShowNode(child)
        end
        imgui.TreePop()
    end
end

function ShowDisplayPanel()
    if not DisplayTree then
        return
    end
    imgui.Begin("Display Panel")
    ShowNode(DisplayTree)
    imgui.End()
end

