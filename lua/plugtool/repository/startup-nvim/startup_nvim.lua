return {
    needs = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    after = {
        'nvim-telescope/telescope.nvim',
        'nvim-lua/plenary.nvim',
        'lukas-reineke/indent-blankline.nvim',
    },
    --XXXXXXX  X    XX    X X  XXX X XX XXXXXXX
    --X     X X  X    X   X XX   X    X X     X
    --X XXX X  X  XX XX X      X X X    X XXX X
    --X XXX X X X                       X XXX X
    --X XXX X               X     X  X  X XXX X
    --X     X X X  XXX   X       X X X  X     X
    --XXXXXXX X X X X X X X X X X X X X XXXXXXX
    --X                      X        XXXXX XXX
    --XXXXXXXXXXXXXXXXXXX  X X X X  X     X   X
    --XXXXXXXXXXXXXXXXXXXX       XX XXX XX   XX
    --XXXXXXXXXXXXXXXXXXXXX   XX  X X       XXX
    --XXXXXXXXXXXXXXXXXXXXXX    X        X XXXX
    --XXXXXXXXXXXXXXXXXXXXXXX  X           XXXX
    --XXXXXXXXXXXXXXXXXXXXXXX  X XXX     X XXXX
    --XXXXXXXXXXXXXXXXXXXXXXX  X   X XX    XXXX
    --XX   XXXXXXXXX   XXXXXX  X X      XX XXXX
    --X     XXXXXXX     XXXXX  XX  X   X   XXXX
    --XXXXX       XXXX   X    XX  X XXXX
    --XXXXX       XXXX XXX    XX    XXXX
    --XXXXX       XXXX            X XXXXX     X
    --XXXXXX     XXXXX  X   XX   X  XXXXXX   XX
    --XXXXXXX   XXXXXX       X   XX XXXXXXXXXXX
    --XX XXXXXXXXXXXXX    X     X   XXXXXXXXXXX
    --XX XXXXXXXXXXXXX    X X  X  X XXXXXXXXXXX
    --XXXXXXXXXXX     X         XXXXXXXXXX
    --XXXXXXXXXX  XX    XXX XX   XXXXXXXXXXXXXX
    --XXXXXXXXX  X X X  X         XXXXXXXXXXXXX
    --XXXXXXXX      X X X X  X    XXXXXXXXXXXXX
    --XXXXXXXX  XX X     XX     X XXX XX XXX XX
    --X XX XXX XX  X XX      XX   XXX XX XXX XX
    --X XX XXX  X   XX          X XXX XX XXX XX
    --X XX XXX X     X   X  XXXX  XXX XX XXX XX
    --X XX XXXXXXXXXX          XX XXXXXX XXX XX
    --X XXXXXXX   X  X XXXXXXX X   XXXXX XXX XX
    --X XXXXX X X X   XX     X  X   XXXXXXXXXXX
    --XXXXXX  X   X    X XXX X X  X  XXXXXXXXXX
    --XXXXX   XXXXX    X XXX X X X    XXXXXXXXX
    --XXXX   XX  X  XX X XXX X X  X
    --X  X X    X X     X X         X        X
    --XX    X  XXXXXXXXX X X    XX    XXXX X       XX   X
    config = {
        function()
            local settings = require 'startup.themes.dashboard'
            settings.header.content = {
                '██████████████    ██        ████        ██  ██    ██████  ██  ████  ██████████████',
                '██          ██  ██    ██        ██      ██  ████      ██        ██  ██          ██',
                '██  ██████  ██    ██    ████  ████  ██            ██  ██  ██        ██  ██████  ██',
                '██  ██████  ██  ██  ██                                              ██  ██████  ██',
                '██  ██████  ██                              ██          ██    ██    ██  ██████  ██',
                '██          ██  ██  ██    ██████      ██              ██  ██  ██    ██          ██',
                '██████████████  ██  ██  ██  ██  ██  ██  ██  ██  ██  ██  ██  ██  ██  ██████████████',
                '                  ██                                            ██                ',
                '██████████  ██████      ██████████████████████████████████████    ██  ██  ██  ██  ',
                '  ██          ██      ██████████████████████████████████████████              ████',
                '  ██████  ████      ██████████████████████████████████████████████      ████    ██',
                '  ██              ██████████████████████████████████████████████████        ██    ',
                '            ██  ██████████████████████████████████████████████████████    ██      ',
                '                ██████████████████████████████████████████████████████    ██  ████',
                '██          ██  ██████████████████████████████████████████████████████    ██      ',
                '██  ████        ████████████      ██████████████████      ████████████    ██  ██  ',
                '          ████  ██████████          ██████████████          ██████████    ████    ',
                '██      ██      ████████              ██████████              ████████      ██    ',
                '    ████    ██  ████████              ██████████              ████████  ██████    ',
                '    ████        ████████              ██████████              ████████            ',
                '            ██  ██████████          ██████████████          ██████████    ██      ',
                '████      ██    ████████████      ██████████████████      ████████████            ',
                '  ██      ████  ██████████████████████████  ██████████████████████████        ██  ',
                '        ██      ██████████████████████████  ██████████████████████████        ██  ',
                '██    ██    ██  ██████████████████████          ██████████████████████          ██',
                '                  ████████████████████          ████████████████████    ████      ',
                '  ██████  ████      ██████████████████████████████████████████████    ██  ██  ██  ',
                '  ██                  ██████████████████████████████████████████            ██  ██',
                '  ██  ██    ██        ██████████████████████████████████████████    ████  ██      ',
                '    ████          ██  ██████  ████  ██████  ██████  ████  ██████  ████    ██  ████',
                '            ████      ██████  ████  ██████  ██████  ████  ██████    ██      ████  ',
                '                  ██  ██████  ████  ██████  ██████  ████  ██████  ██          ██  ',
                '    ██    ████████    ██████  ████  ██████  ██████  ████  ████████████████████    ',
                '                ████  ████████████  ██████  ██████  ██████████████      ██    ██  ',
                '██████████████  ██      ██████████  ██████  ██████  ██████████  ██  ██  ██      ██',
                '██          ██    ██      ██████████████████████████████████    ██      ██        ',
                '██  ██████  ██  ██    ██    ██████████████████████████████      ██████████        ',
                '██  ██████  ██  ██  ██        ██████████████████████████      ████    ██    ████  ',
                '██  ██████  ██  ██    ██                                  ██    ██  ██        ██  ',
                '██          ██  ██                  ██                ██    ████        ██    ████',
                '██████████████  ██  ██        ████        ████████  ██              ████      ██  ',
            }
            settings.header.highlight = 'String'
            require('startup').setup(settings)
        end,
        {
            function()
                vim.api.nvim_exec(
                    [[augroup indentblanklineplugtoolaugroup
              autocmd!
              autocmd BufEnter startup :IndentBlanklineDisable
              autocmd BufLeave startup :IndentBlanklineEnable
              autocmd FileType startup :IndentBlanklineDisable
          augroup end]],
                    true
                )
            end,
            after = 'lukas-reineke/indent-blankline.nvim',
        },
    },
}
