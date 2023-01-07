extends Node

var score = 0
onready var tree_scene = preload("res://Scenes/Tree.tscn")
onready var rock_scene = preload("res://Scenes/Rock.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# for debugging
	if Input.is_action_just_pressed("jump"):
		spawn_tree()


func spawn_tree():
	var spawn_position = Vector2(1200, rand_range(300, 550))
	var tree = tree_scene.instance()
	tree.position = spawn_position
	add_child(tree)
	move_child(tree, 2)
	#print("tree spawned to pos ", spawn_position)


func spawn_rock():
	var spawn_position = Vector2(1200, rand_range(300, 550))
	var rock = rock_scene.instance()
	rock.position = spawn_position
	add_child(rock)
	move_child(rock, 2)


func _on_TreeSpawner_timeout():
	spawn_tree()


func _on_RockSpawner_timeout():
	spawn_rock()


func _on_Player_tree_cut():
	score += 1

