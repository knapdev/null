extends Node3D

var pitch: float = 0.0

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var playback = anim_tree.get("parameters/playback")

func _ready():
	pass

func _process(delta):
	var input = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	#print("input " + str(input))
	var pitch_this_frame = (input * 45.0) * delta
	#print("frame " + str(pitch_this_frame))
	pitch += pitch_this_frame
	pitch = clamp(pitch, -60, 80)
	
	var blend_amount: float = pitch / 90.0
		
	#print(str(pitch) + ", " + str(blend_amount))
	anim_tree.set("parameters/StateMachine/Aim/blend_position", blend_amount)
	$YPivot/XPivot.rotation.x = deg2rad(pitch)
