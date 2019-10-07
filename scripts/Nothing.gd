extends RigidBody
class_name Nothing

signal clicked

var held = false

export(float) var transformation_time = 0.0
var start_transformation_time = 0.0
var mat
var nothing_mat = preload('res://materials/Nothing.tres')

export(bool) var full_nothing = false
export(bool) var drag_n_drop = false
var held_object = null

func _ready():
	connect("clicked", self, "_on_pickable_clicked")
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

	if held:
		var dropPlane  = Plane(Vector3(0, 0, 1), 0)
		var position3D = dropPlane.intersects_ray(
                             get_viewport().get_camera().project_ray_origin(get_viewport().get_mouse_position()),
                             get_viewport().get_camera().project_ray_normal(get_viewport().get_mouse_position()))
		global_transform.origin = position3D


func pickup():
    if held:
        return
    mode = RigidBody.MODE_RIGID
    held = true

func drop(impulse):
    if held:
        mode = RigidBody.MODE_RIGID
        add_central_force(impulse)
        held = false

func _on_pickable_clicked(object):
	if !held_object:
        held_object = object
        held_object.pickup()

func _unhandled_input(event):
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
        if held_object and !event.pressed:
            held_object.drop(Vector3(Input.get_last_mouse_speed().x,Input.get_last_mouse_speed().y,0))
            held_object = null
            drag_n_drop = false
            for body in get_colliding_bodies():
              body.emit_signal('body_entered', self)
            

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			emit_signal("clicked", self)
			drag_n_drop = true
