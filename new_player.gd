extends CharacterBody2D

signal damaged(health: float, delta: float)
signal healed(health: float, delta: float)
signal health_changed(health: float, delta: float)
signal armor_changed(armor: float)
signal died(health: float)
signal coins(amount: int)
signal diamonds(amount: int)

@onready var state_machine: Node = $StateMachine
@onready var fall_timer: Timer = $FallTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var player_loot: Node = $PlayerLoot
@onready var health_node: HealthNode = $HealthNode
@onready var climbing_node: Node = $ClimbingNode
@onready var pushing_node: Node = $PushingNode


@export var ACCELERATION: float = 1400
@export_range(0.0, 1.0, .02, "How much directional control the player has in the air") var AIR_CONTROL: float = 1.0
@export var SPEED: float
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
var attack_number: int = 2
var gravity_multiplier: float = 1
var direction := 0
var facing_direction: bool = true: # True means we're facing right, flase is left
	get():
		return facing_direction
		
	set(value):
		if value != facing_direction:
			facing_direction = value
var attack_count: int = 0


func collect_coins(amount: int):
	player_loot.modify_coins(amount)
	coins.emit(player_loot.coins)

func collect_armor(amount: float):
	armor_changed.emit(health_node.increaseArmor(amount))

func collect_diamonds(amount: int):
	player_loot.modify_diamonds(amount)
	diamonds.emit(player_loot.diamonds)

func get_coins() -> int:
	return player_loot.coins
	
func get_diamonds() -> int:
	return player_loot.diamonds

func is_in_attack_state() -> bool:
	return state_machine.state == "Attack1" or state_machine.state == "Attack2" or state_machine.state == "Attack3"

func hit(damage: float) -> float:
	if state_machine.state == "Dying" or state_machine.state == "Respawn" or is_in_attack_state() or health_node.INVINSIBLE:
		return health_node.health
	else:
		var new_health_amount = health_node.hit(damage)
		if new_health_amount > 0:
			state_machine.state = "Hit"
			damaged.emit(new_health_amount, damage) # Replace with function body.
		else:
			state_machine.state = "Dying" # Replace with function body.
		return new_health_amount
		
func kill(bypass_invinsibility: bool = true) -> int:
	if state_machine.state == "Dying" or state_machine.state == "Respawn" or is_in_attack_state() or health_node.INVINSIBLE:
		return health_node.health
	else:
		var new_health_amount = health_node.kill(bypass_invinsibility)
		if new_health_amount > 0:
			state_machine.state = "Hit"
			damaged.emit(new_health_amount, 0) # Replace with function body.
		else:
			state_machine.state = "Dying" # Replace with function body.
		return new_health_amount
	
func _physics_process(delta: float) -> void:
	if climbing_node.is_climbing():
		state_machine.state = "Climbing"
	apply_gravity(delta)
	handle_direction()
	lateral_movement(delta)
	state_by_movement()
	handle_input()
	handle_push()
	move_and_slide()
	

func handle_push():
	var next_state = state_machine.state
	if pushing_node.can_push(direction):
		next_state = "PushingIdle"
		if abs(direction) > 0 and pushing_node.push_collision_body(direction):
			next_state = "Pushing"
	state_machine.state = next_state

func state_by_movement():
	var next_state = state_machine.default_state
	var current_state = state_machine.state
	
	if abs(velocity.x) != 0:
		if current_state == "Pushing":
			next_state = current_state
		else:
			next_state = do_run(next_state)
	else:
		# TODO: Implement code here for pushing idle state
		if current_state == "PushingIdle":
			if pushing_node.can_push(direction):
				next_state = current_state
			else:
				next_state = state_machine.default_state
	
	if state_machine.state != "Climbing":
		if velocity.y > 0:
			if state_machine.state == "Stomp":
				next_state = "Stomp"
			else:
				next_state = "Fall"
				
		if velocity.y < 0:
			next_state = "Jump"
		
	
	state_machine.state = next_state

