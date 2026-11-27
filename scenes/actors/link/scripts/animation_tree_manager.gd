class_name AnimationTreeManager
extends Component

@export var animation_tree: AnimationTree

const ANI_TEMPLATE: String = "parameters/%s/conditions/is_%s"

var global_state_transition: AnimationNodeTransition 

var x_fade_times: Dictionary[String, float] = {
	"grounded": 0.15,
	"combat": 0.025,
	"other": 0.0,
}

var curr_ani_state: Array = ["grounded", "idle"]

var current_state: String

func _ready() -> void:
	super()
	animation_tree.active = true
	global_state_transition = animation_tree.tree_root.get_node("transition")

func manual_state_change(animation: Array, state: bool) -> void:
	animation_tree[ANI_TEMPLATE % animation] = state

func check_state_machine(animation: Array) -> void:
	var state: String = animation[0]
	if current_state == state:
		return
	global_state_transition.set_xfade_time(x_fade_times.get(state))
	animation_tree.set("parameters/transition/transition_request", state)
	current_state = state

# example: ["Grounded", "idle"]
func set_animation(animation: Array) -> void:
	check_state_machine(animation)
	
	animation_tree[ANI_TEMPLATE % curr_ani_state] = false
	animation_tree[ANI_TEMPLATE % animation] = true
	curr_ani_state = animation

func travel_animation(animation: Array) -> void:
	check_state_machine(animation)
	animation_tree[ANI_TEMPLATE % curr_ani_state] = false
	var template: String = "parameters/%s/playback"
	var state_machine: AnimationNodeStateMachinePlayback
	state_machine = animation_tree.get(template % animation[0])
	state_machine.travel(StringName(animation[1]))

func force_travel_animation(animation: Array) -> void:
	check_state_machine(animation)
	
	animation_tree[ANI_TEMPLATE % curr_ani_state] = false
	var template: String = "parameters/%s/playback"
	var state_machine: AnimationNodeStateMachinePlayback
	state_machine = animation_tree.get(template % animation[0])
	state_machine.start(StringName(animation[1]))

func set_transition_animation(animation: Array, item: String) -> void:
	var template: String = "parameters/%s/%s/%s/transition_request"
	var path: String = String(template % animation)
	animation_tree.set(path, item)

func set_animation_speed(animation: Array, item: float) -> void:
	var template: String = "parameters/%s/%s/%s/scale"
	var path: String = String(template % animation)
	animation_tree.set(path, item)

func get_animation_active(animation: String) -> bool:
	var template: String = "parameters/%s/active"
	var path: String = String(template % animation)
	return animation_tree.get(path)

func abort_one_shot(animation: String) -> void:
	var template: String = "parameters/%s/request"
	var path: String = String(template % animation)
	animation_tree.set(path, AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
