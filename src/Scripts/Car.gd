extends KinematicBody2D

export var speed : int = 150
var can_move = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _process(delta):
	if can_move:
		position.x -= speed * delta


func break_car():
	can_move = false
	$CollisionShape2D.set_deferred("disabled", true)
