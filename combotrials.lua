<<<<<<< Updated upstream
-- importing bitwise operations library
local bit = require("bit")

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

-- ALEX moves
local alexHPFlashChop = {name = "HEAVY FLASH CHOP", address = 102385716}
local alexMP = {name = "MEDIUM PUNCH", address = 102349208}
local alexLPFlashChop = {name = "LIGHT FLASH CHOP", address = 102384844}
local alexBoomerangRaid = {name = "BOOMERANG RAID", address = 102387828}
local alexIdle = {name = "IDLE", address = 102302556, hidden = true}

-- KEN moves
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
local kenLightShoryuken = {name = "LIGHT SHORYUKEN", address = 103429212}
local kenShippuJinraikyaku = {name = "SHIPPU JINRAIKYAKU", address = 103434300}

-- AKUMA moves
local akumaJumpForward = {name = "JUMP FORWARD", address = 103596280, hidden = true}
local akumaDivekick = {name = "DIVEKICK", address = 103638780}
local akumaCHP = {name = "CLOSE HEAVY PUNCH", address = 103632092}
local akumaTestCHP = {name = "CLOSE HEAVY PUNCH", address = 103632092}
local akumaLKTatsu = {name = "LK TATSU", address = 103660928}
local akumaCLP = {name = "CLOSE LIGHT PUNCH", address = 103631116}
local akumaCMK = {name = "CLOSE MEDIUM KICK", address = 103632780}
local akumaLP = {name = "LIGHT PUNCH", address = 104000600}
local akumaCRHP = {name = "CROUCHING HEAVY PUNCH", address = 103633932}
local akumaKara = {name = "MP KARA", address = 103631804}
local akumaDemon = {name = "RAGING DEMON", address = 103621536}
local akumaHTatsu = {name = "HK TATSU", address = 103661824}
local akumaJHP = {name = "JUMPING HEAVY PUNCH", address = 103637820, hiddenMove = akumaJumpForward}

-- HUGO
local hugoMediumUltraThrow = {name = "HEAVY ULTRA THROW", address = 102800188}
local hugoHeavyPalmBomber  = {name = "HEAVY PALM BOMBER", address = 102846464}
local hugoMegatonPress     = {name = "MEGATON PRESS", address = 102854024}
local hugoMoonsaultPress   = {name = "MOONSAULT PRESS", address = 102797300}

-- RYU
local ryuLK = {name = "LIGHT KICK", address =102433472}

-- SEAN moves
local seanIDLE = {name = "IDLE", address = 103441548, hidden = true}
local seanCLP = {name = "CLOSE LIGHT PUNCH", address = 103477692}
local seanTaunt = {name = "TAUNT", address = 103518820}
local seanCHK = {name = "CLOSE HEAVY KICK", address = 103479420}
local seanCRMK = {name = "CROUCHING MEDIUM KICK", address = 103480948}
local seanEXTatsu = {name = "EX TATSU", address = 103507204}
local seanHadouBurst = {name = "HADOU BURST", address = 104010050}

