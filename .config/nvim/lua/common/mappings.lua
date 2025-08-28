vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true })
vim.keymap.set("n", "Q", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true })

vim.opt_local.mouse = "a"

function ToggleMouse()
  local mouse_value = vim.opt_local.mouse:get()

  local is_mouse_enabled = mouse_value["a"] == true

  if is_mouse_enabled then
    vim.opt_local.mouse = ""
  else
    vim.opt_local.mouse = "a"
  end

  print("New mouse value:", vim.inspect(vim.opt_local.mouse:get()))
end

function ShowCodeOutput(compiler)
  local pattern = "__" .. vim.fn.bufname("%") .. "_output__"
  local windowNr = vim.fn.bufwinnr(pattern)

  local code = vim.fn.system(compiler .. " " .. vim.fn.bufname("%") .. " 2>&1")

  if windowNr > 0 then
    vim.cmd("execute" .. windowNr .. " 'wincmd w'")
  else
    vim.cmd("execute 'vsplit " .. pattern .. "'")
  end

  vim.cmd("normal! ggdG")
  vim.opt_local.buftype = "nofile"

  vim.fn.append(0, vim.fn.split(code, "\n"))
  vim.cmd("execute 'wincmd p'")
end

vim.keymap.set("n", "<Leader>tm", ToggleMouse, { noremap = true })
vim.keymap.set({ "n" }, "<F8>", ":w | lua ShowCodeOutput('python3')<CR>", { noremap = true })
vim.keymap.set({ "i" }, "<F8>", "<Esc>:w | lua ShowCodeOutput('python3')<CR>", { noremap = true })
