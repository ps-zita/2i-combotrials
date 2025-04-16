-- libraries
local bit = require("bit")
local json = require("dkjson")

-- OS running script, for directory info
-- local OS = package.config:sub(1,1) == "\\" and "win" or "unix"

-- data pulled from directories
local movesData = {}
local trialsData = {}
local characters = {}

-- Define globals used for hit detection
local comboSegment = 1
local comboCompleted = false
local isStunned = false

-- Standard emulator setup
local curGame = { [1] = 0x200e504, [2] = 0x200e910, [3] = 0x2010167 }
local players = { curGame[1], curGame[2] }
local charOffset = {
    [1] = 0x1c0, [2] = 0x1c4, [3] = 0x1cc, [4] = 0x1da, [5] = 0x1dc,
    [6] = 0x1de, [7] = 0x25c, [8] = 0x260, [9] = 0x284, [10] = 0x288,
    [11] = 0x27c, [12] = 0x280, [13] = 0x290, [14] = 0x294, [15] = 0x298,
    [16] = 0x274, [17] = 0x278, [18] = 0x264, [19] = 0x268, [20] = 0x2d2
}

-- 
local curPlayer = 1

-- 
local selectedChar = 1
local selectedBox = 1
local menuVisible = true
local savestateLoaded = false
local BLOCK_FRAMES = 30
local startHoldFrames = 0
local START_HOLD_THRESHOLD = 30
local debugMode = false

local guiinputs = { P1 = { previousinputs = {} } }

local buttonMappings = {
    [1] = "P1 Light Punch",
    [2] = "P1 Medium Punch",
    [3] = "P1 Heavy Punch",
    [4] = "P1 Light Kick",
    [5] = "P1 Medium Kick",
    [6] = "P1 Heavy Kick",
    [7] = "P1 Start",
    [9] = "P1 Coin"
}

-- Savedata colors
COLORS = {
    background = "#00000080",
    text = "white",
    highlight = "green",
    box = "white",
    completed = "red",
    debug = "yellow"
}

SAVE = {}



-- INIT & TOOLS

-- Helper function to load and decode a JSON file.
local function loadJSONFile(path)
    local file = io.open(path, "r")
    if file then 
        local content = file:read("*a")
        file:close()
        local obj, pos, err = json.decode(content)
        if err then
            print("JSON decode error in file " .. path .. ": " .. err)
        end
        return obj
    else
        print("Error: Could not open file " .. path)
        return nil
    end
end

local function createSave()
    local temp = assert(io.open("./save.json", "w"))
    local data = {}

    
end

local function init()
    SAVE = loadJSONFile("./save.json")

    if SAVE == nil then
        createSave()
    end
end

init()



-- LOADING CHARACTER DATA --


function getMoves(char)
    local path = "./data/" .. char .. "/moves.json"
    return loadJSONFile(path)
end

function getTrial(char, index)
    local path = "./data/" .. char .. "/trial" .. index .. "/combo.json"
    return loadJSONFile(path)
end

function getTrialCount(char)
    local count = -1
    local path = [[dir ".\data\]] .. char .. [[" /b]]

    for dir in io.popen(path):lines() do 
        count = count + 1
    end

    return count
end

-- getting char directories
for dir in io.popen([[dir ".\data" /b]]):lines() do 
    table.insert(characters, dir)
end

-- Modified loadCharacterTrial now loads savestates from the "states" folder.
function loadCharacterTrial(char, index)
    print("Loading savestate...")

    -- updating character globals
    currentCharacter = char
    movesData = getMoves(char)
    trialsData = getTrial(char, index)

    -- getting savedata
    local path = "./data/" .. char .. "/trial" .. index .. "/state.fs"
    local f = io.open(path, "r")

    if f then
        f:close()
        print("Found savestate file: " .. path)
        local success, err = pcall(function()
            savestate.load(path)
            print("Savestate loaded")
            savestateLoaded = true
            inputBlockFrames = BLOCK_FRAMES
        end)
        if not success then
            print("Error: " .. err)
        end
    else
        print("Error: Savestate not found (" .. path .. ")")
    end

    -- for loading ken2.fr
    if char == "KEN" and index == 2 then
        ken2fr()
    end
end