func apply_gravity(delta: float):
	if state_machine.state == "Climbing":
		return
	if not is_on_floor():
		var gravity: Vector2 = get_gravity() * gravity_multiplier
		if state_machine.state == "Fall":
			gravity *= 1.5
		velocity += gravity * delta

func handle_direction():
	if state_machine.state == "Climbing":
		return
	if ACCEPT_INPUT:
		direction = Input.get_axis("DIR_LEFT", "DIR_RIGHT")
		if direction > 0:
			facing_direction = true
			
		elif direction < 0:
			facing_direction = false
	else:
		direction = 0.0

func is_air_state(current_state: String) -> bool:
	return current_state == "Jump" or current_state == "Fall" or current_state == "Stomp" or current_state == "Jump2"

func handle_input():
	if Input.is_action_just_pressed("ACTION_JUMP") and can_jump():
		if jump_count == 1:
			state_machine.state = "Jump"
		else:
			state_machine.state = "Jump2"
		do_jump()
		
	# Tumble 
	if Input.is_action_just_pressed("ACTION_ROLL"):
		if not is_air_state(state_machine.state) and direction != 0:
			state_machine.state = "Tumble"
			
	if Input.is_action_pressed("DIR_DOWN"):
		
		if state_machine.state == "Fall":
			state_machine.state = "Stomp"
			
	if Input.is_action_just_pressed("ACTION_ATTACK_1"):
		handle_attack()

func handle_attack():
	var next_state = "Attack1"
	print(attack_count)
	if attack_count == 0:
		next_state = "Attack1"
	elif attack_count == 1:
		next_state = "Attack2"
	else:
		next_state = "Attack3"
	
	state_machine.state = next_state
	attack_timer.start()
	attack_count +=1
	if attack_count > attack_number:
		attack_count = 0

func lateral_movement(delta: float):
	if state_machine.state == "Climbing":
		velocity.x = 0
		return
	var max_speed = get_speed()
	if direction:
		#mock_velocity.x = clamp(mock_velocity.x + direction * ACCELERATION * delta, -max_speed, max_speed)
		var x_velocity = clamp(velocity.x + direction * ACCELERATION * delta, -max_speed, max_speed)
		if is_on_floor():
			velocity.x = x_velocity
		else:
			velocity.x = AIR_CONTROL * x_velocity
		#velocity.x = direction * get_speed()
	else:
		var x_velocity = move_toward(velocity.x, 0, ACCELERATION * 1.5 * delta)
		if is_on_floor():
			velocity.x = x_velocity
		else:
			velocity.x = x_velocity * AIR_CONTROL
		

func get_speed() -> float:
	return SPEED * SPEED_BOOST

func reset():
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(4, true)
	health_node.reset()
	ACCEPT_INPUT = true
	
func respawn():
	state_machine.state = "Respawn"

func do_jump():
	gravity_multiplier = 1
	velocity.y = JUMP_VELOCITY

func do_run(next_state: String) -> String:
	if state_machine.state != "Tumble":
		next_state = "Run"
	else:
		next_state = "Tumble"
	return next_state

func get_velocity_ratio() -> float:
	return  abs(velocity.x) / SPEED

func can_jump():
	if state_machine.state == "Stomp":
		return false
	var tempJump: bool = false
	if is_on_floor():
		tempJump = true
	else:
		if not fall_timer.is_stopped() and jump_count < JUMPS:
			tempJump = true
		else:
			if jump_count < JUMPS:
				tempJump = true
	if tempJump:
		jump_count +=1
	return tempJump


func _on_dash_combo_input_combo_activated() -> void:
	state_machine.state = "Dash" # Replace with function body.


func _on_attack_timer_timeout() -> void:
	attack_count = 0 # Replace with function body.


func _on_tumble_attack_tumbled(dead: bool) -> void:
	if not dead:
		if facing_direction:
			velocity.x += -1 * TUMBLE_BOUNCE_BACK
		else:
			velocity.x += 1 * TUMBLE_BOUNCE_BACK # Replace with function body.


func _on_health_node_armor_changed(armor: float) -> void:
	armor_changed.emit(armor)
