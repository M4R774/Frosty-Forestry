extends Node

onready var tree_scene = preload("res://Scenes/Tree.tscn")
onready var rock_scene = preload("res://Scenes/Rock.tscn")
onready var tree_layer = $ParallaxBackground/Trees
var spawn_x = 1200
var speed


func _ready():
	randomize()


func _process(delta):
	spawn_x += 200 * delta * $ParallaxBackground.speed
	# for debugging


func spawn_tree():
	var spawn_position = Vector2(int(spawn_x), rand_range(300, 550))
	var tree = tree_scene.instance()
	tree.position = spawn_position
	tree_layer.add_child(tree)
	#print("tree spawned to pos ", spawn_position)


func spawn_rock():
	var spawn_position = Vector2(int(spawn_x), rand_range(300, 550))
	var rock = rock_scene.instance()
	rock.position = spawn_position
	tree_layer.add_child(rock)


func _on_TreeSpawner_timeout():
	spawn_tree()


func _on_RockSpawner_timeout():
	spawn_rock()


func _on_Player_tree_cut():
	$UserInterface/ScoreLabel.increment_score()


func _on_Player_rock_hit():
	$ParallaxBackground.can_scroll = false
	$HitRockDelay.start()


func _on_HitRockDelay_timeout():
	$ParallaxBackground.can_scroll = true

