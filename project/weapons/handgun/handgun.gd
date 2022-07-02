extends BaseWeapon

func fire():
	if can_fire:
		if round_count >= 1:
			print("fire")
			round_count = round_count - 1
			print(round_count)
			if raycast.is_colliding():
				var collider: Object = raycast.get_collider()
				if collider is RigidDynamicBody3D:
					var body: RigidDynamicBody3D = collider
					var point: Vector3 = body.global_transform.origin - raycast.get_collision_point()
					var direction: Vector3 = raycast.global_transform.basis.y
		
					body.apply_impulse(point, direction * 5)
		else:
			print("empty")

func reload():
	print("reload")
	refill_ammo()
