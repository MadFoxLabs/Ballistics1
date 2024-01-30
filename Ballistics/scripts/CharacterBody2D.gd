extends CharacterBody2D
const BULLET = preload("res://scenes/bullet.tscn")

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_released("ui_accept"):
		pass
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("ui_left"):
		rotation_degrees -= 1
	elif Input.is_action_pressed("ui_right"):
		rotation_degrees += 1
		
	if Input.is_action_just_pressed("ui_accept"):
		var new_bullet = BULLET.instantiate()
		new_bullet.position = self.position
		new_bullet.fired(Vector2.RIGHT.rotated(self.rotation), 1250)
		
		get_parent().add_child(new_bullet)

	move_and_slide()
