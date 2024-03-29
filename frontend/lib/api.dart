import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/utils.dart';
import 'package:http/http.dart' as http;

String server = "http://localhost:3000";

class QueryFields {
  List<String>? fields;
  Map<String, dynamic>? s;

  QueryFields({
    this.fields,
    this.s
  });

  Map<String, dynamic> toJson(){
    Map<String, dynamic> f = {};
    if(fields != null){
      f["fields"] = fields!.join(",");
    };

    if(s != null){
      f["s"] = convert.jsonEncode(s);
    }

    return f;
  }
}

extension ResponseSucceeded on http.Response {
  bool get success {
    return 200 <= statusCode && statusCode <= 299;
  }
}

UserData _jsonToUser(Map<String, dynamic> json){
  UserData user = UserData();
  user.id = json["id"];
  user.username = json["username"];
  user.password = json["password"];
  user.birthdate = json["birthdate"] != null ? DateTime.parse(json["birthdate"]) : null;
  user.gender = json["gender"] != null ? Gender.values[json["gender"]] : null;

  return user;
}

DreamData _jsonToDream(Map<String, dynamic> json){
  DreamData dream = DreamData();
  dream.dreamText = json["text"];
  dream.report[0] = json["emotional_content"];
  dream.report[1] = json["concious"] ? 1 : 2;
  dream.report[2] = json["control"];
  dream.report[3] = json["percived_elapsed_time"];
  dream.report[4] = json["sleep_time"];
  dream.report[5] = json["sleep_quality"];
  dream.createdAt = json["created_at"] != null ? DateTime.parse(json["created_at"]) : null;

  return dream;
}

ChronoTypeData _jsonToChronotype(Map<String, dynamic> json){
  ChronoTypeData chronotype = ChronoTypeData();
  for (var i = 1; i <= 19; i++) {
    chronotype.report[i-1] = json["q$i"]; 
  }
  return chronotype;
}

// THIS IS JUST FOR TESTING PURPOSES! DO NOT USE IN PRODUCTION!
Future<(bool, int?)> isValidLogin(String username, String password) async{

  QueryFields f = QueryFields(
    fields: ["id"],
    s: {
      "username": "$username",
      "password": "$password"
    }
  );
  var url = Uri.http("localhost:3000", "/user", f.toJson());
  final headers = {
    HttpHeaders.acceptHeader: 'application/json'
  };

  var response = await http.get(url, headers: headers);
  bool isValid = response.body.isNotEmpty;
  var jsonResponse = convert.jsonDecode(response.body)[0];
  int? id = jsonResponse["id"];
    

  return (isValid, id);
}

Future<(DateTime?, Gender?)> getGeneralInfo(int userId) async {
  var url = Uri.parse('${server}/user/${userId}');
  var response = await http.get(url);
  if(!response.success) throw Exception("User $userId not found.");

  var jsonResponse = convert.jsonDecode(response.body);

  DateTime? birthdate = jsonResponse["birthdate"] != null ? DateTime.parse(jsonResponse["birthdate"]) : null;
  Gender? gender = jsonResponse["gender"] != null ? Gender.values[jsonResponse["gender"]] : null;

  return (birthdate, gender);

}


Future<bool> addUser(UserData user) async {
  var url = Uri.parse('${server}/user/');

  var body = {
    "username": "${user.username}",
    "password": "${user.password}",
  };

  if(user.birthdate != null) body["birthday"] = "${user.birthdate}";
  if(user.gender != null) body["gender"] = "${user.gender!.id}";

  var response = await http.post(url, body : body);
  return response.success;
}

Future<bool> deleteUser(int id) async {
  var url = Uri.parse('${server}/user/${id}');

  var response = await http.delete(url);
  return response.success;
}

Future<bool> updateUserGeneralInfo(int id, Gender gender, DateTime birthdate) async {
  var url = Uri.parse('${server}/user/${id}');

  var body = {
    "birthdate": "$birthdate",
    "gender": "${gender.id}"
  };
  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
    // HttpHeaders.contentTypeHeader: 'application/json'
  };
  var response = await http.patch(url, body: body, headers: headers);
  return response.success;
}

Future<List<UserData>> getAllUsers() async {
  var url = Uri.parse('${server}/user/');

  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
  return jsonResponse.map((json) => _jsonToUser(json)).toList();
}


Future<UserData> getUser(int id) async {
  var url = Uri.parse('${server}/user/${id}');

  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body);
  return _jsonToUser(jsonResponse);
}

Future<bool> addChronotype(int userId, ChronoTypeData chronotype) async{
  var url = Uri.parse('${server}/chronotype/');

  Map<String, String> body = {};
  for (var i = 1; i <= 19; i++) {
    body["q$i"] = "${chronotype.report[i-1]}";
  }
  body["user"] = "$userId";

  var response = await http.post(url, body : body);

  return response.success;
}


Future<bool> addPSQI(int userId, PSQIData psqi) async{
  var url = Uri.parse('${server}/psqi/');

  List<String> columns = [
    "q1",
    "q2",
    "q3",
    "q4_h",
    "q4_m",
    "q5_h",
    "q5_m",
    "q6",
    "q7",
    "q8",
    "q9",
    "q10",
    "q11",
    "q12",
    "q13",
    "q14",
    "q15",
    "q15_text",
    "q15_extended",
    "q16",
    "q17",
    "q18",
    "q19",
  ];

  Map<String, dynamic> body = {};
  for (var i = 0; i < columns.length; i++) {
    var value = psqi.report[i];
    if(value is TimeOfDay){
      var value2 = DateTime.utc(2024, 3, 3, value.hour- 1 , value.minute);
      body[columns[i]] = value2.toIso8601String();
    }else{
      body[columns[i]] = value;

    }
  }

  body["user"] = userId;

  var json = convert.jsonEncode(body);
  
  final headers = {
    // HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json'
  };

  var response = await http.post(url, body : json, headers: headers);

  return response.success;
}


Future<ChronoTypeData?> getChronotype(int userId) async {
  var url = Uri.parse('${server}/user/${userId}?fields=chronotypes&join=chronotypes');


  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body)["chronotypes"] as List<dynamic>;
  if(jsonResponse.isEmpty) return null;

  return _jsonToChronotype(jsonResponse[0]);
}


Future<bool> addDream(int userId, DreamData dream) async {
  var url = Uri.parse('${server}/dream/');

  var body = {
    "text": dream.dreamText,
    "emotional_content": dream.report[0],
    "concious": dream.report[1] == 1,
    "control": dream.report[2],
    "percived_elapsed_time": dream.report[3],
    "sleep_time": dream.report[4],
    "sleep_quality": dream.report[5],
    "user": userId
  };

  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json'
  };

  var json = convert.jsonEncode(body);

  var response = await http.post(url, body : json, headers: headers);

  return response.success;
} 

Future<List<DreamData>> getAllDreams(int userId) async {
  var url = Uri.parse('${server}/user/${userId}?fields=dreams&join=dreams');


  var response = await http.get(url);
  var jsonResponse = convert.jsonDecode(response.body)["dreams"] as List<dynamic>;

  List<DreamData> dreams = jsonResponse.map((e) => _jsonToDream(e)).toList();
  return dreams;
}