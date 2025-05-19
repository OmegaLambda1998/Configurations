local M = {}
---@module "snacks"

---@type snacks.animate.Config
local opts = {
    enabled = true,
    duration = 20,
    fps = 60,
}

---Setup snacks animate
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.animate = opts
    return snacks
end

return M
