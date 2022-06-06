extends CharacterBody3D

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var walk_speed: float = 4
@export var turn_speed: float = 110

var move_speed: float = walk_speed

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	var move_input_dir = Input.get_vector("turn_left", "turn_right", "move_forward", "move_backward")
	
	# turn
	rotation.y -= deg2rad(move_input_dir.x * turn_speed * delta)
	
	# move
	if is_on_floor() == false:
		velocity.y -= GRAVITY * delta
	
	var move_dir = (global_transform.basis.z * move_input_dir.y)
	velocity.x = move_dir.x * move_speed
	velocity.z = move_dir.z * move_speed
	move_and_slide()
	
	# look
	var look_input_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	var camrig_pivot = $CamRig/Pivot
	camrig_pivot.get_child(0).rotation.y = camrig_pivot.rotation.y - deg2rad(60 * look_input_dir.x)
	camrig_pivot.get_child(0).rotation.x = camrig_pivot.rotation.x - deg2rad(30 * look_input_dir.y)
