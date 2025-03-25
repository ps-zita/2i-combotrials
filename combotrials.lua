local curGame = {[1] = 0x200e504, [2] = 0x200e910, [3] = 0x2010167}
local players = {curGame[1], curGame[2]}
local charOffset = {
    [1] = 0x1c0, [2] = 0x1c4, [3] = 0x1cc, [4] = 0x1da, [5] = 0x1dc,
    [6] = 0x1de, [7] = 0x25c, [8] = 0x260, [9] = 0x284, [10] = 0x288,
    [11] = 0x27c, [12] = 0x280, [13] = 0x290, [14] = 0x294, [15] = 0x298,
    [16] = 0x274, [17] = 0x278, [18] = 0x264, [19] = 0x268, [20] = 0x2d2
}

local curPlayer = 1 -- don't fully understand this one

local PlayerAction = memory.readdword(players[curPlayer] + charOffset[1])  -- playeraction = whatever the player is doing

-- ALEX MOVESET
local alexHPFlashChop = {name = "HEAVY FLASH CHOP", address = 102385716}
local alexMP = {name = "MEDIUM PUNCH", address = 102349208}
local alexLPFlashChop = {name = "LIGHT FLASH CHOP", address = 102384844}
local alexBoomerangRaid = {name = "BOOMERANG RAID", address = 102387828}
local alexIdle = {name = "IDLE", address = 102302556, hidden = true}

-- KEN MOVESET
local kenJumpForward = {name = "JUMP FORWARD", address = 103369704, hidden = true}
local kenJMK = {name = "JUMPING MEDIUM KICK", address = 103411512, hiddenMove = kenJumpForward}
local kenCMP = {name = "CLOSE MEDIUM PUNCH", address = 103403840}
local kenCRHP = {name = "CROUCHING HEAVY PUNCH", address = 103406544}
local kenEXTatsu = {name = "EX TATSU", address = 103432044}
local kenEXTatsu2 = {name = "EX TATSU", address = 103432044}
local kenEXShoryuken = {name = "EX SHORYUKEN", address = 103430076}
local kenJHP = {name = "JUMPING HEAVY PUNCH", address = 103410856, hiddenMove = kenJumpForward}
local kenCHP = {name = "CLOSE HEAVY PUNCH", address = 103413664}
local kenShoryuReppa = {name = "SHORYU REPPA", address = 103432660}

-- AKUMA MOVESET
local akumaJumpForward = {name = "JUMP FORWARD", address = 103596280, hidden = true}
local akumaDivekick = {name = "DIVEKICK", address = 103638780}
local akumaCHP = {name = "CLOSE HEAVY PUNCH", address = 103632092}
local akumaLKTatsu = {name = "LK TATSU", address = 103660928}
local akumaLKTatsu2 = {name = "LK TATSU", address = 103660928}
local akumaCLP = {name = "CLOSE LIGHT PUNCH", address = 103631116}
local akumaCMK = {name = "CLOSE MEDIUM KICK", address = 103632780}
local akumaLP = {name = "LIGHT PUNCH", address = 104000600}
local akumaKara = {name = "MP KARA", address = 104000700}
local akumaDemon = {name = "RAGING DEMON", address = 104000800}

-- Define Akuma's transition move with the same RAM address
local akumaLKTatsuTransition = {name = "LK TATSU TRANSITION", address = 103660928}

