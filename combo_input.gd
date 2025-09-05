extends Node2D

# Signals
signal combo_activated()

@onready var combo_timer: Timer = $ComboTimer

enum COMBO_TYPE {REPEAT, SERIES}
enum RUN_MODE {AUTO, MANUAL}

@export var type: COMBO_TYPE = COMBO_TYPE.REPEAT
@export var repeat_count: int = 2
@export var combo_seconds: float = 0.25:
	get():
		return combo_seconds
		
	set(value):
		if value != combo_seconds:
			combo_seconds = value
@export var mode: RUN_MODE = RUN_MODE.AUTO

@export var actions: Array[String] = []

var count_map: Dictionary[String, int] = {}
var series_array: Array[String] = []

func _on_ready() -> void:
	for input_action in actions:
		count_map[input_action] = 0

func _process(_delta: float):
	if mode == RUN_MODE.AUTO:
		isCombo()

func isCombo() -> bool:
	if mode != RUN_MODE.AUTO:
		return false
	var activated: bool = false
	for input_action in count_map.keys():
		if Input.is_action_just_pressed(input_action):
			count_map[input_action] += 1
			series_array.push_back(input_action)
			if combo_timer.is_stopped():
				combo_timer.start(combo_seconds)
			else:
				if isComboActivated():
					combo_activated.emit()
					activated = true
					resetComboCount()
	return activated

func isComboActivated() -> bool:
	if type == COMBO_TYPE.REPEAT:
		for count in count_map.values():
			if count >= repeat_count:
				return true
		
		return false
	else:
		return series_array == actions
		
		

func resetComboCount():
	for action_name in count_map.keys():
		count_map[action_name] = 0
	series_array.clear()
	combo_timer.stop()

func _on_timer_timeout() -> void:
	resetComboCount()
