local M = {}
---@module "snacks"

---@type snacks.bigfile.Config
local opts = {
    enabled = true,
    notify = true,
    size = 1.5 * 1024 * 1024,
    line_length = 1000,
    setup = function(ctx)
        vim.wo.foldmethod = "manual"
        vim.wo.statuscolumn = ""
        vim.wo.conceallevel = 0
        vim.b.snacks_animate = false
        vim.b.snacks_scroll = false
        if vim.fn.exists(":NoMatchParen") ~= 0 then
            vim.cmd([[NoMatchParen]])
        end
        vim.schedule(
            function()
                vim.bo[ctx.buf].syntax = ctx.ft
            end
        )
    end,
}

---Setup snacks bigfile
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.bigfile = opts
    return snacks
end

return M
