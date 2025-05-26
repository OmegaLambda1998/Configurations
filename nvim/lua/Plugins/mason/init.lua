local mason = CFG.spec:add("mason-org/mason.nvim")
---@module "mason"

mason.cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
    "MasonUpdate",
}

mason.build = ":MasonUpdate"

---@class OLMason
CFG.mason = {}
CFG.mason.bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
CFG.mason.ensure_installed = {
    ---@type string[]
    mason = {},
    ---@type string[]
    lsp = {},
}

---@type MasonSettings
mason.opts = {
    registries = {
        "github:mason-org/mason-registry",
        "lua:Plugins.mason.registry",
    },
    pip = {
        upgrade_pip = true,
    },
}

mason.post:insert(
    function()
        local mr = require("mason-registry")
        mr:on(
            "package:install:success", function()
                vim.defer_fn(
                    function()
                        require("lazy.core.handler.event").trigger(
                            {
                                event = "FileType",
                                buf = vim.api.nvim_get_current_buf(),
                            }
                        )
                    end, 100
                )
            end
        )

        mr.refresh(
            function()
                for _, tool in ipairs(CFG.mason.ensure_installed.mason) do
                    local package = mr.get_package(tool)
                    if not package:is_installed() then
                        package:install()
                    end
                end
            end
        )
    end
)

CFG.colourscheme:set("mason")
