extends CharacterBody2D
class_name Chicken

@onready var anim := $AnimatedSprite2D
@onready var cocot_audio := $Cocot
@onready var chicken_shape := $CollisionShape2D

const GRAVITY := 9.8
var cat : Cat
var speed := 50

func _ready() -> void:
	anim.play("run")

func _process(_delta: float) -> void:
	velocity.y += GRAVITY
	_chasse_player()
	
	move_and_slide()

func die():
	chicken_shape.queue_free()
	var tween := create_tween()
	tween.tween_property(self, "rotation_degrees", 360, 1)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 1)
	#tween.parallel().tween_property(self, "position", Vector2(position.x + randf_range(-100, 100), -100), 1)
	
	tween.tween_callback(queue_free)

func _on_vision_area_body_entered(body: Node2D) -> void:
	if body is Cat:
		cat = body
		cocot_audio.play()
		
func _chasse_player():
	if not cat: return
	
	var dir = -1 if global_position.x - cat.global_position.x > 0 else 1
	velocity.x = speed * dir
	anim.flip_h = dir > 0
	

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body is Cat:
		cat = null
