class_name PlayerLandedState
extends ActorState

@onready var recover_timer: Timer = $RecoverTimer

var animation_tree_manager: AnimationTreeManager

func _ready() -> void:
	super()
	animation_tree_manager = my_actor.get_component("AnimationTreeManager")

func enter_state():
	super()
	play_animation()
	recover_timer.start()
	my_actor.get_component("ModelRotationComponent").set_turning(false)
	my_actor.get_component("MovementComponent").speed_mod("Landed", true)
	$Label3D.show()

func exit_state():
	super()
	my_actor.get_component("ModelRotationComponent").set_turning(true)
	my_actor.get_component("MovementComponent").speed_mod("Landed", false)
	recover_timer.stop()
	$Label3D.hide()

func play_animation() -> void:
	pass
	#animation_tree_manager.force_travel_animation(["grounded", "landed"])

func give_control_back() -> void:
	my_actor.get_component("ModelRotationComponent").set_turning(true)
	my_actor.get_component("MovementComponent").speed_mod("Landed", false)
	animation_tree_manager.travel_animation(["grounded", "idle"])
	my_state_machine.change_state("PlayerGroundedState")

func _on_recover_timer_timeout() -> void:
	give_control_back()
