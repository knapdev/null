class_name PlayerAimWeaponState
extends BaseState

var aim_pitch: float = 0.0
var aim_yaw: float = 0.0

func enter():
	super.enter()
	
	context.camera_rig.set_target_camera_distance(context.camera_distance_aim)
	
	context.anim_tree.set("parameters/AimSeek/seek_position", 0.5)
	context.anim_tree.set("parameters/AimingTransition/current", true)
	
func exit():
	super.exit()
	
	context.camera_rig.set_target_camera_distance(context.camera_distance_normal)
	
	context.anim_tree.set("parameters/AimingTransition/current", false)
	
func input(event: InputEvent):
	super.input(event)
	
func process(delta: float):
	super.process(delta)
	
	context.camera_rig_pivot.rotation.y = lerp_angle(context.camera_rig_pivot.rotation.y, 0.0, 10 * delta)
	context.camera_rig_pivot.rotation.x = lerp_angle(context.camera_rig_pivot.rotation.x, 0.0, 10 * delta)
	
	if Input.is_action_pressed("aim") == false:
		context.state.pop_state()
	
	var aim_input_dir = context.get_look_input()
	
	var pitch_amount_this_frame: float = -aim_input_dir.y * context.aim_sensitivity_vertical * delta
	aim_pitch += pitch_amount_this_frame
	aim_pitch = clamp(aim_pitch, -60, 60)
	context.camera_rig_offset.rotation.x = deg2rad(aim_pitch)
	
	var aim_seek_position: float = (((-aim_pitch / 90.0) + 1.0) / 2.0)
	context.anim_tree.set("parameters/AimSeek/seek_position", aim_seek_position)
	
	var yaw_amount_this_frame: float = aim_input_dir.x * context.aim_sensitivity_horizontal * delta
	context.turn(yaw_amount_this_frame, delta)
	
func physics_process(delta: float):
	super.physics_process(delta)
	
	context.move(0.0, delta)
