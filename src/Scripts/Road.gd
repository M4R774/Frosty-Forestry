extends ParallaxBackground

var can_scroll = true
var speed = 1

func _process(delta):
	if can_scroll:
		scroll_offset.x -= 200 * delta * speed
		speed += 0.1 * delta
