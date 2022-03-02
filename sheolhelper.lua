--[[ BSD 3-Clause License

Copyright (c) 2022, Marian Arlt
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of this software nor the name of the copyright holder nor the
   names of its contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. ]]

_addon.name = 'SheolHelper'
_addon.author = 'Deridjian'
_addon.version = 1.2
_addon.commands = {'sheolhelper', 'sheol', 'shh'}

config = require('config')
defaults = require('defaults')
images = require('images')
packets = require('packets')
resources = require('resources')
strings = require('strings')
texts = require('texts')
resistances = require('resistances')
types = require('types')
require('logger')

local settings = config.load(defaults)
local disclaimer = texts.new([[
[Important]

This addon is for your sole convenience while farming segments. Overlays will only be shown in Odyssey.
Try to always load before entering. You can drag segments and resistances around individually.
The resistance table is not a completely accurate representation of actual game data.
Segments might get lost to "lag" but will catch up if you keep killing mobs.
This means that the last (few) mob(s) you kill in a run might not count if you lag too much.
Use as orientation only!

Type '//shh understood' to remove this message permanently and '//shh h' for commands.]],
settings.disclaimer, settings
)
local res_box = texts.new('${type}\n${resistances}${crueljoke}', settings.res_box, settings)
local seg_box = texts.new('Segments: ${segments}', settings.seg_box, settings)
local last_target = ''
local segments = 0
local player_total = 0
local sheolzone
local translocators = {{1,3,5}, {1,3,6}, {1,2}}
local map = images.new(settings.map, settings)

-- when addon loaded while being in Odyssey
if windower.ffxi.get_info().zone == 298 or windower.ffxi.get_info().zone == 279 then
    if settings.seg_box.show then
        seg_box.segments = segments
        seg_box:show()
    end
end

function center_disclaimer()
    local x, y = disclaimer:extents()
    disclaimer:pos(windower.get_windower_settings().ui_x_res/2-x/2,settings.disclaimer.pos.y); disclaimer:bg_alpha(255); disclaimer:alpha(255)
end

-- first load ever
if windower.ffxi.get_info().logged_in and settings.disclaimer.show then
    disclaimer:show()
    coroutine.schedule(center_disclaimer, 0.1)
end

-- called on target change
function build_res_strings(target, target_index)
    local name = target.name
    local family = string.contains(name, 'Nostos') and string.gsub(name, '^%w+%s', '') or string.contains(name, 'Agon') and string.gsub(name, '^%w+%s', '') or name
    local res_string = ''
    local ele_string = ''
    local max_ele = table.max(resistances[family])
    local type

    -- loop over mobs, find current, and get its family key
    for k, v in pairs(types) do
        if table.find(v, family) then
            type = k
        end
    end

    -- loop over weapon types
    for i = 1, 3 do
        local weapon = resistances['Legend'][i]
        local resistance = weapon == types[type][1] and resistances[family][i] - 0.5 or resistances[family][i]
        local color = resistance > 1 and [[\cs(0, 255, 0)]] or resistance < 1 and [[\cs(255, 0, 0)]] or [[\cs(255, 255, 255)]]

        res_string = res_string..'\n'..color..string.rpad(weapon..':', ' ', 10)..string.lpad(tostring(resistance*100), ' ', 3)..[[%\cr]]
    end

    -- loop over elements
    for i = 5, 12 do
        local ele = string.slice(resistances['Legend'][i], 1, 2)
        local val = types[type][1] == 'Magic' and resistances[family][i] - 0.5 or resistances[family][i]
        local color = val == max_ele and [[\cs(0, 255, 0)]] or val < 1 and [[\cs(255, 0, 0)]] or [[\cs(255, 255, 255)]]

        if i == 9 then
            ele_string = ele_string..'\n'..color..ele..':'..string.lpad(tostring(math.round(val * 100, 0)), ' ', 3)..[[%\cr]]
        elseif i == 5 then
            ele_string = ele_string..color..ele..':'..string.lpad(tostring(math.round(val * 100, 0)), ' ', 3)..[[%\cr]]
        else
            ele_string = ele_string..' '..color..ele..':'..string.lpad(tostring(math.round(val * 100, 0)), ' ', 3)..[[%\cr]]
        end
    end

    res_box.name = name
    res_box.type = type
    res_box.resistances = res_string..'\n\n'..ele_string

    if settings.res_box.joke then
        local color = resistances[family][4] == 0.000 and [[\cs(255, 0, 0)]] or [[\cs(0, 255, 0)]]
        res_box.crueljoke = color..'\n\nCruel Joke'..[[\cr]]
    end
end

