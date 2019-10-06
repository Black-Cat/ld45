extends RigidBody

var drawing_force = false

onready var force_line_scene = preload('res://scenes/ForceLine.tscn')
var force_line

onready var something_scene = preload('res://scenes/Something.tscn')
var something

func _ready():
	force_line = force_line_scene.instance()
	add_child(force_line)
	force_line.visible = false

	something = something_scene.instance()

	connect('body_entered', self, 'on_body_entered')

func _process(delta):
	if drawing_force:
		var mouse_pos = get_viewport().get_mouse_position()
		var pos = get_viewport().get_camera().unproject_position(get_transform().origin)
		force_line.set_point_position(0, pos)
		force_line.set_point_position(1, mouse_pos)
		
		# Apply force
		var dir = force_line.get_point_position(1) - force_line.get_point_position(0)
		add_central_force(Vector3(dir.x, -dir.y, 0.0))

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not event.pressed:
			drawing_force = false
			force_line.visible = false

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if mode != RigidBody.MODE_RIGID:
			mode = RigidBody.MODE_RIGID
		drawing_force = event.pressed
		force_line.visible = drawing_force

func on_body_entered(body):
	if not body is StaticBody:
		return

	get_parent().add_child(something)
	something.transform = transform
	queue_free()
