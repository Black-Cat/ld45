extends Node

var map

func _ready():
	parse_map('res://maps/map0.map')

func parse_map(path):
	var file = File.new()
	if file.open(path, File.READ) != 0:
		print('Error opneing file %s' % path)
		return

	var map_dictionary = {}
	var map_land = []

	var line = file.get_line()
	while line != '':
		var segments = line.split(' ')
		var id = segments[0]
		var name = segments[1]
		map_dictionary[id] = name
		line = file.get_line()

	while not file.eof_reached():
		var row = file.get_line()
		var ids_string = row.split(' ')
		var ids = []
		for id in ids_string:
			ids.push_back(id)
		map_land.push_back(ids)

	# Remove last row, cause reasons
	map_land.pop_back()

	# Reverse map land for programming purposes
	map_land.invert()

	map = {}
	map.dictionary = map_dictionary
	map.land = map_land
