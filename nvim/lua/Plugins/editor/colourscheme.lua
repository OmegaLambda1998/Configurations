local colourscheme = CFG.spec:add("catppuccin/nvim")
---@module "catppuccin"

colourscheme.name = "catppuccin"
colourscheme.main = "catppuccin"
colourscheme.lazy = false
colourscheme.cond = true
colourscheme.priority = 1001
colourscheme.dependencies = {
    {
        "nvim-tree/nvim-web-devicons",
        cond = true,
    },
}

---@class OLColourScheme
---@field integrations CtpIntegrations
---@field highlights table<string, CtpHighlight>
---@field opts CatppuccinOptions
---@field name string
CFG.colourscheme = {
    integrations = {},
    highlights = {},
    opts = {
        transparent_background = true,
        default_integrations = false,
        flavour = "mocha",
        term_colors = true,
    },
    name = colourscheme.name,
}

---Setup integrations between plugins and the colourscheme
---@param name string
---@param opts? CtpIntegrations | boolean
function CFG.colourscheme:set(name, opts)
    if opts == nil then
        opts = true
    elseif opts[name] then
        opts = opts[name]
    end
    CFG.colourscheme.integrations[name] = opts
end

---Setup colourscheme highlight rules
---@param name string
---@param opts CtpHighlight
function CFG.colourscheme:hl(name, opts)
    CFG.colourscheme.highlights[name] = opts
end

colourscheme.opts = CFG.colourscheme.opts
colourscheme.opts.integrations = CFG.colourscheme.integrations
colourscheme.opts.highlight_overrides = {
    all = CFG.colourscheme.highlights,
}
