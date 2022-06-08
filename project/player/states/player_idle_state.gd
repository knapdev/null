extends BaseState
class_name PlayerIdleState

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
	
	if context.get_move_input().length_squared() > 0:
		context.state.change_state(PlayerMoveState.new())
		
	# apply gravity
	if context.is_on_floor() == false:
		context.velocity.y -= context.GRAVITY * delta
	context.move_and_slide()
		
	# look
	var look_input_dir = context.get_look_input()
	
	var camrig_pivot = context.get_node("CamRig/Pivot")
	var cam_rot_y = camrig_pivot.get_child(0).rotation.y
	var cam_rot_x = camrig_pivot.get_child(0).rotation.x
	camrig_pivot.get_child(0).rotation.y = lerp_angle(cam_rot_y, camrig_pivot.rotation.y - deg2rad(60 * look_input_dir.x), 0.15)
	camrig_pivot.get_child(0).rotation.x = lerp_angle(cam_rot_x, camrig_pivot.rotation.x - deg2rad(30 * look_input_dir.y), 0.15)
