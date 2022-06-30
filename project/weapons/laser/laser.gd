extends Node3D

@onready var raycast: RayCast3D = $RayCast3D
@onready var beam_mesh: MeshInstance3D = $BeamMesh
@onready var point_mesh: MeshInstance3D = $PointMesh

func _ready():
	pass

func _physics_process(delta):
	if raycast.is_colliding():
		var collision_point: Vector3 = raycast.get_collision_point()
		var distance = raycast.global_transform.origin.distance_to(collision_point)
		
		beam_mesh.scale.y = distance
		point_mesh.visible = true
		point_mesh.global_transform.origin = collision_point
	else:
		beam_mesh.scale.y = raycast.target_position.y
		point_mesh.visible = false
