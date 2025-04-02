local curGame = {[1] = 0x200e504, [2] = 0x200e910, [3] = 0x2010167}
local players = {curGame[1], curGame[2]}
local charOffset = {
    [1] = 0x1c0, [2] = 0x1c4, [3] = 0x1cc, [4] = 0x1da, [5] = 0x1dc,
    [6] = 0x1de, [7] = 0x25c, [8] = 0x260, [9] = 0x284, [10] = 0x288,
    [11] = 0x27c, [12] = 0x280, [13] = 0x290, [14] = 0x294, [15] = 0x298,
    [16] = 0x274, [17] = 0x278, [18] = 0x264, [19] = 0x268, [20] = 0x2d2
}
local curPlayer = 1
local PlayerAction = memory.readdword(players[curPlayer] + charOffset[1])

-- ALEX moves (unchanged)
local alexHPFlashChop = {name = "HEAVY FLASH CHOP", address = 102385716}
local alexMP = {name = "MEDIUM PUNCH", address = 102349208}
local alexLPFlashChop = {name = "LIGHT FLASH CHOP", address = 102384844}
local alexBoomerangRaid = {name = "BOOMERANG RAID", address = 102387828}
local alexIdle = {name = "IDLE", address = 102302556, hidden = true}

-- KEN moves (unchanged)
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

-- AKUMA moves (modified to support new trial)
local akumaJumpForward = {name = "JUMP FORWARD", address = 103596280, hidden = true}
local akumaDivekick = {name = "DIVEKICK", address = 103638780}
local akumaCHP = {name = "CLOSE HEAVY PUNCH", address = 103632092}
local akumaLKTatsu = {name = "LK TATSU", address = 103660928}  -- used for light tatsu in trial2 (updated combo)
local akumaCLP = {name = "CLOSE LIGHT PUNCH", address = 103631116}
local akumaCMK = {name = "CLOSE MEDIUM KICK", address = 103632780}
local akumaLP = {name = "LIGHT PUNCH", address = 104000600}
local akumaCRHP = {name = "CROUCHING HEAVY PUNCH", address = 103633932}
local akumaKara = {name = "MP KARA", address = 103631804}
local akumaDemon = {name = "RAGING DEMON", address = 103621536}
-- New moves for the updated Akuma trial (now trial 1):
local akumaHTatsu = {name = "HK TATSU", address = 103661824}         -- heavy tatsu
local akumaJHP = {name = "JUMPING HEAVY PUNCH", address = 103637820, hiddenMove = akumaJumpForward}

-- Reorganized trialComboMoves with multi-trial support.
-- For ALEX and KEN we wrap the single trial in trial number 1.
local trialComboMoves = {
    ALEX = {
        [1] = {
            segment1 = {
                {move = alexIdle, greenFrames = 1000, hitDetected = true},
            },
            segment2 = {
                {move = alexHPFlashChop, greenFrames = 0, hitDetected = false},
                {move = alexMP, greenFrames = 0, hitDetected = false},
                {move = alexLPFlashChop, greenFrames = 0, hitDetected = false},
                {move = alexBoomerangRaid, greenFrames = 0, hitDetected = false},
            }
        }
    },
    KEN = {
        [1] = {
            segment1 = {
                {move = kenJumpForward, greenFrames = 0, hitDetected = true},
                {move = kenJMK, greenFrames = 0, hitDetected = false},
                {move = kenCMP, greenFrames = 0, hitDetected = false},
                {move = kenCRHP, greenFrames = 0, hitDetected = false},
                {move = kenEXTatsu, greenFrames = 0, hitDetected = false},
                {move = kenEXShoryuken, greenFrames = 0, hitDetected = false},
            },
            segment2 = {
                {move = kenJumpForward, greenFrames = 0, hitDetected = false},
                {move = kenJHP, greenFrames = 0, hitDetected = false},
                {move = kenCMP, greenFrames = 0, hitDetected = false},
                {move = kenCHP, greenFrames = 0, hitDetected = false},
                {move = kenEXTatsu2, greenFrames = 0, hitDetected = false},
                {move = kenShoryuReppa, greenFrames = 0, hitDetected = false},
            }
        }
    },
    AKUMA = {
        -- Trial 1: Updated combo (formerly trial 2), now at index [1]
        [1] = {
            -- Here we add segmentGreenFrames on segment1 to affect all moves.
            segment1 = {
                segmentGreenFrames = 50,  -- custom overall greenFrames for the entire segment
                {move = akumaJumpForward, greenFrames = 0, hitDetected = false},
                {move = akumaDivekick, greenFrames = 0, hitDetected = false},
                {move = akumaCHP, greenFrames = 0, hitDetected = false},
                {move = akumaLKTatsu, greenFrames = 0, hitDetected = false},  -- light tatsu
                {move = akumaHTatsu, greenFrames = 0, hitDetected = false},   -- heavy tatsu
                {move = akumaJHP, greenFrames = 0, hitDetected = false},      -- jumping heavy punch
            },
            segment2 = {
                {move = akumaKara, greenFrames = 0, hitDetected = false},
                {move = akumaDemon, greenFrames = 0, hitDetected = false},
                {move = akumaCHP, greenFrames = 0, hitDetected = false},      -- heavy punch as final move
            }
        },
        -- Trial 2: Original Akuma trial (formerly trial 1), now at index [2]
        [2] = {
            segment1 = {
                {move = akumaJumpForward, greenFrames = 0, hitDetected = true},
                {move = akumaDivekick, greenFrames = 0, hitDetected = false},
                {move = akumaCHP, greenFrames = 0, hitDetected = false},
                {move = akumaLKTatsu, greenFrames = 0, hitDetected = false},
            },
            segment2 = {
                {move = akumaJumpForward, greenFrames = 0, hitDetected = true},
                {move = akumaCLP, greenFrames = 0, hitDetected = false},
                {move = akumaCRHP, greenFrames = 0, hitDetected = false},
                {move = akumaLKTatsu, greenFrames = 0, hitDetected = false},
            },
            segment3 = {
                {move = akumaCLP, greenFrames = 0, hitDetected = false},
                {move = akumaDivekick, greenFrames = 0, hitDetected = false},
                {move = akumaCMK, greenFrames = 0, hitDetected = false},
                {move = akumaLKTatsu, greenFrames = 0, hitDetected = false},
            },
            segment4 = {
                {move = akumaCLP, greenFrames = 0, hitDetected = false},
                {move = akumaKara, greenFrames = 0, hitDetected = false},
                {move = akumaDemon, greenFrames = 0, hitDetected = false},
            },
            segment5 = {}
        }
    }
}

