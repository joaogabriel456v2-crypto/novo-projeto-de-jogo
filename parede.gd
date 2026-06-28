extends StaticBody2D

@export var fase: String = "fase_1"

@onready var colisao: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("parede_puzzle")
	add_to_group("parede_" + fase)
	restaurar()

func remover() -> void:
	visible = false
	colisao.set_deferred("disabled", true)

func restaurar() -> void:
	visible = true
	colisao.set_deferred("disabled", false)
