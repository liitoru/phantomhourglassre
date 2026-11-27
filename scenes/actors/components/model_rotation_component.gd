class_name ModelRotationComponent
extends Component

@export var turn_weight: float = 15.0
@export var mesh: Node3D

var get_movement_direction: Vector3

var facing_angle: float
var default_turn_weight: float

var turning_is_enabled: bool = true
var input_turning: bool = true

func _ready() -> void:
	super()
	default_turn_weight = turn_weight

func _process(delta: float) -> void:
	get_movement_input()
	translate_vector_to_angle()
	if !input_turning:
		return
	rotate_model_towards_direction(delta)

func get_movement_input() -> void:
	get_movement_direction = my_actor.get_component("InputComponent").movement_logic()

func translate_vector_to_angle() -> void:
	facing_angle = Vector2(get_movement_direction.z, -get_movement_direction.x).angle()

func rotate_model_towards_direction(delta: float) -> void:
	if get_movement_direction == Vector3.ZERO or !turning_is_enabled:
		return
	
	mesh.rotation.y = lerp_angle(mesh.rotation.y, -facing_angle, turn_weight * delta)
	mesh.rotation.y = wrapf(mesh.rotation.y, -PI, PI)

func force_model_rotation_to_input() -> void:
	mesh.rotation.y = -facing_angle

func force_model_rotation_to_velocity() -> void:
	var direction: Vector3 = my_actor.velocity
	direction.y = 0.0
	
	if direction.length_squared() > 0.001:
		mesh.rotation.y = atan2(direction.x, direction.z)

func facing_angle_vector() -> Vector3:
	return Vector3(sin(mesh.rotation.y), 0, cos(mesh.rotation.y))

func set_turning(input: bool) -> void:
	turning_is_enabled = input

func input_turn(input: bool) -> void:
	input_turning = input

func face_towards_point(coords: Vector3) -> void:
	if !turning_is_enabled:
		return
	
	var to_target: Vector3 = coords - mesh.global_position
	to_target.y = 0.0
	to_target = to_target.normalized()
	
	var target_yaw := atan2(to_target.x, to_target.z)
	
	mesh.rotation.y = lerp_angle(
		mesh.rotation.y,
		target_yaw,
		turn_weight * get_physics_process_delta_time()
	)

func force_face_towards_point(coords: Vector3) -> void:
	mesh.look_at(coords, Vector3.UP)
	mesh.rotation.x = 0
	mesh.rotation.z = 0

func rotate_180() -> void:
	mesh.rotation.y += PI

func set_turn_weight(value: float) -> void:
	if value == 0:
		turn_weight = default_turn_weight
	else:
		turn_weight = value