-- called on target change
function update_resistances(target_index)
    local target = windower.ffxi.get_mob_by_index(target_index)
    local is_halo = target and target.name:contains('Halo') or nil

    -- only redraw if the mob is different from last one
    if
        target_index > 0 and not
        is_halo and
        target.name ~= last_target and
        target.spawn_type == 16 and
        target.valid_target
    then
        build_res_strings(target, target_index)
        last_target = target.name
    end

    -- only show when enemy is a mob
    if target and target.spawn_type == 16 and target.valid_target and not is_halo then
        res_box:show()
    else
        res_box:hide()
    end
end

windower.register_event('incoming chunk', function(id, data, modified, injected, blocked)
    -- resting message is used for segment count besides other things like odyssey queue messages
    if sheolzone and sheolzone ~= 4 and id == 0x02A and not injected then
        local packet = packets.parse('incoming', data)
        -- message ID is subject to change with future retail updates, usually three to the right
        -- luckily the players total is also passed here
        -- this makes it possible to prevent duplicates and account for packet loss at the same time
        -- we only count segments that also show a difference in total to exclude duplicated chunks
        if packet['Message ID'] == 40001 and player_total ~= packet['Param 2'] then
            -- make an exception if the total does not match the current count, i.e. one ore more former packets got lost
            if packet['Param 2'] - packet['Param 1'] ~= player_total and player_total ~= 0 then
                segments = segments + packet['Param 2'] - player_total
            else
                segments = segments + packet['Param 1']
            end
            player_total = packet['Param 2']
            seg_box.segments = segments
        end

    -- the rabao conflux will send an NPC interaction with our character upon/before zoning that tells us the zone we'll be in (A/B/C/Gaol)
    elseif windower.ffxi.get_info().zone == 247 and id == 0x034 and not injected then
        local packet = packets.parse('incoming', data)
        if packet['Menu ID'] == 173 and packet['NPC'] == windower.ffxi.get_player().id then
            sheolzone = packet['Menu Parameters']:unpack('i', 1)
        end
    end
end)

windower.register_event('outgoing chunk', function(id, data, modified, injected, blocked)
    if
        sheolzone and
        sheolzone ~= 4 and
        (windower.ffxi.get_info().zone == 298 or windower.ffxi.get_info().zone == 279)
        and id == 0x05B and not
        injected
    then
        local packet = packets.parse('outgoing', data)
        local new_floor
        
        -- conflux menu was used
        if tostring(packet):contains('Conflux') then
            -- even numbered confluxes always teleport one floor down where that floor equals the confluxes number divided by two
            if packet['Option Index'] % 2 == 0 then
                new_floor = packet['Option Index'] / 2
            -- odd numbered confluxes always teleport one floor up
            else
                -- store lowest floor
                local f = 1
                -- loop over odd conflux values
                for i = 1, 11, 2 do
                    -- increase floor by one each step
                    f = f + 1
                    -- stop at actual conflux that was used
                    if i == packet['Option Index'] then
                        new_floor = f
                        break
                    end
                end
            end

        -- translocator menu was used
        elseif tostring(packet):contains('Translocator') then
            -- 'option index' is the translocator that was warped to, corresponding floors are known values
            new_floor = translocators[sheolzone][packet['Option Index']]
        end

        if new_floor then
            map:path(windower.addon_path..'maps/'..sheolzone..'-'..new_floor..'.png')
        end
    end
end)

windower.register_event('zone change', function(new_id, old_id)        
    -- odyssey can be instanced in either 'Walk of Echoes [P1]' or 'Walk of Echoes [P2]'
    -- we explicitely specify to zone from Rabao because 298 and 279 are also used by Selbina's HTMB
    -- also exclude Sheol Gaol from mechanics
    if (new_id == 298 or new_id == 279) and old_id == 247 and sheolzone ~= 4 then
        -- reset segments on entering Sheol
        segments = 0
        seg_box.segments = segments
        -- show segment count (default: true, user option)
        if settings.seg_box.show then
            seg_box:show()
        end
        -- set correct map path for first floor
        map:path(windower.addon_path..'maps/'..sheolzone..'-1.png')

        -- if disclaimer hasn't been shown yet (addon was autoloaded on startup e.g.)
        if settings.disclaimer.show then
            disclaimer:show()
            coroutine.schedule(center_disclaimer, 0.1)
        end

    -- leaving Walk of Echoes
    elseif old_id == 298 or old_id == 279 then
        -- keep segments from last run displayed in Rabao (default: true, user option)
        if new_id == 247 and settings.seg_box.conserve and sheolzone and sheolzone ~= 4 then
            res_box:hide()
            seg_box.segments = segments..' (last run)'
            -- inform about user option once
            if settings.seg_box.disclaimer then
                disclaimer:text('Segments from last run are by default conserved in Rabao\nYou can disable this behavior with //shh conserve [on/off]\nType //shh understood to hide this message permanently.')
                disclaimer:show()
            end
        end
        -- unset sheol zone
        if sheolzone then sheolzone = nil end

    elseif seg_box:visible() or res_box:visible() then
        seg_box:hide(); res_box:hide()
    end
end)

