extends KinematicBody2D

export var isCut = false

onready var cut_sprite = preload("res://Sprites/tree_cut.png")
onready var broken_sprite = preload("res://Sprites/rock_broken.png")


#func _process(delta):
#	if $"/root/Main/ParallaxBackground".can_scroll:
#		position.x -= $"/root/Main".speed * delta * $"/root/Main/ParallaxBackground".accelleration


func cut_down():
	$CollisionShape2D/Sprite.set_texture(cut_sprite)
	isCut = true


func break_rock():
	$CollisionShape2D/Sprite.set_texture(broken_sprite)
	#if $CollisionShape2D:
	$CollisionShape2D.set_deferred("disabled", true)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
