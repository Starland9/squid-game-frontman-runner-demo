extends CharacterBody2D
class_name Greenman

@export var movable_by_input := false

@onready var anim :AnimatedSprite2D = $AnimatedSprite2D

enum states {IDLE, RUN, JUMP, KICK, PUNCH, DEATH}

var state: int = states.IDLE
var move_dir: float = 1.0
var face_dir : int = 1
const GRAVITY: float = 9.8
var jump_force: float = 500
var run_speed : float = 50
var in_kick := false
var in_punch := false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _set_state(new_state: int) -> void:
	if state != new_state:
		state = new_state

func _physics_process(delta: float) -> void:
	
	_manage_moves(delta)
	_manage_states()
	_manage_states_animations()



func _manage_moves(_delta: float) -> void:
	# apply gravity
	# velocity.y += GRAVITY * delta * 100

	if not in_kick and not in_punch and movable_by_input:
		move_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		face_dir = sign(move_dir) if move_dir != 0 else face_dir

		if move_dir != 0:
			velocity.x = move_dir * run_speed
		else:
			velocity.x = move_toward(velocity.x, 0, run_speed)

		# manage jump
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_force 
		


	else:
		move_dir = -1
		face_dir = -1
		var can_move = not Input.is_action_pressed("ui_accept")
		if can_move:
			velocity.x = move_dir * run_speed
			# velocity.y = -5

		else:
			velocity.x = move_toward(velocity.x, 0, run_speed)
			velocity.y = 0


	anim.flip_h = face_dir == -1
	move_and_slide()
	
	in_kick = Input.is_action_pressed("ui_accept")
	in_punch = Input.is_action_pressed("ui_cancel")



func _manage_states() -> void:
	if in_kick:
		_set_state(states.KICK)
	if in_punch:
		_set_state(states.PUNCH)
	elif  velocity.x != 0.0:
		_set_state(states.RUN)
	else:
		_set_state(states.IDLE)



	
func _manage_states_animations() -> void:
	match state:
		states.IDLE:
			anim.play("idle")
		states.RUN:
			anim.play("run")
		states.JUMP:
			anim.play("jump")
		states.KICK:
			anim.play("kick")
		states.DEATH:
			anim.play("death")
		states.PUNCH:
			anim.play("punch")