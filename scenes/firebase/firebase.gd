extends Node

var API_KEY
var FIREBASE_TOKEN
var REFRESH_TOKEN
const base_url = "https://firestore.googleapis.com/v1/projects/vigilante-doodle/databases/(default)/documents/"

#Get Hiscores Label
onready var hi = get_node("../P/VB/Hiscores")
onready var send = get_node("../P/VB/SendScore")
onready var username = get_node("../P/VB/Name")
onready var score_label = get_node("../P/VB/Score")
onready var hs = get_node("../P/VB/Hiscores")
	
func run_end_screen():
	score_label.text = "MAP:  " + GlobalData.selected_level.trim_suffix(".json").right(2) + "\n" + \
					   "SCORE:  " + str(GlobalData.score) + "\n" + \
					   "TIME:  " + str("%3.0f" % GlobalData.time_survived)
	get_api_from_env()
	get_token()

func get_api_from_env():
	var file = File.new()
	file.open("res://env.json", File.READ)
	var env = parse_json(file.get_as_text())
	API_KEY = env['firestore_api']
	file.close()

func get_token():
	var http = HTTPRequest.new()
	add_child(http)
	var body := {"returnSecureToken": true }
	http.connect("request_completed", self, "get_token_response")
	http.request("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + API_KEY, [], false, HTTPClient.METHOD_POST, to_json(body))
	
func send_score():
	var http = HTTPRequest.new()
	add_child(http)
	
	var score = {"integerValue": int(GlobalData.score)}
	var name = {"stringValue": username.text}
	var time_s = {"integerValue": int(GlobalData.time_survived)}
	var fields = {"name": name, "score": score, "time": time_s}
	var body := {"fields": fields}
	
	var header := ["Authorization: Bearer " + FIREBASE_TOKEN]
	http.connect("request_completed", self, "send_score_response")
	http.request(base_url + GlobalData.selected_level.trim_suffix(".json"), header, false, HTTPClient.METHOD_POST, to_json(body))
	
func get_token_response(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8()).result
	FIREBASE_TOKEN = json['idToken']
	send.disabled = false
	send.text = "Send Score"
	get_scores()
	
func send_score_response(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		send.text = "Score sent OK"
	print(json.result)
	get_scores()

func get_scores():
	var http = HTTPRequest.new()
	add_child(http)
	var header := ["Authorization: Bearer " + FIREBASE_TOKEN]
	http.connect("request_completed", self, "get_scores_results")
	http.request(base_url + GlobalData.selected_level.trim_suffix(".json"), header, false, HTTPClient.METHOD_GET)

func get_scores_results(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var scores = []
	if response_code == 200 && ('documents' in json.result):
		for score in json.result['documents']:
			var hs_user = score['fields']['name']['stringValue']
			var hs_score = score['fields']['score']['integerValue']
			var hs_time = score['fields']['time']['integerValue']
			scores.append([hs_score, hs_user, hs_time])
		scores.sort_custom(MyCustomSorter, "sort_scores")
		hs.text = "NAME | SCORE | TIME\n\n"
		scores.invert()
		var top_ten = 0
		for hscore in scores:
			top_ten += 1
			hs.text += str(hscore[1]) + " | " + str(hscore[0]) + " | " + str(hscore[2]) +"\n"
			if top_ten > 20:
				break
	elif !('documents' in json.result):
		hs.text = "No Scores yet, submit to populate"
	else:
		hs.text += "Error: " + str(response_code)
	
class MyCustomSorter:
	static func sort_scores(a, b):
		if float(a[0]) < float(b[0]):
			return true
		return false

func _on_SendScore_pressed():
	if len(username.text) != 3:
		send.text = "Send Score [Enter 3 letter name]"
		return
	send.text = "Sending Score"
	send.disabled = true
	send_score()
