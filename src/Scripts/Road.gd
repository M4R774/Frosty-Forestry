extends ParallaxBackground

var can_scroll = true
export var increase_accelleration = true
var speed = 0
var accelleration = 1


func _ready():
	speed = get_node("..").speed

#func _process(delta):
#	if can_scroll:
#		scroll_offset.x -= speed * delta * accelleration
#		if increase_accelleration:
#			accelleration += 0.1 * delta
