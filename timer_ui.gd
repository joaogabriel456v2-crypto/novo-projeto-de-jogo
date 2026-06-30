extends CanvasLayer

@onready var label: Label = $Label

var rodando := false
var tempo := 0.0

func _ready() -> void:
	add_to_group("timer_ui")
	_atualizar_texto()

func _process(delta: float) -> void:
	if not rodando:
		return

	tempo += delta
	_atualizar_texto()

func iniciar() -> void:
	if rodando:
		return

	rodando = true

func parar() -> void:
	rodando = false

func obter_tempo_formatado() -> String:
	return _formatar_tempo()

func _atualizar_texto() -> void:
	label.text = _formatar_tempo()

func _formatar_tempo() -> String:
	if tempo < 60.0:
		return "%.2fs" % tempo

	var minutos := int(tempo / 60.0)
	var segundos := tempo - minutos * 60.0
	return "%dm %.2fs" % [minutos, segundos]
