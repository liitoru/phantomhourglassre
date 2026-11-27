class_name PlayerRolledState
extends ActorState

@onready var roll_speed_increase_timer: Timer = $RollSpeedIncreaseTimer
@onready var roll_finished_timer: Timer = $RollFinishedTimer

var animation_tree_manager: AnimationTreeManager

func _ready() -> void:
	super()
	animation_tree_manager = my_actor.get_component("AnimationTreeManager")

func enter_state():
	super()
	lock_turning()
	roll()
	animation_tree_manager.abort_one_shot("sheathe_shot")
	play_animation()
	$Label3D.show()

# Example if player gets hit while rolling and state changes to hurt, make sure
# that all the roll timers stop to not change something afterwards
func exit_state():
	super()
	my_actor.get_component("MovementComponent").speed_mod("Rolling", false)
	my_actor.get_component("MovementComponent").accel_mod("Rolling", false)
	roll_speed_increase_timer.stop()
	roll_finished_timer.stop()
	roll_speed_finished()
	$Label3D.hide()

func state_process(_delta: float) -> void:
	check_for_player_falling()

func play_animation() -> void:
	pass
	#animation_tree_manager.force_travel_animation(["grounded", "rolling"])

func lock_turning() -> void:
	my_actor.get_component("ModelRotationComponent").set_turning(false)

func roll() -> void:
	roll_speed_increase_timer.start()
	roll_finished_timer.start()
	
	# Roll at full consistent speed and direction
	var get_movement_direction: Vector3 = my_actor.get_component("InputComponent").movement_logic()
	my_actor.get_component("MovementComponent").set_movement_direction(get_movement_direction.normalized())
	
	my_actor.get_component("MovementComponent").speed_mod("Rolling", true)
	my_actor.get_component("MovementComponent").accel_mod("Rolling", true)
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	my_actor.get_component("ModelRotationComponent").force_model_rotation_to_velocity()

func _on_roll_speed_increase_timer_timeout() -> void:
	roll_speed_finished()

func roll_speed_finished() -> void:
	my_actor.get_component("MovementComponent").speed_mod("Rolling", false)
	my_actor.get_component("MovementComponent").accel_mod("Rolling", false)

#This is for blending into idle instead of rolling if not moving after a roll
func check_if_moving() -> void:
	if my_actor.get_component("InputComponent").movement_direction.length() != 0:
		return
	animation_tree_manager.set_animation(["grounded", "idle"])

func _on_roll_finished_timer_timeout() -> void:
	give_player_control_back()

func give_player_control_back() -> void:
	my_actor.get_component("ModelRotationComponent").set_turning(true)
	my_state_machine.change_state("PlayerGroundedState")
	check_if_moving()

func check_for_player_falling() -> void:
	if my_actor.is_on_floor() or my_actor.get_component("RayCastComponent").check_raycast():
		return
	my_state_machine.change_state("PlayerJumpedState")
