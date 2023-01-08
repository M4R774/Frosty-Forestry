extends RichTextLabel


var goal = 100
var _timer = null
var blink_counter = 1


func _init():
	text = "Boss wants: %s ?!" % goal


func end_game(win):
	$"../..".deactive_controls()
	var old_camera = $"../..".get_node("Camera2D")
	var new_camera = $"../../../../EndGameCamera"
	new_camera.position.x = $"../..".position.x
	new_camera.current = true
	$"..".visible = false
	if win:
		# preventing an edge case where player has enough trees but no lives
		if $"../..".lives > 0:
			$"../../../../EndGameCamera/WinText".visible = true
			$WinDelay.start()
	else:
		$"../../../../EndGameCamera/LoseText".visible = true
		$LoseDelay.start()
	#get_parent().remove_child(new_camera)
	#$"../../../..".add_child(new_camera)


# debugging end game
#func _process(_delta):
#	if Input.is_action_just_pressed("jump"):
#		end_game()


func _on_Timer_timeout():
	if $"/root/Main/YSort/Player/UserInterface/ScoreLabel".score >= goal:
		end_game(true)
	goal += 3 # was 1
	text = "Boss wants: %s ?!" % goal
	blink_counter = 0


func flashText(delta, sinTime):
	var _visible = true
	if sinTime > 0:
		_visible = true
		blink_counter += delta
	else:
		_visible = false
	visible = _visible


func _physics_process(delta):
	if blink_counter < 1:
		blink_counter += delta
		var sinTime = sin(blink_counter * 15)
		flashText(delta, sinTime)


func _on_StartDelay_timeout():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(3.2)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _on_WinDelay_timeout():
	if get_tree().change_scene("res://Scenes/Main Menu.tscn") != OK:
		print("Cannot load Main Menu scene")


func _on_LoseDelay_timeout():
	if get_tree().reload_current_scene() != OK:
		print("cannot reload current scene")
