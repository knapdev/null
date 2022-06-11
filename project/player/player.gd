extends CharacterBody3D

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var walk_speed: float = 4
@export var turn_speed: float = 90

@export var look_range_hori: float = 60.0
@export var look_range_vert: float = 30.0
@export var look_speed: float = 7.5

var move_speed: float = walk_speed

var direction: Vector3 = Vector3.FORWARD

var state: StateMachine = null

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var camrig: Position3D = $CamRig
@onready var camrig_pivot: Position3D = $CamRig/Pivot
@onready var camrig_springarm: SpringArm3D = $CamRig/Pivot/SpringArm

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
	
func apply_gravity(delta: float):
	if is_on_floor() == false:
		velocity.y -= GRAVITY * delta
	
func move(amount: float, delta: float):
	var move_dir = direction * amount
	velocity.x = move_dir.x * move_speed
	velocity.z = move_dir.z * move_speed
	apply_gravity(delta)
	move_and_slide()
	
func turn(amount: float, delta: float):
	direction = direction.rotated(Vector3.UP, deg2rad((-amount * turn_speed) * delta))
	mesh.rotation.y = lerp_angle(mesh.rotation.y, -atan2(direction.z, direction.x) + deg2rad(90), 0.25)
	
	camrig.rotation.y = lerp_angle(camrig.rotation.y, -atan2(direction.z, direction.x) - deg2rad(90), 0.25)

func look(look_dir: Vector2, delta: float):
	var cam_rot_y = camrig_springarm.rotation.y
	var cam_rot_x = camrig_springarm.rotation.x
	camrig_springarm.rotation.y = lerp_angle(cam_rot_y, camrig_pivot.rotation.y - deg2rad(look_range_hori * look_dir.x), look_speed * delta)
	camrig_springarm.rotation.x = lerp_angle(cam_rot_x, camrig_pivot.rotation.x - deg2rad(look_range_vert * look_dir.y), look_speed * delta)
