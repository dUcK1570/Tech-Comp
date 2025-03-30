extends CharacterBody2D

class_name slimenemy

@onready var healthbar = $HealthBar

var speed = 1000.0
var player_chase: bool = false
var health: int
var health_max = 30
var health_min = 0
var dead = false
var taking_damage = false
var damage_to_deal =  5
var dealing_damage = false
var direction: Vector2
const gravity = 900
var knockback_force = -20
var is_roaming = true
var player: CharacterBody2D
var player_in_area = false
var stop_chase: bool
var can_move_left = true
var can_move_right = true

func _ready():
	direction = choose([Vector2.RIGHT, Vector2.LEFT])
	Globals.slimeBody = self
	Globals.slimedamageamount = damage_to_deal
	Globals.slimedamagezone = $SlimeDealDamageZone
	Globals.slimecanhit = false
	health = 30
	healthbar.init_health(health)
func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	Globals.slimedamageamount = damage_to_deal
	Globals.slimedamagezone = $SlimeDealDamageZone
	if !Globals.playerAlive:
		player_chase = false
	player = Globals.playerBody
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead and !stop_chase:
		if !taking_damage and !player_chase and !stop_chase:
			velocity = direction * speed * delta
		elif player_chase and !taking_damage and Globals.playerAlive:
			var direction_to_player = position.direction_to(player.position) * speed
			velocity.x = direction_to_player.x * speed/350 * delta
			direction.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0
	elif stop_chase:
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
		await get_tree().create_timer(1.0).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.play("death")
		await get_tree().create_timer(1.2).timeout
		handledeath()
	elif !dead and dealing_damage:
		anim_sprite.play("deal_damage")
	elif stop_chase and !dealing_damage:
		anim_sprite.play("idle")
		await get_tree().create_timer(0.8).timeout

func handledeath():
	Globals.xp += 1


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([2.0, 2.5, 3])
	if !player_chase:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
		
	
func choose(array):
	array.shuffle()
	return array.front()


func _on_detection_are_body_entered(body: Node2D) -> void:
	player_chase = true
	
func _on_detection_are_body_exited(body: Node2D) -> void:
	player_chase = false


func _on_slime_hitbox_area_entered(area: Area2D) -> void:
	if area == Globals.playerDamageZone:
		var damage = Globals.playerDamageAmount
		take_damage(damage)
func take_damage(damage):
	health -= damage
	healthbar.health = health
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
		Globals.level_up()
		self.queue_free()
		handledeath()
	print(str(self), "current health is", health)

func _on_area_2d_body_entered(body: Node2D) -> void:
	stop_chase = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	await get_tree().create_timer(0.05).timeout
	stop_chase = false

func _on_slime_deal_damage_zone_body_entered(body: Node2D) -> void:
	Globals.slimecanhit = true

func _on_slime_deal_damage_zone_body_exited(body: Node2D) -> void:
	Globals.slimecanhit = false
