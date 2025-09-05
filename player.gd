extends CharacterBody2D

class_name Player

# Signals
signal attack(attack_number: int)
signal state_changed(state: GlobalEnums.CharacterState)
signal direction_changed(direction: int)
signal jump(jump_count: int)
signal damaged(health: float, delta: float)
signal healed(health: float, delta: float)
signal health_changed(health: float, delta: float)
signal armor_changed(armor: float)
signal died(health: float)
signal coins(amount: int)
signal diamonds(amount: int)

@export var ACCELERATION: float = 1400
@export var SPEED: float = 300.0
@export var SPEED_BOOST: float = 1.0
@export var JUMP_VELOCITY: float = -400.0
@export var JUMPS: int = 2
@export var MAX_COMBO_ATTACKS: int = 2
@export var ATTACK_DASH: int = 500
@export var ATTACK_COMBO_JUMP = -300
@export var PUSH_FORCE: float = 15.0
@export var TUMBLE_BOUNCE_BACK = 2000
@export var LATERAL_DASH_VELOCITY = 4000.0
@export var ACCEPT_INPUT: bool = true

var jump_count: int = 0
var attack_number: int = 0
var gravity_multiplier: float = 1
var direction := 0
var facing_direction: bool = true: # True means we're facing right, flase is left
	get():
		return facing_direction
		
	set(value):
		if value != facing_direction:
			facing_direction = value
var attack_count: int = 0

@onready var AS2d = $AnimatedSprite2D
@onready var fallTimerNode = $FallTimer
@onready var attackTimer = $AttackTimer
@onready var sword: Area2D = $Sword
@onready var tumble_timer: Timer = $TumbleTimer
@onready var damaged_timer: Timer = $DamagedTimer
@onready var health_node: HealthNode = $HealthNode
@onready var respawn_timer: Timer = $RespawnTimer
@onready var state_label: Label = $StateLabel
@onready var player_loot: Node = $PlayerLoot



func _ready() -> void:
	reset()

var previousState: GlobalEnums.CharacterState = GlobalEnums.CharacterState.IDLE
var state: GlobalEnums.CharacterState = GlobalEnums.CharacterState.IDLE:
	get():
		return state
		
	set(value):
		if value != state and autoStateChangeGuard(value):
			stateTransition(value)
			previousState = state
			state = value
			state_changed.emit(state)

func collect_coins(amount: int):
	player_loot.modify_coins(amount)
	coins.emit(player_loot.coins)

func collect_diamonds(amount: int):
	player_loot.modify_diamonds(amount)
	diamonds.emit(player_loot.diamonds)

func get_coins() -> int:
	return player_loot.coins
	
func get_diamonds() -> int:
	return player_loot.diamonds

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		var gravity: Vector2 = get_gravity() * gravity_multiplier
		if state == GlobalEnums.CharacterState.FALL:
			gravity *= 1.5
		velocity += gravity * delta
	
	
	handleDirection()
	determinState()
	doLateralMovement(delta)
	
	
	if move_and_slide():
	
		for i in get_slide_collision_count():
			var c := get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				#var push_force = (PUSH_FORCE * velocity.length() * SPEED) + 10.0
				c.get_collider().apply_central_impulse(-c.get_normal() * 500) 
	# Handle Animation rotation
	#if is_on_floor():
		#var offset = PI / 2
		#AS2d.rotation = get_floor_normal().angle() + offset

func doLateralMovement(delta: float):
	var max_speed = get_speed()
	
	if direction:
		#mock_velocity.x = clamp(mock_velocity.x + direction * ACCELERATION * delta, -max_speed, max_speed)
		velocity.x = clamp(velocity.x + direction * ACCELERATION * delta, -max_speed, max_speed)
		#velocity.x = direction * get_speed()
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * 1.5 * delta)
		
func get_speed() -> float:
	return SPEED * SPEED_BOOST

func doJump(next_state: int) -> int:
	gravity_multiplier = 1
	next_state = GlobalEnums.CharacterState.JUMP
	velocity.y = JUMP_VELOCITY
	jump.emit(jump_count)
	return next_state


func handleDirection():
	if ACCEPT_INPUT:
		direction = Input.get_axis("DIR_LEFT", "DIR_RIGHT")
		if direction > 0:
			facing_direction = true
			
		elif direction < 0:
			facing_direction = false
			
		direction_changed.emit(direction)
	else:
		direction = 0.0
	

