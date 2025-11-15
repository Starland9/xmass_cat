# Xmass Cat - Godot 4.5 Mobile Game

## Project Architecture

This is an endless runner platformer game built with **Godot 4.5** targeting mobile (Android). The game features procedural floor generation where a cat character runs indefinitely, jumping between platforms and collecting items.

### Core Components

- **Main Scene** (`scenes/main/main.tscn`) - Orchestrates the game loop, manages floor generation/deletion, and coordinates between systems
- **Cat Player** (`characters/cat/cat.gd`) - CharacterBody2D with state machine (RUN, JUMP, ATTACK) and accelerating movement
- **Procedural Generation** (`scenes/tilemap/`) - Dynamic floor spawning/despawning based on camera position
- **AtlasManager** (Autoload) - Singleton providing tile atlas configurations for all floor types (`scripts/atlas_manager.gd`)

### Key Architectural Patterns

#### 1. Procedural Floor Generation System
The game uses an infinite generation pattern in `main.gd`:
- Floors are generated ahead of camera viewport (900px threshold)
- Old floors are deleted when 500px behind camera
- Each `Floor` instance is a `TileMapLayer` that builds itself from atlas coordinates
- Random gap distances (`randi() % 3`) and vertical positions (`randi_range(6, 9)`) create difficulty

#### 2. Atlas-Based Tile System
`AtlasManager.Floors` provides static configurations (see `atlas_manager.gd`):
```gdscript
var atlas = AtlasManager.Floors.simple  // Access predefined atlas configs
atlas.top_left, atlas.middle_center(), atlas.bottom_right()  // 9-position system
```
All floors use a 3x3 (or 2x4) grid pattern with corner/edge/center tile positioning.

#### 3. Signal-Driven Communication
- `Cat.die` signal → `main.gd` reloads scene via `get_tree().reload_current_scene()`
- `Cat.picked_collectible` + `Collectible.picked` signals → HUD updates
- Collectibles animate to HUD position before emitting pickup signals

#### 4. Increasing Difficulty
The cat's `_speed_factor` increases by 0.5 on every jump, creating acceleration. The `jump_factor` is set to 1.7 in `main.gd` when generating floors to match platform gaps.

## Godot-Specific Conventions

### File Structure
- `.gd` scripts always paired with `.tscn` scene files in the same directory
- `.uid` files are Godot's unique identifiers - never modify manually
- `project.godot` defines the main scene as `uid://ddk3xk7amgq3e` (main.tscn)

### Class Naming
Use `class_name` for types that need global access:
```gdscript
extends CharacterBody2D
class_name Cat  # Now usable in type hints: func foo(cat: Cat)
```

### Node References
Use `@onready` for child node references (runs after `_ready()`):
```gdscript
@onready var anim := $AnimatedSprite2D  # Type inferred
@onready var cat : Cat = $Cat  # Explicit type
```

### Input Handling
Project uses both polling and event-based input:
- **Polling**: `Input.is_action_just_pressed("jump")` in `_physics_process()`
- **Events**: `_input(event)` for mouse clicks (mobile tap support)
- Input actions defined in `project.godot` under `[input]` section

## Development Workflows

### Running the Game
Open `project.godot` in Godot Editor (4.5+). Main scene auto-loads. Use F5 to run or F6 for current scene.

### Android Export
Configuration in `export_presets.cfg`:
- Target: ARM64 only (`architectures/arm64-v8a=true`)
- Package: `org.starland9.xmasscat`
- Export generates to `./Xmass Cat.apk`
- Full Android build setup in `android/build/` (Gradle wrapper included)

### Testing Physics
Gravity constant: `GRAVITY := 9.8` in `cat.gd`
Jump force: `_jump_force := 200` with `jump_factor := 1.7` multiplier
Floor death boundary: `global_position.y > 400`

## Critical Implementation Details

### Collectible Animation Pattern
When picked (see `collectible.gd`):
1. Tween to HUD position (calculated from camera viewport)
2. Parallel rotation animation (360° spin)
3. Chain callbacks: `emit picked → emit body.picked_collectible → queue_free()`

This pattern ensures signals fire before deletion.

### Camera-Relative Positioning
```gdscript
var final_x_pos := (get_viewport().get_camera_2d().global_position.x 
                    - get_viewport().get_camera_2d().position.x * 1.2) + 50
```
Camera position adjustments account for viewport stretch mode (`canvas_items`).

### State Machine Pattern
See `cat.gd` for standard Godot state machine:
```gdscript
enum State { ATTACK, JUMP, RUN }
func _manage_state(): # Evaluates conditions
func _set_state(state: State): # Updates if changed
func _update_anim(): # Match state to animation
```
Attack state returns to RUN via `_on_animated_sprite_2d_animation_finished()` signal.

## Common Pitfalls

1. **Don't preload scenes in hot paths** - Use `const scene = preload()` at class level (see `floor.gd`)
2. **Viewport size is 640x360** - All UI/positioning assumes this resolution with canvas_items stretch
3. **Pixel art settings** - `textures/canvas_textures/default_texture_filter=0` (nearest neighbor), `snap_2d_transforms_to_pixel=true`
4. **Mobile rendering** - Uses `mobile` rendering method, ASTC/ETC2 compression enabled

## Key Files Reference

- `project.godot` - Engine configuration, autoloads, input maps
- `scenes/main/main.gd` - Game orchestration and generation logic
- `scripts/atlas_manager.gd` - Tile atlas definitions (FloorAtlas class)
- `characters/cat/cat.gd` - Player physics and state management
- `.gitignore` - Excludes `.godot/`, `android/`, `exports/`, `*.import`
