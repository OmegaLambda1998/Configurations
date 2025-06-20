local persisted = CFG.spec:add("olimorris/persisted.nvim")
---TODO: Config Types

persisted.lazy = false

--- Filetypes that should not be saved or loaded in sessions
local ignored_ft = {
    "oil",
}

--- Directories which should not be saved or loaded as sessions
persisted.opts.ignored_dirs = {
    {
        "~",
        exact = true,
    },
}

--- Inlcude git branch in session name
persisted.opts.use_git_branch = true

--- Saving Options
persisted.opts.autostart = true
persisted.opts.should_save = function()
    return not vim.tbl_contains(ignored_ft, vim.bo.filetype)
end

--- Loading Options
persisted.opts.autoload = true
persisted.opts.on_autoload_no_session = function()
    vim.cmd(":Oil")
end

CFG.set:o(
    "sessionoptions", "buffers,curdir,folds,globals,tabpages,winpos,winsize"
)

--- Remove unwanted filetypes from sessions
CFG.aucmd:on(
    "User", function()
        --- Save buffer order and pins
        vim.api.nvim_exec_autocmds(
            "User", {
                pattern = "SessionSavePre",
            }
        )
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.tbl_contains(ignored_ft, vim.bo[buf].filetype) then
                vim.api.nvim_buf_delete(
                    buf, {
                        force = true,
                    }
                )
            end
        end
    end, {
        pattern = "PersistedSavePre",
        group = vim.api.nvim_create_augroup("PersistedHooks", {}),
    }
)

CFG.aucmd:on(
    "User", function()
        vim.defer_fn(
            function()
                vim.cmd("bufdo e")
            end, 10
        )
    end, {
        pattern = "PersistedLoadPost",
        group = vim.api.nvim_create_augroup("PersistedHooks", {}),
    }
)
