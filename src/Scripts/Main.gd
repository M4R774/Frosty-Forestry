extends Node

onready var tree_scene = preload("res://Scenes/Tree.tscn")
onready var rock_scene = preload("res://Scenes/Rock.tscn")
onready var car_scene = preload("res://Scenes/Car.tscn")
onready var road_scene = preload("res://Scenes/Road.tscn")
onready var tree_layer = $YSort
var spawn_x = 600
export var tree_spawn_rate = 1.0
export var rock_spawn_rate = 4.75

export var road_mode_toggle_rate = 30
export var road_mode_duration = 15
export var road_mode_transition_delay = 2
export var car_spawn_rate = 2
export var road_tile_spawn_rate = .3

export var speed = 200
export (NodePath) var playerNodePath = ""

var road_mode_is_active : bool = false
var transition_ongoing : bool = false


func _ready():
	randomize()
	$RoadModeToggler.start(road_mode_toggle_rate)


func spawn_tree():
	var playerPosition : Vector2 = get_node(playerNodePath).get_position()
	var spawn_position = Vector2(int(playerPosition.x + spawn_x), rand_range(270, 470))
	var tree = tree_scene.instance()
	tree.position = spawn_position
	tree.z_as_relative = false
	tree.z_index = spawn_position.y
	tree_layer.add_child(tree)
	#print("tree spawned to pos ", spawn_position)


func spawn_rock():
	var playerPosition : Vector2 = get_node(playerNodePath).get_position()
	var spawn_position = Vector2(int(playerPosition.x + spawn_x), rand_range(270, 470))
	var rock = rock_scene.instance()
	rock.position = spawn_position
	rock.z_as_relative = false
	rock.z_index = spawn_position.y
	tree_layer.add_child(rock)


func _on_TreeSpawner_timeout():
	if !road_mode_is_active and !transition_ongoing:
		spawn_tree()
	$TreeSpawner.start(tree_spawn_rate)


func _on_RockSpawner_timeout():
	if !road_mode_is_active and !transition_ongoing:
		spawn_rock()
	$RockSpawner.start(rock_spawn_rate)

# starts road mode
func _on_RoadModeToggler_timeout():
	$RoadModeToggler/RoadModeTransition.start(road_mode_transition_delay)
	$RoadModeToggler/StopRoadMode.start(road_mode_duration)
	transition_ongoing = true
	road_mode_is_active = true
#	if road_mode_is_active:
#		road_mode_is_active = false
#	else:
#		road_mode_is_active = true

# stops road mode
func _on_StopRoadMode_timeout():
	transition_ongoing = true
	road_mode_is_active = false
	$RoadModeToggler/RoadModeTransition.start(road_mode_transition_delay)
	$RoadModeToggler.start(road_mode_toggle_rate)


func _on_RoadModeTransition_timeout():
	transition_ongoing = false
	if road_mode_is_active:
		$BackgroundMusicSlow.volume_db = -80
		$BackgroundMusicFast.volume_db = 0
		$YSort/Player.speed = 600
	else:
		$BackgroundMusicSlow.volume_db = 0
		$BackgroundMusicFast.volume_db = -80
		$YSort/Player.speed = 200


func _on_CarSpawner_timeout():
	if road_mode_is_active and !transition_ongoing:
		var playerPosition : Vector2 = get_node(playerNodePath).get_position()
		var spawn_position = Vector2(int(playerPosition.x + spawn_x*2), rand_range(270, 470))
		var car = car_scene.instance()
		car.position = spawn_position
		car.z_as_relative = false
		car.z_index = spawn_position.y
		tree_layer.add_child(car)


func _on_RoadTileSpawner_timeout():
	if road_mode_is_active:
		var playerPosition : Vector2 = get_node(playerNodePath).get_position()
		var spawn_position = Vector2(int(playerPosition.x + spawn_x + 300), 365)
		var road = road_scene.instance()
		road.position = spawn_position
		tree_layer.add_child(road)
		$RoadModeToggler/RoadTileSpawner.start(road_tile_spawn_rate)

