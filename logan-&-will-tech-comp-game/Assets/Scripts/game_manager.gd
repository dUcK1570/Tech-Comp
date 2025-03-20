extends Node


var current_area = 0
var area_path = "res://Assets/Scenes/Biomes/"

func next_level():
	current_area += 1
	var full_path = area_path + "area_" + str(current_area) + ".tscn"
	get_tree().change_scene_to_file(full_path)
	print("Level " + str(current_area) + " entered")

func _process(delta: float) -> void:
	if !Globals.playerAlive and current_area == 1:
		GameManager.next_level()
