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

function Editor.bool(node, key)
    _, node[key] = imgui.Checkbox(key.."###"..node.id..key, node[key])
end

function Editor.color(node, key)
    _, node[key][1] = imgui.DragInt(key..".r###"..node.id..key.."r", node[key][1])
    _, node[key][2] = imgui.DragInt(key..".g###"..node.id..key.."g", node[key][2])
    _, node[key][3] = imgui.DragInt(key..".b###"..node.id..key.."b", node[key][3])
    _, node[key][4] = imgui.DragInt(key..".a###"..node.id..key.."a", node[key][4])
end

function Editor.ease(node, key)
    local easeData = {"line","CCActionEase","CCEaseRateAction","CCEaseIn","CCEaseOut","CCEaseInOut",
                      "CCEaseExponentialIn","CCEaseExponentialOut","CCEaseExponentialInOut",
                      "CCEaseSineIn","CCEaseSineOut","CCEaseSineInOut","CCEaseElastic",
                      "CCEaseElasticIn","CCEaseElasticOut","CCEaseElasticInOut","CCEaseBounce",
                      "CCEaseBounceIn","CCEaseBounceOut","CCEaseBounceInOut","CCEaseBackIn",
                      "CCEaseBackOut","CCEaseBackInOut"}
    _, node[key] = imgui.Combo(key.."###"..node.id .. key, node[key], table.concat(easeData, "\0"))
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
