extends Node2D

export var speed = 200
var can_scroll = true
var lives = 4
onready var life_sprites = [$UserInterface/Lives/Life0, $UserInterface/Lives/Life1, $UserInterface/Lives/Life2]
var blink_counter = 1


func update_z_level():
	z_index = $Player.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if can_scroll:
		position.x += speed * delta
	if blink_counter < 1:
		blink_counter += delta
		var sinTime = sin(blink_counter * 15)
		flashText(delta, sinTime)
	update_z_level()


func _on_Player_rock_hit():
	lives -= 1
	blink_counter = 0
	can_scroll = false
	$HitRockSound.play()
	if lives > 0:
		$HitRockDelay.start()
	elif lives == 0:
		$UserInterface/GoalLabel.end_game(false)
		$OutOfLivesSound.play()


func _on_HitRockDelay_timeout():
	can_scroll = true
	$Player.can_move = true
	$Player/NoSawBladeSprite.visible = false
	$Player/AnimatedSprite.visible = true


func deactive_controls():
	$Player.can_move = false
	$Player/CollisionShape2D.set_deferred("disabled", true)


func flashText(delta, sinTime):
	var _visible = false
	if sinTime > 0:
		_visible = false
		blink_counter += delta
	else:
		_visible = true
	life_sprites[lives - 1].visible = _visible
