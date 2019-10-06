extends Node

const EMPTY_SPACE_NAME = 'Empty'

onready var map_dictionary = preload('res://scenes/Dictionary.tscn').instance()
onready var map_node = get_node('Map')

func _ready():
	spawn_map()

func spawn_map():
	# Reset map
	for child in map_node.get_children():
		child.queue_free()

	# Spawn map
	var map = GameManager.map
	for y in range(map.land.size()):
		var voxel_row = []
		for x in range(map.land[y].size()):
			var id = map.land[y][x]
			var name = map.dictionary[id]
			if name == EMPTY_SPACE_NAME:
				continue
			var voxel = map_dictionary.get_node(name).duplicate()
			map_node.add_child(voxel)
			voxel.transform.origin = Vector3(x, y, 0) * map_dictionary.grid_size
			voxel_row.push_back(voxel)
