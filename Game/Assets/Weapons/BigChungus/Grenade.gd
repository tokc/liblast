extends RigidBody


var shooter


master func on_hit(damage, location):
	var direction = location.direction_to(transform.origin)
	# Central so that it doesn't just spin wildly like a bowling ball.
	apply_central_impulse(direction * damage)
