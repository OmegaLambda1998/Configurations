local M = {}
---@module "rainbow-delimiters"

local url = "hiphish/rainbow-delimiters.nvim"
local rd = CFG.spec:add(url)

rd.main = "rainbow-delimiters.setup"

---@class OLRainbowDelimiter
CFG.rainbow_delimiter = {}

--- Strategy ---
---@type rainbow_delimiters.config.strategies
CFG.rainbow_delimiter.strategy = {
    [""] = "global",
}

--- Query ---
---@type rainbow_delimiters.config.queries
CFG.rainbow_delimiter.query = {
    [""] = "rainbow-delimiters",
}
--- Priority ---
---@type rainbow_delimiters.config.priorities
CFG.rainbow_delimiter.priority = {
    [""] = 110,
}

--- Opts ---
---@type rainbow_delimiters.config
rd.opts = {
    strategy = CFG.rainbow_delimiter.strategy,
    query = CFG.rainbow_delimiter.query,
    priority = CFG.rainbow_delimiter.priority,
    highlight = CFG.spec:get("snacks").opts.indent.indent.hl,
}

rd.pre:insert(
    function(opts)
        local rainbow = require("rainbow-delimiters")
        for k, v in pairs(opts.strategy) do
            if type(v) == "string" then
                opts.strategy[k] = rainbow.strategy[v]
            end
        end
        return opts
    end
)

---@param treesitter Specification
---@return Specification
function M.setup(treesitter)
    table.insert(
        treesitter.dependencies --[[@as table]] , {
            url,
        }
    )
    return treesitter
end

return M
