extends ParallaxBackground

var can_scroll = true

func _process(delta):
	if can_scroll:
		scroll_offset.x -= 200 * delta
		
