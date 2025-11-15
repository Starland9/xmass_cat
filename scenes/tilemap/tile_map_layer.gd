extends Node2D
class_name TileMapGen

const floor_scene = preload("res://scenes/tilemap/floor.tscn")

@onready var floors : Node2D = $Floors

var last_floor_pos : Vector2


func gen_floor(start_pos: Vector2, size: Vector2) -> Floor:
	last_floor_pos = start_pos
	var f : Floor = floor_scene.instantiate()
	floors.add_child(f)
	f.generate(start_pos, size)
	return f
	
