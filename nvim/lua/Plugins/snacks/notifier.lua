local M = {}
---@module "snacks"

---@type snacks.notifier.Config
local opts = {
    enabled = true,
    timeout = 3000,
    width = {
        min = 40,
        max = 0.4,
    },
    height = {
        min = 1,
        max = 0.6,
    },
    margin = {
        top = 0,
        right = 1,
        bottom = 0,
    },
    padding = true,
    sort = {
        "level",
        "added",
    },
    level = CFG.log.level,
    icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
    },
    keep = function(_notif)
        return vim.fn.getcmdpos() > 0
    end,
    ---@type snacks.notifier.style
    style = "fancy",
    top_down = true,
    date_format = "%R",
    more_format = " ↓ %d lines ",
    refresh = 50,
}

---Setup snacks notifier
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.notifier = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<leader>n",
                    mode = {
                        "n",
                    },
                    group = "Notififications",
                    desc = "Notifications",
                    {
                        "<leader>nn",
                        function()
                            Snacks.notifier.show_history(
                                {
                                    reverse = false,
                                }
                            )
                        end,
                        desc = "Show",
                    },
                    {
                        "<leader>nc",
                        function()
                            Snacks.notifier.hide()
                        end,
                        desc = "Clear",
                    },

                }
            )
        end
    )
    return snacks
end

return M
