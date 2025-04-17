-- Libraries
local json = require("dkjson")  -- JSON parsing library

local movesData = {}
local trialsData = {}
CHARACTERS = {}
SAVE = {}
local comboSegment = 1
local comboCompleted = false
local isStunned = false
local curGame = { [1] = 0x200e504, [2] = 0x200e910, [3] = 0x2010167 }
local players = { curGame[1], curGame[2] } 
local charOffset = {
    [1] = 0x1c0, [2] = 0x1c4, [3] = 0x1cc, [4] = 0x1da, [5] = 0x1dc,
    [6] = 0x1de, [7] = 0x25c, [8] = 0x260, [9] = 0x284, [10] = 0x288,
    [11] = 0x27c, [12] = 0x280, [13] = 0x290, [14] = 0x294, [15] = 0x298,
    [16] = 0x274, [17] = 0x278, [18] = 0x264, [19] = 0x268, [20] = 0x2d2
}
local curPlayer = 1
local selectedChar = 1
local selectedBox = 1
local menuVisible = true
local savestateLoaded = false 
local BLOCK_FRAMES = 30   
local startHoldFrames = 0
local START_HOLD_THRESHOLD = 30  
local debugMode = false

-- Table to store previous inputs for detecting new button events
local guiinputs = { P1 = { previousinputs = {} } }

-- Mapping of joypad buttons to descriptions
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

-- Savedata color configuration for GUI elements
COLORS = {
    background = "#00000080",
    text = "white",
    highlight = "green",
    box = "white",
    completed = "red",
    debug = "yellow"
}

--------------------------------------------------
-- INIT & UTILITY FUNCTIONS
--------------------------------------------------

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

--[[
  saveTrial(character, index)
  Marks the specified trial as completed for a character.
  The SAVE table is updated and written back into save.json.
]]--
local function saveTrial(character, index)
    local file = assert(io.open("./save.json", "w"))
    SAVE[character].trialStatus[index] = true
    file:write(json.encode(SAVE, { indent = true }))
    file:close()
end

--[[
  createSave()
  Creates initial save data for each character scanned from the data directory.
]]--
local function createSave()
    local file = assert(io.open("./save.json", "w")) -- create file for save data
    SAVE = {}
    for _, char in ipairs(CHARACTERS) do
        local object = {}  -- create new save object for the character
        object.name = char
        object.trialCount = getTrialCount(char)
        object.trialStatus = {}
        for i = 1, object.trialCount do
            object.trialStatus[i] = false
        end
        SAVE[char] = object
    end
    file:write(json.encode(SAVE, { indent = true }))
    file:close()
end

--[[
  init()
  Initializes the application by reading the save file.
]]--
local function init()
    SAVE = loadJSONFile("./save.json")
    if SAVE == nil then
        -- Scan the "./data" directory for character folders without excluding any directories
        for dir in io.popen([[dir ".\data" /b]]):lines() do 
            table.insert(CHARACTERS, dir)
        end
        createSave()
        return
    end

    -- Use save file data to setup character list
    for _, char in pairs(SAVE) do
        print("Loaded character: " .. char.name)
        table.insert(CHARACTERS, char.name)
    end
end

--------------------------------------------------
-- LOADING CHARACTER DATA
--------------------------------------------------

--[[
  getMoves(char)
  Loads the moves file (JSON) for the specified character.
]]--
function getMoves(char)
    local path = "./data/" .. char .. "/moves.json"
    return loadJSONFile(path)
end

--[[
  getTrial(char, index)
  Loads the trial combo definition JSON file for the specified character trial.
]]--
function getTrial(char, index)
    local path = "./data/" .. char .. "/trial" .. index .. "/combo.json"
    return loadJSONFile(path)
end

--[[
  getTrialCount(char)
  Counts the number of trial directories for a given character using a command line directory listing.
]]--
function getTrialCount(char)
    local count = -1
    local path = [[dir ".\data\]] .. char .. [[" /b]]
    for dir in io.popen(path):lines() do 
        count = count + 1
    end
    return count
end

--[[
  loadCharacterTrial(char, index)
  Loads the savestate file for a given character's trial, updates globals for the current trial,
  and loads the corresponding moves and trial combo data.
]]--
function loadCharacterTrial(char, index)
    print("Loading savestate for character: " .. char .. ", trial: " .. index)
    currentCharacter = char
    movesData = getMoves(char)
    trialsData = getTrial(char, index)

    local path = "./data/" .. char .. "/trial" .. index .. "/state.fs"
    local f = io.open(path, "r")
    if f then
        f:close()
        print("Found savestate file: " .. path)
        local success, err = pcall(function()
            savestate.load(path)
            print("Savestate loaded successfully")
            savestateLoaded = true
            inputBlockFrames = BLOCK_FRAMES
        end)
        if not success then
            print("Error loading savestate: " .. err)
        end
    else
        print("Error: Savestate not found (" .. path .. ")")
    end
