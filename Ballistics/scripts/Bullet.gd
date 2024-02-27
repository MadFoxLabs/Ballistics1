extends RigidBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_fired = false

var fins_position = Vector2(-2, 0)

var total_fins_area = 0.7
var cl = 0.3

var total_fins_section_area = 0.01
var cd = 0.7

var lift_force = Vector2()
var drag_force = Vector2()
var displacement = Vector2()



@onready var vectors_layer = $VectorsLayer
func fired(initial_speed_value, power, initial_angle):
	
	self.rotate(initial_angle)
	self.apply_impulse(initial_speed_value * power,Vector2())
	#velocity = initial_speed_value * power
	

func set_vector(node, camera_2d):
	vectors_layer.draw.add_vector(
		node, "linear_velocity", 0.3, 4, Color(1,1,1, 0.5), true)
		
	vectors_layer.draw.add_vector(
		node, "lift_force", 1, 4, Color(0,1,0, 0.5), true)
	
	vectors_layer.draw.add_vector(
		node, "drag_force", 10, 4, Color(1,0,0, 0.5), true)
	vectors_layer.draw.add_vector(
		node, "displacement", 10, 4, Color(0,0,1, 0.5), true)
	vectors_layer.set_custom_camera(camera_2d)

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if not body.is_in_group("Player"):
		var EXPLOSION  = load("res://scenes/explosion.tscn")
		var explosion = EXPLOSION.instantiate()
		explosion.position = self.position
		get_parent().add_child(explosion)
		
		self.queue_free()

func angle_of_attack_calculation(a, b):
	
	return acos(a.dot(b)/(a.length() * b.length()))
	
func lift_angle_of_attack_mod(aa):
	
	if aa > 0 and aa < 0.262:
		return 4.77 * aa #+ 0.5 
	elif aa >= 0.262 and aa < 0.35:
		return 1.75
	else:
		return -4.77 * aa + 3.42
	

func _integrate_forces(state):
	var direction_vector = Vector2(1,0).rotated(rotation)
	var aa = angle_of_attack_calculation(direction_vector,linear_velocity)
	#var aa = angle_of_attack_calculation(linear_velocity, direction_vector)
	var lift_aa_coef = lift_angle_of_attack_mod(abs(aa))
	
	var product = direction_vector.dot(linear_velocity) 
	var crossed = direction_vector.cross(linear_velocity)
	if crossed < 0:
		aa = -aa
	lift_force = 0.5 * linear_velocity.normalized().rotated(PI/2) * .002377 * product * product * total_fins_area * cl * lift_aa_coef
	drag_force = -0.5 * linear_velocity.normalized() * .002377 * product * product * total_fins_section_area * cd
	#print(aa)
	displacement = fins_position.rotated(rotation)
	if crossed > 0:
		apply_force(lift_force, displacement)
		#print("positive")
		
	else:
		lift_force = - lift_force
		apply_force(lift_force, displacement)
		#print("negative")
		
	apply_force(drag_force, displacement)
	
	#print(lift_force)
	#print(drag_force)
	#apply_force(-lift_force, fins_position.rotated(rotation))
	#print(product)
	#print(linear_velocity.length())
