extends Node

var API_KEY
var FIREBASE_TOKEN
var REFRESH_TOKEN

func _ready():
	get_api_from_env()
	get_token()
	
func get_api_from_env():
	var file = File.new()
	file.open("env.json", File.READ)
	var env = parse_json(file.get_as_text())
	API_KEY = env['firestore_api']
	file.close()
	
func get_data():
	var http = HTTPRequest.new()
	add_child(http)
	var body := {"fields": {"name": {"stringValue": ""},"Age": {"integerValue": "23"}}}
	var header := ["Authorization: Bearer " + FIREBASE_TOKEN]
	http.connect("request_completed", self, "response_data")
	http.request("https://firestore.googleapis.com/v1/projects/vigilante-doodle/databases/(default)/documents/scores", header, false, HTTPClient.METHOD_POST, to_json(body))
	
	
func get_token():
	var http = HTTPRequest.new()
	add_child(http)
	var body := {"returnSecureToken": true }
	http.connect("request_completed", self, "response_token")
	http.request("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + API_KEY, [], false, HTTPClient.METHOD_POST, to_json(body))
	
	
func response_token(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8()).result
	print(json['idToken'])
	FIREBASE_TOKEN = json['idToken']
	print(response_code)
	get_data()
	
func response_data(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	print(response_code)
