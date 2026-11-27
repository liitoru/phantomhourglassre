class_name RayCastComponent
extends Component

@export var raycast: RayCast3D

func check_raycast() -> bool:
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		if raycast.get_collider().get_parent().is_in_group("no_jump_zone"):
			return true
	
	return raycast.is_colliding()
