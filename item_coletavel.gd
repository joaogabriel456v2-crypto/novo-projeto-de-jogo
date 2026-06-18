extends Area2D

# Configure esses dois valores no Inspector para cada peça que você colocar no mapa
@export var componente_id: String = "componente_1"   # ex: "componente_1", "componente_2", "componente_3"
@export var parte: String = "parte_a"                 # "parte_a" ou "parte_b"

@export var prompt_label: Label  # opcional: um Label "Pressione E" que aparece quando o jogador chega perto

var jogador_no_alcance := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if prompt_label:
		prompt_label.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jogador_no_alcance = true
		if prompt_label:
			prompt_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jogador_no_alcance = false
		if prompt_label:
			prompt_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if not jogador_no_alcance:
		return

	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interagir"):
		_coletar()

func _coletar() -> void:
	Inventory.coletar_peca(componente_1, parte_a)
	queue_free()  # remove a peça do mapa
