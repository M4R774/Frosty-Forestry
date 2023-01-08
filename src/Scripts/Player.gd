extends Area2D

signal tree_cut
signal rock_hit

export var speed = 400
var screen_size
var can_move = true
var can_saw = true
export var saw_cooldown = 1
onready var sprites = [preload("res://Sprites/traktor.png"), preload("res://Sprites/traktor_no_saw.png")]


func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.animation = "saw"
	$AnimatedSprite.play()
	$AnimatedSprite.speed_scale = 0.25


func _process(delta):
	var velocity = Vector2.ZERO
	if can_move:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		
		if Input.is_action_just_pressed("activate_saw") and can_saw:
			can_saw = false
			$Saw.monitoring = true
			# Play saw animation
			#$CollisionShape2D/AnimatedSprite.animation = "saw"
			#$CollisionShape2D/AnimatedSprite.play()
			$AnimatedSprite.speed_scale = 1
			$SawActive.start()
			get_node("ChainsawSound").play()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position.x = clamp(position.x, -350, 500)
	var road = get_node("/root/Main/ParallaxBackground/Road/Sprite")
	var hud_size_y = get_node("/root/Main/YSort/Player/UserInterface/ColorRect").rect_size.y
	var road_height_in_pixels = road.texture.get_height() * road.scale.y
	var road_upper_limit = road.get_global_position().y - road_height_in_pixels - 15
	var road_lower_limit = road.get_global_position().y + road_height_in_pixels - hud_size_y + 35
	position.y = clamp(position.y, road_upper_limit, road_lower_limit)


func _on_Player_body_entered(body):
	if body.is_in_group("rock"):
		body.break_rock()
		emit_signal("rock_hit")
		can_move = false
	elif body.is_in_group("car"):
		emit_signal("rock_hit")
		body.break_car()


func _on_SawActive_timeout():
	$ChainsawSound.stop()
	$SawCooldown.start(saw_cooldown)
	$Saw.monitoring = false
	# Stop saw animation
	$AnimatedSprite.stop()


func _on_SawCooldown_timeout():
	#$CollisionShape2D/Sprite.set_texture(sprites[0])
	can_saw = true
	$AnimatedSprite.animation = "saw"
	$AnimatedSprite.play()
	$AnimatedSprite.speed_scale = 0.25


func _on_Saw_body_entered(body):
	# TODO: Auton kanssa sopivaksi
	if body.is_in_group("tree") and not body.isCut:
		pass
		#print("tree hit")
		body.cut_down()
		emit_signal("tree_cut")
		$"/root/Main/YSort/Player/UserInterface/ScoreLabel".increment_score()

