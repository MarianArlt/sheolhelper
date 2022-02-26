local defaults = {
    disclaimer = {
        pos = {
            x = windower.get_windower_settings().ui_x_res / 4,
            y = windower.get_windower_settings().ui_y_res / 2 - 140
        },
        bg = {
            alpha = 0
        },
        text = {
            size = 11,
            alpha = 0,
            font = 'Consolas'
        },
        padding = 20,
        show = true
    },
    res_box = {
        pos = {
            x = windower.get_windower_settings().ui_x_res / 4,
            y = windower.get_windower_settings().ui_y_res / 2
        },
        bg = {
            alpha = 0
        },
        text = {
            size = 11,
            font = 'Consolas',
            stroke = {
                width = 1,
                alpha = 200
            }
        },
        padding = 10,
        flags = {
            bold = true
        },
        show = true,
        joke = true
    },
    seg_box = {
        pos = {
            x = windower.get_windower_settings().ui_x_res / 4,
            y = windower.get_windower_settings().ui_y_res / 2 - 36
        },
        bg = {
            alpha = 0
        },
        text = {
            size = 11,
            font = 'Consolas',
            stroke = {
                width = 1,
                alpha = 200
            }
        },
        padding = 10,
        flags = {
            bold = true
        },
        show = true,
        disclaimer = true,
        conserve = true
    },
    map = {
        pos = {
            x = windower.get_windower_settings().ui_x_res / 2 - 256,
            y = windower.get_windower_settings().ui_y_res / 2 - 256
        },
        size = {
            width = 512,
            height = 512
        },
        texture = {
            fit = false,
            path = ''
        }
    }
}
return defaults