-- TRIAL COMBOS
local trialComboMoves = {
    ALEX = {
        segment1 = {
            {move = alexIdle, greenFrames = 1000, hitDetected = true},      -- Automatically activated hidden move
        },
        segment2 = {
            {move = alexHPFlashChop, greenFrames = 0, hitDetected = false},  -- Heavy Flash Chop
            {move = alexMP, greenFrames = 0, hitDetected = false},           -- Medium Punch
            {move = alexLPFlashChop, greenFrames = 0, hitDetected = false},    -- Light Flash Chop
            {move = alexBoomerangRaid, greenFrames = 0, hitDetected = false}   -- Boomerang Raid
        }
    },
    KEN = {
        segment1 = {
            {move = kenJumpForward, greenFrames = 0, hitDetected = true},   -- Hidden Move before JMK
            {move = kenJMK, greenFrames = 0, hitDetected = false},          -- Jumping Medium Kick
            {move = kenCMP, greenFrames = 0, hitDetected = false},          -- Close Medium Punch
            {move = kenCRHP, greenFrames = 0, hitDetected = false},         -- Crouching Heavy Punch
            {move = kenEXTatsu, greenFrames = 0, hitDetected = false},        -- EX Tatsu
            {move = kenEXShoryuken, greenFrames = 0, hitDetected = false}     -- EX Shoryuken
        },
        segment2 = {
            {move = kenJumpForward, greenFrames = 0, hitDetected = true},   -- Hidden Move before JHP
            {move = kenJHP, greenFrames = 0, hitDetected = false},          -- Jumping Heavy Punch
            {move = kenCMP, greenFrames = 0, hitDetected = false},          -- Close Medium Punch
            {move = kenCHP, greenFrames = 0, hitDetected = false},          -- Close Heavy Punch
            {move = kenEXTatsu2, greenFrames = 0, hitDetected = false},       -- EX Tatsu
            {move = kenShoryuReppa, greenFrames = 0, hitDetected = false}     -- Shoryu Reppa
        }
    },
    AKUMA = {
        segment1 = {
            {move = akumaJumpForward, greenFrames = 0, hitDetected = true},
            {move = akumaDivekick, greenFrames = 0, hitDetected = false},
            {move = akumaCHP, greenFrames = 0, hitDetected = false},
            {move = akumaLKTatsu, greenFrames = 0, hitDetected = false},
            {move = akumaCLP, greenFrames = 0, hitDetected = false},
            {move = akumaCMK, greenFrames = 0, hitDetected = false},
            {move = akumaLKTatsu, greenFrames = 0, hitDetected = false}  -- Last move in segment1 for Akuma
        },
        segment2 = {
            {move = akumaCLP, greenFrames = 0, hitDetected = false},
            {move = akumaDivekick, greenFrames = 0, hitDetected = false},
            {move = akumaCMK, greenFrames = 0, hitDetected = false},
            {move = akumaLKTatsu, greenFrames = 0, hitDetected = false},
            {move = akumaCLP, greenFrames = 0, hitDetected = false},
            {move = akumaCLP, greenFrames = 0, hitDetected = false},
            {move = akumaKara, greenFrames = 0, hitDetected = false},
            {move = akumaDemon, greenFrames = 0, hitDetected = false}
        }
    }
}

-- DEFINE GREENFRAMES
local greenFrameValues = {
    -- ALEX greenframes
    [alexHPFlashChop] = 45,
    [alexMP] = 60,
    [alexLPFlashChop] = 77,
    [alexBoomerangRaid] = 100,
    [alexIdle] = 1000,  -- Hidden move
    -- KEN greenframes
    [kenJumpForward] = 1000,  -- Hidden move
    [kenEXShoryuken] = 360,
    [kenCMP] = 22,
    [kenEXTatsu] = 67,
    [kenEXTatsu2] = 106,
    [kenShoryuReppa] = 1000000,
    [kenJMK] = 23,
    [kenCRHP] = 27,
    [kenJHP] = 40,
    [kenCHP] = 30,
    -- AKUMA greenframes (example values; adjust as needed)
    [akumaJumpForward] = 1000,  -- Hidden move
    [akumaDivekick] = 50,
    [akumaCHP] = 40,
    [akumaLKTatsu] = 105,
    [akumaLKTatsu2] = 105,
    [akumaLKTatsuTransition] = 105,  -- Transition move
    [akumaCLP] = 105,
    [akumaCMK] = 75,
    [akumaLP] = 30,
    [akumaKara] = 60,
    [akumaDemon] = 80
}

