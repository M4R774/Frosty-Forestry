extends CPUParticles2D

export (NodePath) var playerNodePath

func _process(delta):
	var playerPosition = get_node(playerNodePath).get_position();
	self.position = playerPosition

