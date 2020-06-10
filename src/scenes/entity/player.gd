extends Entity


func _input(event):
	if event.is_action_pressed("move_right"):
		required_move_direction=Vector3.RIGHT
	elif event.is_action_pressed("move_left"):
		required_move_direction=Vector3.LEFT
	elif event.is_action_pressed("move_down"):
		required_move_direction=Vector3.BACK
	elif event.is_action_pressed("move_up"):
		required_move_direction=Vector3.FORWARD
	elif event.is_action_released("move_right"):
		if required_move_direction.x==1:
			required_move_direction.x=0
	elif event.is_action_released("move_left"):
		if required_move_direction.x==-1:
			required_move_direction.x=0
	elif event.is_action_released("move_up"):
		if required_move_direction.z==-1:
			required_move_direction.z=0
	elif event.is_action_released("move_down"):
		if required_move_direction.z==1:
			required_move_direction.z=0
	require_movement()
