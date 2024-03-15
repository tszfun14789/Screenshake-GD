extends Node

var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0

enum Type {Random, Sine, Noise}
var camera_shake_type = Type.Random

var noise : FastNoiseLite

func _ready():
	# Generate noise for noise shake

	process_mode = Node.PROCESS_MODE_ALWAYS
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.fractal_octaves = 4
#	noised.period = 20
#	noise.persistence = 0.8
	

func shake(intensity, duration, type = Type.Sine):
	# BIG NOTE HERE, You may use three shake type (random sine and noise) and Sine is perferred in my project as it is rather smoother compared to others
	# if player_no_want:
	# 	intensity = 0
	
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration
		camera_shake_type = type


func _process(delta):
	# Get the camera please use the corresponding camera path in your project. Note one might have multiple cameras in one project.
	if get_tree().current_scene.scene_file_path != "res://mainmenu.tscn" && get_tree().current_scene.scene_file_path != "res://intro.tscn" && get_tree().current_scene.filename != "res://settingmenu.tscn":
		var camera = get_tree().current_scene.get_node("Player/Camera2D")	
		if camera_shake_duration <= 0:

			camera.offset = Vector2.ZERO
			camera_shake_intensity = 0.0
			camera_shake_duration = 0.0
			return

		camera_shake_duration = camera_shake_duration - delta
			

		var offset = Vector2.ZERO
			
		if camera_shake_type == Type.Random:
			# Random shake
			offset = Vector2(randf(), randf()) * camera_shake_intensity

		if camera_shake_type == Type.Sine:
			# Sine wave based shake
			offset = Vector2(sin(Time.get_ticks_msec() * 0.03), sin(Time.get_ticks_msec() * 0.07)) * camera_shake_intensity * 0.5
			
		if camera_shake_type == Type.Noise:
			# Noise based shake
			var noise_value_x = noise.get_noise_1d(Time.get_ticks_msec() * 0.1)
			var noise_value_y = noise.get_noise_1d(Time.get_ticks_msec() * 0.1 + 100.0)
			offset = Vector2(noise_value_x, noise_value_y) * camera_shake_intensity * 2.0
						
		camera.offset = offset
