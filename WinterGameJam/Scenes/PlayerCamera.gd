extends Camera2D






func _on_Player_Grounded_Update(isGrounded):
	drag_margin_v_enabled = !isGrounded