local greenFrameValues = {
    -- ALEX
    [alexHPFlashChop] = 45,
    [alexMP] = 60,
    [alexLPFlashChop] = 77,
    [alexBoomerangRaid] = 100,
    [alexIdle] = 1000,
    -- KEN
    [kenJumpForward] = 1000,
    [kenEXShoryuken] = 360,
    [kenCMP] = 22,
    [kenEXTatsu] = 67,
    [kenEXTatsu2] = 106,
    [kenShoryuReppa] = 1000000,
    [kenJMK] = 23,
    [kenCRHP] = 27,
    [kenJHP] = 40,
    [kenCHP] = 30,
    -- AKUMA
    [akumaJumpForward] = 1000,
    [akumaDivekick] = 25,
    [akumaCHP] = 35,
    [akumaLKTatsu] = 105,
    [akumaCLP] = 40,
    [akumaCMK] = 23,
    [akumaCRHP] = 35,
    [akumaLP] = 30,
    [akumaKara] = 60,
    [akumaDemon] = 80,
    [akumaHTatsu] = 110,   -- heavy tatsu
    [akumaJHP] = 40       -- jumping heavy punch
}

COLORS = {
    background = "#00000080",
    text = "white",
    highlight = "green",
    box = "white",
    completed = "red",
    debug = "yellow"
}

characters = {
    "ALEX", "AKUMA", "DUDLEY", "ELENA", "HUGO", "IBUKI", "KEN", "NECRO", "ORO",
    "RYU", "SEAN", "URIEN", "YANG", "YUN"
}

-- Updated trialDescriptions with multiple trials for AKUMA.
local trialDescriptions = {
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
        [1] = "Trial 1: Segment 1 (Updated Combo with custom segment greenFrames)\nSegment 2: MP Kara, Demon, Heavy Punch",
        [2] = "Trial 2: Original Akuma Combo\nJump Forward, Divekick, CHP, LK Tatsu\nJump Forward, CLP, CRHP, LK Tatsu\nCLP, Divekick, CMK, LK Tatsu\nCLP, Kara, Demon"
    }
}
for _, char in ipairs(characters) do
    if char ~= "ALEX" and char ~= "KEN" then
        if not trialDescriptions[char] then
            trialDescriptions[char] = trialDescriptions.ALEX
        end
    end
end

selectedChar = 1
selectedBox = 1
menuVisible = true
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

guiinputs = { P1 = {previousinputs = {}} }

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

function drawText(x, y, text, color)
    gui.text(x - 1, y, text, "black")
    gui.text(x + 1, y, text, "black")
    gui.text(x, y - 1, text, "black")
    gui.text(x, y + 1, text, "black")
    gui.text(x, y, text, color or COLORS.text)
end

function readTrialCompletionStatus()
    local file = io.open("combo_trial_completion.txt", "r")
    if not file then return {} end
    local status = {}
    for line in file:lines() do
        local char, trial = line:match("^(%w+)(%d+) = COMPLETED$")
        if char and trial then
            if not status[char] then status[char] = {} end
            status[char][tonumber(trial)] = true
        end
    end
    file:close()
    return status