-- for loading ken2fr
function ken2fr()
    local frFilename = "./data/KEN/trial2/ken2.fr"
    local frFile = io.open(frFilename, "r")
    if frFile then
        frFile:close()
        local success_fr, err_fr = pcall(function() 
            savestate.load(frFilename) 
        end)
        if success_fr then
            print("Loaded ken2.fr")
        else
            print("Error loading ken2.fr")
        end
    else
        print("Error: Missing ken2.fr savestate file")
    end
end



-- LOADING SAVE DATA --



-- Fixed savedata functions using string representation
local function getSaveDataLength()
    return #characters * 10
end

function pullSave()
    local filename = "combo_trial_completion.bin"
    local file = io.open(filename, "r")
    if not file then
        local init = string.rep("0", getSaveDataLength())
        local temp = assert(io.open(filename, "w"))
        temp:write(init)
        temp:close()
        return init
    end
    local data = file:read("*all")
    file:close()
    if #data < getSaveDataLength() then
        data = data .. string.rep("0", getSaveDataLength() - #data)
    end
    return data
end

function readTrialStatus(data, charIndex, trialIndex)
    local pos = ((charIndex - 1) * 10) + trialIndex
    return data:sub(pos, pos) == "1"
end

function writeTrialCompletion(currentCharacter, trialIndex)
    local charIndex = toCharIndex(currentCharacter)
    if not charIndex then return end
    local data = pullSave()
    local pos = ((charIndex - 1) * 10) + trialIndex
    local newData = data:sub(1, pos - 1) .. "1" .. data:sub(pos + 1)
    local file = assert(io.open("combo_trial_completion.bin", "w"))
    file:write(newData)
    file:close()
end

function toBinaryIndex(charIndex, trialIndex)
    return 2 ^ (((charIndex - 1) * 10) + (trialIndex - 1))
end

function toCharIndex(findchar)
    for index, char in ipairs(characters) do
        if char == findchar then
            return index
        end
    end
    return nil
end



-- GUI DRAWING --



function drawText(x, y, text, color)
    gui.text(x - 1, y, text, "black")
    gui.text(x + 1, y, text, "black")
    gui.text(x, y - 1, text, "black")
    gui.text(x, y + 1, text, "black")
    gui.text(x, y, text, color or COLORS.text)
end

function drawBox(x, y, width, height, isSelected, isCompleted)
    local outline = isSelected and COLORS.highlight or COLORS.box
    local fillColor = isCompleted and COLORS.completed or COLORS.background
    gui.box(x, y, x + width, y + height, fillColor, outline)
end

function drawTrialBoxes(x, y, charIndex)
    local boxWidth = 5
    local boxHeight = 5
    local spacing = 2
    local startX = x + 35
    local data = pullSave()
    local trialCount = getTrialCount(characters[charIndex])

    for i = 1, trialCount do
        local boxX = startX + ((boxWidth + spacing) * (i - 1))
        local isSelected = (charIndex == selectedChar) and (i == selectedBox)
        local isCompleted = readTrialStatus(data, charIndex, i)
        drawBox(boxX, y, boxWidth, boxHeight, isSelected, isCompleted)
    end
end

function drawTrialExplanation()
    local char = characters[selectedChar]
    local desc = getTrial(char, selectedBox).desc

    if desc then
        local boxWidth = 200
        local boxHeight = 45
        local boxX = 5
        local boxY = 110
        drawBox(boxX, boxY, boxWidth, boxHeight)
        drawText(boxX + 5, boxY + 10, desc)
    end
end

function drawCharacterPanel()
    local panelWidth = 120
    local panelX = emu.screenwidth() - panelWidth - 5
    local itemHeight = 10
    drawBox(panelX, 5, panelWidth, (#characters * itemHeight) + 10)
    for i, char in ipairs(characters) do
        local y = 10 + ((i - 1) * itemHeight)
        local color = (i == selectedChar) and COLORS.highlight or COLORS.text
        drawText(panelX + 5, y, char, color)
        drawTrialBoxes(panelX, y + 1, i)
    end
end

function drawHelpPanel()
    drawBox(5, 5, 200, 100)
    local helpText = {
        "STREET FIGHTER 3: SECOND IMPACT COMBO TRIALS",
        "----------------------",
        "HOLD START - Open Menu",
        "TAP START - Reset Trial",
        "UP/DOWN - Select Character",
        "LEFT/RIGHT - Select Trial",
        "MEDIUM PUNCH/KICK - Confirm Selection",
        "RED BOX - TRIAL COMPLETED",
    }
    for i, line in ipairs(helpText) do
        drawText(10, 10 + (i * 10), line)
    end
end

function drawCreditPanel()
    drawBox(5, 160, 374, 50)
    local creditText = {
        "made by zizi",
        "vesper - writing combos",
        "satalight - help with hit detection, debugging & savedata implementation",
        "somethingwithaz - help finding memory addresses",
    }
    for i, line in ipairs(creditText) do
        drawText(10, 155 + (i * 10), line)
    end
end




-- MENU INPUT --




function handleMenuInput()
    local inputs = joypad.get()
    if inputs["P1 Down"] and not guiinputs.P1.previousinputs["P1 Down"] then
        selectedChar = selectedChar % #characters + 1
        print("Selected: " .. characters[selectedChar])
    elseif inputs["P1 Up"] and not guiinputs.P1.previousinputs["P1 Up"] then
        selectedChar = selectedChar - 1
        if selectedChar < 1 then selectedChar = #characters end
        print("Selected: " .. characters[selectedChar])
    elseif inputs["P1 Right"] and not guiinputs.P1.previousinputs["P1 Right"] then
        selectedBox = selectedBox % 10 + 1
        print("Trial " .. selectedBox)
    elseif inputs["P1 Left"] and not guiinputs.P1.previousinputs["P1 Left"] then
        selectedBox = selectedBox - 1
        if selectedBox < 1 then selectedBox = 10 end
        print("Trial " .. selectedBox)
    end
    for i = 1, 9 do
        local button = buttonMappings[i]
        if inputs[button] and not guiinputs.P1.previousinputs[button] then
            if button == "P1 Coin" then
                debugMode = not debugMode
                print("Debug Mode: " .. (debugMode and "ON" or "OFF"))
            else
                local message = button .. " pressed for " .. characters[selectedChar] .. " trial " .. selectedBox
                print(message)
                print(message)
                loadCharacterTrial(characters[selectedChar], selectedBox)
                gui.transparency(100)
                break
            end
        end
    end
    for k, v in ipairs(inputs) do
        guiinputs.P1.previousinputs[k] = v
    end
end

function handleStartButton()
    local inputs = joypad.get()
    if inputs["P1 Start"] then
        startHoldFrames = startHoldFrames + 1
        if startHoldFrames >= START_HOLD_THRESHOLD and not menuVisible then
            menuVisible = true
            savestateLoaded = false
            startHoldFrames = 0
            print("Menu opened")
        end
    else
        if startHoldFrames > 0 and startHoldFrames < START_HOLD_THRESHOLD and savestateLoaded then
            loadCharacterTrial(characters[selectedChar], selectedBox)
        end
        startHoldFrames = 0
    end
end



-- COMBO LOGIC --




local function onLoad()
    -- updating globals
    menuVisible = false
    comboSegment = 1
    comboCompleted = false
    isStunned = false
    segmentDelay = 0  -- reset delay counter

    -- reset green frames
    for _, segment in ipairs(trialsData.scheme) do
        for _, move in ipairs(segment) do
            move.greenFrames = 0
            move.hitDetected = false
            if move.projectile then
                move.projTimer = nil
            end
        end
    end
end

savestate.registerload(onLoad)

function updateGreenFrames()
    local segments = trialsData.scheme
    local activeSegment = segments[comboSegment]

    if comboCompleted and not isStunned then 
        return 
    end
    
    if not activeSegment then
        return 
    end

    -- debug
    -- print(string.format("Current Segment: %d, Character: %s", comboSegment, currentCharacter or "none"))
    -- for i, m in ipairs(activeSegment) do
    --     print(string.format("Move %d: %s, Green Frames: %d, Hit Detected: %s",
    --         i, m.move, m.greenFrames, tostring(m.hitDetected)))
    -- end

    -- Read memory values once.
    local movePressed = memory.readdword(players[curPlayer] + charOffset[1])
    local hitValue = memory.readdword(players[curPlayer] + charOffset[20])
    
    for i, m in ipairs(activeSegment) do
        local moveObj = movesData[m.move]
        if moveObj.hidden then
            m.greenFrames = moveObj.greenFrames or 20
            m.hitDetected = true
        end

        if movePressed and moveObj.address and (movePressed == moveObj.address) then
            if moveObj.projectile then
                -- For projectile moves, ignore hitValue.
                if (i == 1 or (activeSegment[i-1] and activeSegment[i-1].greenFrames > 0)) and m.greenFrames == 0 then
                    m.greenFrames = moveObj.greenFrames or 20
                    m.hitDetected = true
                    if debugMode then
                        print("Projectile move detected: " .. m.move)
                    end
                end
            else
                if hitValue ~= 0 then
                    if (i == 1 or (activeSegment[i-1] and activeSegment[i-1].greenFrames > 0)) and m.greenFrames == 0 then
                        m.greenFrames = moveObj.greenFrames or 20
                        m.hitDetected = true
                        if debugMode then 
                            print("Move detected: " .. m.move)
                        end
                    end
                end
            end
            memory.writedword(players[curPlayer] + charOffset[20], 0)
        else
            m.greenFrames = m.greenFrames or 0
        end
    end

    for i = #activeSegment, 2, -1 do
        local prev = activeSegment[i-1]
        if activeSegment[i].greenFrames > 0 then
            prev.greenFrames = math.max(prev.greenFrames, activeSegment[i].greenFrames)
        end
    end

    local allMovesGreen = true
    local anyMoveTurnedWhite = false
    for i, m in ipairs(activeSegment) do
        if m.greenFrames > 0 then
            m.greenFrames = m.greenFrames - 1
            if m.greenFrames <= 0 then 
                m.hitDetected = false 
                anyMoveTurnedWhite = true
            end
        else
            allMovesGreen = false
        end
    end

    if anyMoveTurnedWhite then
        for segIndex = 1, comboSegment - 1 do
            local prevSegment = segments["segment" .. segIndex]
            if prevSegment then
                for _, m in ipairs(prevSegment) do
                    m.greenFrames = 0
                    m.hitDetected = false
                end
            end
        end
    end

    if allMovesGreen and not debugMode then
        local maxSegment = 0
        for segName, _ in ipairs(segments) do
            local segNum = tonumber(string.match(segName, "%d+"))
            if segNum and segNum > maxSegment then
                maxSegment = segNum
            end
        end
        if comboSegment == maxSegment then
            comboCompleted = true
            isStunned = false
            comboSegment = 1
            writeTrialCompletion(currentCharacter, selectedBox)
        else
            comboSegment = comboSegment + 1
            isStunned = true
            local nextSegment = segments["segment" .. comboSegment]
            if nextSegment then
                for _, m in ipairs(nextSegment) do
                    m.greenFrames = 0
                    m.hitDetected = false
                end
            end
        end
    end

    local combined = {}
    for _, seg in ipairs(segments) do
        for _, m in ipairs(seg) do
            table.insert(combined, m)
        end
    end
    local anyActive = false
    for _, m in ipairs(combined) do
        if m.hitDetected then 
            anyActive = true 
            break 
        end
    end
    if not anyActive then 
        resetGreenFrames() 
        for _, m in ipairs(combined) do
            m.greenFrames = 0
            m.hitDetected = false
        end
    end
end

function drawDynamicText()
    updateGreenFrames()
    local yPosition = 50
    local segments = trialsData.scheme
    if not segments then return end

    -- debug
    -- local personalActionAddress = memory.readdword(players[curPlayer] + charOffset[1])
    -- gui.text(10, 10, string.format("Player Action Address: %08X", personalActionAddress), "yellow")
    -- gui.text(10, 30, string.format("Current Segment: %d", comboSegment), "yellow")

    for _, seg in ipairs(segments) do
        for _, m in ipairs(seg) do
            if (not movesData or not movesData[m.move] or not movesData[m.move].hidden) then
                local xOffset = 10
                local color = (m.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
                local moveName = m.move
                if movesData and movesData[m.move] and movesData[m.move].name then 
                    moveName = movesData[m.move].name
                end
                gui.text(xOffset, yPosition, moveName, color)
                yPosition = yPosition + 10
            end
        end
    end
end

function mainLoop()
    handleStartButton()
    print(memory.readdword(players[curPlayer] + charOffset[1]))
    if menuVisible then
        handleMenuInput()
        drawHelpPanel()
        drawCharacterPanel()
        drawTrialExplanation()
        gui.transparency(1)
        drawCreditPanel()
    else
        if savestateLoaded then 
            drawDynamicText() 
        end
    end

    if currentCharacter == "SEAN" and selectedBox == 1 then
        joypad.set({ ["P2 Down"] = true }, 2)
    end
    if currentCharacter == "KEN" and selectedBox == 2 then
        joypad.set({ ["P2 Up"] = true }, 2)
    end
end

while true do
    mainLoop()
    emu.frameadvance()
end