# Changelog

## v0.13.0a (2025-10-10)

- **♻️:** name in main menu
- **➕:** UIEffect.gd
- **♻️:** gameplay background to something more contrasting to the items and mascot
- **🚀:** configuration by changing name and adding description
- **➕:** UIEffect script to autoload
- **➕:** play and global group
- **♻️:** cart size
- **➕:** new scene for floating score
- **♻️:** name of game and repositioned to center
- **➕:** score pop-up logic to the kill_line.gd script
- **🚀:** cart logic with score pop-ups
- **➕:** icon.png for splace screen
- **♻️:** configuration in relation to the splash screen
- **🚀:** comments and restructured

## v0.12.0a (2025-10-05)

- **➕:** game background artwork
- **➕:** game-background import file
- **➕:** main menu background artwork
- **➕:** main menu background import file
- **⬆️:** README.md with new main menu artwork
- **❌:** tiles as background
- **➕:** background to main menu
- **🛠️:** logical error that caused cart to slightly go off screen
- **♻️:** Final Score to Score

## v0.11.0a (2025-10-04)

- **➕:** logic to recognize missed items and then apply that to the score
- **➕:** added kill_line script to catch missed items
- **♻️:** ```delta_points``` to ```points_to_add``` for clarity
- **🛠️:** collision visibility when debugging/testing
- **➕:** KillLine node and connections
- **🚀:** code to be more legible
- **➕:** Scoring API
- **➕:** logic to catch and miss items so it reflects in the score
- **🚀:** numbers in score to read with commas when count gets larger than three digits
- **🐞:** causing cart to slightly go off screen

## v0.10.0a (2025-10-02)

- **🚀:** Global.gd to be more legible
- **⬆️:** project.godot
- **⬆️:** game.tscn
- **🚀:** UI logic to include main menu
- **🚀:** UI logic to include start option
- **🚀:** UI logic for quit option
- **➕:** Game over menu
- **➕:** UI logic for restart option

## v0.9.0a (2025-10-01)

- **➕:** background pattern
- **➕:** Grape Soda font
- **➕:** mainMenu.tscn
- **➕:** start button logic
- **➕:** quit button logic
- **➕:** main menu logic
- **➕:** screenshot of main menu for README.md

## v0.8.0a (2025-09-30)

- **➕:** background tiles
- **➕:** tileset
- **➕:** new scene for apples
- **➕:** new scene for fish
- **➕:** new scene for pretzel
- **➕:** tilemap
- **❌:** background color
- **❌:** apple sprite from items.tscn
- **♻️:** changed function from ```_process``` to ```_physics_process``` for falling items
- **🚀:** item-spawner to produce an array of items
- **🚀:** pixel image recognition for apples

## v0.7.0a (2025-09-29)

- **⬆️:** project.godot
- **❌:** shaped placeholder
- **➕:** apple sprite
- **➕:** mascot sprite
- **➕:** cart sprite
- **➕:** cart asset import
- **➕:** mascot asset import

## v0.6.0a (2025-09-25)

- **➕:** mascot gd script
- **🚀:** spawner.gd to produce a mascot randomly
- **♻️:** game over logic to freeze when mascot is caught

## v0.5.1a (2025-09-24)

- **🛠️:** bug that caused items to only fall to the right side of the screen

## v0.5.0a (2025-09-21)

- **➕:** a script that will randomly spawn items
- **🐞:** that causes items to fall only on the right side of the screen
- **🚀:** randomness of falling items

## v0.4.0a (2025-09-20)

- **➕:** gd script for scoreboard
- **🚀:** the size of the scoreboard so it is easier to read

## v0.3.0a (2025-09-20)

- **➕:** item scene for falling items
- **➕:** gd script for falling items

## v0.2.1a (2025-09-19)

- **🛠️:** snytax error from ```_on_CatchZone_area_entered``` to ```_on_catch_zone_area_entered```

## v0.2.0a (2025-09-19)

- **➕:** collision shape to catch zone in cart
- **➕:** color to collision shape to separate elements
- **➕:** signal to connect cart to catch zone
- **🐞:** caused by methods not connected properly


## v0.1.0a (2025-09-16)

- **➕:** rectangle as placeholder for cart artwork
- **➕:** project directories
- **➕:** README.md
- **➕:** ROADMAP.md
- **➕:** Godot configuration setup

# Glossary

**ADDED** = ➕ **|**
**REMOVED** = ❌ **|**
**FIXED** = 🛠️ **|**
**BUG** = 🐞 **|**
**IMPROVED** = 🚀 **|**
**CHANGED** = ♻️ **|**
**SECURITY** = 🛡️ **|**
**DEPRECIATED** = ⚠️ **|**
**UPDATED** = ⬆️