end

local trialStatus = readTrialCompletionStatus()

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
    local char = characters[charIndex]
    local charStatus = trialStatus[char] or {}
    for i = 1, 10 do
        local boxX = startX + ((boxWidth + spacing) * (i - 1))
        local isSelected = (charIndex == selectedChar) and (i == selectedBox)
        local isCompleted = charStatus[i] or false
        drawBox(boxX, y, boxWidth, boxHeight, isSelected, isCompleted)
    end
end

function drawTrialExplanation()
    local char = characters[selectedChar]
    local desc = nil
    if trialDescriptions[char] then
        if type(trialDescriptions[char][1]) == "string" then
            if char == "AKUMA" then
                desc = trialDescriptions[char][selectedBox] or trialDescriptions[char][1]
            else
                desc = trialDescriptions[char][selectedBox] or trialDescriptions[char][1]
            end
        end
    end
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

function showDebug(message)
    debugMessage = message
    debugTimer = 180
    print(message)
end

function loadCharacterTrial(char, trial)
    showDebug("Loading savestate...")
    menuVisible = false
    currentCharacter = char
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
        for _, trial in pairs(character) do
            for _, segment in pairs(trial) do
                for _, move in ipairs(segment) do
                    move.greenFrames = 0
                    move.hitDetected = false
                end
            end
        end
    end
    comboSegment = 1
    comboCompleted = false
    isStunned = false
end

function updateGreenFrames()
    if comboCompleted and not isStunned then return end
    local segments = trialComboMoves[currentCharacter] and trialComboMoves[currentCharacter][selectedBox]
    if not segments then return end

    local activeSegment = nil
    if currentCharacter == "AKUMA" then
        if segments.segment1 and comboSegment == 1 then
            activeSegment = segments.segment1
        elseif segments.segment2 and comboSegment == 2 then
            activeSegment = segments.segment2
        elseif segments.segment3 and comboSegment == 3 then
            activeSegment = segments.segment3
        elseif segments.segment4 and comboSegment == 4 then
            activeSegment = segments.segment4
        elseif segments.segment5 and comboSegment == 5 then
            activeSegment = segments.segment5
        end
    else
        if comboSegment == 1 then
            activeSegment = segments.segment1
        elseif comboSegment == 2 then
            activeSegment = segments.segment2
        end
    end

    if not activeSegment then return end

    -- If the segment has its own overall greenFrames value, apply it to all moves that haven't been triggered yet.
    if activeSegment.segmentGreenFrames then
        for _, move in ipairs(activeSegment) do
            if move.greenFrames == 0 then
                move.greenFrames = activeSegment.segmentGreenFrames
            end
        end
    end

    if debugMode then
        print(string.format("Current Segment: %d, Character: %s", comboSegment, currentCharacter or "none"))
        for i, move in ipairs(activeSegment) do
            print(string.format("Move %d: %s, Green Frames: %d, Hit Detected: %s",
                i, move.move.name, move.greenFrames, tostring(move.hitDetected)))
        end
    end

    for i, move in ipairs(activeSegment) do
        if move.move.hidden then
            move.greenFrames = greenFrameValues[move.move] or 20
            move.hitDetected = true
        end
        local movePressed = memory.readdword(players[curPlayer] + charOffset[1])
        local moveAddress = move.move and move.move.address
        local hitValue = memory.readdword(players[curPlayer] + charOffset[20])
        if move.move.name == "MP KARA" then
            if movePressed and moveAddress and (movePressed == moveAddress) then
                move.greenFrames = greenFrameValues[move.move] or 20
                move.hitDetected = true
                if debugMode then print("Move detected: " .. move.move.name) end
            end
        else
            if movePressed and moveAddress and (movePressed == moveAddress) and (hitValue ~= 0) then
                if i == 1 or (activeSegment[i - 1] and activeSegment[i - 1].greenFrames > 0) then
                    if move.greenFrames == 0 then
                        move.greenFrames = greenFrameValues[move.move] or 20
                        move.hitDetected = true
                        if debugMode then print("Move detected: " .. move.move.name) end
                    end
                end
                memory.writedword(players[curPlayer] + charOffset[20], 0)
            else
                activeSegment[i].greenFrames = activeSegment[i].greenFrames or 0
            end
        end
    end

    for i = #activeSegment, 2, -1 do
        local prevMove = activeSegment[i - 1]
        if activeSegment[i].greenFrames > 0 then
            prevMove.greenFrames = math.max(prevMove.greenFrames, activeSegment[i].greenFrames)
        end
    end

    local allMovesGreen = true
    local anyMoveTurnedWhite = false
    for i, move in ipairs(activeSegment) do
        if move.greenFrames > 0 then
            move.greenFrames = move.greenFrames - 1
            if move.greenFrames <= 0 then 
                move.hitDetected = false 
                anyMoveTurnedWhite = true
            end
        else
            allMovesGreen = false
        end
    end

    if anyMoveTurnedWhite then
        for segmentIndex = 1, comboSegment - 1 do
            local previousSegment = segments["segment" .. segmentIndex]
            if previousSegment then
                for _, move in ipairs(previousSegment) do
                    move.greenFrames = 0
                    move.hitDetected = false
                end
            end
        end
    end

    if allMovesGreen and not debugMode then
        if currentCharacter == "AKUMA" then
            if comboSegment ==  ( (trialComboMoves[currentCharacter][selectedBox].segment2 and 2) or 5) then
                comboCompleted = true
                isStunned = false
                comboSegment = 1
                local file = io.open("combo_trial_completion.txt", "a")
                if file then
                    file:write(currentCharacter .. selectedBox .. " = COMPLETED\n")
                    file:close()
                end
            else
                comboSegment = comboSegment + 1
                isStunned = true
                local nextSegment = segments["segment" .. comboSegment]
                if nextSegment then
                    for _, move in ipairs(nextSegment) do
                        move.greenFrames = 0
                        move.hitDetected = false
                    end
                end
            end
        else
            if comboSegment == 2 then
                comboCompleted = true
                isStunned = false
                comboSegment = 1
                local file = io.open("combo_trial_completion.txt", "a")
                if file then
                    file:write(currentCharacter .. selectedBox .. " = COMPLETED\n")
                    file:close()
                end
            else
                comboSegment = comboSegment + 1
                isStunned = true
                local nextSegment = segments["segment" .. comboSegment]
                if nextSegment then
                    for _, move in ipairs(nextSegment) do
                        move.greenFrames = 0
                        move.hitDetected = false
                    end
                end
            end
        end
    end

    local combined = {}
    for _, segment in pairs(segments) do
        for _, move in ipairs(segment) do
            table.insert(combined, move)
        end
    end
    local anyActive = false
    for _, move in ipairs(combined) do
        if move.hitDetected then anyActive = true break end
    end
    if not anyActive then 
        resetGreenFrames() 
        for _, move in ipairs(combined) do
            move.greenFrames = 0
            move.hitDetected = false
        end
    end
