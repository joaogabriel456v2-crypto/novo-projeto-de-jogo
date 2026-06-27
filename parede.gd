extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var colisao: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("parede_puzzle")

func remover() -> void:
	sprite.visible = false
	colisao.disabled = true
