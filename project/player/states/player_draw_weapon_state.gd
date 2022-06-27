class_name PlayerDrawWeaponState
extends BaseState

var has_triggered: bool = false

func enter():
	super.enter()
	
func exit():
	super.exit()
	
func input(event: InputEvent):
	super.input(event)
	
func process(delta: float):
	super.process(delta)
	
	if has_triggered == false:
		context.anim_tree.set("parameters/DrawWeapon/active", true)
		has_triggered = true
	else:
		if context.anim_tree.get("parameters/DrawWeapon/active") == false:
			context.anim_tree.set("parameters/ArmedTransition/current", true)
			context.is_armed = true
			context.state.pop_state()
	
func physics_process(delta: float):
	super.physics_process(delta)
		
	context.turn(0.0, delta)
	context.move(0.0, delta)
		
	var look_input_dir = context.get_look_input()
	context.look(look_input_dir, delta)
