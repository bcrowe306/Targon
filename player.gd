extends CharacterBody2D
# Signals

signal attack(attack_number: int)
signal state_changed(state: playerState)
signal direction_changed(direction: int)
signal jump(jump_count: int)

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var JUMPS: int = 2
@export var MAX_COMBO_ATTACKS: int = 2
@export var ATTACK_DASH: int = 1000
@export var ATTACK_COMBO_JUMP = -300
@export var PUSH_FORCE: float = 15.0

var jump_count: int = 0
var attack_number: int = 0
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
@onready var sword_collision_shape: CollisionShape2D = $Sword/swordCollisionShape

enum playerState {IDLE, RUN, JUMP, FALL, ATTACK1, ATTACK2}
var stateStringMap = {
	playerState.IDLE: "Idle",
	playerState.RUN: "Run",
	playerState.JUMP: "Jump",
	playerState.FALL: "Fall",
	playerState.ATTACK1: "Attack1",
	playerState.ATTACK2: "Attack2"
}

@onready var state: playerState = playerState.IDLE
var previousState: playerState = state

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ACTION_JUMP") and canJump():
		jump.emit(jump_count)
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ACTION_ATTACK_1"):
		handleAttack()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("DIR_LEFT", "DIR_RIGHT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	handleState()
	handleDirection()

	if move_and_slide():
	
		for i in get_slide_collision_count():
			var c := get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				#var push_force = (PUSH_FORCE * velocity.length() * SPEED) + 10.0
				c.get_collider().apply_central_impulse(-c.get_normal() * 500) 
		

func handleDirection():
	if direction > 0:
		facing_direction = true
		
	elif direction < 0:
		facing_direction = false
		
	direction_changed.emit(direction)
	

func handleAttack():
	if attack_count == 0:
		doAttack()
	else:
		if not attackTimer.expired and attack_count < MAX_COMBO_ATTACKS:
			doAttack()
		
func doAttack():
	self.attack_number = attack_count
	attack.emit(self.attack_number)
	attack_count += 1
	if self.attack_number == 1:
		if facing_direction:
			velocity.x = 1 * ATTACK_DASH
		else:
			velocity.x = -1 * ATTACK_DASH
	if self.attack_number == 2:
		if facing_direction:
			velocity.x = 1 * ATTACK_DASH
		else:
			velocity.x = -1 * ATTACK_DASH
		velocity.y = ATTACK_COMBO_JUMP

func canJump():
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

func handleState():
	var next_state := playerState.IDLE
	
	if abs(direction) > 0:
		next_state = playerState.RUN
	
	if velocity.y > 0:
		next_state = playerState.FALL
	elif velocity.y < 0:
		next_state = playerState.JUMP	
	
	setState(next_state)
	
func setState(new_state: playerState):
	if new_state != state:
		stateTransition(new_state)
		previousState = state
		state = new_state
		state_changed.emit(state)
		
func stateTransition(next_state: playerState):
	
	if state == playerState.FALL and next_state != playerState.JUMP:
		jump_count = 0

func _on_attack_timer_timeout() -> void:
	attack_count = 0 # Replace with function body.
