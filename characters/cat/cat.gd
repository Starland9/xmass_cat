extends CharacterBody2D
class_name Cat

signal die
@warning_ignore("unused_signal")
signal picked_collectible

enum State {
	ATTACK,
	JUMP,
	RUN
}

@onready var anim := $AnimatedSprite2D
@onready var jump_sound := $Sounds/JumpSound

const GRAVITY := 9.8   

var _current_state := State.RUN
var _jump_force := 200
var _run_speed := 100

var jump_factor := 1.0
var _speed_factor := 1.0


func _physics_process(_delta: float) -> void:
	_apply_gravity()
	_run()
	_manage_inputs()
	_manage_state()
	
	
	move_and_slide()
	
	_die()
	
	
func _apply_gravity():
	velocity.y += GRAVITY
	
func _run():
	velocity.x = _run_speed * _speed_factor

func _manage_inputs():
	if Input.is_action_just_pressed("jump"):
		_jump()
	
	if Input.is_action_just_pressed("attack"):
		_attack()
		
func _jump():
	if is_on_floor():
		jump_sound.play()
		velocity.y -= _jump_force * jump_factor
		_speed_factor += .1
	
		
func _die():
	if global_position.y > 400:
		die.emit()
		
func _attack():
	_set_state(State.ATTACK)
	
func _manage_state():
	if not is_on_floor():
		_set_state(State.JUMP)
	else:
		if not _current_state == State.ATTACK:
			_set_state(State.RUN)
		
		
func _set_state(state: State):
	if not _current_state == state:
		_current_state = state
		_update_anim()
	

func _update_anim():
	match _current_state:
		State.RUN:
			anim.play("run")
			
		State.JUMP:
			anim.play("jump")
			
		State.ATTACK:
			anim.play("attack")


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack" and _current_state == State.ATTACK:
		_set_state(State.RUN)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			_jump()
