local esqueleto = CFG.spec:add("cvigilv/esqueleto.nvim")
---@module "esqueleto"

esqueleto.lazy = false

---@type Esqueleto.Config
esqueleto.opts = {
    autouse = true,
    directories = {
        vim.fs.joinpath(vim.fn.stdpath("config"), "templates"),
    },
    patterns = function(dir)
        return vim.fn.readdir(dir)
    end,
    wildcards = {
        expand = true,
        lookup = {
            --- File-specific
            ["filename"] = function()
                return vim.fn.expand("%:t:r")
            end,
            ["fileabspath"] = function()
                return vim.fn.expand("%:p")
            end,
            ["filerelpath"] = function()
                return vim.fn.expand("%:p:~")
            end,
            ["fileext"] = function()
                return vim.fn.expand("%:e")
            end,
            ["filetype"] = function()
                return vim.bo.filetype
            end,

            --- Datetime-specific
            ["date"] = function()
                return os.date("%Y%m%d", os.time())
            end,
            ["year"] = function()
                return os.date("%Y", os.time())
            end,
            ["month"] = function()
                return os.date("%m", os.time())
            end,
            ["day"] = function()
                return os.date("%d", os.time())
            end,
            ["time"] = function()
                return os.date("%T", os.time())
            end,

            --- System-specific
            ["user"] = os.getenv("USER") or "",
        },
    },
    advanced = {
        ignored = {},
        ignore_os_files = true,
        ignore_patterns = {},
    },
}

