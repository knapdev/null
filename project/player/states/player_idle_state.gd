class_name PlayerIdleState
extends BaseState

func enter():
	super.enter()
	
func exit():
	super.exit()
	
func input(event: InputEvent):
	super.input(event)
	
func process(delta: float):
	super.process(delta)
	
	if Input.is_action_just_released("ui_accept"):
		if context.is_armed:
			context.state.push_state(PlayerHolsterWeaponState.new())
		else:
			context.state.push_state(PlayerDrawWeaponState.new())
	
func physics_process(delta: float):
	super.physics_process(delta)
	
	var move_input_dir = context.get_move_input()
	if move_input_dir.length_squared() > 0:
		context.state.change_state(PlayerMoveState.new())
		
	context.turn(0.0, delta)
	context.move(0.0, delta)
		
	var look_input_dir = context.get_look_input()
	context.look(look_input_dir, delta)
