# Untitled Goblin Project <br />
## Prototype of a top-down ARPG, inspired by Gothic/Risen series <br />

## How to Install:
1. Open Godot_v3.5.2-stable_win64
1. Click "Import"
1. Navigate to GitHub Game Demo/Untitled Goblin Project/project.godot
1. Click "Import & Edit"
1. Once loaded into the editor, press F5 (or click the "Play" button in top-right) to run the game

## Tips:

Weapons and armor are only equipped once you hide the inventory (press TAB again)<br />
Enemies will try to pathfind to their destination using the NavPolygon<br />
Walking backwards is 1/3 slower than normal, walking with your weapon wound up is 5 times slower<br />
The player can't die yet, but you get a cool vignette as your health gets closer to zero ;)<br />
You can freely aim with ranged weapons when wound up, but not melee weapons

## Controls <br />
**WASD** – Movement <br />
**LMB** – Attack <br />
**Shift** - Sprint <br />
**Space** – Dash <br />
**F** – Interact <br />
**Tab** – Inventory <br />
**C** – Character Sheet <br />
**J** – Quest Jounral <br />
**L** – Lorebook <br />
**M** – Map (not implemented yet) <br />
<br />
## Inventory Controls <br />
**LMB** – Drag and Drop <br />
**CTRL** + **LMB** – Quick transfer (containers only) <br />
**Shift** when dropping an item – Split stack <br />
<br />
## Known Bugs <br />
Enemies don't try to avoid each other <br />
Projectiles pass through tilemap collisions (but not props) <br />