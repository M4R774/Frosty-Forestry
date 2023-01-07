extends Label

var goal = 5
var _timer = null


func _init():
	text = "Boss wants: %s!!" % goal


func _ready():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(3.2)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _on_Timer_timeout():
	goal += 1
	text = "Boss wants: %s!!" % goal
