-- vimtex
-- LaTeX
vim.pack.add({ "https://github.com/lervag/vimtex" })

vim.g.vimtex_view_method = "general"

-- Here _ marks default compiler
vim.g.vimtex_compiler_latexmk_engines = {
  ["pdf"] = "-pdf",
  ["pdfdvi"] = "-pdfdvi",
  ["pdfps"] = "-pdfps",
  ["pdflatex"] = "-pdf",
  ["luatex"] = "-lualatex",
  ["_"] = "-lualatex",
  ["xelatex"] = "-xelatex",
  ["context (pdftex)"] = "-pdf -pdflatex=texexec",
  ["context (luatex)"] = "-pdf -pdflatex=context",
  ["context (xetex)"] = "-pdf -pdflatex='texexec --xtx'",
}
