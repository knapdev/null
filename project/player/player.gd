extends CharacterBody3D

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var walk_speed: float = 2.0
@export var turn_speed: float = 90.0

@export var look_range_hori: float = 60.0
@export var look_range_vert: float = 30.0
@export var look_speed: float = 7.5

var direction: Vector3 = Vector3.FORWARD

var state: StateMachine = null

@onready var move_speed: float = walk_speed

@onready var model: Node3D = $Model

@onready var camrig: Position3D = $CamRig
@onready var camrig_pivot: Position3D = $CamRig/Pivot
@onready var camrig_springarm: SpringArm3D = $CamRig/Pivot/SpringArm

@onready var anim_tree: AnimationTree = $Model/AnimationTree

@export var handgun_path: NodePath
@onready var handgun_node: Node3D = get_node(handgun_path)

@export var handgun_grip_path: NodePath
@onready var handgun_grip_node: Node3D = get_node(handgun_grip_path)

@export var handgun_holster_path: NodePath
@onready var handgun_holster_node: Node3D = get_node(handgun_holster_path)

var is_armed: bool = false
var move_blend: float = 0.0

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
	
	move_blend = lerp(move_blend, amount, 10 * delta)
	if is_armed:
		anim_tree.set("parameters/ArmedLocomotion/blend_position", move_blend)
	else:
		anim_tree.set("parameters/UnarmedLocomotion/blend_position", move_blend)
	
func turn(amount: float, delta: float):
	direction = direction.rotated(Vector3.UP, deg2rad((-amount * turn_speed) * delta))
	
	model.rotation.y = lerp_angle(model.rotation.y, -atan2(direction.z, direction.x) - deg2rad(90), 0.25)
	camrig.rotation.y = lerp_angle(camrig.rotation.y, -atan2(direction.z, direction.x) - deg2rad(90), 0.25)

func look(look_dir: Vector2, delta: float):
	var cam_rot_y = camrig_springarm.rotation.y
	var cam_rot_x = camrig_springarm.rotation.x
	camrig_springarm.rotation.y = lerp_angle(cam_rot_y, camrig_pivot.rotation.y - deg2rad(look_range_hori * look_dir.x), look_speed * delta)
	camrig_springarm.rotation.x = lerp_angle(cam_rot_x, camrig_pivot.rotation.x - deg2rad(look_range_vert * look_dir.y), look_speed * delta)

func attach_weapon_to_grip():
	handgun_node.get_parent().remove_child(handgun_node)
	handgun_grip_node.add_child(handgun_node)

func attach_weapon_to_holster():
	handgun_node.get_parent().remove_child(handgun_node)
	handgun_holster_node.add_child(handgun_node)
