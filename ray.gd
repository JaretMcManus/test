extends RayCast

var canCollide := false

#func _process(delta):
#	var collidedArea = get_collider() as Barrier
#	if collidedArea:
#		GameEvents.emit_signal("rayCollided",get_collision_point())
	
func shoot():
	var collidedArea = get_collider() as Barrier
	if collidedArea:
		GameEvents.emit_signal("rayCollided",get_collision_point())
