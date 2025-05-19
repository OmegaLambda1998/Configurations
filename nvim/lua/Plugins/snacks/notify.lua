local M = {}
---@module "snacks"

---Setup snacks notify
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.log.notify_fn = function(msg, opts)
                Snacks.notify.notify(msg, opts)
            end
        end
    )
    return snacks
end

return M
