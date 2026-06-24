extends CanvasLayer

@onready var slots := [
	$HBoxContainer/Slot_C1A,
	$HBoxContainer/Slot_C1B,
	$HBoxContainer/Slot_C2A,
	$HBoxContainer/Slot_C2B,
	$HBoxContainer/Slot_C3A,
	$HBoxContainer/Slot_C3B,
]

var ordem := [
	["componente_1", "parte_a"],
	["componente_1", "parte_b"],
	["componente_2", "parte_a"],
	["componente_2", "parte_b"],
	["componente_3", "parte_a"],
	["componente_3", "parte_b"],
]

func _ready() -> void:
	Inventory.peca_coletada.connect(_on_peca_coletada)
	Inventory.componente_craftado.connect(_on_componente_craftado)

func _on_peca_coletada(componente_id: String, parte: String) -> void:
	for i in range(ordem.size()):
		if ordem[i][0] == componente_id and ordem[i][1] == parte:
			slots[i].modulate.a = 1.0  # fica totalmente visível quando coletado
			break

func _on_componente_craftado(componente_id: String) -> void:
	for i in range(ordem.size()):
		if ordem[i][0] == componente_id:
			slots[i].visible = false
