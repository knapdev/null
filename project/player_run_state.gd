class_name PlayerRunState
extends BaseState

func enter():
	super.enter()
	
	context.move_speed = context.run_move_speed
	context.turn_speed = context.run_turn_speed
	
	if context.is_armed:
		context.anim_tree.set("parameters/ArmedRunningTransition/current", true)
	else:
		context.anim_tree.set("parameters/UnarmedRunningTransition/current", true)
	
func exit():
	super.exit()
	
	context.move_speed = context.walk_move_speed
	context.turn_speed = context.walk_turn_speed
	
	if context.is_armed:
		context.anim_tree.set("parameters/ArmedRunningTransition/current", false)
	else:
		context.anim_tree.set("parameters/UnarmedRunningTransition/current", false)
	
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
		
	if abs(move_input_dir.y) < 0.5:
		context.state.pop_state()
	
	context.turn(move_input_dir.x, delta)
	context.move(1.0, delta)
	
	var look_input_dir = context.get_look_input()
	context.look(look_input_dir, delta)
