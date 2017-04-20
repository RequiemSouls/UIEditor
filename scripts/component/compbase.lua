local function compClone(comp)
    local r = {}
    for k,v in pairs(comp) do
        r[k] = v
    end
    return r
end

-- d default              default value
-- t type                 [float:int:vec2:string:texture]
-- e exclude              when export ui file exclude this key
-- rv revisable
CompBase = {}
CompBase.type = {d = "CompBase", rv = false, t = "string"}
CompBase.id = {d = 0, rv = false, t = "int"}
CompBase.parent = {d = -1, rv = false, t = "int"}
CompBase.name = {d = "node", t = "string"}
CompBase.anchor = {d = {0.5, 0.5}, t = "vec2"}
CompBase.position = {d = {0.0, 0.0}, t = "vec2"}
CompBase.zorder = {d = 0, t = "int"}
CompBase.scale = {d = {1.0, 1.0}, t = "vec2"}
CompBase.rotation = {d = 0, t = "int"}
CompBase.inAction = {d = {}, t = "action"}
CompBase.outAction = {d = {}, t = "action"}
CompBase.display = {d = "icon_red_mark.png", t = "texture"}

Image = compClone(CompBase)
Image.type = {d = "Image", rv = false, t = "string"}
Image.name = {d = "image", t = "string"}
Image.display = {d = "", t = "texture"}

Button = compClone(CompBase)
Button.type = {d = "Button", rv = false, t = "string"}
Button.name = {d = "button", t = "string"}
Button.display = {d = "", t = "texture"}
Button.second = {d = "", t = "texture"}

Base_action = {}
Base_action.id = {d = 0, rv = false, t = "int"}
Base_action.parent = {d = -1, rv = false, t = "int"}
Base_action.time = {d = 1, t = "float"}
Base_action.ease = {d = 0, t = "ease"}

Delay_action = compClone(Base_action)
Delay_action.type = {d = "Delay_action", rv = false, t = "string"}

Move_action = compClone(Base_action)
Move_action.type = {d = "Move_action", rv = false, t = "string"}
Move_action.position = {d = {0, 0}, t = "vec2"}

Scale_action = compClone(Base_action)
Scale_action.type = {d = "Scale_action", rv = false, t = "string"}
Scale_action.scale = {d = {1, 1}, t = "vec2"}

Rotate_action = compClone(Base_action)
Rotate_action.type = {d = "Rotate_action", rv = false, t = "string"}
Rotate_action.rotate = {d = 0, t = "int"}

FadeIn_action = compClone(Base_action)
FadeIn_action.type = {d = "FadeIn_action", rv = false, t = "string"}

FadeOut_action = compClone(Base_action)
FadeOut_action.type = {d = "FadeOut_action", rv = false, t = "string"}
