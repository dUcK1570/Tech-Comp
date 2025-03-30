extends ProgressBar

@onready var timer = $Timer
@onready var stamDepletion = $StamDepletion

var stam = 0 : set = _set_stam

func _set_stam(new_stam):
	var prev_stam = stam
	stam = min(max_value, new_stam)
	value = stam
	
	if stam < prev_stam:
		timer.start()
	else:
		stamDepletion.value = stam
func init_stam(_stam):
	stam = _stam
	max_value = stam
	value = stam
	stamDepletion.max_value = stam
	stamDepletion.value = stam
	

func _on_timer_timeout() -> void:
	await get_tree().create_timer(0.1).timeout
	stamDepletion.value = stam
