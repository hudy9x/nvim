local stt, diffview = pcall(require, 'diffview')

if not stt then return end

diffview.setup({
  view = {
    merge_tool = {
      layout = "diff3_mixed"
    }
  }
})
