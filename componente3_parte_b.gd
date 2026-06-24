extends Area2D

var componente_id := "componente_3"
var parte := "parte_b"

@onready var sprite: Sprite2D = $Sprite2D

var jogador_no_alcance := false

func _ready() -> void:
	sprite.texture = load("res://sprites/componente3_parte_b.png")
	sprite.scale = Vector2(0.024, 0.024)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jogador_no_alcance = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jogador_no_alcance = false

func _unhandled_input(event: InputEvent) -> void:
	if not jogador_no_alcance:
		return
	if event.is_action_pressed("interagir"):
		Inventory.coletar_peca(componente_id, parte)
		queue_free()
