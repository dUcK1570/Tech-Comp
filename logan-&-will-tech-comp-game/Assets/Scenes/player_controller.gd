extends CharacterBody2D
class_name PlayerController
@onready var animated_sprite = $AnimatedSprite2D
@onready var deal_damage_zone = $dealDamageZone
@export var speed = 10.0
@export var jump_power = 10.0
@onready var healthbar = $CanvasLayer/HealthBar
@onready var stambar = $CanvasLayer/StamBar

var stam: int
var max_stam = 100
var can_take_damage: bool
var health: float
var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var dead: bool
var current_attack: bool
var attack_type: String
const gravity = 900
var regentimer = 0
var jumped = false
var stamtimer = 0


func _ready():
	health = 100
	healthbar.init_health(health)
	stam = 100
	stambar.init_stam(stam)
	Globals.playerBody = self
	dead = false
	current_attack = false
	can_take_damage = true
	Globals.playerAlive = true

func _physics_process(delta: float) -> void:
	Globals.playerDamageSword = ((Globals.str)-3)*1.75
	Globals.playerDamageZone = deal_damage_zone
	if can_take_damage and !current_attack:
		await get_tree().create_timer(0.1).timeout
		regentimer += 1
	elif !can_take_damage or current_attack:
		regentimer = 0
	if regentimer >= 100:
		if health < 100:
			health += 0.25
			healthbar.health = health
		if health > 100:
			health = 100
			healthbar.health = health
		if health <= 0:
			health = 0
			healthbar.health = health
		if is_inside_tree():
			await get_tree().create_timer(Globals.regenwait).timeout
	if jumped:
		stamtimer = 0
	if !current_attack:
		if is_inside_tree():
			await get_tree().create_timer(0.1).timeout
		stamtimer += 1
	elif current_attack:
		stamtimer = 0
	if stamtimer >= 60:
		if stam < 100:
			stam += 1
		if stam > 100:
			stam = 100
		if stam <= 0:
			stam = 0
		if is_inside_tree():
			await get_tree().create_timer(Globals.stamregenwait).timeout
	stambar.stam = stam
	if not is_on_floor():
		velocity.y += gravity * delta
	if !dead:
		if Input.is_action_just_pressed("jump") and is_on_floor() and stam >= 5:
			velocity.y = jump_power * jump_multiplier
			jumped = true
			stam -= 5
			stambar.stam = stam
			await get_tree().create_timer(0.01).timeout
			jumped = false
		direction = Input.get_axis("move_left", "move_right")
		toggle_flip_sprite(direction)
		if direction:
			velocity.x = direction * speed * speed_multiplier
		else:
			velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
		if !current_attack:
			$AnimatedSprite2D2.play("idle")
			if Input.is_action_just_pressed("left_mouse") or Input.is_action_just_pressed("right_mouse"):
				if Input.is_action_just_pressed("left_mouse") and stam >= 20:
					stam -= 20
					stambar.stam = stam
					attack_type = "slice"
					current_attack = true
				#elif Input.is_action_just_pressed("right_mouse"):
					#attack_type = "spell1"
				handle_attack_animation(attack_type)
				set_damage(attack_type)
	
		checkHitbox()
			
	move_and_slide()
	
func toggle_flip_sprite(direction):
	if direction == 1:
		deal_damage_zone.scale.x = 1
		$Sprite2D.scale.x = 0.02
		$AnimatedSprite2D2.scale.x = 1
	if direction == -1:
		deal_damage_zone.scale.x = -1
		$Sprite2D.scale.x = -0.02
		$AnimatedSprite2D2.scale.x = -1
func handle_attack_animation(attack_type):
	if current_attack:
		var animation = str(attack_type)
		$AnimatedSprite2D2.play(animation)
		toggle_damage_collisions(attack_type)


func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("damagecollision")
	var wait_time: float
	if attack_type == "slice":
		wait_time = 0.5
	#elif attack_type == "spell1":
		#wait_time == 0.8
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true
	current_attack = false
func set_damage(attack_type):
	var current_damage_to_deal: int
	if attack_type == "slice":
		current_damage_to_deal = Globals.playerDamageSword
		Globals.playerDamageAmount = current_damage_to_deal
	elif attack_type == "spell1":
		current_damage_to_deal = Globals.playerDamageSpell1
		Globals.playerDamageAmount = current_damage_to_deal
func checkHitbox():
	var damage: int
	if Globals.slimecanhit:
		damage = Globals.slimedamageamount
		if can_take_damage:
			take_damage(damage)
		
func take_damage(damage):
	if damage != 0:
		if health > 0:
			health -= damage
			healthbar.health = health
			print("player health: ", health)
			if health <= 0:
				health = 0
				dead = true
				Globals.playerAlive = false
				handle_death_animation()
			invincibility(0.67)
			
func handle_death_animation():
	#animated_sprite.play("death")
	await get_tree().create_timer(0.5).timeout
	$Camera2D.zoom.x = 9
	$Camera2D.zoom.y = 9
	await get_tree().create_timer(3.5).timeout
	self.queue_free()
func invincibility(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true
#
#func _on_regen_timer_timeout() -> void:
	#if health < 100:
		#health += Globals.regen*2
	#if health > 100:
		#health = 100
	#if health <= 0:
		#health = 0
	#healthbar.health = health

#func _on_stam_regen_timer_timeout() -> void:
	#if stam < 100:
		#stam += Globals.stamregen*2
	#if stam > 100:
		#stam = 100
	#if stam <= 0:
		#stam = 0
	#stambar.stam = stam
