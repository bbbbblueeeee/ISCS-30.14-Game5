extends Node3D

var health: int = 3
var is_dead: bool = false

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var area_3d: Area3D = $Area3D
@onready var death_vfx: GPUParticles3D = $GPUParticles3D
@onready var death_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	# print("Enemy body entered")
	if body.is_in_group("bullet"):
		health -= 1
	if health <= 0:
		queue_free()

func hit():
	# print("Hit function detected")
	health -= 1
	if health <= 0 and not is_dead:
		is_dead = true
		mesh.visible = false
		area_3d.set_collision_layer_value(2, false)
		death_vfx.emitting = true
		death_sfx.play()
		await get_tree().create_timer(3.0).timeout
		queue_free()
