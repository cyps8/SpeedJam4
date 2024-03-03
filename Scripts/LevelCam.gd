extends Camera2D

func _process(_delta):
	var player_position = %Player.position.x
	var player_vel = %Player.velocity.x

	var target_position: float = player_position + sign(player_vel) * 150
	if target_position < 0:
		target_position = 0

	position.x = lerp(position.x, target_position, 0.07)