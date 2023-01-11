extends Area2D

signal tree_cut
signal rock_hit
signal saw_ready
signal saw_not_ready

export var speed = 400
var screen_size
var can_move = true
var can_saw = true
export var saw_cooldown = 1
onready var sprites = [preload("res://Sprites/traktor.png"), preload("res://Sprites/traktor_no_saw.png")]

# touch controls
export var is_using_touch_controls = false
var target_pos = Vector2(0, 0)
var direction
var duration
var time_elapsed = 0
var distance_from_beginning = 0
var is_going_left = false
var is_going_right = false
var is_going_up = false
var is_going_down = false

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.animation = "saw"
	$AnimatedSprite.play()
	$AnimatedSprite.speed_scale = 0.25
	# saw ui
	$"../UserInterface/AnimatedSprite".animation = "default"
	$"../UserInterface/AnimatedSprite".set_frame(0)
	# touch controls
	target_pos = global_position


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

		if Input.is_action_just_pressed("activate_saw"):
			activate_saw()
			
		# touch controls
		if is_using_touch_controls and target_pos != null:
			target_pos.x +=  $"..".speed * delta
			var distance = global_position.distance_to(target_pos)
			if distance > 5:
				pass
#				global_position = global_position.linear_interpolate(target_pos, time_elapsed / duration)
#				#lerp(global_position, target_pos, 2 * delta)
#				#print("trying to get to pos")
#				time_elapsed += delta
			else:
#				#print("got to pos")
				global_position = target_pos
				target_pos = null
#				time_elapsed = 0
			if target_pos != null:
				direction = target_pos - global_position
				velocity = direction
#			if is_going_right:
#				velocity.x += 1
#			if is_going_left:
#				velocity.x -= 1
#			if is_going_down:
#				velocity.y += 1
#			if is_going_up:
#				velocity.y -= 1
	
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
	#print(road_upper_limit, " ", road_lower_limit)
	
	distance_from_beginning = $"..".speed * delta

func _input(event):
	if event is InputEventScreenTouch and is_using_touch_controls:
		if event.is_pressed():
			# don't let player move if chainsaw button is pressed
			# button approx pos starts at 845 470
			if check_touch_pos(event.position):
				target_pos = get_global_mouse_position()
				target_pos.x += distance_from_beginning
				#target_pos.x = clamp(target_pos.x, -350, 500)
				target_pos.y = clamp(target_pos.y, 251, 484)
				duration = global_position.distance_to(target_pos) / (speed * 0.1)
				time_elapsed = 0
				#print(event.position)
		else: 
			target_pos = null
	if event is InputEventScreenDrag and is_using_touch_controls:
		if check_touch_pos(event.position):
			target_pos = get_global_mouse_position()
			target_pos.x += distance_from_beginning
			#target_pos.x = clamp(target_pos.x, -350, 500)
			target_pos.y = clamp(target_pos.y, 251, 484)
			duration = global_position.distance_to(target_pos) / (speed * 0.1)
			time_elapsed = 0
			#print(event.position)


func check_touch_pos(pos):
	var can_move_to_pos
	if pos.x < 845 and pos.y < 470:
		can_move_to_pos = true
	elif pos.x > 845 and pos.y < 470:
		can_move_to_pos = true
	elif pos.x < 845 and pos.y > 470:
		can_move_to_pos = true
	else:
		can_move_to_pos = false
	return can_move_to_pos
	
	
func activate_saw():
	if can_saw:
		$"../UserInterface/ChainsawIndicator".visible = false
		can_saw = false
		$Saw.monitoring = true
		# Play saw animation
		#$CollisionShape2D/AnimatedSprite.animation = "saw"
		#$CollisionShape2D/AnimatedSprite.play()
		$AnimatedSprite.speed_scale = 1
		$SawActive.start()
		get_node("ChainsawSound").play()
		$"../UserInterface/AnimatedSprite".set_frame(1)


func _on_Player_body_entered(body):
	if body.is_in_group("rock"):
		body.break_rock()
		emit_signal("rock_hit")
		can_move = false
		$NoSawBladeSprite.visible = true
		$AnimatedSprite.visible = false
	elif body.is_in_group("car"):
		emit_signal("rock_hit")
		body.break_car()
		$NoSawBladeSprite.visible = true
		$AnimatedSprite.visible = false


func _on_SawActive_timeout():
	$ChainsawSound.stop()
	$SawCooldown.start(saw_cooldown)
	$Saw.monitoring = false
	# Stop saw animation
	$AnimatedSprite.stop()
	# start ui animation
	$"../UserInterface/AnimatedSprite".animation = "cooldown"
	$"../UserInterface/AnimatedSprite".play()


func _on_SawCooldown_timeout():
	#$CollisionShape2D/Sprite.set_texture(sprites[0])
	$"../UserInterface/ChainsawIndicator".visible = true
	can_saw = true
	$ChainsawReadySound.play()
	$AnimatedSprite.animation = "saw"
	$AnimatedSprite.play()
	$AnimatedSprite.speed_scale = 0.25
	$"../UserInterface/AnimatedSprite".stop()
	$"../UserInterface/AnimatedSprite".animation = "default"
	$"../UserInterface/AnimatedSprite".set_frame(0)


func _on_Saw_body_entered(body):
	if body.is_in_group("tree") and not body.isCut:
		pass
		#print("tree hit")
		body.cut_down()
		emit_signal("tree_cut")
		$"/root/Main/YSort/Player/UserInterface/ScoreLabel".increment_score()
