local M = {}
local inlay_hint = CFG.spec:add("felpafel/inlay-hint.nvim")
---@module "inlay-hint"

inlay_hint.branch = "nightly"
inlay_hint.event = {
    "LspAttach",
}
inlay_hint.cond = CFG.lsp.inlay_hint.enabled

---@type InlayHintPartialConfig
inlay_hint.opts = {
    virt_text_pos = "inline",
    display_callback = function(line_hints, _options, _bufnr)
        local lhint = {}
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Fetch cursor position once

        for _, hint in pairs(line_hints) do
            if hint.position.line ~= line then
                local label_parts =
                    type(hint.label) == "table" and hint.label or {
                        {
                            value = hint.label,
                        },
                    }
                local text_parts = {}

                if hint.paddingLeft then
                    text_parts[#text_parts + 1] = " "
                end

                for _, part in ipairs(
                    label_parts --[[@as lsp.InlayHintLabelPart[] ]]
                ) do
                    text_parts[#text_parts + 1] = part.value
                end

                if hint.paddingRight then
                    text_parts[#text_parts + 1] = " "
                end

                lhint[#lhint + 1] = {
                    text = table.concat(text_parts),
                    col = hint.position.character,
                }
            end
        end

        return lhint
    end,
}

inlay_hint.post:insert(
    function()
        CFG.aucmd:on(
            {
                "CursorHold",
            }, function()
                if not CFG.is_pager() then
                    local hint = require("inlay-hint")
                    hint.enable(true) --- Refresh inlay hints
                end
            end
        )
    end
)

return M
