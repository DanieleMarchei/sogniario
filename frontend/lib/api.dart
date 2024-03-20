import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

String server = "http://localhost:3000";

Future<Map<String, dynamic>> getDreams(int userId) async {
  var url = Uri.parse('${server}/dream/${userId}');

  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  return jsonResponse;
}

Future<Map<String, dynamic>> addDream(int userId) async {
  var url = Uri.parse('http://localhost:3000/dream');

  var body = {
    "id": "0",
    "text": "string",
    "created_at": "2024-03-19T14:31:46.627Z",
    "last_edit": "2024-03-19T14:31:46.627Z",
    "deleted": "false"
  };

  var response = await http.post(url, body : body);
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  return jsonResponse;
  
}
