extends CharacterBody2D
const BULLET = preload("res://scenes/bullet.tscn")
@onready var missiles = $"../../Missiles"
@onready var vectors_layer = $"../../VectorsLayer"
@onready var camera_2d = $"../Camera2D"
@onready var node_2d = $"../.."


var engine_torque = 15000

@onready var wheel_1 = $"../Wheel1"
@onready var wheel_2 = $"../Wheel2"

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_released("ui_accept"):
		pass
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#if Input.is_action_pressed("ui_left"):
		#rotation_degrees -= 1
	#elif Input.is_action_pressed("ui_right"):
		#rotation_degrees += 1
	if Input.is_action_pressed("ui_left"):
		rotation -= 0.01
	elif Input.is_action_pressed("ui_right"):
		rotation += 0.01
		
	if Input.is_action_just_pressed("ui_accept"):
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = self.global_position
		new_bullet.fired(Vector2.RIGHT.rotated(self.rotation), 1000, deg_to_rad(rotation_degrees))
		
		node_2d.add_child(new_bullet)
		new_bullet.set_vector(new_bullet, camera_2d)
	
	
	if Input.is_action_pressed("ui_up"):
		wheel_1.apply_torque(engine_torque)
		wheel_2.apply_torque(engine_torque)
	if Input.is_action_pressed("ui_down"):
		wheel_1.apply_torque(-engine_torque)
		wheel_2.apply_torque(-engine_torque)

	move_and_slide()
	
	