-- moves for the trial, segmenting is done because the trial bugs out if identical moves are done in 1 combo & also because it makes implementing stun combos easier
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
        },
        [2] = {
            segment1 = {
                {move = kenLightShoryuken, greenFrames = 0, hitDetected = false},
                {move = kenShippuJinraikyaku, greenFrames = 0, hitDetected = false},
            },
            segment2 = {
                {move = kenShippuJinraikyaku, greenFrames = 0, hitDetected = false},
                {move = kenLightShoryuken, greenFrames = 0, hitDetected = false},
            }
        },
    },
    AKUMA = {
        [1] = {
            segment1 = {
                {move = akumaJumpForward, greenFrames = 0, hitDetected = false},
                {move = akumaDivekick, greenFrames = 0, hitDetected = false},
                {move = akumaCHP, greenFrames = 0, hitDetected = false},
                {move = akumaLKTatsu, greenFrames = 0, hitDetected = false},
                {move = akumaHTatsu, greenFrames = 0, hitDetected = false},
                {move = akumaJHP, greenFrames = 0, hitDetected = false},
            },
            segment2 = {
                {move = akumaKara, greenFrames = 0, hitDetected = false},
                {move = akumaDemon, greenFrames = 0, hitDetected = false},
            }
        },
        -- test trial for sata, hi sata!!
        -- HIHI TOUCH !!
        [3] = {
            segment1 = {
                {move = akumaJumpForward, greenFrames = 0, hitDetected = false},
                --ik it says jumpforward here but its actually just his idle animation action
                {move = akumaTestCHP, greenFrames = 0, hitDetected = false},
            },
            segment2 = {
                {move = akumaTestCHP, greenFrames = 0, hitDetected = false},
            }
        },
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
    },
    HUGO = {
        [1] = {
            segment1 = {
                {move = hugoMediumUltraThrow, greenFrames = 0, hitDetected = false},
                {move = hugoHeavyPalmBomber,  greenFrames = 0, hitDetected = false},
            },
            segment2 = {
                {move = hugoHeavyPalmBomber, greenFrames = 0, hitDetected = false},
            },
            segment3 = {
                {move = hugoHeavyPalmBomber, greenFrames = 0, hitDetected = false},
            },
            segment4 = {
                {move = hugoHeavyPalmBomber, greenFrames = 0, hitDetected = false},
            },
            segment5 = {
                {move = hugoHeavyPalmBomber, greenFrames = 0, hitDetected = false},
            },
            segment6 = {
                {move = hugoMegatonPress,   greenFrames = 0, hitDetected = false},
                {move = hugoMoonsaultPress, greenFrames = 0, hitDetected = false},
            },
        }
    },
    SEAN = {
        [1] = {
            segment1 = {
                {move = seanEXTatsu, greenFrames = 0, hitDetected = false},
                {move = seanCRMK,    greenFrames = 0, hitDetected = false},
            },
            segment2 = {
                {move = seanEXTatsu, greenFrames = 0, hitDetected = false},
                {move = seanCRMK,    greenFrames = 0, hitDetected = false},
            },
            segment3 = {
                {move = seanEXTatsu, greenFrames = 0, hitDetected = false},
                {move = seanCRMK,    greenFrames = 0, hitDetected = false},
            },
            segment4 = {
                {move = seanEXTatsu,  greenFrames = 0, hitDetected = false},
                {move = seanHadouBurst, greenFrames = 0, hitDetected = false},
            },
        }
    }
}

-- greenframes are however many frames a move is registered as a hit for & updated to make the text for combos green
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
    [kenLightShoryuken] = 120,
    [kenShippuJinraikyaku] = 80,
    -- AKUMA
    [akumaJumpForward] = 1000,
    [akumaDivekick] = 25,
    [akumaCHP] = 35,
    [akumaTestCHP] = 180,
    [akumaLKTatsu] = 105,
    [akumaCLP] = 40,
    [akumaCMK] = 23,
    [akumaCRHP] = 35,
    [akumaLP] = 30,
    [akumaKara] = 60,
    [akumaDemon] = 80,
    [akumaHTatsu] = 110,
    [akumaJHP] = 40,
    -- HUGO
    [hugoMediumUltraThrow] = 75,    
    [hugoHeavyPalmBomber]  = 165,       
    [hugoMegatonPress]     = 295,     
    [hugoMoonsaultPress]   = 105,
    -- SEAN
    [seanCLP] = 40,
    [seanTaunt] = 50,
    [seanCHK] = 35,
    [seanCRMK] = 45,
    [seanEXTatsu] = 70,
    [seanHadouBurst] = 90
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
        [1] = "stun adds an extra frame of hitstun, this allows \nyou to do cl.mp > cr.hp and ex tatsu > shippu.\ntrial by vesper",
        [2] = "this one is stupid lmao\ntrial by vesper"
    },
    HUGO = {
        [1] = "this character fucking sucks\nthis trial is also kinda broken"
    },
    AKUMA = {
        [2] = "light punch in a juggle against a stunned gill\nallows for the next move to restand",
        [1] = "normal corner bnb but the reset > kara demon\nis only a true combo on hugo",
        [3] = "test trial fur sata :)"
    }
}
for _, char in ipairs(characters) do
    if char ~= "ALEX" and char ~= "KEN" then
        if not trialDescriptions[char] then
            trialDescriptions[char] = trialDescriptions.ALEX
        end
    end
