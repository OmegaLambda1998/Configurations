local M = {}
---@module "snacks"

---@type snacks.scratch.Config
local opts = {
    enabled = true,
    name = "Scratch",
    ft = function()
        return "markdown"
    end,
    icon = nil,
    root = (vim.fn.environ().AREAS or vim.fn.stdpath("data")) ..
        "/Notes/Scratch",
    autowrite = true,
    filekey = {
        cwd = true,
        branch = true,
        count = true,
    },
    win = {
        style = "scratch",
        relative = "editor",
    },
    win_by_ft = {},
}

local function get_file()
    local Snacks = require("snacks")
    local file = opts.file
    if not file then
        local branch = ""
        if opts.filekey.branch and vim.uv.fs_stat(".git") then
            local ret = vim.fn.systemlist("git branch --show-current")[1]
            if vim.v.shell_error == 0 then
                branch = ret
            end
        end

        local filekey = {
            opts.filekey.count and tostring(vim.v.count1) or "",
            opts.icon or "",
            opts.name:gsub("|", " "),
            opts.filekey.cwd and vim.fs.normalize(assert(vim.uv.cwd())) or "",
            vim.fn.expand("%:t"),
            branch,
        }

        vim.fn.mkdir(opts.root, "p")
        local fname = Snacks.util.file_encode(
            table.concat(filekey, "|") .. "." .. "md"
        )
        file = opts.root .. "/" .. fname
    end
    file = vim.fs.normalize(file)
    return file
end

---Setup snacks scroll
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.scratch = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    {
                        "<leader>s",
                        group = "Scratch",
                        desc = "Scratch",
                        mode = {
                            "n",
                        },
                    },
                    {
                        "<leader>ss",
                        function()
                            Snacks.scratch(
                                vim.tbl_deep_extend(
                                    "force", opts, {
                                        file = get_file(),
                                    }
                                )
                            )
                        end,
                        desc = "Toggle Scratch",
                        mode = {
                            "n",
                        },
                    },
                    {
                        "<leader>sp",
                        function()
                            Snacks.scratch.select()
                        end,
                        desc = "Scratch",
                        mode = {
                            "n",
                        },
                    },
                }
            )
        end
    )
    return snacks
end

return M
