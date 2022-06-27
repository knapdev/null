extends Node3D

@export var target_path: NodePath
@onready var target_node: Node3D = get_node(target_path)

@export var follow_speed: float = 20

func _process(delta):		
	transform.origin = transform.origin.lerp(target_node.transform.origin, follow_speed * delta)
