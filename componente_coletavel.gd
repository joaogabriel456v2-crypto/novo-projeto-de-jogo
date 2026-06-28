extends Area2D

@export_enum("componente_1", "componente_2", "componente_3") var componente_id := "componente_1"
@export var tamanho_visual := 48.0

@onready var sprite: Sprite2D = $Sprite2D

var jogador_no_alcance := false

func _ready() -> void:
	_atualizar_sprite()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _atualizar_sprite() -> void:
	if not Inventory.componentes.has(componente_id):
		return

	var textura: Texture2D = Inventory.componentes[componente_id]["sprite_montado"]
	sprite.texture = textura

	var maior_lado := maxf(textura.get_width(), textura.get_height())
	if maior_lado > 0.0:
		sprite.scale = Vector2.ONE * (tamanho_visual / maior_lado)

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
		Inventory.coletar_componente(componente_id)
		Dialogo.mostrar_componente(componente_id)
		get_viewport().set_input_as_handled()
		queue_free()
