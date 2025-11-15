extends CanvasLayer
class_name HUD

@onready var label_time := $Control/MarginContainer/Time
@onready var label_collectible := $Control/MarginContainer/HSplitContainer/Label

func set_time(time: int):
	label_time.text = str(time)

func set_collectible_count(count: int):
	label_collectible.text = "X " + str(count)


func _on_collectible_area_area_entered(area: Area2D) -> void:
	print(area)


func _on_collectible_area_body_entered(body: Node2D) -> void:
	print(body)
