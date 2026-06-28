extends CharacterBody2D

const MOVE_SPEED = 200.0
const PUSH_SPEED = 180.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var direcao_olhando := Vector2.DOWN

func _ready() -> void:
	z_index = 2
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)

func _physics_process(_delta: float) -> void:
	var craft_ui = get_node_or_null("/root/Mapa/CanvasLayerCraft/CraftUI")
	if _movimento_bloqueado(craft_ui):
		velocity = Vector2.ZERO
		anim.stop()
		move_and_slide()
		return

	var direcao := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	_atualizar_animacao(direcao)
	velocity = direcao * MOVE_SPEED
	move_and_slide()
	_empurrar_caixas(direcao)

func _movimento_bloqueado(craft_ui: Node) -> bool:
	var craft_aberto := false
	if craft_ui:
		craft_aberto = craft_ui.aberto
	var dialogo_aberto := Dialogo.aberto
	var introducao_aberta := Introducao.aberto
	return craft_aberto or dialogo_aberto or introducao_aberta

func _atualizar_animacao(direcao: Vector2) -> void:
	if direcao == Vector2.ZERO:
		anim.stop()
		return

	if absf(direcao.x) > absf(direcao.y):
		if direcao.x > 0.0:
			direcao_olhando = Vector2.RIGHT
			anim.play("RightWalk")
		else:
			direcao_olhando = Vector2.LEFT
			anim.play("LeftWalk")
	else:
		if direcao.y > 0.0:
			direcao_olhando = Vector2.DOWN
			anim.play("FrontWalk")
		else:
			direcao_olhando = Vector2.UP
			anim.play("BackWalk")

func _empurrar_caixas(direcao: Vector2) -> void:
	if direcao == Vector2.ZERO:
		return

	for i in range(get_slide_collision_count()):
		var colisao := get_slide_collision(i)
		var objeto := colisao.get_collider()

		if not objeto or not objeto.is_in_group("caixa"):
			continue

		var empurrando_de_frente := direcao.dot(-colisao.get_normal()) > 0.5
		if empurrando_de_frente and objeto.has_method("receber_empurrao"):
			objeto.receber_empurrao(direcao, PUSH_SPEED)
