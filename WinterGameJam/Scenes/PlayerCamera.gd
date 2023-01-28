extends Camera2D



func _on_player_grounded_update(isGrounded):
	drag_margin_v_enabled = !isGrounded
