class_name PlayerHolsterWeaponState
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
		context.anim_tree.set("parameters/HolsterWeapon/active", true)
		has_triggered = true
	else:
		if context.anim_tree.get("parameters/HolsterWeapon/active") == false:
			context.anim_tree.set("parameters/ArmedTransition/current", false)
			context.is_armed = false
			context.state.pop_state()
	
func physics_process(delta: float):
	super.physics_process(delta)
		
	context.turn(0.0, delta)
	context.move(0.0, delta)
		
	var look_input_dir = context.get_look_input()
	context.look(look_input_dir, delta)
