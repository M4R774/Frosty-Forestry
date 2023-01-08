extends KinematicBody2D

export var speed : int = 150

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _process(delta):
	position.x -= speed * delta
