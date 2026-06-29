extends CanvasLayer

var aberto := false
var slide_atual := -1

var slides := [
	{
		"texto": "Oi! Meu nome é Charlie! Eu sou uma exploradora e gosto de explorar minha cidade e descobrir os seus mistérios!",
		"imagem": "res://ChatGPT Image 14 de jun. de 2026, 20_18_31.png"
	},
	{
		"texto": "Eu estava andando numa região abandonada e encontrei uma fabrica. Eu decidi entrar nela, mas uma porta se fechou e eu estou presa nela!",
		"imagem": "res://fabrica abandonada.png"
	},
	{
		"texto": "Agora eu tenho que encontrar alguns componentes para que eu possa ligar algumas maquinas e abrir a porta de novo.
		*para voltar ao menu, tecle ALT",
		"imagem": "res://porta trancada.png"
	}
]

@onready var fundo: ColorRect = ColorRect.new()
@onready var imagem: TextureRect = TextureRect.new()
@onready var painel: PanelContainer = PanelContainer.new()
@onready var texto: Label = Label.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 200
	_criar_interface()
	hide()

func iniciar() -> void:
	aberto = true
	slide_atual = -1
	show()
	_avancar_slide()

func reiniciar() -> void:
	aberto = false
	slide_atual = -1
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if not aberto:
		return

	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_SPACE:
		_avancar_slide()
		get_viewport().set_input_as_handled()

func fechar() -> void:
	aberto = false
	hide()

func _avancar_slide() -> void:
	slide_atual += 1
	if slide_atual >= slides.size():
		fechar()
		return

	var slide = slides[slide_atual]
	texto.text = slide["texto"]
	imagem.texture = load(slide["imagem"])

func _criar_interface() -> void:
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fundo.color = Color.BLACK
	add_child(fundo)

	imagem.set_anchors_preset(Control.PRESET_CENTER_TOP)
	imagem.offset_left = -360
	imagem.offset_top = 40
	imagem.offset_right = 360
	imagem.offset_bottom = 390
	imagem.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	imagem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(imagem)

	painel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	painel.offset_left = 48
	painel.offset_top = -190
	painel.offset_right = -48
	painel.offset_bottom = -36
	add_child(painel)

	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.02, 0.02, 0.02, 0.96)
	estilo.border_color = Color.WHITE
	estilo.set_border_width_all(4)
	estilo.set_corner_radius_all(0)
	estilo.content_margin_left = 24
	estilo.content_margin_top = 18
	estilo.content_margin_right = 24
	estilo.content_margin_bottom = 18
	painel.add_theme_stylebox_override("panel", estilo)

	texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texto.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texto.size_flags_vertical = Control.SIZE_EXPAND_FILL
	texto.add_theme_color_override("font_color", Color.WHITE)
	texto.add_theme_font_size_override("font_size", 25)
	painel.add_child(texto)
