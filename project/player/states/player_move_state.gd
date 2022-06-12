extends BaseState
class_name PlayerMoveState

func enter():
	context.playback.travel("Walk")
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
	
	context.turn(move_input_dir.x, delta)
	context.move(-move_input_dir.y, delta)
	
	var look_input_dir = context.get_look_input()
	context.look(look_input_dir, delta)
	
	context.anim_tree.set("parameters/Walk/blend_position", -move_input_dir.y)
