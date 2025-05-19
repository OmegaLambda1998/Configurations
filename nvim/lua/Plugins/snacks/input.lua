local M = {}
---@module "snacks"

---@type snacks.input.Config
local opts = {
    enabled = true,
    icon_hl = "SnacksInputIcon",
    expand = true,
}

---Setup snacks input
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.input = opts
    return snacks
end

return M
