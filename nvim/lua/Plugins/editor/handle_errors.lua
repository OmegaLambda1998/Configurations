local handle_errors = CFG.spec:add("aaron-p1/handle_errors.nvim")

handle_errors.lazy = false
handle_errors.build = "make"
handle_errors.setup = false

handle_errors.post:insert(
    function()
        local he = require("handle_errors")
        he.set_on_error(
            function(msg, opts)
                local notify_opts = vim.tbl_deep_extend(
                    "force", opts, {
                        level = vim.log.levels.ERROR,
                    }
                )
                CFG.log:notify(msg, notify_opts)
            end, true
        )
    end
)
