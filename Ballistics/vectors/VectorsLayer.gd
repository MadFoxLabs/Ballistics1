extends CanvasLayer

@onready var draw = get_node("DebugDraw3D")

var custom_camera = null

var start_visible = true

var my_list_vectors = []

func _ready():
	if not InputMap.has_action("toggle_debug"):
		InputMap.add_action("toggle_debug")
		var ev = InputEventKey.new()
#		ev.scancode = KEY_BACKSLASH
		InputMap.action_add_event("toggle_debug", ev)
		
func _input(event):
	if event.is_action_pressed("toggle_debug"):
		for n in get_children():
			n.visible = not n.visible

func set_custom_camera(new_camera):
	draw.custom_camera = new_camera

func get_hidden_label():
	for c in get_node("MyLabels").get_children():
		if c.visible != true:
			return c
			
	return null

#func add_vector(v):
#	my_list_vectors.append(v)
func add_vector(object, property, scale, width, color, start_visible):
	draw.add_vector(object, property, scale, width, color, start_visible)
#func add_vector(object, property, scale, width, color, start_visible = true):
func show_label(label_text, label_position):
	var my_label = get_hidden_label()
	if my_label == null:
		my_label = Label.new()
		my_label.position = label_position
		my_label.set_text(label_text)
	else:
		my_label.visible = true
		my_label.position = label_position
		my_label.set_text(label_text)
		
	return my_label
