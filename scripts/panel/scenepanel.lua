local function ShowNode(node, basex, basey, basesx, basesy, a)
    if node.visible == nil then
        node.visible = true
    end
    if not node.visible then
        return
    end
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
    local alpha = (node.alpha / 255) * a
    if tex then
        -- if node.type == "Image9" then
        --     local w = tex and tex.w or 0
        --     local h = tex and tex.h or 0
        --     local sx1 = node.origin[1] / w
        --     local sy1 = node.origin[2] / h
        --     local sx2 = node.size[1] / w
        --     local sy2 = node.size[2] / h
        --     local ow = epx - spx
        --     local oh = epy - spy
        --     local function addImage(_x, _y, _w, _h)
        --         imgui.DrawList_AddImage(tex.id, spx + _x * ow, spy + _y * oh, spx + _w * ow, spy + _h * oh, _x, _y, _w, _h,
        --                                 0x00ffffff + 0xff000000 * alpha)
        --     end
        --     addImage(0, 0, sx1, sy1) -- bl
        --     addImage(sx1, 0, sx2, sy1) -- bc
        --     addImage(sx2, 0, 1, sy1) -- br
        --     addImage(0, sy1, sx1, sy2) -- ml
        --     addImage(sx1, sy1, sx2, sy2) -- mc
        --     addImage(sx2, sy1, 1, sy2) -- mr
        --     addImage(0, sy2, sx1, 1) -- tl
        --     addImage(sx1, sy2, sx2, 1) -- tc
        --     addImage(sx2, sy2, 1, 1) -- tr
        -- else
            imgui.DrawList_AddImage(tex.id, spx, spy, epx, epy, 0, 0, 1, 1,
                                    0x00ffffff + 0xff000000 * alpha)
        -- end
    end
    for _, child in ipairs(node.children) do
        if node.type == "CompBase" then
            ShowNode(child, x, y, sx, sy, alpha)
        else
            ShowNode(child, spx, spy, sx, sy, alpha)
        end
    end
end

function ShowScenePanel()
    imgui.Begin("Scene Panel")
    if DisplayTree then
        local x, y = imgui.GetWindowPos()
        local w, h = imgui.GetWindowSize()
        local pandingx, pandingy = 10, 10
        ShowNode(DisplayTree, x + pandingx, y + h - pandingy, globalScale, globalScale, 1)
    end
    imgui.End()
end
