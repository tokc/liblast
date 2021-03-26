extends Spatial

func spawn(player: Player):
	player.translation = player.get_parent().to_local(global_transform.origin)
	player.velocity = Vector3()
