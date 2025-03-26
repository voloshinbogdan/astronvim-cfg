function toggle_qf()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then qf_exists = true end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then vim.cmd "copen" end
end

return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_directory = function()
        local osys = require "cmake-tools.osys"
        if osys.iswin32 then return "build\\${variant:buildType}" end
        return "build/${variant:buildType}"
      end, -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
      cmake_dap_configuration = { -- debug settings for cmake
        name = "cpp",
        type = "cppdbg",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "Enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
    },
    lazy = false,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          -- Build
          ["<F4>"] = { desc = "󱌣 Build" },
          ["<F4>q"] = { "<cmd>lua toggle_qf()<cr>", desc = "Toggle Quickfix" },
          ["<F4>r"] = { "<cmd>CMakeRun<cr>", desc = "Run" },
          ["<F4>b"] = { "<cmd>CMakeBuild<cr>", desc = "Build" },
          ["<F4>B"] = { "<cmd>CMakeBuild!<cr>", desc = "Build (Clean & Build)" },
          ["<F4>g"] = { "<cmd>CMakeGenerate<cr>", desc = "Default Init" },
          ["<F4>G"] = { "<cmd>CMakeGenerate!<cr>", desc = "Init (Clean & Generate)" },
          ["<F4>t"] = { "<cmd>CMakeSelectBuildTarget<cr>", desc = "Target" },
          ["<F4>d"] = { "<cmd>CMakeDebug<cr>", desc = "Debug" },
          ["<F4>x"] = {
            function()
              require("cmake-tools").stop_executor()
              require("cmake-tools").stop_runner()
              require("dap").terminate()
            end,
            desc = "Stop",
          },
          ["<F4>X"] = {
            function()
              require("cmake-tools").stop_executor()
              require("cmake-tools").stop_runner()
              require("cmake-tools").close_executor()
              require("cmake-tools").close_runner()

              require("dap").terminate()
              require("dap").close()
              require("dapui").close()
            end,
            desc = "Stop & Close",
          },
          ["<F4>c"] = { "<cmd>CMakeClean<cr>", desc = "Clean" },

          -- Tests
          ["<F4>T"] = { "<cmd>CMakeRunTest<cr>", desc = "Run Tests" },

          -- Target Selection
          ["<F4>L"] = { "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select Launch Target" },

          -- Settings
          ["<F4>s"] = { desc = "Settings" },
          ["<F4>sg"] = { "<cmd>CMakeSettings<cr>", desc = "Global Settings" },
          ["<F4>st"] = { "<cmd>CMakeTargetSettings<cr>", desc = "Target Settings" },
          ["<F4>sb"] = { "<cmd>CMakeSelectBuildType<cr>", desc = "Select Build Type" },

          -- Install
          ["<F4>i"] = { "<cmd>CMakeInstall<cr>", desc = "Install Targets" },
        },
      },
    },
  },
}
