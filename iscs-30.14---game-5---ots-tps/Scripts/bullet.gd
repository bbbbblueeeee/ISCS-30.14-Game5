extends Node3D

const SPEED = 30.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
@onready var sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		ray.enabled = false
		# print("Hit! Emitted Particles")
		sfx.play()
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().get_parent().hit()
		await get_tree().create_timer(1.0).timeout
		queue_free()
	else:
		position += transform.basis * Vector3(0, 0, -SPEED) * delta

func _on_timer_timeout() -> void:
	queue_free()
