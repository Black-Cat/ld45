extends Spatial

onready var nothing_scene = preload('res://scenes/Nothing.tscn')

func _ready():
	call_deferred('spawn_nothing')

func spawn_nothing():
	var nothing = nothing_scene.instance()
	get_parent().add_child(nothing)
	nothing.global_transform.origin = global_transform.origin