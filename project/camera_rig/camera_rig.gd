extends Node3D

@export var target_path: NodePath
@onready var target_node: Node3D = get_node(target_path)

@export var follow_speed: float = 20

var target_camera_distance: float = 1.0

@onready var spring_arm: SpringArm3D = $Offset/Pivot/SpringArm

func _process(delta):		
	transform.origin = transform.origin.lerp(target_node.transform.origin, follow_speed * delta)
	
	spring_arm.spring_length = lerp(spring_arm.spring_length, target_camera_distance, 10.0 * delta)

func set_target_camera_distance(value: float):
	target_camera_distance = value
