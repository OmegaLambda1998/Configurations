local ft = "tex"

vim.filetype.add(
    {
        extension = {
            tex = "tex",
        },
    }
)

---
--- === Conceal ===
---

local conceal = CFG.spec:add("mathjiajia/nvim-latex-conceal")
conceal.event = {
    "BufReadPost *." .. ft,
}
conceal.setup = false

conceal.pre:insert(
    function()
        vim.g.latex_conf = {
            enabled = {
                "amssymb",
                "core",
                "delim",
                "font",
                "greek",
                "math",
                "mleftright",
                "script",
            },
            add = {},
        }
    end
)

---
--- === LSP ===
---

local server = vim.v.servername
local inverse_search_cmd = string.format(
    "\"nvim --headless --server %s --remote \"%s\" && nvim --headless --server %s --remote-send \"gg%sjk0%slh\"\"",
        server, "%%1", server, "%%2", "%%3"
)

local lsp = "texlab"
local lsp_config = {
    settings = {
        texlab = {
            --- Use tectonic
            build = {
                executable = "tectonic",
                args = {
                    "-X",
                    "compile",
                    "-Z",
                    "shell-escape-cwd=.",
                    "--keep-logs",
                    "--keep-intermediates",
                    "--synctex",
                    "%f",
                },
                forwardSearchAfter = false,
                onSave = false,
                useFileList = false,
            },
            --- Use sioyek
            forwardSearch = {
                executable = "sioyek",
                args = {
                    "--reuse-window",
                    "--inverse-search",
                    string.format("bash -c %s", inverse_search_cmd),
                    "--forward-search-file",
                    "%f",
                    "--forward-search-line",
                    "%l",
                    "%p",
                },
            },
            --- Disable, handled by formatter
            chktex = {
                onOpenAndSave = false,
                onEdit = false,
            },
            --- Diagnostics
            diagnostics = {
                ignoredPatterns = {
                    "Unused entry", --- Ignore unused bibtex entries
                    "Underfull", --- Ignore undefull hbox
                    "Overfull", --- Ignore overfull hbox
                    "multiply defined", --- Ignore multiply defined labels and bibtex entries
                },
            },
            --- Disable, handled by formatter
            bibtexFormatter = "none",
            --- Disable, handled by formatter
            latexFormatter = "none",
            --- Completion
            completion = {
                matcher = "fuzzy-ignore-case",
            },
            --- Inlay Hints
            inlayHints = {
                labelDefinitions = true,
                labelReferences = true,
                maxLength = 15,
            },
            --- Experimental settings
            experimental = {
                --- If set to true, dependencies of custom packages are resolved and included in the dependency graph.
                followPackageLinks = true,
            },
            --- Extend verbatim environments
            verbatimEnvironments = {
                "yamlcode",
                "textcode",
                "pythoncode",
            },
            --- Extend \ref-like commands
            labelReferenceCommands = {
                "footnoteref",
            },
        },
    },
}

CFG.lsp:ft(ft)
CFG.lsp.servers[lsp] = lsp_config

---
--- === Formatter ===
---

local fmt = "latexindent"
table.insert(CFG.mason.ensure_installed.mason, fmt)

CFG.fmt:ft(ft)
CFG.fmt.providers[fmt] = {
    prepend_args = {
        "-m",
        "-rv",
        "-l",
    },
}
CFG.fmt.source[ft] = {
    fmt,
}

---
--- === Linter ===
---

local linter = "chktex"

CFG.lint:ft(ft)
CFG.lint.providers[linter] = {}
CFG.lint.source[ft] = {
    linter,
}
