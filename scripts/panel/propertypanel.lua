local Editor = {}
function Editor.vec2(node, key)
    _, node[key][1], node[key][2] = imgui.DragFloat2(key.."###"..node.id .. key, node[key][1], node[key][2])
end

function Editor.string(node, key)
    _, node[key] = imgui.CreateInput(key.."###"..node.id .. key, node[key])
end

function Editor.int(node, key)
    _, node[key] = imgui.DragInt(key.."###"..node.id .. key, node[key])
end

function Editor.float(node, key)
    _, node[key] = imgui.DragFloat(key.."###"..node.id .. key, node[key])
end

function Editor.texture(node, key)
    _, node[key] = imgui.CreateInput(key.."###"..node.id .. key, node[key])
end

function Editor.action(node, key)
    _, node[key].isOpen = imgui.Checkbox(key, node[key].isOpen);
    if node[key].isOpen then
        ShowActionEditor(node, key)
    end
end
function ShowProperty(node)
    imgui.Begin("property")
    imgui.Separator()
    if node ~= nil then
        local base = _G[node.type]
        local keys = {}
        for k, _ in pairs(node) do
            table.insert(keys, k)
        end
        table.sort(keys)
        for _, k in ipairs(keys) do
            local def = base[k]
            if def and def.rv ~= false then
                Editor[def.t](node, k)
            end
        end
    end
    imgui.End()
end
