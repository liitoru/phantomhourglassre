class_name PlayerFallingState
extends ActorState

var animation_tree_manager: AnimationTreeManager

func _ready() -> void:
	super()
	animation_tree_manager = my_actor.get_component("AnimationTreeManager")

func enter_state():
	super()
	my_actor.get_component("ModelRotationComponent").set_turning(false)
	play_animation()
	$Label3D.show()

func exit_state():
	super()
	my_actor.get_component("ModelRotationComponent").set_turning(true)
	$Label3D.hide()

func state_process(_delta: float) -> void:
	check_for_player_landed()

func play_animation() -> void:
	pass
	#animation_tree_manager.set_animation(["grounded", "falling"])

func check_for_player_landed() -> void:
	if !my_actor.is_on_floor():
		return
	my_state_machine.change_state("PlayerLandedState")
