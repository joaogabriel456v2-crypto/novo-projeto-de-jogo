extends CanvasLayer

@onready var slots := {
	"componente_1": $HBoxContainer/Slot_C1,
	"componente_2": $HBoxContainer/Slot_C2,
	"componente_3": $HBoxContainer/Slot_C3,
}

func _ready() -> void:
	Inventory.componente_coletado.connect(_on_componente_coletado)
	_atualizar_todos_os_slots()

func _on_componente_coletado(componente_id: String) -> void:
	_atualizar_slot(componente_id)

func _atualizar_todos_os_slots() -> void:
	for componente_id in slots.keys():
		_atualizar_slot(componente_id)

func _atualizar_slot(componente_id: String) -> void:
	if not slots.has(componente_id):
		return

	if Inventory.componente_foi_coletado(componente_id):
		slots[componente_id].modulate.a = 1.0
	else:
		slots[componente_id].modulate.a = 0.235
