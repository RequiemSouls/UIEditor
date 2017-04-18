local Editor = {}
function Editor.vec2(key)
    _, SelectNode[key][1], SelectNode[key][2] = imgui.InputFloat2(key, SelectNode[key][1], SelectNode[key][2])
end

function Editor.string(key)
    _, SelectNode[key] = imgui.CreateInput(key, SelectNode[key])
end

function Editor.int(key)
    _, SelectNode[key] = imgui.InputInt(key, SelectNode[key])
end

function Editor.float(key)
    _, SelectNode[key] = imgui.InputFloat(key, SelectNode[key])
end

function Editor.texture(key)
end
function ShowProperty()
    imgui.Begin("property")
    if SelectNode ~= nil then
        local base = _G[SelectNode.type]
        for k, _ in pairs(SelectNode) do
            local def = base[k]
            if def and def.rv ~= false then
                Editor[def.t](k)
            end
        end
    end
    imgui.End()
end

