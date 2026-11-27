class_name MovementComponent
extends Component

@export var move_speed: float = 5.0
@export var acceleration: float = 0.4

var movement_direction: Vector3 = Vector3.ZERO
var knockback_direction: Vector3 = Vector3.ZERO

var speed_multiplier: float = 1.0
var final_speed: float = move_speed
var final_accel: float = acceleration

var speed_modifiers: Dictionary[String, float] = {
	"Rolling": 2.0,
	"Jumping": 0.7,
	"Landed": 0.0,
	"Stabbing": 0.0,
	"Slashing": 0.0,
	"SpinAttacking": 0.0,
	"ZTarget": 0.7,
	"Dodging": 1.5,
	"launching": 1.5,
	"launching_up": 0.0,
	"PickingUp": 0.0,
	"Throwing": 0.0,
	"UsingItem": 0.0,
	"ItemGot": 0.0,
	"Rebound": 0.0,
	"Dizzy": 0.0,
	"Cutscene": 0.0,
}

var acceleration_modifiers: Dictionary[String, float] = {
	"Rolling": 20.0,
	"JumpSlashing": 20.0,
	"launching": 20.0,
	"launching_up": 0.7,
}

var current_speed_mods: Array[String] = []
var current_accel_mods: Array[String] = []

var my_actors_velocity: float

func _ready() -> void:
	super()

func _physics_process(_delta: float) -> void:
	move_actor()

func _process(_delta: float) -> void:
	my_actors_velocity = my_actor.velocity.length() / move_speed

func speed_mod(modifier: String, add: bool) -> void:
	if add and !current_speed_mods.has(modifier):
		current_speed_mods.append(modifier)
	elif !add and current_speed_mods.has(modifier):
		current_speed_mods.erase(modifier)
	add_up_speed_mods()

func accel_mod(modifier: String, add: bool) -> void:
	if add and !current_accel_mods.has(modifier):
		current_accel_mods.append(modifier)
	elif !add and current_accel_mods.has(modifier):
		current_accel_mods.erase(modifier)
	add_up_accel_mods()

func add_up_speed_mods() -> void:
	final_speed = move_speed
	for mod in current_speed_mods:
		final_speed *= speed_modifiers.get(mod)

func add_up_accel_mods() -> void:
	final_accel = acceleration
	for mod in current_accel_mods:
		final_accel *= acceleration_modifiers.get(mod)

func speed_mod_reset() -> void:
	current_speed_mods.clear()
	final_speed = move_speed

func accel_mod_reset() -> void:
	current_accel_mods.clear()
	final_accel = acceleration

func set_movement_direction(received_movement_direction: Vector3) -> void:
	movement_direction = received_movement_direction

func set_acceleration(received_acceleration: float) -> void:
	acceleration = received_acceleration
	
func set_knockback_direction(direction: Vector3, knockback: float) -> void:
	var finale_knockback: float = knockback if my_actor.is_on_floor() else knockback / 2.0
	my_actor.velocity = direction * finale_knockback

func move_actor() -> void: 
	my_actor.velocity.x = move_toward(my_actor.velocity.x, \
	movement_direction.x * final_speed * speed_multiplier, final_accel)
	
	my_actor.velocity.z = move_toward(my_actor.velocity.z, \
	movement_direction.z * final_speed * speed_multiplier, final_accel)
	
	my_actor.move_and_slide()
