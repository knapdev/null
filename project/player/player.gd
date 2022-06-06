extends CharacterBody3D

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var walk_speed: float = 4
@export var turn_speed: float = 110

var move_speed: float = walk_speed

var state: StateMachine = null

func _ready():
	state = StateMachine.new()
	state.init(self, PlayerIdleState.new())

func _input(event):
	state.input(event)

func _process(delta):
	state.process(delta)

func _physics_process(delta):
	state.physics_process(delta)

func get_move_input():
	return Input.get_vector("turn_left", "turn_right", "move_forward", "move_backward")
	
func get_look_input():
	return Input.get_vector("look_left", "look_right", "look_up", "look_down")
