local M = {}
---@module "snacks"

---@type snacks.scroll.Config
local opts = {
    enabled = true,
    debug = CFG.verbose,
    animate = {
        duration = {
            step = 15,
            total = 250,
        },
        easing = "linear",
    },
    -- faster animation when repeating scroll after delay
    animate_repeat = {
        delay = 100, -- delay in ms before using the repeat animation
        duration = {
            step = 5,
            total = 50,
        },
        easing = "linear",
    },
    -- what buffers to animate
    filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~=
                   false and vim.bo[buf].buftype ~= "terminal"
    end,
}

---Setup snacks scroll
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.scroll = opts
    return snacks
end

return M
