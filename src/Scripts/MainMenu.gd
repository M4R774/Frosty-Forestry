extends Node2D

export var mainGameScene : PackedScene

func _on_New_Game_Button_button_up():
	print("Aloita peli!")
	if get_tree().change_scene(mainGameScene.resource_path) != OK:
		print("Cannot load gameplay scene.")
