extends Resource

class_name enemy_stats

export(int) var speed = 10
export(int) var health = 100
export(Texture) var texture = load("res://scenes/enemy/textures/carot.png")

export(bool) var knockbackable = true
export(int) var knockback_amount = -20

export(Vector2) var sprite_scale = Vector2(1, 1)
