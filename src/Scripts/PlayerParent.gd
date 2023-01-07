extends Node2D

var speed = 200
var can_scroll = true
var lives = 3
onready var life_sprites = [$UserInterface/Lives/Life0, $UserInterface/Lives/Life1, $UserInterface/Lives/Life2]
var blink_counter = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if can_scroll:
		position.x += speed * delta
	if blink_counter < 1:
		blink_counter += delta
		var sinTime = sin(blink_counter * 15)
		flashText(delta, sinTime)


func _on_Player_rock_hit():
	can_scroll = false
	$HitRockDelay.start()
	$HitRockSound.play()
	lives -= 1
	#life_sprites[lives].visible = false
	blink_counter = 0
	if lives == 0:
		$OutOfLivesSound.play()
		$GameOverDelay.start()


func _on_HitRockDelay_timeout():
	can_scroll = true
	$Player.can_move = true


func _on_GameOverDelay_timeout():
	if get_tree().reload_current_scene() != OK:
			print("cannot reload current scene")


func flashText(delta, sinTime):
	var _visible = false
	if sinTime > 0:
		_visible = false
		blink_counter += delta
	else:
		_visible = true
	life_sprites[lives].visible = _visible
