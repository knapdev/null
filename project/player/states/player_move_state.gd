extends BaseState
class_name PlayerMoveState

func enter():
	super.enter()
	
func exit():
	super.exit()
	
func input(event: InputEvent):
	super.input(event)
	
func process(delta: float):
	super.process(delta)
	
func physics_process(delta: float):
	super.physics_process(delta)
	
	var move_input_dir = context.get_move_input()
	if move_input_dir.length_squared() <= 0:
		context.state.change_state(PlayerIdleState.new())
	
	# turn
	context.rotation.y -= deg2rad(move_input_dir.x * context.turn_speed * delta)
	
	# move
	if context.is_on_floor() == false:
		context.velocity.y -= context.GRAVITY * delta
	
	var move_dir = (context.global_transform.basis.z * move_input_dir.y)
	context.velocity.x = move_dir.x * context.move_speed
	context.velocity.z = move_dir.z * context.move_speed
	context.move_and_slide()
	
	# look
	var look_input_dir = context.get_look_input()
	
	var camrig_pivot = context.get_node("CamRig/Pivot")
	var cam_rot_y = camrig_pivot.get_child(0).rotation.y
	var cam_rot_x = camrig_pivot.get_child(0).rotation.x
	camrig_pivot.get_child(0).rotation.y = lerp_angle(cam_rot_y, camrig_pivot.rotation.y - deg2rad(60 * look_input_dir.x), 0.15)
	camrig_pivot.get_child(0).rotation.x = lerp_angle(cam_rot_x, camrig_pivot.rotation.x - deg2rad(30 * look_input_dir.y), 0.15)
