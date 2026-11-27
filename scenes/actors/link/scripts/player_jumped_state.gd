class_name PlayerJumpedState
extends ActorState

@export var jump_force: float = 4.0

@onready var fall_timer: Timer = $FallTimer

var animation_tree_manager: AnimationTreeManager

var jump_animation: int = -1

func _ready() -> void:
	super()
	animation_tree_manager = my_actor.get_component("AnimationTreeManager")

func enter_state():
	super()
	my_actor.get_component("ModelRotationComponent").set_turning(false)
	animation_tree_manager.abort_one_shot("sheathe_shot")
	grab_models_angle()
	apply_jump_force()
	apply_speed_multiplier()
	play_animation()
	fall_timer.start()
	$Label3D.show()

func exit_state():
	super()
	my_actor.get_component("ModelRotationComponent").set_turning(true)
	my_actor.get_component("MovementComponent").speed_mod("Jumping", false)
	fall_timer.stop()
	$Label3D.hide()

func state_process(_delta: float) -> void:
	check_for_player_landed()

func play_animation() -> void:
	pass
	#animation_tree_manager.force_travel_animation(["grounded", "jumping"])

func grab_models_angle() -> void:
	# Reset all speed first
	my_actor.velocity = Vector3.ZERO
	var get_movement_direction: Vector3 = my_actor.get_component("ModelRotationComponent").facing_angle_vector()
	my_actor.get_component("MovementComponent").set_movement_direction(get_movement_direction.normalized())

func apply_jump_force() -> void:
	my_actor.velocity.y = jump_force

func apply_speed_multiplier() -> void:
	my_actor.get_component("MovementComponent").speed_mod("Jumping", true)

func check_for_player_landed() -> void:
	if !my_actor.is_on_floor():
		return
	my_actor.get_component("ModelRotationComponent").set_turning(true)
	my_state_machine.change_state("PlayerGroundedState")
	animation_tree_manager.travel_animation(["grounded", "idle"])
	fall_timer.stop()

func _on_fall_timer_timeout() -> void:
	switch_to_falling()

func switch_to_falling() -> void:
	my_state_machine.change_state("PlayerFallingState")
