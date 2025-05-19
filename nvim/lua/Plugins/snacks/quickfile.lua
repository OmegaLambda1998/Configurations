local M = {}
---@module "snacks"

---@type snacks.quickfile.Config
local opts = {
    enabled = true,
    exclude = {},
}

---Setup snacks quickfile
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.quickfile = opts
    return snacks
end

return M
