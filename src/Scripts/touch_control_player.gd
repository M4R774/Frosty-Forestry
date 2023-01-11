extends Area2D

export (int) var speed = 200

var target_pos = Vector2(0, 0)

func _ready():
	target_pos = global_position

func _input(event):
	if event.is_action_pressed('touch'):
		target_pos = get_global_mouse_position()

func _physics_process(delta):
	print(global_position)
	target_pos.x += speed * delta
	if !is_equal_approx(global_position.x, target_pos.x):
		global_position = lerp(global_position, target_pos, 5 * delta)
