# ReaChatGPT

## Disclaimer
The prompts are provided with the ReaTeam github repository (https://github.com/ReaTeam/ReaScripts), cfillion's imgui api documentation (https://api.codetabs.com/v1/proxy/?quest=https://github.com/cfillion/reaimgui/releases/latest/download/reaper_imgui_doc.html) as well as the official reaper api documentation (https://www.reaper.fm/sdk/reascript/reascripthelp.html) 

Since the code that ChatGPT produces is likely based on the data provided; credit is due to the creators in the links provided above.

## Notes
This is just a proof of concept to see how ChatGPT could work inside Reaper. Most of the time it doesn't work, and it will likely crash Reaper. Sometimes it does some unexpected stuff and it is rather slow. This could be because I'm using the text-davinci-003 model, which is in general slower but also produces better content. 

I'm also executing a python script to call the openai API. Some improvements can probably be done there by removing python completely and just do HTTP calls.

## How to use
If you would like to try it out you will need an OpenAI account. In the python script you need to provide your organization id as well as the secret key. 

Build a binary of the python script by executing pyinstaller reachatgpt.py --onefile you can also skip the pyinstaller step and call python directly from the lua script, but then you need to modify it a bit.

[![IMAGE_ALT](https://img.youtube.com/vi/1kS-peS3RLw/default.jpg)](https://www.youtube.com/watch?v=1kS-peS3RLw&ab_channel=FilipConic)
