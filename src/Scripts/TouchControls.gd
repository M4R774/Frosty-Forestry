extends Node2D

onready var player = $".."

func _on_GoRight_button_down():
	player.is_going_right = true


func _on_GoRight_button_up():
	player.is_going_right = false


func _on_GoLeft_button_down():
	player.is_going_left = true


func _on_GoLeft_button_up():
	player.is_going_left = false


func _on_GoUp_button_down():
	player.is_going_up = true


func _on_GoUp_button_up():
	player.is_going_up = false


func _on_GoDown_button_down():
	player.is_going_down = true


func _on_GoDown_button_up():
	player.is_going_down = false


func _on_ActivateChainSaw_button_down():
	player.activate_saw()
