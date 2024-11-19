local status, bufferline = pcall(require, 'bufferline')
if not status then return end

-- Tab pages
bufferline.setup {
	options = {
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "center",
				separator = true
			}
		},
		buffer_close_icon = "×"
	}
}
