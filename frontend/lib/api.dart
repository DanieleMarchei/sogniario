import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/utils.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

// String server = "http://localhost:3000";
String authority = "localhost:3000";
// String authority = "10.0.0.2:3000";
String server = "http://$authority";

enum RequestType {
  delete(func: http.delete, needBody: false),
  get(func: http.get, needBody: false),
  patch(func: http.patch, needBody: true),
  post(func: http.post, needBody: true),
  put(func: http.put, needBody: true);

  const RequestType({required this.func, required this.needBody});
  final Function func;
  final bool needBody;
}

enum TableName {
  authLogin(label: "auth/login"),
  authRegister(label: "auth/register"),
  chronotype(label: "chronotype"),
  dream(label: "dream"),
  psqi(label: "psqi"),
  user(label: "user"),
  userDownload(label: "user/download");

  const TableName({required this.label});
  final String label;
}

class HttpRequest {
  List<String>? fields;
  Map<String, dynamic>? search;
  String? jwt;
  RequestType requestType;
  bool useId;
  TableName tableName;
  TableName? joinWith;
  Map<String, dynamic>? body;

  HttpRequest({
    required this.tableName,
    this.fields,
    this.jwt,
    this.search,
    required this.requestType,
    this.useId = false,
    this.joinWith,
    this.body
  });

  Future<http.Response> exec() async {

    String idQuery = "";
    if(useId){
      int id = JwtDecoder.decode(jwt!)["sub"];
      idQuery = "/$id";
    }
    List<String> queries = [];
    if(fields != null){
      String fieldsQuery = "fields=${fields!.join(',')}";
      queries.add(fieldsQuery);
    };

    if(search != null){
      String searchQuery = "s=${convert.jsonEncode(search)}";
      queries.add(searchQuery);
    }

    if(joinWith != null){
      String joinQuery = "join=${joinWith!.label}s";
      queries.add(joinQuery);
    }

    String queryUrl = queries.isEmpty ? "" : "?${queries.join("&")}";

    var url = Uri.parse('${server}/${tableName.label}$idQuery$queryUrl');

    Map<String, String> headers = {};
    if(jwt != null) {
      headers[HttpHeaders.authorizationHeader] = jwtHeader(jwt!);
    }

    if(requestType.needBody){
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
      String jsonbody = convert.jsonEncode(body);
      return requestType.func(url, headers: headers, body: jsonbody);
    }
    else{
      return requestType.func(url, headers: headers);

    }

  }
}

extension ResponseSucceeded on http.Response {
  bool get success {
    return 200 <= statusCode && statusCode <= 299;
  }
}

String jwtHeader(String jwt){
  return "Bearer $jwt";
}

UserData _jsonToUser(Map<String, dynamic> json){
  UserData user = UserData();
  user.id = json["id"];
  user.username = json["username"];
  user.password = json["password"];
  user.birthdate = json["birthdate"] != null ? DateTime.parse(json["birthdate"]) : null;
  user.sex = json["sex"] != null ? Sex.values[json["sex"]] : null;
  user.organizationId = json["organizationId"] != null ? json["organizationId"]: null;

  return user;
}

