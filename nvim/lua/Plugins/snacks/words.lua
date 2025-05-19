local M = {}
---@module "snacks"

---@type snacks.words.Config
local opts = {
    enabled = true,
    debounce = 200,
    notify_jump = false,
    notify_end = true,
    foldopen = true,
    jumplist = true,
    modes = {
        "n",
        "i",
        "c",
    },
    filter = function(buf)
        return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
    end,
}

---Setup snacks words
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.words = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    mode = {
                        "n",
                    },
                    {
                        "[[",
                        function()
                            if Snacks.words.is_enabled() then
                                Snacks.words.jump(-1, true)
                            end
                        end,
                        desc = "Prev Word",
                    },
                    {
                        "]]",
                        function()
                            if Snacks.words.is_enabled() then
                                Snacks.words.jump(1, true)
                            end
                        end,
                        desc = "Next Word",
                    },

                }
            )
        end
    )
    return snacks
end

return M
