class_name InputComponent
extends Component

signal interacted

@onready var interact_timer: Timer = $InteractTimer

var movement_direction: Vector3

var movement_vector: Vector2

func _ready() -> void:
	super()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		interacted.emit()

func movement_logic() -> Vector3:
	movement_direction = Vector3(movement_vector.y, 0, movement_vector.x)
	
	if movement_direction.length() > 0.5:
		movement_direction = movement_direction.normalized()
	
	return movement_direction