DreamData _jsonToDream(Map<String, dynamic> json){
  DreamData dream = DreamData();
  dream.dreamText = json["text"];
  dream.report[0] = json["emotional_content"];
  dream.report[1] = json["conscious"] ? 1 : 2;
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

Future<(bool, String?)> isValidLogin(String username, String password) async{

  var response = await HttpRequest(
    tableName: TableName.authLogin,
    requestType: RequestType.post,
    body: {
      "username" : username,
      "password" : password
    })
    .exec();

  bool isValid = response.success;
  if(!isValid) return (false, null);

  var jsonResponse = convert.jsonDecode(response.body);
  String? token = jsonResponse["access_token"];
    

  return (true, token);
}

Future<(DateTime?, Sex?)> getGeneralInfo(String jwt) async {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
  int id = decodedToken["sub"];

  var url = Uri.parse('${server}/user/${id}');

  var headers = {
    HttpHeaders.authorizationHeader: jwtHeader(jwt)
  };

  var response = await http.get(url, headers: headers);
  if(!response.success) throw Exception("User $id not found.");

  var jsonResponse = convert.jsonDecode(response.body);

  DateTime? birthdate = jsonResponse["birthdate"] != null ? DateTime.parse(jsonResponse["birthdate"]) : null;
  Sex? sex = jsonResponse["sex"] != null ? Sex.values[jsonResponse["sex"]] : null;

  return (birthdate, sex);

}


Future<bool> addUser(UserData user) async {
  var url = Uri.parse('${server}/user/');

  var body = {
    "username": "${user.username}",
    "password": "${user.password}",
  };

  if(user.birthdate != null) body["birthday"] = "${user.birthdate}";
  if(user.sex != null) body["sex"] = "${user.sex!.id}";

  var response = await http.post(url, body : body);
  return response.success;
}

Future<bool> deleteUser(int id) async {
  var url = Uri.parse('${server}/user/${id}');

  var response = await http.delete(url);
  return response.success;
}

Future<bool> updateUserGeneralInfo(Sex sex, DateTime birthdate, String jwt) async {

  var response = await HttpRequest(
    tableName: TableName.user,
    useId: true, 
    requestType: RequestType.patch,
    body: {
      "birthdate": "$birthdate",
      "sex": "${sex.id}"
    },
    jwt: jwt
    ).exec();


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

Future<UserData> getMyUser(String jwt) async {
  // var url = Uri.parse('${server}/user/${id}');

  // var response = await http.get(url);

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    jwt: jwt,
    useId: true).exec();

  var jsonResponse = convert.jsonDecode(response.body);
  return _jsonToUser(jsonResponse);
}

Future<bool> addChronotype(String jwt, ChronoTypeData chronotype) async{

  Map<String, dynamic> body = {};
  for (var i = 1; i <= 19; i++) {
    body["q$i"] = "${chronotype.report[i-1]}";
  }

  Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
  int id = decodedToken["sub"];
  body["user"] = id;


  var response = await HttpRequest(
    tableName: TableName.chronotype,
    requestType: RequestType.post,
    jwt: jwt,
    body: body
    ).exec();

  return response.success;
}


Future<bool> addPSQI(String jwt, PSQIData psqi) async{
  Map<String, dynamic> body = {};
  for (var i = 0; i < 19; i++) {
    late var value;
    if(psqi.report[i] is TimeOfDay){
      TimeOfDay tod = psqi.report[i] as TimeOfDay;
      DateTime date = DateTime.utc(1, 1, 1, tod.hour, tod.minute);
      value = date.toIso8601String();
    }else{
      value = psqi.report[i];
    }
    
    body["q${i+1}"] = value;
  }

  body["q15_text"] = psqi.optionalText;

  Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
  int id = decodedToken["sub"];
  body["user"] = id;

  var response = await HttpRequest(
    tableName: TableName.psqi,
    requestType: RequestType.post,
    jwt: jwt,
    body: body
  ).exec();

  return response.success;
}


Future<ChronoTypeData?> getChronotype(String jwt) async {
  // var url = Uri.parse('${server}/user/${userId}?fields=chronotypes&join=chronotypes');


  // var response = await http.get(url);

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    joinWith: TableName.chronotype,
    jwt: jwt,
    useId: true
    ).exec();


  var jsonResponse = convert.jsonDecode(response.body)["chronotypes"] as List<dynamic>;
  if(jsonResponse.isEmpty) return null;

  return _jsonToChronotype(jsonResponse[0]);
}


Future<bool> addDream(String jwt, DreamData dream) async {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
  int id = decodedToken["sub"];
  
  var body = {
    "text": dream.dreamText,
    "emotional_content": dream.report[0],
    "concious": dream.report[1] == 1,
    "control": dream.report[2],
    "percived_elapsed_time": dream.report[3],
    "sleep_time": dream.report[4],
    "sleep_quality": dream.report[5],
    "user": id
  };


  var response = await HttpRequest(
    tableName: TableName.dream,
    requestType: RequestType.post,
    body: body,
    jwt: jwt
  ).exec();

  return response.success;
} 

Future<List<DreamData>> getAllDreams(String jwt) async {

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    jwt: jwt,
    useId: true,
    fields: ["dreams"],
    joinWith: TableName.dream
  ).exec();

  var jsonResponse = convert.jsonDecode(response.body)["dreams"] as List<dynamic>;

  List<DreamData> dreams = jsonResponse.map((e) => _jsonToDream(e)).toList();
  return dreams;
}

Future<bool> getDatabase(String jwt) async {
  int id = JwtDecoder.decode(jwt)["sub"];
  UserData user = await getMyUser(jwt);
  var response = await HttpRequest(
    tableName: TableName.userDownload,
    requestType: RequestType.post,
    body: {
      "organizationId": user.organizationId
    },
    jwt: jwt
    ).exec();

  return response.success;
}