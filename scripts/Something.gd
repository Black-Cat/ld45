extends RigidBody

onready var nothing_scene = preload('res://scenes/SomethingToNothing.tscn')
var nothing

func _ready():
	nothing = nothing_scene.instance()
	connect('body_entered', self, 'on_body_entered')

func on_body_entered(body):
	if not 'full_nothing' in body:
		return

	if body.drag_n_drop:
		return

	if nothing == null or not body.full_nothing:
		return


	get_parent().add_child(nothing)
	nothing.transform = transform
	nothing = null
	queue_free()
