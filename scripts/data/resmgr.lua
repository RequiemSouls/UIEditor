function GetTexture(filepath)
    if not filepath then
        return nil
    end
    if not ResourceRootPath then
        return
    end
    if ResourceCache[filepath] then
        return ResourceCache[filepath]
    end

    local id, w, h = imgui.CreateTexture(ResourceRootPath .. filepath)
    if id > 0 then
        ResourceCache[filepath] = {id=id, w=w, h=h}
    end
    return nil
end
