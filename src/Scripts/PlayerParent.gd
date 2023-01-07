extends Node2D

var speed = 200
var can_scroll = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if can_scroll:
		position.x += speed * delta


func _on_Player_rock_hit():
	can_scroll = false
	$HitRockDelay.start()


func _on_HitRockDelay_timeout():
	can_scroll = true
