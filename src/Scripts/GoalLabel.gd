extends RichTextLabel


var goal = 50
var _timer = null
var blink_counter = 1


func _init():
	text = "Boss wants: %s ?!" % goal


func end_game():
	if get_tree().change_scene("res://Scenes/Main Menu.tscn") != OK:
		print("Cannot load Main Menu scene")


func _ready():
	pass


func _on_Timer_timeout():
	if $"/root/Main/YSort/Player/UserInterface/ScoreLabel".score >= goal:
		end_game()
	goal += 5 # was 1
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
