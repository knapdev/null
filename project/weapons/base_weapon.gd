class_name BaseWeapon
extends Node3D

@export var round_capacity: int = 1
@export var fire_rate: float = 1.0

var can_fire: bool = true

@onready var round_count: int = round_capacity
@onready var laser: Node3D = $Laser
@onready var raycast: RayCast3D = $RayCast3D

func _ready():
	set_laser_enabled(false)

func _process(delta):
	pass

func fire():
	pass
	
func reload():
	pass
	
func refill_ammo():
	if round_count < round_capacity:
		round_count = round_capacity
		
func set_laser_enabled(flag: bool):
	laser.visible = flag
	laser.set_process(flag)
