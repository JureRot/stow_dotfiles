require("todo-comments").setup {
    signs = true,
    sign_priority = 8,
    keywords = {
        TODO = { icon = " ", color = "todo", alt = { "todo", }, signs = false, },
        NOTE = { icon = " ", color = "note", alt = { "INFO", }, },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", }, },
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "bug" }, },
    },
    gui_style = {
        fg = "NONE",
        bg = "BOLD",
    },
    merge_keywords = false,
    highlight = {
        multiline = false,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
    },
    colors = {
        todo = { "#2563EB" },
        error = { "Red", "#DC2626" },
        warning = { "Yellow", "#FBBF24" },
        note = { "Green", "#10B981" },
    },
    search = {
        command = "rg",
        args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
        },
        pattern = [[\b(KEYWORDS):]],
    },
}