windower.register_event('target change', function(target_index)
    if
        (windower.ffxi.get_info().zone == 298 or windower.ffxi.get_info().zone == 279) and
        sheolzone ~= 4 and
        settings.res_box.show
    then
        update_resistances(target_index)
    end
end)

windower.register_event('addon command', function(command, ...)
    cmd = command and command:lower()
    local arg = {...}

    if cmd == 'understood' then
        disclaimer:hide()
        if settings.disclaimer.show then
            settings.disclaimer.show = false
        elseif settings.seg_box.disclaimer then
            settings.seg_box.disclaimer = false
        end
        settings:save()

    elseif cmd == 'toggle' then
        if arg[1] == 'segments' then
            if settings.seg_box.show then
                seg_box:hide()
                notice("Segments will now be hidden.")
            else
                seg_box.segments = segments
                seg_box:show()
                notice("Segments will now be shown.")
            end
            settings.seg_box.show = not settings.seg_box.show
            settings:save()
            
        elseif arg[1] == 'resistances' then
            local target = windower.ffxi.get_mob_by_target('t')
            if settings.res_box.show then
                res_box:hide()
                notice("Resistances will now be hidden.")
            elseif
                (windower.ffxi.get_info().zone == 298 or windower.ffxi.get_info().zone == 279) and
                target and target.spawn_type == 16 and
                target.valid_target
            then
                res_box:show()
            end
            if not settings.res_box.show then
                notice("Resistances will now be shown.")
            end
            settings.res_box.show = not settings.res_box.show
            settings:save()

        elseif arg[1] == 'joke' then
            if settings.res_box.joke then
                notice("Cruel Joke compatability will now be hidden.")
            else
                notice("Cruel Joke compatability will now be shown.")
            end
            settings.res_box.joke = not settings.res_box.joke
            settings:save()
            last_target = ''
        else
            error("//shh toggle accepts either 'segments' or 'resistances'.")
        end

    elseif cmd == 'bg' then
        arg[2] = tonumber(arg[2])
        if arg[1] == 'all' or arg[1] == 'segments' or arg[1] == 'resistances' then
            if not arg[2] or arg[2] < 0 or arg[2] > 255 then
                error("The value for bg transparency must be between 0 and 255.")
            else
                if arg[1] == 'all' or arg[1] == 'segments' then
                    settings.seg_box.bg.alpha = arg[2]
                    settings:save()
                    seg_box:bg_alpha(arg[2])
                end
                if arg[1] == 'all' or arg[1] == 'resistances' then
                    settings.res_box.bg.alpha = arg[2]
                    settings:save()
                    res_box:bg_alpha(arg[2])
                end
            end
        else
            error("//shh bg accepts either 'segments', 'resistances' or 'all'.")
        end

    elseif cmd == 'conserve' then
        settings.seg_box.conserve = not settings.seg_box.conserve
        settings:save()

    elseif cmd == 'map' then
        if arg[1] == 'center' then
            map:pos_x(windower.get_windower_settings().ui_x_res / 2 - settings.map.size.width / 2)
            map:pos_y(windower.get_windower_settings().ui_y_res / 2 - settings.map.size.height / 2)

        elseif arg[1] == 'size' and tonumber(arg[2]) then
            settings.map.size.width = tonumber(arg[2])
            settings.map.size.height = tonumber(arg[2])
            settings:save()
            config.reload(settings)
            if map and map:visible() then
                map:size(settings.map.size.width, settings.map.size.height)
            end

        elseif arg[1] == 'size' and not tonumber(arg[2]) then
            error("Must be an integer.")

        elseif sheolzone and sheolzone ~= 4 and (windower.ffxi.get_info().zone == 279 or windower.ffxi.get_info().zone == 298) then
        --elseif true then
            if map and map:visible() then
                map:hide()
            else
                map:show()
            end

        else
            error("Must have addon loaded before entering and be in either Sheol A, B or C to load maps.")
        end

    else
        windower.add_to_chat(200, "SheolHelper Commands:")
        windower.add_to_chat(207, "//shh toggle [segments/resistances/joke] : Shows/hides either info")
        windower.add_to_chat(207, "//shh bg [segments/resistances/all] [0-255] : Sets the alpha channel for backgrounds")
        windower.add_to_chat(207, "//shh conserve : Toggles segments being shown in Rabao after a run")
        windower.add_to_chat(207, "//shh map : Toggle the current floor's map")
        windower.add_to_chat(207, "//shh map center : Repositions the map to the center of the screen")
        windower.add_to_chat(207, "//shh map size [size] : Sets the map to the new [size].")
    end
end)
