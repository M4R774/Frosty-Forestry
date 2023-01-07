extends ParallaxBackground

onready var dirt_sprite = preload("res://Sprites/dirt.png")
onready var snow_sprite = preload("res://Sprites/snow.png")

var can_scroll = true
export var increase_accelleration = true
var speed = 0
var accelleration = 1
var level = "snow"


func _ready():
	speed = get_node("..").speed


func change_level():
	if level == "snow":
		$"/root/Main/ParallaxBackground/Road/Sprite".set_texture(dirt_sprite)
		level = "dirt"
	else:
		$"/root/Main/ParallaxBackground/Road/Sprite".set_texture(snow_sprite)
		level = "snow"
