function ShowOutput(opts)
  opts = opts or {}
  local output = opts.output or ""
  local filetype = opts.filetype or ""
  local compiler = opts.compiler or ""
  local width = opts.width or ""

  local pattern = "__" .. vim.fn.bufname("%") .. "_output__"
  local windowNr = vim.fn.bufwinnr(pattern)

  if #compiler > 0 then
    output = vim.fn.system(compiler .. " " .. vim.fn.bufname("%") .. " 2>&1")
  end

  if windowNr > 0 then
    vim.cmd("execute" .. windowNr .. " 'wincmd w'")
  else
    vim.cmd("execute '" .. width .. "vsplit " .. pattern .. "'")
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, {})

  vim.opt_local.buftype = "nofile"
  vim.opt_local.filetype = filetype

  if filetype == "markdown" then
    vim.wo.conceallevel = 2
    vim.treesitter.start()
  end

  vim.fn.append(0, vim.split(output, "\n"))

  vim.cmd("execute 'wincmd p'")
end

-- Define a global function to show hover info in a new buffer
function ShowHoverInNewBuffer(width)
  width = width or ""
  -- Create the parameters for the hover request
  local params = vim.lsp.util.make_position_params(0, "utf-8")

  -- Send the LSP request for hover information
  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result)
    if err then
      print("Error fetching hover information: ", err)
      return
    end
    if not result or not result.contents then
      print("No hover information available.")
      return
    end

    -- Extract the hover text from the result
    local hover_text = result.contents.value

    hover_text = vim.lsp.util.convert_input_to_markdown_lines(hover_text)
    if type(hover_text) == "table" then
      hover_text = table.concat(hover_text, "\n")
    end

    ShowOutput({ output = hover_text, filetype = "markdown", width = width })
  end)
end
