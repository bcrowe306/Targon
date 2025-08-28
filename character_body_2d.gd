extends CharacterBody2D

@export var SPEED: float = 75.0

signal state_changed(state: GlobalEnums.CharacterState)
signal direction_changed(direction: int)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_node: HealthNode = $HealthNode

@export var JUMP_VELOCITY: float = -400.0

var direction: float = -1.9:
	get():
		return direction
	
	set(value):
		if value != direction:
			direction = value
			direction_changed.emit(direction)

var previousState: GlobalEnums.CharacterState = GlobalEnums.CharacterState.WALK
var state: GlobalEnums.CharacterState = GlobalEnums.CharacterState.IDLE:
	
	get():
		return state
	
	set(value):
		if value != state:
			previousState = state
			state = value
			state_changed.emit(state)

func set_health(health: float):
	if health_node:
		health_node.health = health

func previous_state():
	state = previousState

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	handleMovement()
	handleState()
	
	
	
func handleMovement():
	var d = direction
	if state == GlobalEnums.CharacterState.HIT or state == GlobalEnums.CharacterState.DYING:
		d = 0
	
	if d:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if is_on_wall():
		var collision_count = get_slide_collision_count()
		for i in collision_count:
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collision.get_collider() is TileMapLayer:
				direction *= -1 # Reverse direction
			else:
				if collider.get_collision_layer() == 8:
					direction *= -1
					
				
	if is_on_floor():
		var offset = PI / 2
		animated_sprite_2d.rotation = get_floor_normal().angle() + offset

func handleState():
	if state == GlobalEnums.CharacterState.HIT or state == GlobalEnums.CharacterState.DYING:
		return
	
	if direction:
		state = GlobalEnums.CharacterState.WALK
	else:
		state = GlobalEnums.CharacterState.IDLE
	
func _on_ready() -> void:
	pass


func _on_health_node_damaged(health: float, delta: float) -> void:
	if health > 0:
		state = GlobalEnums.CharacterState.HIT
	else:
		state = GlobalEnums.CharacterState.DYING # Replace with function body.
		print(collision_layer)
		set_collision_layer_value(3, false)
		set_collision_layer_value(9, true)
		set_collision_mask_value(2, false)
		set_collision_mask_value(3, false)
		set_collision_mask_value(4, false)
		print(collision_layer)
		


func _on_animated_sprite_2d_animation_finished() -> void:
	var animation: String = animated_sprite_2d.animation
	if animation == "Hit":
		previous_state()
	if animation == "Dying":
		queue_free()
