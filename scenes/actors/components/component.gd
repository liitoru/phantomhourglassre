class_name Component
extends Node

var my_actor: Actor

func _ready() -> void:
	add_to_actor()

func add_to_actor() -> void:
	if owner is not Actor:
		return
	my_actor = owner
	my_actor.receive_component(self)
