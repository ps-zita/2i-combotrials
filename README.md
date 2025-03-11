# SF3: 2nd Impact Combo Trials

This script is designed for use with **Street Fighter III: 2nd Impact** to provide a robust and interactive training menu. It allows players to select characters, trials, and dynamically load savestates for combo practice, all while offering an intuitive and visually appealing UI.

## Features
- **Interactive Character and Trial Selection**:
  - Select from all 14 characters in **SF3: 2nd Impact**.
  - Choose from 10 unique combo trials for each character.
- **Dynamic Savestate Loading**:
  - Automatically loads savestates based on the selected character and trial.
- **Real-Time Debugging Tools**:
  - Displays debug messages for input feedback and savestate loading status.
- **Input Handling**:
  - Comprehensive mapping for player inputs to interact with the menu.

## How It Works

### 1. Menu System
   - **Menu Visibility**: The menu appears when the Start button is held for a specified duration. It automatically hides when a savestate is loaded.
   - **Character Selection**: Navigate up and down through the character list using directional inputs.
   - **Trial Selection**: Use left and right inputs to cycle through available trials.

### 2. Savestate Loading
   - The script dynamically constructs the savestate filename based on the selected character and trial. Ensure the savestate files are named in the format `<character><trial>.fs` (e.g., `ryu1.fs`, `ken5.fs`).

### 3. Input Mapping
   - Button mappings are defined for all primary inputs, including punches, kicks, and the Start button.

### 4. UI Design
   - The UI consists of:
     - **Character Panel**: Displays the list of characters with highlights for the current selection.
     - **Trial Selection Boxes**: A visual indicator for selecting a specific trial.
     - **Help Panel**: A compact guide for navigation controls and tips.
     - **Trial Explanation Box**: Displays detailed trial descriptions for the selected character and trial.

### 5. Debugging
   - Debug messages provide insights into the script's current operations, such as savestate loading success or errors.

## Installation & Usage

### Requirements
- Emulator supporting Lua scripting (e.g., FBA-rr, MAME-rr).
- Savestate files for each trial and character.

### Setup
1. Load the Lua script through your chosen emulator.
2. Ensure savestate files follow the naming convention `<character><trial>.fs` and are stored in the same directory as the script.

### Running the Script
1. Load the script via the emulator's Lua console.
2. Navigate the menu using player inputs as per the instructions.

## Controls

| Action                        | Input           |
|-------------------------------|-----------------|
| Open Menu                     | Hold Start      |
| Reset Current Trial           | Tap Start       |
| Navigate Characters           | Up/Down         |
| Navigate Trials               | Left/Right      |
| Confirm Selection             | Medium Punch/Kick|

## Notes
- Ensure that the savestate files are compatible with your emulator and are saved at the correct point in the game.
- The script includes transparent background effects for the UI, ensuring minimal obstruction of the gameplay screen.

## Debugging
- Errors related to missing savestate files will be displayed both on-screen and in the emulator's console.
- Use the `showDebug` function to add additional debugging messages as needed.

## Customization
Feel free to tweak the following:
- **Colors**: Modify the `COLORS` table to customize the menu's color scheme.
- **Trial Descriptions**: Update `trialDescriptions` for unique and character-specific trial details.

## To-Do List
1. **Write the Trials**:
   - Fill out detailed, unique combo trial descriptions for all 14 characters in `trialDescriptions`.
   - Ensure the trials include accurate instructions for moves, combos, and timing.

2. **Find Memory Addresses**:
   - Identify and document relevant memory addresses for tracking character states, health, positions, or other metrics.
   - Integrating these memory addresses into the script for combo trial utilisation, recognizing when moves are hit etc.

3. **Optimize UI**:
   - Improve the UI layout for better readability and add more advanced visual features, like animated transitions between menu states. add custom music & graphics.

## Contribution
Contributions to improve this script are welcome! Whether it's enhancing the UI, optimizing the code, or adding new features, feel free to share your updates.
