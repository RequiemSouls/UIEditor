local function ShowNode(node, basex, basey, basesx, basesy)
    local tex = GetTexture(node.display)
    local x = basex + node.position[1] * basesx
    local y = basey - node.position[2] * basesy
    local sx = basesx * node.scale[1]
    local sy = basesy * node.scale[2]
    if tex then
        local w = tex.w * sx
        local h = tex.h * sy
        local sx = x - w * node.anchor[1];
        local sy = y + h * node.anchor[2];
        local ex = sx + w
        local ey = sy - h
        imgui.DrawList_AddImage(tex.id, sx, sy, ex, ey, 0, 0, 1, 1, 0xffffffff)
    end
    for _, child in ipairs(node.children) do
        ShowNode(child, x, y, sx, sy)
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
