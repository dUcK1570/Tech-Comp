extends Area2D

func _process(delta):
	for body in get_overlapping_bodies():
		print("Detected:", body.name)
		if body is PlayerController:
			_on_area_exit_body_entered(body)



func _on_area_exit_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		Globals.transitionOut = true
