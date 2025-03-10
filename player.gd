extends RigidBody2D

var direction_mult = {
	"forward": 1.0,
	"lateral": 0.5,
	"backward": 0.7
}
var linear_moveSpeed = 200
var angular_moveSpeed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var precalc_velocity = Vector2(0, 0)
	if Input.is_action_pressed("move_forward"):
		precalc_velocity.y -= linear_moveSpeed * delta * direction_mult["forward"]
	if Input.is_action_pressed("move_backward"):
		precalc_velocity.y += linear_moveSpeed * delta * direction_mult["backward"]
	if Input.is_action_pressed("move_left"):
		precalc_velocity.x -= linear_moveSpeed * delta * direction_mult["lateral"]
	if Input.is_action_pressed("move_right"):
		precalc_velocity.x += linear_moveSpeed * delta * direction_mult["lateral"]
	
	if Input.is_action_pressed("yaw_left"):
		angular_velocity -= angular_moveSpeed * delta
	if Input.is_action_pressed("yaw_right"):
		angular_velocity += angular_moveSpeed * delta
	
	linear_velocity.y = linear_velocity.y + \
		cos(rotation) * precalc_velocity.y + \
		sin(rotation) * precalc_velocity.x
	
	linear_velocity.x = linear_velocity.x + \
		cos(rotation) * precalc_velocity.x - \
		sin(rotation) * precalc_velocity.y
