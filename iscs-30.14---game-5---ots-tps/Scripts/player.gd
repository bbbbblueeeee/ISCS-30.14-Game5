extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var gun_ray: RayCast3D = $Skeleton3D/BoneAttachment3D/MeshInstance3D/GunRay
@onready var cam_ray: RayCast3D = $Camera/EdgeSpringArm/RearSpringArm/Camera3D/CamRay
@onready var bullet_ray: RayCast3D = $Skeleton3D/BoneAttachment3D/MeshInstance3D/BulletRay

# Bullets
var bullet = load("res://Scenes/bullet.tscn")
var instance

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Handle shooting
	if Input.is_action_pressed("shoot"):
		var collision_point: Vector3
		if cam_ray.is_colliding():
			collision_point = cam_ray.get_collision_point()
		else:
			collision_point = Vector3(0,0,-500)
		bullet_ray.position = gun_ray.position
		bullet_ray.target_position = collision_point
		print("Collision Point: "+str(collision_point))
		print("Bullet Target: "+str(bullet_ray.target_position))
		instance = bullet.instantiate()
		instance.position = bullet_ray.global_position
		instance.transform.basis = bullet_ray.global_transform.basis
		# instance.position = gun_ray.global_position
		# instance.transform.basis = gun_ray.global_transform.basis
		get_parent().add_child(instance)

	move_and_slide()