-- Colors for UI (with transparency)
COLORS = {
    background = "#00000080",  -- 50% transparent black
    text = "white",
    highlight = "green",
    box = "white",
    completed = "red",
    debug = "yellow"
}

-- Character list for SF3: 2nd Impact
characters = {
    "ALEX", "AKUMA", "DUDLEY", "ELENA", "HUGO", "IBUKI", "KEN", "NECRO", "ORO",
    "RYU", "SEAN", "URIEN", "YANG", "YUN"
}

-- trial descriptions for each character
trialDescriptions = {
    ALEX = {
        "Lorem ipsum dolor sit amet\nConsectetur adipiscing elit\nSed do eiusmod tempor",
        "Ut enim ad minim veniam\nQuis nostrud exercitation\nUllamco laboris nisi",
        "Duis aute irure dolor in\nReprehenderit in voluptate\nVelit esse cillum dolore",
        "Excepteur sint occaecat\nCupidatat non proident\nSunt in culpa qui officia",
        "Integer nec odio praesent\nLibero sed cursus ante\nDapibus diam sed nisi",
        "Nulla quis sem at nibh\nElementum imperdiet duis\nSagittis ipsum praesent",
        "Nam nec ante sed lacinia\nSapien non libero nullam\nOrci pede venenatis non",
        "In hac habitasse platea\nDictumst aliquam augue\nQuam sollicitudin vitae",
        "Etiam justo etiam pretium\nIaculis justo in hac\nMaecenas rhoncus aliquam",
        "Cum sociis natoque\nPenatibus et magnis dis\nParturient montes nascetur"
    },
    KEN = {
        "stun adds an extra frame of hitstun, this allows \nyou to do cl.mp > cr.hp and ex tatsu > shippu.\ntrial written by vesper"
    },
    AKUMA = {
        "Segment1: Jump Forward, Divekick, CHP, LK Tatsu, CLP, CMK, LK Tatsu\nSegment2: CLP, Divekick, CMK, LK Tatsu, LP, MP Kara, Raging Demon"
    }
}

for _, char in ipairs(characters) do
    if char ~= "ALEX" and char ~= "KEN" then
        if not trialDescriptions[char] then
            trialDescriptions[char] = trialDescriptions.ALEX
        end
    end
end

-- Variables to track menu state and inputs
selectedChar = 1
selectedBox = 1
menuVisible = true  -- Start with the menu open
savestateLoaded = false
firstFrame = true
buttonPressed = false
inputBlockFrames = 0
BLOCK_FRAMES = 30
pendingSavestate = false
startHoldFrames = 0
START_HOLD_THRESHOLD = 30
debugMessage = ""
debugTimer = 0
debugMode = false

-- Input handling setup
guiinputs = {
    P1 = {previousinputs = {}}
}

-- Define button names and their corresponding input keys
local buttonMappings = {
    [1] = "P1 Light Punch",  -- Light Punch
    [2] = "P1 Medium Punch",  -- Medium Punch
    [3] = "P1 Heavy Punch",  -- Heavy Punch
    [4] = "P1 Light Kick",   -- Light Kick
    [5] = "P1 Medium Kick",  -- Medium Kick
    [6] = "P1 Heavy Kick",   -- Heavy Kick
    [7] = "P1 Start",        -- Start Button (to trigger menu)
    [9] = "P1 Coin"          -- Coin Button (to trigger debug mode)
}

-- Helper function to draw text on the screen
function drawText(x, y, text, color)
    gui.text(x - 1, y, text, "black")
    gui.text(x + 1, y, text, "black")
    gui.text(x, y - 1, text, "black")
    gui.text(x, y + 1, text, "black")
    gui.text(x, y, text, color or COLORS.text)
end

