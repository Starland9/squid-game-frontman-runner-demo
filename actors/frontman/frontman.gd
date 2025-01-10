extends CharacterBody2D
class_name Frontman

@onready var anim = $AnimatedSprite2D

enum states {IDLE, RUN, JUMP, SHOOT, DEATH}

var state: int = states.IDLE
var move_dir: float = 1.0
var face_dir : int = 1
const GRAVITY: float = 9.8
var jump_force: float = 500
var run_speed : float = 400
var in_shoot := false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _set_state(new_state: int) -> void:
	if state != new_state:
		state = new_state
		print(states.keys()[state])

func _physics_process(delta: float) -> void:
	
	_manage_moves(delta)
	_manage_states()
	_manage_states_animations()



func _manage_moves(delta: float) -> void:
	# apply gravity
	velocity.y += GRAVITY * delta * 100

	if not in_shoot:
		move_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		face_dir = sign(move_dir) if move_dir != 0 else face_dir
		anim.flip_h = face_dir == -1

		if move_dir != 0:
			velocity.x = move_dir * run_speed
		else:
			velocity.x = move_toward(velocity.x, 0, run_speed)

		# manage jump
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_force 
		
		move_and_slide()
	
	in_shoot = Input.is_action_pressed("ui_accept")



func _manage_states() -> void:
	if is_on_floor():
		if in_shoot:
			_set_state(states.SHOOT)
		elif  move_dir != 0:
			_set_state(states.RUN)
		else:
			_set_state(states.IDLE)
	else:
		if velocity.y < 0:
			_set_state(states.JUMP)



	
func _manage_states_animations() -> void:
	match state:
		states.IDLE:
			anim.play("idle")
		states.RUN:
			anim.play("run")
		states.JUMP:
			anim.play("jump")
		states.SHOOT:
			anim.play("shoot")
		states.DEATH:
			anim.play("death")