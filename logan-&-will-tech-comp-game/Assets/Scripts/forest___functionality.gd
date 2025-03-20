extends Node2D

@onready var SceneSwap = $SceneSwap/AnimationPlayer

func _ready() -> void:
	SceneSwap.get_parent().get_node("ColorRect").color.a = 255
	SceneSwap.play("fade_out")
func _process(delta: float) -> void:
	if Globals.transitionOut == true:
		Globals.transitionOut = false
		SceneSwap.play("fade_in")
		await get_tree().create_timer(0.75).timeout
		GameManager.next_level()
