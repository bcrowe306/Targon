extends Node

enum CharacterState {
	IDLE, RUN, JUMP, FALL, 
	ATTACK1, ATTACK2, ATTACK3, ATTACK4, 
	USE, WALK, CROUCH, TUMBLE, DASH, CLIMB, HANG, PUSH, PICKUP, PUTDOWN, CARRY, LAYING, 
	HIT, HEALING, DYING, DEAD, SPAWN, RESPAWN 
	}

enum GameState {
		MENU,
		PLAYING,
		PAUSED,
		GAME_OVER
	}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