-- Helper function to read trial completion statuses from a file
function readTrialCompletionStatus()
    local file = io.open("combo_trial_completion.txt", "r")
    if not file then return {} end

    local status = {}
    for line in file:lines() do
        local char, trial = line:match("^(%w+)(%d+) = COMPLETED$")
        if char and trial then
            if not status[char] then
                status[char] = {}
            end
            status[char][tonumber(trial)] = true
        end
    end
    file:close()
    return status
end

local trialStatus = readTrialCompletionStatus()

-- Function to draw a box on the screen
function drawBox(x, y, width, height, isSelected, isCompleted)
    local outline = isSelected and COLORS.highlight or COLORS.box
    local fillColor = isCompleted and COLORS.completed or COLORS.background
    gui.box(x, y, x + width, y + height, fillColor, outline)
end

-- Function to draw trial selection boxes
function drawTrialBoxes(x, y, charIndex)
    local boxWidth = 5
    local boxHeight = 5
    local spacing = 2
    local startX = x + 35

    local char = characters[charIndex]
    local charStatus = trialStatus[char] or {}

    for i = 1, 10 do
        local boxX = startX + ((boxWidth + spacing) * (i - 1))
        local isSelected = (charIndex == selectedChar) and (i == selectedBox)
        local isCompleted = charStatus[i] or false
        drawBox(boxX, y, boxWidth, boxHeight, isSelected, isCompleted)
    end
end

-- Function to draw the trial explanation text
function drawTrialExplanation()
    local char = characters[selectedChar]
    if trialDescriptions[char] and trialDescriptions[char][selectedBox] then
        local desc = trialDescriptions[char][selectedBox]
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
        "COIN BUTTON - Toggle Debug Mode"
    }

    for i, line in ipairs(helpText) do
        drawText(10, 10 + (i * 10), line)
    end
end

function drawCreditPanel()
    drawBox(5, 160, 200, 50)
    local creditText = {
        "made by zizi",
        "SPECIAL THANKS:",
        "satalite - help writing hit detection",
        "somethingwithaz - help finding memory addresses",
    }

    for i, line in ipairs(creditText) do
        drawText(10, 155 + (i * 10), line)
    end
end

-- Function to show debug messages
function showDebug(message)
    debugMessage = message
    debugTimer = 180
    print(message)
end

function loadCharacterTrial(char, trial)
    showDebug("Loading savestate...")
    menuVisible = false
    currentCharacter = char  -- set the current character for trials
    local filename = char:lower() .. trial .. ".fs"
    local f = io.open(filename, "r")
    if f then
        f:close()
        showDebug("Found savestate file")
        local success, err = pcall(function()
            savestate.load(filename)
            showDebug("Savestate loaded")
            savestateLoaded = true
            inputBlockFrames = BLOCK_FRAMES
        end)
        if not success then
            showDebug("Error: " .. err)
        end
    else
        showDebug("Error: Savestate not found")
    end
end

-- Function to handle menu input
function handleMenuInput()
    local inputs = joypad.get()

    if inputs["P1 Down"] and not guiinputs.P1.previousinputs["P1 Down"] then
        selectedChar = selectedChar % #characters + 1
        showDebug("Selected: " .. characters[selectedChar])
    elseif inputs["P1 Up"] and not guiinputs.P1.previousinputs["P1 Up"] then
        selectedChar = selectedChar - 1
        if selectedChar < 1 then selectedChar = #characters end
        showDebug("Selected: " .. characters[selectedChar])
    elseif inputs["P1 Right"] and not guiinputs.P1.previousinputs["P1 Right"] then
        selectedBox = selectedBox % 10 + 1
        showDebug("Trial " .. selectedBox)
    elseif inputs["P1 Left"] and not guiinputs.P1.previousinputs["P1 Left"] then
        selectedBox = selectedBox - 1
        if selectedBox < 1 then selectedBox = 10 end
        showDebug("Trial " .. selectedBox)
    end

    for i = 1, 9 do
        local button = buttonMappings[i]
        if inputs[button] and not guiinputs.P1.previousinputs[button] then
            if button == "P1 Coin" then
                debugMode = not debugMode
                showDebug("Debug Mode: " .. (debugMode and "ON" or "OFF"))
            else
                local message = button .. " pressed for " .. characters[selectedChar] .. " trial " .. selectedBox
                print(message)
                showDebug(message)
                loadCharacterTrial(characters[selectedChar], selectedBox)
                gui.transparency(100)
                break
            end
        end
    end

    for k, v in pairs(inputs) do
        guiinputs.P1.previousinputs[k] = v
    end
