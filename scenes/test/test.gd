extends Node2D


@onready var greens = $Grennmans
@onready var greens_spawn : Line2D = $SpawnArea

const greenman_scene = preload("res://actors/greenman/greenman.tscn");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	_fill_greenmans()

func _fill_greenmans():
	var points := greens_spawn.points;
	print(points)

	for i in range(30):
		var speed_scale := randf()

		var gm = greenman_scene.instantiate()
		greens.get_parent().add_child(gm)
		# gm.global_position = _get_random_point_along_line(
			# points[0], points[1]
		# )
		gm.scale = Vector2.ONE * 0.1
		gm.run_speed *= speed_scale
		gm.run_speed = clampf(gm.run_speed, 10, 30)
		gm.anim.speed_scale *= speed_scale


func _get_random_point_in_rect(p1: Vector2, p2: Vector2, p3: Vector2, p4:Vector2) -> Vector2:
	# var area := 0.5 * absf((p1.x * p2.y + p2.x * p3.y + p3.x * p4.y + p4.x * p1.y) - (p2.x * p1.y + p3.x * p2.y + p4.x * p3.y + p1.x * p4.y)) 
	var u := randf()

	if u < 0.25:
		var v := randf()
		return Vector2(
			p1.x + v * (p2.x - p1.x),
			p1.y + v * (p2.y - p1.y)
		)
	if u < 0.5:
		var v:= randf()
		return Vector2(
			p2.x + v * (p3.x - p2.x),
			p2.y + v * (p3.y - p2.y)
		)
	if u < 0.75:
		var v := randf()
		return Vector2(
			p3.x + v * (p4.x - p3.x),
			p3.y + v * (p4.y - p3.y)
		)
	else:
		var v := randf()
		return Vector2(
			p4.x + v * (p1.x - p4.x),
			p4.y + v - (p1.y - p4.y)
		)


func _get_random_point_along_line(p1: Vector2, p2: Vector2) -> Vector2:
	var u := randf()
	return Vector2(
		p1.x + u * (p2.x - p1.x),
		p1.y + u * (p2.y - p1.y)
	)