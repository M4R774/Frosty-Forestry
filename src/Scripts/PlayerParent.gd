extends Node2D

var speed = 200
var can_scroll = true
var lives = 3
onready var life_sprites = [$UserInterface/Lives/Life0, $UserInterface/Lives/Life1, $UserInterface/Lives/Life2]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if can_scroll:
		position.x += speed * delta


func _on_Player_rock_hit():
	can_scroll = false
	$HitRockDelay.start()
	lives -= 1
	life_sprites[lives].visible = false
	if lives == 0:
		if get_tree().reload_current_scene() != OK:
			print("cannot reload current scene")


func _on_HitRockDelay_timeout():
	can_scroll = true
	$Player.can_move = true
