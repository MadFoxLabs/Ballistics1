extends Node2D

@onready var gpu_particles_2d = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	gpu_particles_2d.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gpu_particles_2d_finished():
	self.queue_free()
