extends Control

var custom_camera = null
@onready var vectors_layer = $".."


class Vector:
	var object  # The node to follow
	var property  # The property to draw
	var scale  # Scale factor
	var width  # Line width
	var color  # Draw color
	var is_visible = true
	var vector_name = ""
	var initial_position_text = ""
	var final_position_text = "" 
	
	

	func _init(_object, _property, _scale, _width, _color, _is_visible):
		object = _object
		property = _property
		scale = _scale
		width = _width
		color = _color
		is_visible = _is_visible

	func draw(node, camera, canvas):
		if not is_visible:
			return
		
		var camera_coords = camera.get_screen_center_position()
		var screen_coords = camera.get_viewport().get_screen_transform() * camera.get_global_transform_with_canvas() * object.position
		var object_coords = object.get_global_transform() * object.position
		var camera_object_coords = camera.get_global_transform().affine_inverse() * object_coords
		
		#var start = Vector2( object.global_position.x - camera_coords.x,
					 #object.global_position.y - camera_coords.y)
		var start = (camera.get_viewport().get_screen_transform() * camera.get_global_transform_with_canvas() * object.position 
			- object.position + 
			Vector2( object.global_position.x - camera_coords.x,
					 object.global_position.y - camera_coords.y))
		#var start = object_coords
		print(camera.get_viewport().get_screen_transform() * camera.get_global_transform_with_canvas() * object.position)
		print(object.position)
		#var start = Vector2( - camera_coords.x,
					 #- camera_coords.y)
		var end =  start  + object.get(property) * scale 
		
		#var start =  object.global_transform.origin + camera.global_transform.origin
		#var end = object.global_transform.origin + object.get(property) * scale + camera.global_transform.origin
		node.draw_line(start, end, color, width)
		draw_triangle(node, end, start.direction_to(end), width*2, color)

	func draw_triangle(node, pos, dir, size, color):
		var a = pos + dir * size
		var b = pos + dir.rotated(2*PI/3) * size
		var c = pos + dir.rotated(4*PI/3) * size
		
		var points = Array([a, b, c])
		node.draw_polygon(points, Array([color]))


var vectors = []  # Array to hold all registered values.
func _ready():
#	visible = get_parent().start_visible
	pass
func _process(delta):
	if not visible:
		return
	queue_redraw()

func _draw():
	var camera = custom_camera
	if custom_camera != null:
		camera = get_viewport().get_camera_2d()
	
	if camera == null:
			return
	for vector in vectors:
		vector.draw(self, camera, vectors_layer)
		
func add_vector(object, property, scale, width, color, start_visible = true):
	
	vectors.append(Vector.new(object, property, scale, width, color, start_visible))
