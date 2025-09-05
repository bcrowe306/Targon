extends Node
@onready var rc_right_foot: RayCast2D = $"../RCRightFoot"
@onready var rc_left_foot: RayCast2D = $"../RCLeftFoot"
@onready var rc_right_head: RayCast2D = $"../RCRightHead"
@onready var rc_left_head: RayCast2D = $"../RCLeftHead"

var climbing_direction: bool = true # true is right, false is left
var climbing_activated: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("ACTION_ROLL"):
		climbing_activated = true
	else:
		climbing_activated = false
	
	if rc_left_foot.is_colliding() and rc_left_head.is_colliding():
		climbing_direction = false
	elif rc_right_foot.is_colliding() and rc_right_head.is_colliding():
		climbing_direction = true 
	
func is_climbing()-> bool:
	if climbing_activated:
		return is_attached()
	else:
		return false
		
func is_attached() -> bool:
	return ( rc_left_foot.is_colliding() and rc_left_head.is_colliding() ) or (rc_right_foot.is_colliding() and rc_right_head.is_colliding())
	
func can_climb(direction: bool) -> bool:
	if direction:
		return rc_right_foot.is_colliding() and rc_right_head.is_colliding()
	else:
		return rc_left_foot.is_colliding() and rc_left_head.is_colliding()


func can_climb_up(direction: bool) -> bool:
	if direction:
		return rc_right_head.is_colliding()
	else:
		return rc_left_head.is_colliding()
		
func can_climb_down(direction: bool) -> bool:
	if direction:
		return rc_right_foot.is_colliding()
	else:
		return rc_left_foot.is_colliding()
	
