extends CharacterBody2D

class_name slimenemy

var speed = 1000.0
var player_chase: bool = false
var health = 80
var health_max = 80
var health_min = 0
var dead: bool = false
var taking_damage: bool = false
var damage = 20
var dealing_damage: bool = false
var direction: Vector2
const gravity = 900
var knockback_force = 200
var is_roaming: bool = true

func _ready():
	direction = choose([Vector2.RIGHT, Vector2.LEFT])

func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:
		if !player_chase:
			velocity = direction * speed * delta
		is_roaming = true
	elif dead:
		velocity.x = 0

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !dealing_damage:
		anim_sprite.play("walk")
		if direction.x == -1:
			anim_sprite.flip_h = true
		elif direction.x == 1:
			anim_sprite.flip_h = false
	if !dead and taking_damage and !dealing_damage:
		anim_sprite.play("taking_damage")
		if direction.x == -1:
			anim_sprite.flip_h = true
		elif direction.x == 1:
			anim_sprite.flip_h = false

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([2.0, 2.5, 3])
	if !player_chase:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		
	
func choose(array):
	array.shuffle()
	return array.front()
