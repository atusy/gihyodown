-- if sec is nil, then reference numbers increments throughout the document
section = 0
--sec = nil
labels = {fig = "図", tab = "表", eqn = "式"}

-- Initialize counts and index
count = {}
index = {}

patterns = {
    ref = "(@ref%(([%a%d-]+):([%a%d-]+)%))",
    hash = "(%(#([%a%d-]+):([%a%d-]+)%))"
}

function solve_reference(element, pattern_key, section)
    local pattern = patterns[pattern_key]
    local _ = ""
    local type = ""
    local key = ""
    local name = ""
    local label = ""

    for matched in element.text:gmatch(pattern) do
        _, type, name = matched:match(pattern)

        if (pattern_key == "hash") then
            label = labels[type]
        else
            label = ""
        end

        if index[type][name] == nil then
            count[type] = count[type] + 1
            index[type][name] = count[type]
        end
        element.text = element.text:gsub(
            matched:gsub("([()-])", "%%%1"), -- escaping
            label .. section .. "." .. index[type][name]
        )
    end
    return(element)
end

function Meta(element)
    if element.crossref.section then
        section = pandoc.utils.stringify(element.crossref.section)
    elseif element.section then
        section = pandoc.utils.stringify(element.section)
    end

    if element.crossref.labels then
        for key, val in pairs(element.crossref.labels) do
            labels[key] = pandoc.utils.stringify(val)
        end
    end

    for k, v in pairs(labels) do
        count[k] = 0
        index[k] = {}
    end

    return(element)
end

function Str(element)
    element = solve_reference(element, "hash", section) -- (#fig:foo)
    element = solve_reference(element, "ref", section)  -- \@ref(fig:foo)
    return(element)
end

return {
  { Meta = Meta },
  { Str = Str }
}
