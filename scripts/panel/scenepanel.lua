local function ShowNode(node, basex, basey, basesx, basesy)
    local tex = GetTexture(node.display)
    local x = basex + node.position[1] * basesx
    local y = basey - node.position[2] * basesy
    local sx = basesx * node.scale[1]
    local sy = basesy * node.scale[2]
    local w = ( tex and tex.w or 0 ) * sx
    local h = ( tex and tex.h or 0 ) * sy
    local spx = x - w * node.anchor[1];
    local spy = y + h * node.anchor[2];
    local epx = spx + w
    local epy = spy - h
    if tex then
        imgui.DrawList_AddImage(tex.id, spx, spy, epx, epy, 0, 0, 1, 1,
                                0x00ffffff + 0xff000000 * node.alpha / 255)
    end
    for _, child in ipairs(node.children) do
        if node.type == "CompBase" then
            ShowNode(child, x, y, sx, sy)
        else
            ShowNode(child, spx, spy, sx, sy)
        end
    end
end
function ShowScenePanel()
    imgui.Begin("Scene Panel")
    if DisplayTree then
        local x, y = imgui.GetWindowPos()
        local w, h = imgui.GetWindowSize()
        local pandingx, pandingy = 10, 10
        ShowNode(DisplayTree, x + pandingx, y + h - pandingy, globalScale, globalScale)
    end
    imgui.End()
end