end

local selectedChar = 1
local selectedBox = 1
local menuVisible = true
local savestateLoaded = false
local firstFrame = true
local buttonPressed = false
local inputBlockFrames = 0
local BLOCK_FRAMES = 30
local pendingSavestate = false
local startHoldFrames = 0
local START_HOLD_THRESHOLD = 30
local debugMessage = ""
local debugTimer = 0
local debugMode = false

local segmentDelay = 0

local guiinputs = { P1 = {previousinputs = {}} }

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

function pullSave()
    local file = io.open("combo_trial_completion.bin", "r")

    if file == nil then
        local temp = assert(io.open("combo_trial_completion.bin", "w"))
        temp:write(0)
        temp:close()
        
        return 0
    end

    local data = file:read("*all")
    file:close()
    data = tonumber(data)

    return data
end

function readTrialStatus(data, charIndex, trialIndex)
    local index = toBinaryIndex(charIndex, trialIndex)

    if (bit.band(data, index) == index) then
        return true
    end

    return false
end

function writeTrialCompletion(currentCharacter, trialIndex)
    -- get data
    local data = pullSave()

    -- edit data to flip trial bit flag
    data = bit.bor(data, toBinaryIndex(toCharIndex(currentCharacter), trialIndex))

    -- open file, save, close file
    local file = assert(io.open("combo_trial_completion.bin", "w"))
    file:write(data)
    file:close()
end

-- converts to bitflag index https://pressbooks.lib.jmu.edu/programmingpatterns/chapter/bitflags/
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

    for i = 1, 10 do
        local boxX = startX + ((boxWidth + spacing) * (i - 1))
        local isSelected = (charIndex == selectedChar) and (i == selectedBox)
        local isCompleted = readTrialStatus(data, charIndex, i)
        drawBox(boxX, y, boxWidth, boxHeight, isSelected, isCompleted)
    end
end

function drawTrialExplanation()
    local char = characters[selectedChar]
    local desc = nil
    if trialDescriptions[char] then
        if type(trialDescriptions[char][1]) == "string" then
            desc = trialDescriptions[char][selectedBox] or trialDescriptions[char][1]
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

function showDebug(message)
    debugMessage = message
    debugTimer = 180
    print(message)
end

function loadCharacterTrial(char, trial)
    showDebug("Loading savestate...")
    menuVisible = false
    currentCharacter = char
    if char == "KEN" and trial == 2 then
        local fsFilename = "ken2.fs"
        local frFilename = "ken2.fr"
        local fsFile = io.open(fsFilename, "r")
        local frFile = io.open(frFilename, "r")
        if fsFile and frFile then
            fsFile:close()
            frFile:close()
            local success_fs, err_fs = pcall(function() 
                savestate.load(fsFilename) 
            end)
            local success_fr, err_fr = pcall(function() 
                savestate.load(frFilename) 
            end)
            if success_fs and success_fr then
                showDebug("Loaded Ken trial 2 (ken2.fs and ken2.fr)")
                savestateLoaded = true
                inputBlockFrames = BLOCK_FRAMES
            else
                showDebug("Error loading ken2.fs or ken2.fr")
            end
        else
            showDebug("Error: Missing ken2.fs or ken2.fr savestate file")
        end
    else
        local filename = char:lower() .. trial .. ".fs"
        local f = io.open(filename, "r")
        if f then
            f:close()
            showDebug("Found savestate file: " .. filename)
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
            showDebug("Error: Savestate not found (" .. filename .. ")")
        end
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
    segmentDelay = 0  -- reset delay counter
end

