class_name GravityComponent
extends Component

@export var gravity: float = 20.0
@export var enabled: bool = true

func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

func apply_gravity(delta: float) -> void:
	if !my_actor.is_on_floor() and enabled:
		my_actor.velocity.y -= gravity * delta

func enable_gravity(recieved_bool: bool) -> void:
	enabled = recieved_bool
