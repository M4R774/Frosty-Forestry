extends KinematicBody2D

export var isCut = false

onready var cut_sprite = preload("res://Sprites/tree_cut.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _process(delta):
#	position.x -= 200 * delta


func cut_down():
	$CollisionShape2D/Sprite.set_texture(cut_sprite)
	isCut = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