end

--------------------------------------------------
-- RESET GREEN FRAMES FUNCTION
--------------------------------------------------

--[[
  resetGreenFrames()
  Resets the combo state by restoring the global variables 
  and clearing the green frame indicators and hit detection flags for all moves.
]]--
function resetGreenFrames()
    -- Reset global combo state variables
    comboSegment = 1
    comboCompleted = false
    isStunned = false
    segmentDelay = 0  -- Reset delay counter
  
    -- Reset each move in the current trial's scheme, if it exists.
    if trialsData and trialsData.scheme then
        for _, segment in ipairs(trialsData.scheme) do
            for _, move in ipairs(segment) do
                move.greenFrames = 0      -- Clear the green frame timer
                move.hitDetected = false  -- Reset hit detection flag
                if move.projectile then
                    move.projTimer = nil  -- Clear projectile timer if applicable
                end
            end
        end
    end
end

--------------------------------------------------
-- GUI DRAWING FUNCTIONS
--------------------------------------------------

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
    local data = SAVE[CHARACTERS[charIndex]]
    local trialCount = data.trialCount
    for i = 1, trialCount do
        local boxX = startX + ((boxWidth + spacing) * (i - 1))
        local isSelected = (charIndex == selectedChar) and (i == selectedBox)
        local isCompleted = data.trialStatus[i]
        drawBox(boxX, y, boxWidth, boxHeight, isSelected, isCompleted)
    end
end

function drawTrialExplanation()
    local char = CHARACTERS[selectedChar]
    local trial = getTrial(char, selectedBox)
    if trial and trial.desc then
        local boxWidth = 200
        local boxHeight = 45
        local boxX = 5
        local boxY = 110
        drawBox(boxX, boxY, boxWidth, boxHeight)
        drawText(boxX + 5, boxY + 10, trial.desc)
    end
end

