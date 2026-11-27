extends Node

@onready var player: Actor = get_owner()

var input_component: InputComponent

func _ready() -> void:
	input_component = player.get_component("InputComponent")

func _process(_delta: float) -> void:
	if !input_component:
		return
	
	input_component.movement_vector = Input.get_vector("move_forward", "move_backward", "move_left", "move_right")
