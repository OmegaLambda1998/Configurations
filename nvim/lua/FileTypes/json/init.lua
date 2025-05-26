local ft = "jsn"
local filetype = "json"
local alt_filetype = "jsonc"

---
--- === LSP ===
---

CFG.lsp:ft(ft)
CFG.lsp:ft(filetype)
CFG.lsp:ft(alt_filetype)

local lsp = "jsonls"
CFG.lsp.servers[lsp] = {}

---
--- === CMP ===
---

CFG.cmp:ft(ft)
CFG.cmp:ft(filetype)
CFG.cmp:ft(alt_filetype)
