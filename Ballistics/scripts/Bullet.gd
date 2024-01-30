extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_fired = false

func fired(initial_speed_value, power):
	velocity = initial_speed_value * power

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	rotation = velocity.angle()
	

	move_and_slide()


func _on_timer_timeout():
	queue_free()
