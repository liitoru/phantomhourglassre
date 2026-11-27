class_name PlayerGroundedState
extends ActorState

var get_movement_direction: Vector3

var link_velocity: float
var link_input: float

func _ready() -> void:
	super()

func enter_state():
	super()
	my_actor.get_component("InputComponent").interacted.connect(on_interacted)
	$Label3D.show()

func exit_state():
	super()
	my_actor.get_component("InputComponent").interacted.disconnect(on_interacted)
	$Label3D.hide()

func state_process(_delta: float) -> void:
	move_player()
	check_for_player_falling()

func state_physics_process(_delta: float) -> void:
	pass

func check_for_player_falling() -> void:
	if my_actor.is_on_floor():
		return
	
	if my_actor.get_component("RayCastComponent").check_raycast():
		my_state_machine.change_state("PlayerFallingState")
		return
	
	my_state_machine.change_state("PlayerJumpedState")

func move_player() -> void:
	get_movement_direction = my_actor.get_component("InputComponent").movement_logic()
	my_actor.get_component("MovementComponent").set_movement_direction(get_movement_direction)
	get_links_movement()

func get_links_movement() -> void:
	link_velocity = my_actor.get_component("MovementComponent").my_actors_velocity
	link_input = my_actor.get_component("InputComponent").movement_vector.length()

func on_interacted() -> void:
	# Else do other interact stuff like picking things up
	if link_velocity < 0.5:
		return
	
	on_rolled()

func on_rolled() -> void:
	if link_velocity <= 0.5 or link_input <= 0.5:
		return
	
	my_state_machine.change_state("PlayerRolledState")