func handleAttack(next_state: int) -> int:
	if attack_count == 0:
		return doAttack(next_state)
	else:
		if not attackTimer.expired and attack_count < MAX_COMBO_ATTACKS:
			return doAttack(next_state)
	return next_state
		
func is_air_state(current_state: int) -> bool:
	return current_state == GlobalEnums.CharacterState.JUMP or state == GlobalEnums.CharacterState.FALL or state == GlobalEnums.CharacterState.STOMP
	
func doTumble(next_state: int) -> int:
	next_state = GlobalEnums.CharacterState.TUMBLE
	SPEED_BOOST = 1.5
	tumble_timer.start()
	return next_state

func doRun(next_state: int) -> int:
	if state != GlobalEnums.CharacterState.TUMBLE:
		next_state = GlobalEnums.CharacterState.RUN
	else:
		next_state = GlobalEnums.CharacterState.TUMBLE
	return next_state
	

func doAttack(next_state: int) -> int:
	self.attack_number = attack_count
	if attack_count == 0:
		next_state = GlobalEnums.CharacterState.ATTACK1
		
	elif attack_count == 1:
		next_state = GlobalEnums.CharacterState.ATTACK2
		if facing_direction:
			velocity.x = 1 * ATTACK_DASH
		else:
			velocity.x = -1 * ATTACK_DASH
	elif attack_count == 2:
		next_state = GlobalEnums.CharacterState.ATTACK3
		if facing_direction:
			velocity.x = 1 * ATTACK_DASH
		else:
			velocity.x = -1 * ATTACK_DASH
		velocity.y = ATTACK_COMBO_JUMP
	
	attack.emit(self.attack_count)
	attack_count += 1
	return next_state
		
func determinState():
	var next_state := GlobalEnums.CharacterState.IDLE
	
	# Process combo inputs 1st
	var combo: bool = false
	var has_input: bool = false
	
	if not ACCEPT_INPUT:
		direction = 0
		return
	
	if Input.is_action_pressed("DIR_DOWN"):
		
		if state == GlobalEnums.CharacterState.FALL:
			combo = true
			has_input = true
			next_state = GlobalEnums.CharacterState.STOMP
			state = next_state
			return 
			
	# Process single inputs next
	if not combo:
		if Input.is_action_just_pressed("ACTION_JUMP") and canJump():
			has_input = true
			next_state = doJump(next_state)
		
		# Handle Attack Actions Pressed
		if Input.is_action_just_pressed("ACTION_ATTACK_1"):
			has_input = true
			next_state = handleAttack(next_state)
			
		# Tumble 
		if Input.is_action_just_pressed("ACTION_ROLL"):
			if not is_air_state(state) and direction != 0:
				has_input = true
				next_state = doTumble(next_state)
		
	if has_input or combo:
		state = next_state
		return
	
	# State based on player velocities
	if abs(direction) > 0:
		next_state = doRun(next_state)
	
	
	if velocity.y > 0:
		if state == GlobalEnums.CharacterState.STOMP:
			next_state = state
		else:
			next_state = GlobalEnums.CharacterState.FALL
		
	elif velocity.y < 0:
		if state == GlobalEnums.CharacterState.STOMP:
			next_state = state
		else:
			next_state = GlobalEnums.CharacterState.JUMP
	
	
	state = next_state

func is_attack_state(state_value: int):
	return state_value == GlobalEnums.CharacterState.ATTACK1 or state_value == GlobalEnums.CharacterState.ATTACK2 or state_value == GlobalEnums.CharacterState.ATTACK3

func autoStateChangeGuard(next_state) -> bool:
	if state == GlobalEnums.CharacterState.RESPAWN:
		return next_state == GlobalEnums.CharacterState.READY
	elif state == GlobalEnums.CharacterState.DYING:
		return next_state == GlobalEnums.CharacterState.RESPAWN
	else:
		return AS2d.is_animation_finished(next_state)

func is_attack(current_state: int) -> bool:
	return current_state == GlobalEnums.CharacterState.ATTACK1 or current_state == GlobalEnums.CharacterState.ATTACK2 or current_state == GlobalEnums.CharacterState.ATTACK3 or current_state == GlobalEnums.CharacterState.ATTACK4

