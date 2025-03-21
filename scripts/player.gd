extends RigidBody2D

var mouse_control = false
var direction_mult = { # Define Directional Multipliers
	"forward": 1.0,
	"lateral": 0.7,
	"backward": 0.5
}
var linear_thrust = 300 # Overall thrust multiplier
var angular_thrust = 5000 # Overall yaw thrust multiplier
var thrustparticles; # Booster particles

func process_movement() -> void:
	# Initialize zero force vector
	var precalc_force = Vector2(0, 0)
	
	# Calculate 0-1 force mult for each input
	if Input.is_action_pressed("move_forward"):
		precalc_force.x += direction_mult["forward"] * Input.get_action_strength("move_forward")
	if Input.is_action_pressed("move_backward"):
		precalc_force.x -= direction_mult["backward"] * Input.get_action_strength("move_backward")
	if Input.is_action_pressed("move_left"):
		precalc_force.y -= direction_mult["lateral"] * Input.get_action_strength("move_left")
	if Input.is_action_pressed("move_right"):
		precalc_force.y += direction_mult["lateral"] * Input.get_action_strength("move_right")
	
	# Apply overall mult
	precalc_force *= linear_thrust
	
	# Rotate and apply force vector
	constant_force.y = \
		cos(rotation) * precalc_force.y + \
		sin(rotation) * precalc_force.x
	constant_force.x = \
		cos(rotation) * precalc_force.x - \
		sin(rotation) * precalc_force.y
	
	# Handle yaw forces
	if mouse_control: # Implement PID LOOP?
		var mouse_direction = (get_global_mouse_position() - global_position).normalized()
		var angle_to_mouse = Vector2().from_angle(rotation).angle_to(mouse_direction)
		
		constant_torque = angle_to_mouse / PI * angular_thrust
	
	else:
		if Input.is_action_pressed("yaw_left"):
			constant_torque = -angular_thrust
		elif Input.is_action_pressed("yaw_right"):
			constant_torque = angular_thrust
		else:
			constant_torque = 0

func process_emitters() -> void:
	thrustparticles.amount_ratio = Input.get_action_strength("move_forward")
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thrustparticles = get_node("thrustParticles")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_movement()
	process_emitters()