end

-- Function to handle start button press
function handleStartButton()
    local inputs = joypad.get()

    if inputs["P1 Start"] then
        startHoldFrames = startHoldFrames + 1
        if startHoldFrames >= START_HOLD_THRESHOLD and not menuVisible then
            menuVisible = true
            savestateLoaded = false
            startHoldFrames = 0
            showDebug("Menu opened")
        end
    else
        if startHoldFrames > 0 and startHoldFrames < START_HOLD_THRESHOLD and savestateLoaded then
            loadCharacterTrial(characters[selectedChar], selectedBox)
        end
        startHoldFrames = 0
    end
end

local function resetGreenFrames()
    for _, character in pairs(trialComboMoves) do
        for _, segment in pairs(character) do
            for _, move in ipairs(segment) do
                move.greenFrames = 0
                move.hitDetected = false
            end
        end
    end
    comboSegment = 1
    comboCompleted = false
    isStunned = false
end

function updateGreenFrames()
    if comboCompleted and not isStunned then
        return
    end

    local segments = trialComboMoves[currentCharacter]
    local allMovesGreen = true
    local activeSegment = (comboSegment == 1) and segments.segment1 or 
                         (currentCharacter == "AKUMA" and comboSegment == 3) and segments.segment3 or 
                         segments.segment2

    -- Check if all previous moves are completed before transition
    local function checkPreviousMoves(currentIndex)
        for i = 1, currentIndex - 1 do
            if not activeSegment[i].hitDetected or activeSegment[i].greenFrames <= 0 then
                return false
            end
        end
        return true
    end

    for i, move in ipairs(activeSegment) do
        if move.move.hidden then
            move.greenFrames = greenFrameValues[move.move] or 20
            move.hitDetected = true
        end

        local movePressed = memory.readdword(players[curPlayer] + charOffset[1])
        local moveAddress = move.move and move.move.address
        local hitValue = memory.readdword(players[curPlayer] + charOffset[20])
        if movePressed and moveAddress and (movePressed == moveAddress) and (hitValue ~= 0) then
            if debugMode or i == 1 or (activeSegment[i - 1] and activeSegment[i - 1].greenFrames > 0) then
                if move.greenFrames == 0 then
                    move.greenFrames = greenFrameValues[move.move] or 20
                    move.hitDetected = true
                end
            end
            memory.writedword(players[curPlayer] + charOffset[20], 0)
        else
            allMovesGreen = false
        end

        if not move.hitDetected then
            move.greenFrames = 0
        end

        -- Transition logic
        if comboSegment == 1 then
            if currentCharacter == "KEN" and move.move.name == "EX SHORYUKEN" and move.greenFrames > 0 and move.hitDetected then
                if checkPreviousMoves(i) then
                    isStunned = true
                    comboSegment = 2
                    allMovesGreen = false
                    break
                end
            elseif currentCharacter == "AKUMA" and move.move.name == "LK TATSU" and move.greenFrames > 0 and move.hitDetected then
                if checkPreviousMoves(i) then
                    isStunned = true
                    comboSegment = 2
                    allMovesGreen = false
                    break
                end
            end
        elseif comboSegment == 2 and currentCharacter == "AKUMA" then
            if move.move.name == "LK TATSU" and move.greenFrames > 0 and move.hitDetected then
                if checkPreviousMoves(i) then
                    isStunned = true
                    comboSegment = 3
                    allMovesGreen = false
                    break
                end
            end
        end
    end

    -- Keep previous moves green
    for i = #activeSegment, 2, -1 do
        local prevMove = activeSegment[i - 1]
        if activeSegment[i].greenFrames > 0 then
            prevMove.greenFrames = math.max(prevMove.greenFrames, activeSegment[i].greenFrames)
        end
    end

    -- Reset segment1 if segment2 fails
    if comboSegment == 2 then
        for _, move in ipairs(segments.segment2) do
            if move.hitDetected and move.greenFrames <= 0 then
                for _, m in ipairs(segments.segment1) do
                    m.greenFrames = 0
                    m.hitDetected = false
                end
                break
            end
        end
    end

    -- Reset segment2 if segment3 fails (Akuma only)
    if comboSegment == 3 and currentCharacter == "AKUMA" then
        for _, move in ipairs(segments.segment3) do
            if move.hitDetected and move.greenFrames <= 0 then
                for _, m in ipairs(segments.segment2) do
                    m.greenFrames = 0
                    m.hitDetected = false
                end
                break
            end
        end
    end

    -- Update green frames for active segment
    if comboSegment == 1 then
        for _, move in ipairs(segments.segment1) do
            if move.greenFrames > 0 then
                move.greenFrames = move.greenFrames - 1
            else
                move.hitDetected = false
            end
        end
    elseif comboSegment == 2 then
        for _, move in ipairs(segments.segment2) do
            if move.greenFrames > 0 then
                move.greenFrames = move.greenFrames - 1
            else
                move.hitDetected = false
            end
        end
    elseif comboSegment == 3 and currentCharacter == "AKUMA" then
        for _, move in ipairs(segments.segment3) do
            if move.greenFrames > 0 then
                move.greenFrames = move.greenFrames - 1
            else
                move.hitDetected = false
            end
        end
    end

    -- Check for combo completion
    if allMovesGreen and not debugMode then
        if currentCharacter == "AKUMA" and comboSegment == 3 then
            comboCompleted = true
            isStunned = false
            comboSegment = 1
            local file = io.open("combo_trial_completion.txt", "a")
            if file then
                file:write(currentCharacter .. selectedBox .. " = COMPLETED\n")
                file:close()
            end
        elseif currentCharacter ~= "AKUMA" and comboSegment == 2 then
            comboCompleted = true
            isStunned = false
            comboSegment = 1
            local file = io.open("combo_trial_completion.txt", "a")
            if file then
                file:write(currentCharacter .. selectedBox .. " = COMPLETED\n")
                file:close()
            end
        end
    end
