return {
  -- vimtex
  -- LaTeX
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "general"

      -- Here _ marks default compiler
      vim.g.vimtex_compiler_latexmk_engines = {
        ["_"] = "-pdf",
        ["pdfdvi"] = "-pdfdvi",
        ["pdfps"] = "-pdfps",
        ["pdflatex"] = "-pdf",
        ["luatex"] = "-lualatex",
        ["lualatex"] = "-lualatex",
        ["xelatex"] = "-xelatex",
        ["context (pdftex)"] = "-pdf -pdflatex=texexec",
        ["context (luatex)"] = "-pdf -pdflatex=context",
        ["context (xetex)"] = "-pdf -pdflatex='texexec --xtx'",
      }
    end,
  },
}
