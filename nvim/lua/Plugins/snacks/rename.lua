local M = {}
---@module "snacks"

---Setup snacks rename
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            vim.api.nvim_create_autocmd(
                "User", {
                    pattern = "OilActionsPost",
                    callback = function(event)
                        if event.data.actions.type == "move" then
                            Snacks.rename.on_rename_file(
                                event.data.actions.src_url,
                                    event.data.actions.dest_url
                            )
                        end
                    end,
                }
            )
        end
    )
    return snacks
end

return M
