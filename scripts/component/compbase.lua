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
CompBase.name = {d = "node", t = "string"}
CompBase.parent = {d = -1, t = "int"}
CompBase.anchor = {d = {0.5, 0.5}, t = "vec2"}
CompBase.position = {d = {0.0, 0.0}, t = "vec2"}
CompBase.scale = {d = {1.0, 1.0}, t = "vec2"}
CompBase.rotation = {d = 0, t = "int"}
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
