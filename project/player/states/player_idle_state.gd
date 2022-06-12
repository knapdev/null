extends BaseState
class_name PlayerIdleState

func enter():
	context.playback.travel("Idle")
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
		
	context.turn(0.0, delta)
	context.move(0.0, delta)
		
	var look_input_dir = context.get_look_input()
	context.look(look_input_dir, delta)
