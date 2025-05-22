local oil = CFG.spec:add("stevearc/oil.nvim")
---@module "oil"

oil.lazy = false

---@type oil.SetupOpts
oil.opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    lsp_file_methods = {
        enabled = true,
        timeout_ms = 50000,
        autosave_changes = "unmodified",
    },
    constrain_cursor = "name",
    watch_for_changes = true,
    keymaps = {
        ["q"] = {
            "actions.close",
            mode = "n",
        },
    },
    view_options = {
        show_hidden = true,
    },
}

oil.post:insert(
    function()
        CFG.key:map(
            {
                "<leader>o",
                function()
                    vim.cmd(":Oil")
                end,
                mode = {
                    "n",
                },
                desc = "Open (Oil)",
            }
        )
    end
)
