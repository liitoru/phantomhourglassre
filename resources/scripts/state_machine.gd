class_name StateMachine
extends Node

signal changed_state(new_state: State)

@export var starting_state: State

var states: Dictionary[String, State] = {}

var current_state: State = null

func _ready() -> void:
	change_state(starting_state.name)

func receive_state(new_state: State) -> void:
	states[new_state.name] = new_state

func change_state(state_name: String) -> void:
	if states.is_empty():
		return
	
	if current_state != null:
		if state_name == current_state.name:
			return
		current_state.exit_state()
	
	current_state = states.get(state_name, current_state)
	
	current_state.enter_state()
	changed_state.emit(current_state)

func reenter_state() -> void:
	if states.is_empty():
		return
	
	if current_state == null:
		return
	
	current_state.exit_state()
	current_state.enter_state()
	changed_state.emit(current_state)

func _process(delta: float) -> void:
	if current_state == null:
		return
	
	if current_state.has_method("state_process"):
		current_state.state_process(delta)

func _physics_process(delta: float) -> void:
	if current_state == null:
		return
	
	if current_state.has_method("state_physics_process"):
		current_state.state_physics_process(delta)

func _input(event: InputEvent) -> void:
	if current_state == null:
		return
	
	if current_state.has_method("state_input"):
		current_state.state_input(event)
