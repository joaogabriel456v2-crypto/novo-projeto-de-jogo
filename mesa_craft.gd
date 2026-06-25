extends Area2D

var jogador_no_alcance := false
@onready var craft_ui = get_node("/root/Mapa/CanvasLayerCraft/CraftUI")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jogador_no_alcance = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jogador_no_alcance = false

func _process(_delta: float) -> void:
	if jogador_no_alcance and Input.is_action_just_pressed("interagir"):
		craft_ui.abrir()
