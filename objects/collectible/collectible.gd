extends Area2D
class_name Collectible

signal picked


func _ready() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_loops(-1)
	tween.tween_property(self, "position:y", position.y + 5, .5).set_ease(Tween.EASE_IN_OUT).as_relative()
	tween.tween_property(self, "position:y", position.y - 5, .5).set_ease(Tween.EASE_IN_OUT).as_relative()
	

func _on_body_entered(body: Node2D) -> void:
	if body is Cat:
		on_picked(body)

func on_picked(body: Cat):
	var final_x_pos := (get_viewport().get_camera_2d().global_position.x - get_viewport().get_camera_2d().position.x * 1.2) + 50
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(final_x_pos, 32), .7).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
	tween  .parallel().tween_property(self, "rotation", deg_to_rad(360), .7).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT).as_relative()
	
	tween.tween_callback(picked.emit)
	tween.tween_callback(body.picked_collectible.emit)
	tween.tween_callback(queue_free)
	
	
	
