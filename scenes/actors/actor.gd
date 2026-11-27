class_name Actor
extends CharacterBody3D

var components: Dictionary[String, Component] = {}

func receive_component(new_component: Component) -> void:
	components[new_component.name] = new_component

func get_component(component_name: String) -> Component:
	return components.get(component_name, null)
