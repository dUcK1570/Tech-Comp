extends Node2D

@onready var SceneSwap = $SceneSwap/AnimationPlayer

func _ready() -> void:
	Globals.timesEntered += 1
	SceneSwap.get_parent().get_node("ColorRect").color.a = 255
	SceneSwap.play("fade_out")
func _process(delta: float) -> void:
	if Globals.transitionOut == true:
		Globals.transitionOut = false
		SceneSwap.play("fade_in")
		await get_tree().create_timer(0.65).timeout
		SceneSwap.get_parent().get_node("ColorRect").color.a = 255
		GameManager.next_level()
