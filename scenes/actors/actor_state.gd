class_name ActorState
extends State

var my_actor: Actor

func _ready() -> void:
	super()
	get_actor()

func get_actor() -> void:
	my_actor = owner