function drawCharacterPanel()
    local panelWidth = 120
    local panelX = emu.screenwidth() - panelWidth - 5
    local itemHeight = 10
    drawBox(panelX, 5, panelWidth, (#CHARACTERS * itemHeight) + 10)
    for i, char in ipairs(CHARACTERS) do
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
        "RED BOX - TRIAL COMPLETED"
    }
    for i, line in ipairs(helpText) do
        drawText(10, 10 + (i * 10), line)
    end
end

--[[
  drawCreditPanel()
  Displays credits for the combo trial project.
]]--
function drawCreditPanel()
    drawBox(5, 160, 374, 50)
    local creditText = {
        "made by zizi",
        "vesper - writing combos",
        "satalight - help with hit detection, debugging & savedata implementation",
        "somethingwithaz - help finding memory addresses"
    }
    for i, line in ipairs(creditText) do
        drawText(10, 155 + (i * 10), line)
    end
end

--------------------------------------------------
-- MENU INPUT HANDLING
--------------------------------------------------

--[[
  handleMenuInput()
  Checks for player input to navigate the menu.
  Updates selected character and trial, and loads a trial when an action button is pressed.
]]--
function handleMenuInput()
    local inputs = joypad.get()
    local trialCount = SAVE[CHARACTERS[selectedChar]].trialCount
    if inputs["P1 Down"] and not guiinputs.P1.previousinputs["P1 Down"] then
        selectedChar = selectedChar % #CHARACTERS + 1
        trialCount = SAVE[CHARACTERS[selectedChar]].trialCount
        selectedBox = math.min(selectedBox, trialCount)
        print("Selected character: " .. CHARACTERS[selectedChar])
    elseif inputs["P1 Up"] and not guiinputs.P1.previousinputs["P1 Up"] then
        selectedChar = (selectedChar - 1) ~= 0 and selectedChar - 1 or #CHARACTERS
        trialCount = SAVE[CHARACTERS[selectedChar]].trialCount
        selectedBox = math.min(selectedBox, trialCount)
        print("Selected character: " .. CHARACTERS[selectedChar])
    elseif inputs["P1 Right"] and not guiinputs.P1.previousinputs["P1 Right"] then
        selectedBox = selectedBox % trialCount + 1
        print("Selected trial: " .. selectedBox)
    elseif inputs["P1 Left"] and not guiinputs.P1.previousinputs["P1 Left"] then
        selectedBox = (selectedBox > 1) and selectedBox - 1 or trialCount
        print("Selected trial: " .. selectedBox)
    end
    for i = 1, 9 do
        local button = buttonMappings[i]
        if inputs[button] and not guiinputs.P1.previousinputs[button] then
            if button == "P1 Coin" then
                debugMode = not debugMode
                print("Debug Mode: " .. (debugMode and "ON" or "OFF"))
            else
                local message = button .. " pressed for " .. CHARACTERS[selectedChar] .. " trial " .. selectedBox
                print(message)
                loadCharacterTrial(CHARACTERS[selectedChar], selectedBox)
                gui.transparency(100)
                break
            end
        end
    end
    for k, v in pairs(inputs) do
        guiinputs.P1.previousinputs[k] = v
    end
end

--[[
  handleStartButton()
  Checks for use of the start button. If held long enough, toggles the menu;
  if tapped, reloads the current trial.
]]--
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
            loadCharacterTrial(CHARACTERS[selectedChar], selectedBox)
        end
        startHoldFrames = 0
    end
end

--------------------------------------------------
-- COMBO LOGIC & DYNAMIC TEXT UPDATES
--------------------------------------------------

--[[
  onLoad()
  Callback invoked when a savestate is loaded.
  Resets menu visibility and the combo state.
]]--
local function onLoad()
    menuVisible = false
    comboSegment = 1
    comboCompleted = false
    isStunned = false
    segmentDelay = 0  -- Reset delay counter
  
    if trialsData and trialsData.scheme then
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
end

-- Register onLoad callback with savestate
savestate.registerload(onLoad)

--[[
  updateGreenFrames()
  Core function to update the green frames for each move in the active combo segment.
  It checks for triggered moves, applies hit detection, and handles resetting segments.
]]--
function updateGreenFrames()
    local segments = trialsData and trialsData.scheme
    local activeSegment = segments and segments[comboSegment]
    if comboCompleted and not isStunned then 
        return 
    end
    if not activeSegment then
        return 
    end

    local movePressed = memory.readdword(players[curPlayer] + charOffset[1])
    local hitValue = memory.readdword(players[curPlayer] + charOffset[20])
    
    -- Process each move in the active segment and update its status.
    for i, m in ipairs(activeSegment) do
        local moveObj = movesData[m.move]
        if moveObj and moveObj.hidden then
            m.greenFrames = moveObj.greenFrames or 20
            m.hitDetected = true
        end

        if movePressed and moveObj and moveObj.address and (movePressed == moveObj.address) then
            if moveObj.projectile then
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

    -- Propagate green frames backwards through the active segment.
    for i = #activeSegment, 2, -1 do
        local prev = activeSegment[i-1]
        if activeSegment[i].greenFrames > 0 then
            prev.greenFrames = math.max(prev.greenFrames, activeSegment[i].greenFrames)
        end
    end

    local allMovesGreen = true
    local anyMoveTurnedWhite = false
    -- Decrement each move's green frame timer and note if any move turns white.
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

    -- Reset all moves in previous segments if any move turned white.
    if anyMoveTurnedWhite then
        for segIndex = 1, comboSegment - 1 do
            local prevSegment = segments[segIndex]
            if prevSegment then
                for _, m in ipairs(prevSegment) do
                    m.greenFrames = 0
                    m.hitDetected = false
                end
            end
        end
    end

    -- Determine the maximum segment number using the length of the segments array.
    local maxSegment = #segments
    if allMovesGreen and not debugMode then
        if comboSegment == maxSegment then
            comboCompleted = true
            isStunned = false
            comboSegment = 1
            saveTrial(currentCharacter, selectedBox)
        else
            comboSegment = comboSegment + 1
            isStunned = true
            local nextSegment = segments[comboSegment]
            if nextSegment then
                for _, m in ipairs(nextSegment) do
                    m.greenFrames = 0
                    m.hitDetected = false
                end
            end
        end
    end

    -- Combine all moves from all segments.
    local combined = {}
    for _, seg in ipairs(segments) do
        for _, m in ipairs(seg) do
            table.insert(combined, m)
        end
    end

    -- If no move remains active, reset everything.
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

--[[
  drawDynamicText()
  Displays dynamic text for each move in the current trial.
  Text color reflects the move's state: green if active, white otherwise.
]]--
function drawDynamicText()
    updateGreenFrames()
    local yPosition = 50
    local segments = trialsData and trialsData.scheme
    if not segments then return end
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

--------------------------------------------------
-- MAIN LOOP
--------------------------------------------------

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

    -- force p2 inputs for specific trials.
    if currentCharacter == "SEAN" and selectedBox == 1 then
        joypad.set({ ["P2 Down"] = true }, 2)
    end
    if currentCharacter == "KEN" and selectedBox == 2 then
        joypad.set({ ["P2 Up"] = true }, 2)
    end
end

init()
while true do
    mainLoop()
    emu.frameadvance()
end