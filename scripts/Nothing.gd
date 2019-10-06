extends RigidBody
class_name Nothing

export(float) var transformation_time = 0.0
var start_transformation_time = 0.0
var mat
var nothing_mat = preload('res://materials/Nothing.tres')

export(bool) var full_nothing = false
var drawing_force = false

onready var force_line_scene = preload('res://scenes/ForceLine.tscn')
var force_line

func _ready():
	force_line = force_line_scene.instance()
	add_child(force_line)
	force_line.visible = false

	if transformation_time > 0.0:
		full_nothing = false
		start_transformation_time = transformation_time
		mat = get_child(0).get_surface_material(0)
		mat = mat.duplicate()
		get_child(0).set_surface_material(0, mat)

func _process(delta):
	if not full_nothing and transformation_time > 0.0:
		transformation_time -= delta
		mat.set_shader_param('mix_coef', 1.0 - (transformation_time / start_transformation_time))
		full_nothing = transformation_time < 0.0
		if full_nothing:
			get_child(0).set_surface_material(0, nothing_mat)
			for body in get_colliding_bodies():
				body.emit_signal('body_entered', self)

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
