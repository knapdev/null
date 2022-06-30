extends CharacterBody3D

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var walk_speed: float = 2.0
@export var turn_speed: float = 90.0

@export var look_range_horizontal: float = 60.0
@export var look_range_vertical: float = 30.0
@export var look_sensitivity_horizontal: float = 5
@export var look_sensitivity_vertical: float = 5

@export var aim_sensitivity_horizontal: float = 45.0
@export var aim_sensitivity_vertical: float = 45.0

@export var camera_distance_normal: float = 0.5
@export var camera_distance_aim: float = 0.3

@export var camera_rig_path: NodePath
@onready var camera_rig: Node3D = get_node(camera_rig_path)
@onready var camera_rig_offset: Position3D = camera_rig.get_child(0)
@onready var camera_rig_pivot: Position3D = camera_rig_offset.get_child(0)

@onready var anim_tree: AnimationTree = $Model/AnimationTree

@export var handgun_path: NodePath
@onready var handgun_node: Node3D = get_node(handgun_path)

@export var handgun_grip_path: NodePath
@onready var handgun_grip_node: Node3D = get_node(handgun_grip_path)

@export var handgun_holster_path: NodePath
@onready var handgun_holster_node: Node3D = get_node(handgun_holster_path)

@onready var model: Node3D = $Model
@onready var move_speed: float = walk_speed

var state: StateMachine = null
var direction: Vector3 = Vector3.FORWARD
var is_armed: bool = false
var move_blend: float = 0.0

func _ready():
	camera_rig.set_target_camera_distance(camera_distance_normal)
	
	anim_tree.set("parameters/ArmedTransition/current", false)
		
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
	move_blend = lerp(move_blend, amount, 10 * delta)
	var move_dir = direction * move_blend
	velocity.x = move_dir.x * move_speed
	velocity.z = move_dir.z * move_speed
	apply_gravity(delta)
	move_and_slide()
	
	if is_armed:
		anim_tree.set("parameters/ArmedLocomotion/blend_position", move_blend)
	else:
		anim_tree.set("parameters/UnarmedLocomotion/blend_position", move_blend)
	
func turn(amount: float, delta: float):
	direction = direction.rotated(Vector3.UP, deg2rad((-amount * turn_speed) * delta))
	
	model.rotation.y = lerp_angle(model.rotation.y, -atan2(direction.z, direction.x) - deg2rad(90), 0.25)
	camera_rig.rotation.y = lerp_angle(camera_rig.rotation.y, -atan2(direction.z, direction.x) - deg2rad(90), 0.075)

func look(look_dir: Vector2, delta: float):
	var rot_y = camera_rig_pivot.rotation.y
	var rot_x = camera_rig_pivot.rotation.x
	camera_rig_pivot.rotation.y = lerp_angle(rot_y, camera_rig_offset.rotation.y - deg2rad(look_range_horizontal * look_dir.x), look_sensitivity_horizontal * delta)
	camera_rig_pivot.rotation.x = lerp_angle(rot_x, camera_rig_offset.rotation.x - deg2rad(look_range_vertical * look_dir.y), look_sensitivity_vertical * delta)

func attach_weapon_to_grip():
	handgun_node.get_parent().remove_child(handgun_node)
	handgun_grip_node.add_child(handgun_node)

func attach_weapon_to_holster():
	handgun_node.get_parent().remove_child(handgun_node)
	handgun_holster_node.add_child(handgun_node)
