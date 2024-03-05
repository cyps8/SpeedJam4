extends Camera2D

func _process(_delta):
	var player_position = %Player.position.x
	var player_vel = %Player.velocity.x

	var target_position: float = player_position + sign(player_vel) * 150
	target_position = clamp(target_position, 0, 22500)

	position.x = lerp(position.x, target_position, 0.03)