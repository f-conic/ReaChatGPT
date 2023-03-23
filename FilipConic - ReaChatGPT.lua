local windows_platform = string.find(reaper.GetOS(), 'Win') ~= nil
local path_seperator = windows_platform and '\\' or '/'
local history = nil

function setup_window()
    ctx = reaper.ImGui_CreateContext('ReaChatGPT', reaper.ImGui_ConfigFlags_DockingEnable())

    config = { win_size_width  = 500, win_size_height = 300, imgui_api = true, reaper_api = true , temp_text = ''}
    reaper.ImGui_SetNextWindowSize(ctx, config.win_size_width, config.win_size_height)
end
  
function exec_chat_gpt(text)
    scripts_path = reaper.GetResourcePath() .. path_seperator .. 'Scripts' .. path_seperator
    local chat_gpt_python = '\"' .. '.' .. scripts_path .. 'reachatgpt' .. '\"' .. ' ' .. '\"' .. text .. '\"'
    local file = io.popen(chat_gpt_python)
    local output = file:read("*all")

    -- Create a temp file in order to run the script.
    local file_path = scripts_path .. path_seperator .. 'reachatgpt.lua'
    local file, err = io.open(file_path, "w")

    if file then
        log_output = output
        file:write(output)
        file:close()

        -- This doesn't really work. But a bit of a safety net if the script runs into an error.
        local res, err = loadfile(file_path)
        if pcall(res) then
            res()
        else
            reaper.ShowConsoleMsg(tostring(err))
        end
    else
        reaper.ShowConsoleMsg(err)
    end
end

function loop()
  local visible, open = reaper.ImGui_Begin(ctx, 'ReaChatGPT', true)
  if visible then
    reaper.ImGui_PushItemWidth(ctx, reaper.ImGui_GetFontSize(ctx) * -0.1)
    local multiline_text_flags = reaper.ImGui_InputTextFlags_WordWrap
    retval, text = reaper.ImGui_InputTextMultiline(ctx, 'input', text, multiline_text_flags)
    retval, log_output = reaper.ImGui_InputTextMultiline(ctx, 'log', log_output, multiline_text_flags)

    submit_btn = reaper.ImGui_Button(ctx, 'Submit')
    reaper.ImGui_SameLine(ctx)
    re_submit_btn = reaper.ImGui_Button(ctx, 'Run Again')
    reaper.ImGui_SameLine(ctx)
    clear_btn = reaper.ImGui_Button(ctx, 'Clear')

    reaper.ImGui_SameLine(ctx)
    rv, config.imgui_api = reaper.ImGui_Checkbox(ctx, 'Use ImGui API', config.imgui_api)

    reaper.ImGui_SameLine(ctx)
    rv, config.reaper_api = reaper.ImGui_Checkbox(ctx, 'Use ReaTeam API', config.reaper_api)

    if clear_btn then
        text = ''
        log_output = ''
        history = ''
    end

    if submit_btn then

        text = 'Write lua code for reaper that will ' .. text

        if config.imgui_api then
            text = text .. '. you can use the imgui api for reference https://api.codetabs.com/v1/proxy/?quest=https://github.com/cfillion/reaimgui/releases/latest/download/reaper_imgui_doc.html'
        end

        if config.reaper_api then
            text = text .. '. Use the reaper api as reference https://www.reaper.fm/sdk/reascript/reascripthelp.html'
        end

        text = text .. '. You can use the source between the tags <source file=""> for reference from here https://raw.githubusercontent.com/ReaTeam/ReaScripts/master/index.xml '
        text = text .. ". You can't use the require() statement"
        text = text .. '. Show me only code.'

        exec_chat_gpt(text)
        if history == nil then
            history = string.format("Q: %s\nA: %s", text, log_output)
        else
            history = string.format("%s\nA: %s", text, log_output)
        end

        text = ''
    end

    if re_submit_btn then
        text = string.format("%s\nQ: %s", history, text)
        text = text .. ". Don't show me the prefix A: in the output of the answer."
        exec_chat_gpt(text)
    end

    reaper.ImGui_End(ctx)
  end

  if open then
    reaper.defer(loop)
  end

end

function main()
    setup_window()
end

main()
reaper.defer(loop)