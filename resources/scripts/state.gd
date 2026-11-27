class_name State
extends Node

var my_state_machine: StateMachine

var is_state_active: bool = false

func _ready() -> void:
	add_to_state_machine()

func add_to_state_machine() -> void:
	if get_parent() is not StateMachine:
		return
	
	my_state_machine = get_parent()
	my_state_machine.receive_state(self)

func enter_state() -> void:
	is_state_active = true

func exit_state() -> void:
	is_state_active = false

func state_process(_delta: float) -> void:
	pass

func state_physics_process(_delta: float) -> void:
	pass

func state_input(_event: InputEvent) -> void:
	pass