--this is such a fucking mess omg
function updateGreenFrames()
    if comboCompleted and not isStunned then 
        return 
    end
    local segments = trialComboMoves[currentCharacter] and trialComboMoves[currentCharacter][selectedBox]
    if not segments then 
        return 
    end

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
        elseif comboSegment == 3 then
            activeSegment = segments.segment3
        elseif comboSegment == 4 then
            activeSegment = segments.segment4
        elseif comboSegment == 5 then
            activeSegment = segments.segment5
        elseif comboSegment == 6 then
            activeSegment = segments.segment6
        elseif comboSegment == 7 then
            activeSegment = segments.segment7
        elseif comboSegment == 8 then
            activeSegment = segments.segment8
        end
    end

    if not activeSegment then 
        return 
    end

    if debugMode then
        print(string.format("Current Segment: %d, Character: %s", comboSegment, currentCharacter or "none"))
        for i, move in ipairs(activeSegment) do
            print(string.format("Move %d: %s, Green Frames: %d, Hit Detected: %s",
                i, move.move.name, move.greenFrames, tostring(move.hitDetected)))
        end
    end

    if currentCharacter == "KEN" and selectedBox == 2 then
        local isShippuSegment = true
        for _, m in ipairs(activeSegment) do
            if m.move.name ~= "SHIPPU JINRAIKYAKU" then
                isShippuSegment = false
                break
            end
        end
        if isShippuSegment then
            if segmentDelay < 120 then
                segmentDelay = segmentDelay + 1
                return
            else
                segmentDelay = 0
            end
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
                if debugMode then
                    print("Move detected: " .. move.move.name)
                end
            end
        else
            if movePressed and moveAddress and (movePressed == moveAddress) and (hitValue ~= 0) then
                if currentCharacter == "SEAN" and move.move.name == "CLOSE LIGHT PUNCH" then
                    -- Process the CLOSE LIGHT PUNCH hit as usual.
                    if i == 1 or (activeSegment[i - 1] and activeSegment[i - 1].greenFrames > 0) then
                        if move.greenFrames == 0 then
                            move.greenFrames = greenFrameValues[move.move] or 20
                            move.hitDetected = true
                            if debugMode then 
                                print("Move detected: " .. move.move.name)
                            end
                        end
                    end
                    -- Automatically mark TAUNT as hit
                    for _, other in ipairs(activeSegment) do
                        if other.move.name == "TAUNT" then
                            other.greenFrames = greenFrameValues[other.move] or 20
                            other.hitDetected = true
                            if debugMode then 
                                print("Automatically marking TAUNT as hit.")
                            end
                        end
                    end
                else
                    if i == 1 or (activeSegment[i - 1] and activeSegment[i - 1].greenFrames > 0) then
                        if move.greenFrames == 0 then
                            move.greenFrames = greenFrameValues[move.move] or 20
                            move.hitDetected = true
                            if debugMode then 
                                print("Move detected: " .. move.move.name)
                            end
                        end
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
        local maxSegment = 0
        for segmentName, _ in pairs(segments) do
            local segNum = tonumber(string.match(segmentName, "%d+"))
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
                for _, move in ipairs(nextSegment) do
                    move.greenFrames = 0
                    move.hitDetected = false
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
        if move.hitDetected then 
            anyActive = true 
            break 
        end
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
    for i = 1, 8 do
        local seg = segments["segment" .. i]
        if seg then
            for _, move in ipairs(seg) do
                if not move.move.hidden then
                    local xOffset = 10
                    local color = (move.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
                    if move.move and move.move.name then 
                        gui.text(xOffset, yPosition, move.move.name, color)
                    else 
                        gui.text(xOffset, yPosition, "Unknown Move", color)
                    end
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

    -- Force player 2's "Down" input when playing SEAN trial 1
    if currentCharacter == "SEAN" and selectedBox == 1 then
        joypad.set({["P2 Down"] = true}, 2)
    end
end

while true do
    mainLoop()
    emu.frameadvance()
=======
local bit = require("bit")
local json = require("dkjson")
-- OS running script, for directory info
local OS = package.config:sub(1,1) == "\\" and "win" or "unix"

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

local movesData = {}
local trialsData = {}
local characters = {
    "ALEX", "AKUMA", "DUDLEY", "ELENA", "HUGO", "IBUKI", "KEN", "NECRO",
    "ORO", "RYU", "SEAN", "URIEN", "YANG", "YUN"
}

for dir in io.popen([[dir ".\" /b]]):lines() do 
    print(dir)
end

for _, char in ipairs(characters) do
    local mfile = "moves/" .. string.lower(char) .. ".json"
    local tfile = "trials/" .. string.lower(char) .. ".json"
    movesData[char] = loadJSONFile(mfile)
    trialsData[char] = loadJSONFile(tfile)
    if (not trialsData[char]) and char ~= "ALEX" then
        trialsData[char] = loadJSONFile("trials/alex.json")
    end
end

local trialComboMoves = trialsData

-- Define globals used for hit detection
local comboSegment = 1
local comboCompleted = false
local isStunned = false
local segmentDelay = 0

-- Standard emulator setup
local curGame = { [1] = 0x200e504, [2] = 0x200e910, [3] = 0x2010167 }
local players = { curGame[1], curGame[2] }
local charOffset = {
    [1] = 0x1c0, [2] = 0x1c4, [3] = 0x1cc, [4] = 0x1da, [5] = 0x1dc,
    [6] = 0x1de, [7] = 0x25c, [8] = 0x260, [9] = 0x284, [10] = 0x288,
    [11] = 0x27c, [12] = 0x280, [13] = 0x290, [14] = 0x294, [15] = 0x298,
    [16] = 0x274, [17] = 0x278, [18] = 0x264, [19] = 0x268, [20] = 0x2d2
}
local curPlayer = 1
local PlayerAction = memory.readdword(players[curPlayer] + charOffset[1])

-- Savedata colors and trial descriptions remain the same.
COLORS = {
    background = "#00000080",
    text = "white",
    highlight = "green",
    box = "white",
    completed = "red",
    debug = "yellow"
}

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
        [1] = "stun adds an extra frame of hitstun, this allows \nyou to do cl.mp > cr.hp and ex tatsu > shippu.\ntrial by vesper",
        [2] = "this one is stupid lmao\ntrial by vesper"
    },
    HUGO = {
        [1] = "this character fucking sucks\nthis trial is also kinda broken"
    },
    AKUMA = {
        [2] = "light punch in a juggle against a stunned gill\nallows for the next move to restand",
        [1] = "normal corner bnb but the reset > kara demon\nis only a true combo on hugo",
        [3] = "test trial fur sata :)"
    }
}
for _, char in ipairs(characters) do
    if char ~= "ALEX" and char ~= "KEN" then
        if not trialDescriptions[char] then
            trialDescriptions[char] = trialDescriptions.ALEX
        end
    end
end

local selectedChar = 1
local selectedBox = 1
local menuVisible = true
local savestateLoaded = false
local firstFrame = true
local buttonPressed = false
local inputBlockFrames = 0
local BLOCK_FRAMES = 30
local pendingSavestate = false
local startHoldFrames = 0
local START_HOLD_THRESHOLD = 30
local debugMessage = ""
local debugTimer = 0
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

function drawText(x, y, text, color)
    gui.text(x - 1, y, text, "black")
    gui.text(x + 1, y, text, "black")
    gui.text(x, y - 1, text, "black")
    gui.text(x, y + 1, text, "black")
    gui.text(x, y, text, color or COLORS.text)
end

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
    for i = 1, 10 do
        local boxX = startX + ((boxWidth + spacing) * (i - 1))
        local isSelected = (charIndex == selectedChar) and (i == selectedBox)
        local isCompleted = readTrialStatus(data, charIndex, i)
        drawBox(boxX, y, boxWidth, boxHeight, isSelected, isCompleted)
    end
end

function drawTrialExplanation()
    local char = characters[selectedChar]
    local desc = nil
    if trialDescriptions[char] then
        if type(trialDescriptions[char][1]) == "string" then
            desc = trialDescriptions[char][selectedBox] or trialDescriptions[char][1]
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

function showDebug(message)
    debugMessage = message
    debugTimer = 180
    print(message)
end

-- Modified loadCharacterTrial now loads savestates from the "states" folder.
function loadCharacterTrial(char, trial)
    showDebug("Loading savestate...")
    menuVisible = false
    currentCharacter = char
    if char == "KEN" and trial == 2 then
        local fsFilename = "states/ken2.fs"
        local frFilename = "states/ken2.fr"
        local fsFile = io.open(fsFilename, "r")
        local frFile = io.open(frFilename, "r")
        if fsFile and frFile then
            fsFile:close()
            frFile:close()
            local success_fs, err_fs = pcall(function() 
                savestate.load(fsFilename) 
            end)
            local success_fr, err_fr = pcall(function() 
                savestate.load(frFilename) 
            end)
            if success_fs and success_fr then
                showDebug("Loaded Ken trial 2 (ken2.fs and ken2.fr)")
                savestateLoaded = true
                inputBlockFrames = BLOCK_FRAMES
            else
                showDebug("Error loading ken2.fs or ken2.fr")
            end
        else
            showDebug("Error: Missing ken2.fs or ken2.fr savestate file")
        end
    else
        local filename = "states/" .. char:lower() .. trial .. ".fs"
        local f = io.open(filename, "r")
        if f then
            f:close()
            showDebug("Found savestate file: " .. filename)
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
            showDebug("Error: Savestate not found (" .. filename .. ")")
        end
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
                    if move.projectile then
                        move.projTimer = nil
                    end
                end
            end
        end
    end
    comboSegment = 1
    comboCompleted = false
    isStunned = false
    segmentDelay = 0  -- reset delay counter
end

function updateGreenFrames()
    if comboCompleted and not isStunned then 
        return 
    end
    local segments = trialComboMoves[currentCharacter] and trialComboMoves[currentCharacter][tostring(selectedBox)]
    if not segments then 
        return 
    end

    local segmentName = "segment" .. comboSegment
    local activeSegment = segments[segmentName]
    if not activeSegment then
        return 
    end

    if debugMode then
        print(string.format("Current Segment: %d, Character: %s", comboSegment, currentCharacter or "none"))
        for i, m in ipairs(activeSegment) do
            print(string.format("Move %d: %s, Green Frames: %d, Hit Detected: %s",
                i, m.move, m.greenFrames, tostring(m.hitDetected)))
        end
    end

    -- Read memory values once.
    local movePressed = memory.readdword(players[curPlayer] + charOffset[1])
    local hitValue = memory.readdword(players[curPlayer] + charOffset[20])
    
    for i, m in ipairs(activeSegment) do
        local moveObj = (movesData[currentCharacter] and movesData[currentCharacter][m.move]) or {}
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
        for segName, _ in pairs(segments) do
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
    for _, seg in pairs(segments) do
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
    local segments = trialComboMoves[currentCharacter] and trialComboMoves[currentCharacter][tostring(selectedBox)]
    if not segments then return end
    if debugMode then
        local personalActionAddress = memory.readdword(players[curPlayer] + charOffset[1])
        gui.text(10, 10, string.format("Player Action Address: %08X", personalActionAddress), "yellow")
        gui.text(10, 30, string.format("Current Segment: %d", comboSegment), "yellow")
    end
    for i = 1, 8 do
        local seg = segments["segment" .. i]
        if seg then
            for _, m in ipairs(seg) do
                if (not movesData[currentCharacter] or not movesData[currentCharacter][m.move] or not movesData[currentCharacter][m.move].hidden) then
                    local xOffset = 10
                    local color = (m.greenFrames > 0) and (debugMode and "yellow" or "green") or "white"
                    local moveName = m.move
                    if movesData[currentCharacter] and movesData[currentCharacter][m.move] and movesData[currentCharacter][m.move].name then 
                        moveName = movesData[currentCharacter][m.move].name
                    end
                    gui.text(xOffset, yPosition, moveName, color)
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
>>>>>>> Stashed changes
end