func canJump():
	if state == GlobalEnums.CharacterState.STOMP:
		return false
	var tempJump: bool = false
	if is_on_floor():
		tempJump = true
	else:
		if not fallTimerNode.expired and jump_count < JUMPS:
			tempJump = true
		else:
			if jump_count < JUMPS:
				tempJump = true
	if tempJump:
		jump_count +=1
	return tempJump

func getVelocityPercentage() -> float:
	return abs(velocity.x) / SPEED

		
func stateTransition(next_state: GlobalEnums.CharacterState):
	# Reset Jump Count when player hits the ground again
	var current_state = state
	if (current_state == GlobalEnums.CharacterState.FALL or current_state == GlobalEnums.CharacterState.STOMP) and next_state != GlobalEnums.CharacterState.JUMP:
		jump_count = 0
		
	# Set gravity multiplier for stomp
	if next_state == GlobalEnums.CharacterState.STOMP:
		gravity_multiplier = 3
	else:
		gravity_multiplier = 1
		
	# Reset Speed boost after tumble is over
	if current_state == GlobalEnums.CharacterState.TUMBLE:
		SPEED_BOOST = 1.0
		
	# Toggle health_node invinsible based on attack state:
	if is_attack(next_state) or next_state == GlobalEnums.CharacterState.TUMBLE or next_state == GlobalEnums.CharacterState.STOMP:
		health_node.INVINSIBLE = true
	else:
		if damaged_timer.is_stopped():
			health_node.INVINSIBLE = false
			
	# Handle Dying State
	if next_state == GlobalEnums.CharacterState.DYING:
		ACCEPT_INPUT = false

func _on_attack_timer_timeout() -> void:
	attack_count = 0 # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	var current_animation = AS2d.animation
	if current_animation == "Dying":
		died.emit(health_node.health)
		
func _on_stomp_attack_area_stomp(dead: bool) -> void:
	state = doJump(state)# Replace with function body.

func hit(damage: float) -> float:
	if state == GlobalEnums.CharacterState.DYING or state == GlobalEnums.CharacterState.RESPAWN:
		return health_node.health
	else:
		return health_node.hit(damage)
		

func _on_dash_combo_activated() -> void:
	if facing_direction:
		velocity.x += 1 * LATERAL_DASH_VELOCITY
	else:
		velocity.x += -1 * LATERAL_DASH_VELOCITY
	health_node.INVINSIBLE = true
	move_and_slide()
	health_node.INVINSIBLE = false
	

func _on_tumble_timer_timeout() -> void:
	state = GlobalEnums.CharacterState.RUN
	SPEED_BOOST = 1 # Replace with function body.


func _on_tumble_attack_tumbled(dead: bool) -> void:
	if not dead:
		if facing_direction:
			velocity.x += -1 * TUMBLE_BOUNCE_BACK
		else:
			velocity.x += 1 * TUMBLE_BOUNCE_BACK


func _on_health_node_damaged(health: float, delta: float) -> void:
	if health > 0:
		damaged_timer.start()
		state = GlobalEnums.CharacterState.HIT
		health_node.INVINSIBLE = true
		#set_collision_layer_value(2, false)
		damaged.emit(health, delta) # Replace with function body.
	else:
		health_node.INVINSIBLE = true
		ACCEPT_INPUT = false
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
		set_collision_mask_value(3, false)
		set_collision_mask_value(4, false)
		state = GlobalEnums.CharacterState.DYING

func reset():
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(4, true)
	health_node.reset()
	ACCEPT_INPUT = true
	state = GlobalEnums.CharacterState.READY
	
func respawn():
	state = GlobalEnums.CharacterState.RESPAWN
	respawn_timer.start()

func _on_health_node_changed(health: float, delta: float) -> void:
	health_changed.emit(health, delta) # Replace with function body.


func _on_health_node_healed(health: float, delta: float) -> void:
	healed.emit(health, delta) # Replace with function body.


func _on_health_node_armor_changed(armor: float) -> void:
	armor_changed.emit(armor) # Replace with function body.


func _on_damaged_timer_timeout() -> void:
	health_node.INVINSIBLE = false
	#set_collision_layer_value(2, true) # Replace with function body.


func _on_respawn_timer_timeout() -> void:
	reset() # Replace with function body.
