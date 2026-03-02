vim.o.statusline = "%!v:lua.ShowBuffers()"

function ShowBuffers()
    local current_buf = vim.fn.bufnr('%')
    local buffers = vim.fn.getbufinfo({ buflisted = true })
    local buffer_list = {}

    for _, buf in ipairs(buffers) do
        local buf_name = vim.fn.fnamemodify(buf.name, ":t")
        if buf_name == "" then buf_name = "[No Name]" end

        if buf.bufnr == current_buf then
            table.insert(buffer_list, "%#CurrentBuffer#<<" .. buf_name .. ">>%*")
        else
            table.insert(buffer_list, buf_name)
        end
    end

    return table.concat(buffer_list, " | ")
end

