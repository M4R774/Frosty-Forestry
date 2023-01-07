extends Node

onready var tree_scene = preload("res://Scenes/Tree.tscn")
onready var rock_scene = preload("res://Scenes/Rock.tscn")
onready var tree_layer = $YSort
var spawn_x = 1200
var tree_spawn_rate = 1
var rock_spawn_rate = 4.75
export var speed = 200
export (NodePath) var playerNodePath = ""

func _ready():
	randomize()


func spawn_tree():
	var playerPosition : Vector2 = get_node(playerNodePath).get_position()
	var spawn_position = Vector2(int(playerPosition.x + spawn_x), rand_range(300, 500))
	var tree = tree_scene.instance()
	tree.position = spawn_position
	tree_layer.add_child(tree)
	print("tree spawned to pos ", spawn_position)


func spawn_rock():
	var playerPosition : Vector2 = get_node(playerNodePath).get_position()
	var spawn_position = Vector2(int(playerPosition.x + spawn_x), rand_range(300, 500))
	var rock = rock_scene.instance()
	rock.position = spawn_position
	tree_layer.add_child(rock)


func _on_TreeSpawner_timeout():
	spawn_tree()
	$TreeSpawner.start(tree_spawn_rate / $ParallaxBackground.accelleration)


func _on_RockSpawner_timeout():
	spawn_rock()
	$RockSpawner.start(rock_spawn_rate / $ParallaxBackground.accelleration)

