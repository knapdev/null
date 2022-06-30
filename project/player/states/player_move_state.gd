class_name PlayerMoveState
extends BaseState

func enter():
	super.enter()
	
func exit():
	super.exit()
	
func input(event: InputEvent):
	super.input(event)
	
func process(delta: float):
	super.process(delta)
	
	context.camera_rig_offset.rotation.x = lerp(context.camera_rig_offset.rotation.x, 0.0, 10 * delta)
	
	if Input.is_action_pressed("aim") && context.is_armed == true:
		context.state.change_state(PlayerIdleState.new())
		context.state.push_state(PlayerAimWeaponState.new())
	
	if Input.is_action_just_pressed("equip_toggle"):
		if context.is_armed:
			context.state.change_state(PlayerIdleState.new())
			context.state.push_state(PlayerHolsterWeaponState.new())
		else:
			context.state.change_state(PlayerIdleState.new())
			context.state.push_state(PlayerDrawWeaponState.new())
	
func physics_process(delta: float):
	super.physics_process(delta)
	
	var move_input_dir = context.get_move_input()
	if move_input_dir.length_squared() <= 0:
		context.state.change_state(PlayerIdleState.new())
	
	context.turn(move_input_dir.x, delta)
	context.move(-move_input_dir.y, delta)
	
	var look_input_dir = context.get_look_input()
	context.look(look_input_dir, delta)
