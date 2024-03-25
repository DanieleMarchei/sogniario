import 'dart:convert' as convert;
import 'package:frontend/utils.dart';
import 'package:http/http.dart' as http;

String server = "http://localhost:3000";



Future<Map<String, dynamic>> addUser(UserData user) async {
  var url = Uri.parse('${server}/user/');

  var body = {
    "username": "${user.username}",
    "password": "${user.password}",
  };

  if(user.birthdate != null) body["birthday"] = "${user.birthdate}";
  if(user.gender != null) body["gender"] = "${user.gender!.id}";

  var response = await http.post(url, body : body);
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  return jsonResponse;
}


Future<List<dynamic>> getAllUsers() async {
  var url = Uri.parse('${server}/user/');

  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
  return jsonResponse;
}


Future<UserData> getUser(int id) async {
  var url = Uri.parse('${server}/user/${id}');

  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body);
  UserData user = UserData();
  user.username = jsonResponse["username"];
  user.password = jsonResponse["password"];
  user.birthdate = jsonResponse["birthdate"] != null ? DateTime.parse(jsonResponse["birthdate"]) : null;
  user.gender = jsonResponse["gender"] != null ? Gender.values[jsonResponse["gender"]] : null;
  return user;
}