end

function drawDynamicText()
    updateGreenFrames()
    local yPosition = 50
    local segments = trialComboMoves[currentCharacter] and trialComboMoves[currentCharacter][selectedBox]
    if not segments then return end
    if debugMode then
        local personalActionAddress = memory.readdword(players[curPlayer] + charOffset[1])
        gui.text(10, 10, string.format("Player Action Address: %08X", personalActionAddress), "yellow")
        gui.text(10, 30, string.format("Current Segment: %d", comboSegment), "yellow")
    end
    if segments.segment1 then
        for _, move in ipairs(segments.segment1) do
            if not move.move.hidden then
                local xOffset = 10
                local color = (move.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
                if move.move and move.move.name then gui.text(xOffset, yPosition, move.move.name, color)
                else gui.text(xOffset, yPosition, "Unknown Move", color) end
                yPosition = yPosition + 10
            end
        end
    end
    if segments.segment2 then
        for _, move in ipairs(segments.segment2) do
            if not move.move.hidden then
                local xOffset = 10
                local color = (move.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
                if move.move and move.move.name then gui.text(xOffset, yPosition, move.move.name, color)
                else gui.text(xOffset, yPosition, "Unknown Move", color) end
                yPosition = yPosition + 10
            end
        end
    end
    if currentCharacter == "AKUMA" then
        if segments.segment3 then
            for _, move in ipairs(segments.segment3) do
                if not move.move.hidden then
                    local xOffset = 10
                    local color = (move.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
                    if move.move and move.move.name then gui.text(xOffset, yPosition, move.move.name, color)
                    else gui.text(xOffset, yPosition, "Unknown Move", color) end
                    yPosition = yPosition + 10
                end
            end
        end
        if segments.segment4 then
            for _, move in ipairs(segments.segment4) do
                if not move.move.hidden then
                    local xOffset = 10
                    local color = (move.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
                    if move.move and move.move.name then gui.text(xOffset, yPosition, move.move.name, color)
                    else gui.text(xOffset, yPosition, "Unknown Move", color) end
                    yPosition = yPosition + 10
                end
            end
        end
        if segments.segment5 then
            for _, move in ipairs(segments.segment5) do
                if not move.move.hidden then
                    local xOffset = 10
                    local color = (move.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
                    if move.move and move.move.name then gui.text(xOffset, yPosition, move.move.name, color)
                    else gui.text(xOffset, yPosition, "Unknown Move", color) end
                    yPosition = yPosition + 10
                end
            end
        end
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