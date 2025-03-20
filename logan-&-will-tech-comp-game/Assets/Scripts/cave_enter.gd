extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController and Globals.timesEntered == 1:
		Globals.transitionOut = true
