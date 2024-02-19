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
	

	var collision = move_and_collide(velocity * delta)
	if collision:
		
		
		var EXPLOSION  = load("res://scenes/explosion.tscn")
		var explosion = EXPLOSION.instantiate()
		explosion.position = self.position
		get_parent().add_child(explosion)
		
		self.queue_free()


func _on_timer_timeout():
	queue_free()
