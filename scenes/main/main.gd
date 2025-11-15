extends Node2D


@onready var cat : Cat = $Cat
@onready var tilemap : TileMapGen = $TileMap
@onready var cam : Camera2D = $Cat/Camera2D
@onready var hud : HUD = $HUD
@onready var picked_sound := $PickedSound

var tile_start_pos := Vector2(0, 8)
var tile_size := Vector2(4, 4)
var current_floors : Array[Floor] = []
var current_time := 0
var collectible_count := 0




func _ready() -> void:
	_add_floor()

func _process(_delta: float) -> void:
	_gen_floor()
	_delete_hidden_floors()

func _add_floor():
	var f := tilemap.gen_floor(tile_start_pos, tile_size)
	current_floors.append(f)
	tile_start_pos.x = f.end_pos.x + randi() % 3
	tile_start_pos.y  = randi_range(6, 9)
	
	tile_size.x = randi() % 10 + 20
	tile_size.y = 12 - tile_start_pos.y
	cat.jump_factor = 1.7
	

func _gen_floor():
	var last_floor = current_floors[-1]
	var d = last_floor.global_end_pos().x - cam.global_position.x + cam.get_viewport_rect().size.x

	if d < 900:
		_add_floor()

func _delete_hidden_floors():
	for f : Floor in current_floors:
		var end_pos = f.global_end_pos()
		var d = cam.global_position.x - end_pos.x
		if d > 500:
			f.queue_free()
			current_floors.erase(f)


func _on_cat_die() -> void:
	var __ = get_tree().reload_current_scene()


func _on_game_timer_timeout() -> void:
	current_time += 1
	hud.set_time(current_time)


func _on_cat_picked_collectible() -> void:
	picked_sound.play()
	collectible_count += 1
	hud.set_collectible_count(collectible_count)
	