end

function drawDynamicText()
    updateGreenFrames()

    local yPosition = 50
    local segments = trialComboMoves[currentCharacter]

    for _, move in ipairs(segments.segment1) do
        if not move.move.hidden then
            local xOffset = 10
            local color = (move.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
            if move.move and move.move.name then
                gui.text(xOffset, yPosition, move.move.name, color)
            else
                gui.text(40, yPosition, "Unknown Move", color)
                print("Error: move.move or move.move.name is nil")
            end
            yPosition = yPosition + 10
        end
    end

    for _, move in ipairs(segments.segment2) do
        if not move.move.hidden then
            local xOffset = 10
            local color = (move.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
            if move.move and move.move.name then
                gui.text(xOffset, yPosition, move.move.name, color)
            else
                gui.text(40, yPosition, "Unknown Move", color)
                print("Error: move.move or move.move.name is nil")
            end
            yPosition = yPosition + 10
        end
    end

    if debugMode then
        local personalActionAddress = memory.readdword(players[curPlayer] + charOffset[1])
        gui.text(10, 10, string.format("Player Action Address: %08X", personalActionAddress), "yellow")
    end
end

function onSavestateLoad()
    resetGreenFrames()
end

savestate.registerload(onSavestateLoad)

function mainLoop()
    handleStartButton()
    showDebug(memory.readdword(players[curPlayer] + charOffset[1]))
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
end

while true do
    mainLoop()
    emu.frameadvance()
end