local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("GB.lazy")

local opts = { noremap=true, silent=true }
--
-- ----------------------------------------------------------
local function quickfix()
    vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
    })
end

vim.keymap.set('n', '<leader>qf', quickfix, {desc = "[q]uick fix"})


local make_code_action_params = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {
        diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    }
    return params
end

TEST = function ()
    local params = make_code_action_params()
    -- params.context.only = { "quickfix" }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    local p = result[1].result[1]
    print(vim.inspect(p))

    vim.lsp.util.apply_workspace_edit(p, 'utf-8')
    --local mycodeaction = result[1]

    vim.lsp.buf.execute_command(p)
    --print(vim.inspect(result))
   -- for _, res in pairs(result or {}) do
   --     print(vim.inspect(mycodeaction))
   --     vim.lsp.util.apply_workspace_edit(mycodeaction.data, 'utf-8')
   --     for _, r in pairs(res.result or {}) do
   --         print(vim.inspect(r))
   --     end
   -- end
end

execute_code_action = function(kind)
    if not kind then return end
    local params = make_code_action_params()
    params.context.only = { kind }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            print(vim.inspect(r.command))
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, 'utf-8')
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

list_code_action_kinds = function()
    local params = make_code_action_params()
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for _, res in pairs(result or {}) do
        print(vim.inspect(res))
        print('---', 'CODE ACTIONS')
        for _, r in pairs(res.result or {}) do
            -- vim.pretty_print(r) 
            print(r.kind)
        end
        print('---')
    end
end

function buildRunGB()
    local root_dir = vim.fn.getcwd()
    print("Root dir:" .. root_dir)

    local function findAndRunExecutable(folder)
        local exe_files = vim.fn.findfile('*.exe', folder, -1)
        if #exe_files > 0 then
            print("Running executable:", exe_files[1])
            vim.fn.jobstart(exe_files[1], { detach = 1 })
        else
            print("No executable found.")
        end
    end
    print("hello test here")
    -- Check for .sln file
    -- local sln_files = vim.fn.findfile('*.sln', root_dir, 1)
    local sln_files = vim.fn.glob('*.sln')
    local somepath = root_dir .. '\\' .. sln_files
    print("Solution dir:" .. somepath)
    local cwDir = vim.fn.getcwd()
    print("Dll paths : >>>> " .. vim.inspect(vim.fn.glob(cwDir .. "**.dll")))
    --  if #sln_files > 0 then
    --      print("Found .sln file:", sln_files[1])
    --      vim.fn.system('msbuild ' .. sln_files[2])

    --      -- Run the executable if it exists in ./bin/debug/
    --      local exe_path = root_dir .. '/bin/debug/'
    --      findAndRunExecutable(exe_path)

    --      -- If not found, check one level deeper
    --      if #vim.fn.findfile('*.exe', root_dir .. '/bin/', 1) == 0 then
    --          findAndRunExecutable(root_dir .. '/bin/')
    --      end

    --      return
    --  end

    -- Check for .csproj file
    local csproj_files= vim.fn.glob('**/*.csproj',false,true)

    if #csproj_files > 0 then
        print("Found .csproj file:", csproj_files[1])
        vim.fn.system('msbuild ' .. csproj_files[1])

        -- Run the executable if it exists in ./bin/debug/
        local exe_path = vim.fn.glob("**/bin/**/*.exe",false,true)[1]
        vim.fn.jobstart(exe_path, { detach = 1 })
        return
    end
    print("No .sln or .csproj file found.")
end
