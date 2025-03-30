extends ProgressBar

@onready var timer = $Timer
@onready var manaDepletion = $ManaDepletion

var mana = 0 : set = _set_mana

func _set_mana(new_mana):
	var prev_mana = mana
	mana = min(max_value, new_mana)
	value = mana
	
	if mana < prev_mana:
		timer.start()
	else:
		manaDepletion.value = mana
func init_mana(_mana):
	mana = _mana
	max_value = mana
	value = mana
	manaDepletion.max_value = mana
	manaDepletion.value = mana
	

func _on_timer_timeout() -> void:
	await get_tree().create_timer(0.1).timeout
	manaDepletion.value = mana
