extends Label

var goal = 50
var _timer = null


func _init():
	text = "Boss wants: %s ?!" % goal


func end_game():
	if get_tree().change_scene("res://Scenes/Main Menu.tscn") != OK:
		print("Cannot load Main Menu scene")


func _ready():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(3.2)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _on_Timer_timeout():
	if $"/root/Main/YSort/Player/UserInterface/ScoreLabel".score >= goal:
		end_game()
	goal += 5 # was 1
	text = "Boss wants: %s ?!" % goal
