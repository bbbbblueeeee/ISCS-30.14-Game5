extends CharacterBody3D


const SPEED = 5.0
const AIM_SPEED = 2.5
const JUMP_VELOCITY = 3.5

@onready var gun_pivot: Node3D = $Skeleton3D/gunpivot
@onready var gun_ray: RayCast3D = $Skeleton3D/gunpivot/gun/GunRay
@onready var cam_ray: RayCast3D = $Camera/EdgeSpringArm/RearSpringArm/Camera3D/CamRay
@onready var bullet_ray: RayCast3D = $Skeleton3D/gunpivot/gun/BulletRay

# Bullets
var bullet = load("res://Scenes/bullet.tscn")
var instance

func _physics_process(delta: float) -> void:
	var current_speed = SPEED

	if Input.is_action_pressed("aim"):
		current_speed = AIM_SPEED
	
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
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	var collision_point: Vector3
		
	if cam_ray.is_colliding():
		collision_point = cam_ray.get_collision_point()
	else:
		collision_point = cam_ray.to_global(cam_ray.target_position)
		
	gun_pivot.look_at(collision_point, Vector3.UP)
	
	# Handle shooting
	if Input.is_action_just_pressed("shoot"):		
		var gun_position = gun_pivot.global_position
		var shot_direction = (collision_point - gun_position).normalized()
		
		instance = bullet.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = gun_position
		#makes the bullet point to the aim
		gun_ray.look_at(collision_point, Vector3.UP)
		instance.look_at(gun_position + shot_direction, Vector3.UP)

	move_and_slide()
