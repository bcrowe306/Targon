extends Node

class_name PushingNode

@export var pushing_force: float = 250.0
@export var right_raycast: RayCast2D
@export var left_raycast: RayCast2D
@export var pushable_group: String
@export var push_input_action: String = "ACTION_USE"


var use_action_pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	use_action_pressed = Input.is_action_pressed(push_input_action)
	
	
func can_push(direction: int) -> bool:
	if direction > 0:
		return right_raycast.is_colliding() and use_action_pressed
			
	elif direction < 0:
		return left_raycast.is_colliding() and use_action_pressed
	else:
		return (left_raycast.is_colliding() or right_raycast.is_colliding()) and use_action_pressed
		
func push_collision_body(direction: int) -> bool:
	
	if can_push(direction):
		var collider
		if direction > 0:
			collider = right_raycast.get_collider()
		elif direction < 0:
			collider = left_raycast.get_collider()
		else:
			return false
			
		if collider and collider.is_in_group(pushable_group):
				collider.apply_central_impulse(Vector2(direction, 0) * pushing_force)
				return true
		else:
			return false 
	else:
		return false
