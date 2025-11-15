extends Control
class_name Home

@onready var tap_to_play_label := $TextureRect/TapToPlay

func _ready() -> void:
	pass



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			get_tree().change_scene_to_file("res://scenes/main/main.tscn")
