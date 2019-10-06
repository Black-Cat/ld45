extends Area

func _ready():
	connect('body_entered', self, 'on_body_entered')

func on_body_entered(body):
	if not body is Nothing:
		return

	body.queue_free()
