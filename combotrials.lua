-- SF3: 2nd Impact Training Menu Script

-- Colors for UI (with transparency)
COLORS = {
    background = "#000000" .. "80",  -- 50% transparent black
    text = "white",
    highlight = "green",
    box = "white"
}

-- Character list for SF3: 2nd Impact
characters = {
    "ALEX", "AKUMA", "DUDLEY", "ELENA", "HUGO", "IBUKI", "KEN", "NECRO", "ORO",
    "RYU", "SEAN", "URIEN", "YANG", "YUN"
}

-- Trial descriptions for each character
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
    }
}

-- Copy the format for all characters
for _, char in ipairs(characters) do
    if char ~= "ALEX" then
        trialDescriptions[char] = trialDescriptions.ALEX
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

-- Input handling setup
guiinputs = {
    P1 = {previousinputs={}}
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
    [8] = "P1 Select"        -- Select Button (to trigger menu)
}

-- Helper function to draw text on the screen
function drawText(x, y, text, color)
    gui.text(x-1, y, text, "black")
    gui.text(x+1, y, text, "black")
    gui.text(x, y-1, text, "black")
    gui.text(x, y+1, text, "black")
    gui.text(x, y, text, color or COLORS.text)
end

-- Function to draw a box on the screen
function drawBox(x, y, width, height, isSelected)
    local outline = isSelected and COLORS.highlight or COLORS.box
    gui.box(x, y, x + width, y + height, COLORS.background, outline)
end

-- Function to draw trial selection boxes
function drawTrialBoxes(x, y, charIndex)
    local boxWidth = 5
    local boxHeight = 5
    local spacing = 2
    local startX = x + 35
    
    for i = 1, 10 do
        local boxX = startX + ((boxWidth + spacing) * (i-1))
        local isSelected = (charIndex == selectedChar) and (i == selectedBox)
        drawBox(boxX, y, boxWidth, boxHeight, isSelected)
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

-- Function to draw the character selection panel
function drawCharacterPanel()
    local panelWidth = 120
    local panelX = emu.screenwidth() - panelWidth - 5
    local itemHeight = 10
    drawBox(panelX, 5, panelWidth, (#characters * itemHeight) + 10)
    
    for i, char in ipairs(characters) do
        local y = 10 + ((i-1) * itemHeight)
        local color = (i == selectedChar) and COLORS.highlight or COLORS.text
        drawText(panelX + 5, y, char, color)
        drawTrialBoxes(panelX, y + 1, i)
    end
end

-- Function to draw the help panel
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
        debugMessage -- Debug line
    }
    
    for i, line in ipairs(helpText) do
        drawText(10, 10 + (i * 10), line)
    end
end

-- Function to show debug messages
function showDebug(message)
    debugMessage = message
    debugTimer = 180 -- Show message for 3 seconds
    print(message) -- Also print to console
end

function loadCharacterTrial(char, trial)
    showDebug("Loading savestate...")

    -- Set the menu to be invisible immediately
    menuVisible = false

    local filename = char:lower() .. trial .. ".fs" -- Dynamic filename based on character and trial
    
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

    -- Iterate over each button in buttonMappings and check for presses
    for i = 1, 8 do
        local button = buttonMappings[i]  -- Get the button name
        if inputs[button] and not guiinputs.P1.previousinputs[button] then
            -- Button pressed, show debug and print messages
            local message = button .. " pressed for " .. characters[selectedChar] .. " trial " .. selectedBox
            print(message)  -- Print to console
            showDebug(message)  -- Show in debugger

            -- Load the character trial
            loadCharacterTrial(characters[selectedChar], selectedBox)
			gui.transparency(100)
            break
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
        startHoldFrames = 0  -- Reset the frame counter after button release
    end
end

-- Main game loop
function mainLoop()
    -- Handle the start button input
    handleStartButton()

    -- Handle menu input when menu is visible
    if menuVisible then
        handleMenuInput()
		drawHelpPanel()
		drawCharacterPanel()
		drawTrialExplanation()
		gui.transparency(1)
	else
	end
end

-- Run the main loop every frame
while true do
    mainLoop()
    emu.frameadvance()
end