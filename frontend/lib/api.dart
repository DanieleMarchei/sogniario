import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import "package:universal_html/html.dart" as html;

// String server = "http://localhost:3000";
// String authority = "localhost:3000";
String authority = kIsWeb ? "localhost:3000" : "10.0.2.2:3000";
String server = "http://$authority";

var tokenBox = Hive.box('tokens');


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
  authLoginUser(label: "auth/login/user", needJwt: false, deletable: false),
  authRegisterUser(label: "auth/register/user", needJwt: false, deletable: false),
  authLoginResearcher(label: "auth/login/researcher", needJwt: false, deletable: false),
  authRegisterResearcher(label: "auth/register/researcher", needJwt: false, deletable: false),

  chronotype(label: "chronotype", needJwt: true, deletable: false),
  dream(label: "dream", needJwt: true, deletable: false),
  psqi(label: "psqi", needJwt: true, deletable: false),

  researcher(label: "researcher", needJwt: true, deletable: true),


  user(label: "user", needJwt: true, deletable: true),
  userDownload(label: "user/download", needJwt: true, deletable: false),
  
  organization(label: "Organization", needJwt: true, deletable: false);

  const TableName({required this.label, required this.needJwt, required this.deletable});
  final String label;
  final bool needJwt;
  final bool deletable;
}

class HttpRequest {
  List<String>? fields;
  Map<String, dynamic> search = {};
  int? id;
  String? jwt;
  RequestType requestType;
  bool useIdInJwt;
  TableName tableName;
  TableName? joinWith;
  Map<String, dynamic>? body;

  HttpRequest({
    required this.tableName,
    this.fields,
    Map<String, dynamic>? search,
    this.id,
    required this.requestType,
    this.useIdInJwt = false,
    this.joinWith,
    this.body,
    includeDeletedRows = false
  }) {
    if(useIdInJwt || tableName.needJwt){
      this.jwt = tokenBox.get("jwt");
    }

    this.search = Map<String, dynamic>.from(search ?? {});

    if(this.tableName.deletable) {
      this.search["deleted"] = includeDeletedRows;
    }

    if(joinWith != null && joinWith!.deletable){
      this.search["${joinWith!.label}s.deleted"] = includeDeletedRows;
    }
  }

  Future<http.Response> exec() async {

    String idQuery = "";
    if(id != null){
      idQuery = "/$id";
    }
    if(useIdInJwt){
      int id = JwtDecoder.decode(jwt!)["sub"];
      idQuery = "/$id";
    }
    List<String> queries = [];
    if(fields != null){
      String fieldsQuery = "fields=${fields!.join(',')}";
      queries.add(fieldsQuery);
    };

    if(this.search.isNotEmpty){
      String searchQuery = "s=${convert.jsonEncode(this.search)}";
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
  user.organizationId = json["organization"] != null ? json["organization"]["id"] : null;
  user.organizationName = json["organization"] != null ? json["organization"]["name"] : null;

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

Future<bool> isValidLoginUser(String username, String password) async{

  var response = await HttpRequest(
    tableName: TableName.authLoginUser,
    requestType: RequestType.post,
    body: {
      "username" : username,
      "password" : password
    })
    .exec();

  bool isValid = response.success;
  if(!isValid) return false;

  var jsonResponse = convert.jsonDecode(response.body);
  String? token = jsonResponse["access_token"];
  tokenBox.put("jwt", token!);

  return true;
}

Future<bool> isValidLoginResearcher(String username, String password) async{

  var response = await HttpRequest(
    tableName: TableName.authLoginResearcher,
    requestType: RequestType.post,
    body: {
      "username" : username,
      "password" : password
    })
    .exec();

  bool isValid = response.success;
  if(!isValid) return false;

  var jsonResponse = convert.jsonDecode(response.body);
  String? token = jsonResponse["access_token"];
  tokenBox.put("jwt", token!);

  return true;
}

Future<(DateTime?, Sex?)> getMyGeneralInfo() async {

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    useIdInJwt: true
  ).exec();

  if(!response.success) throw Exception("Cannot get general info.");

  var jsonResponse = convert.jsonDecode(response.body);

  DateTime? birthdate = jsonResponse["birthdate"] != null ? DateTime.parse(jsonResponse["birthdate"]) : null;
  Sex? sex = jsonResponse["sex"] != null ? Sex.values[jsonResponse["sex"]] : null;

  return (birthdate, sex);

}


Future<bool> addUser(UserData user) async {

  UserData myUser = await getMyResearcher();

  var body = {
    "username": user.username,
    "password": user.password,
    "organization": myUser.organizationId
  };

  if(user.birthdate != null) body["birthday"] = "${user.birthdate}";
  if(user.sex != null) body["sex"] = user.sex!.id;

  var response = await HttpRequest(
    tableName: TableName.authRegisterUser,
    requestType: RequestType.post,
    body: body
  ).exec();

  return response.success;
}

Future<bool> deleteUser(int id) async {
  var response = await HttpRequest(
    tableName: TableName.user,
    id: id, 
    requestType: RequestType.patch,
    body: {
      "deleted": true
    },
    ).exec();


  return response.success;
}

Future<bool> updateMyGeneralInfo(Sex sex, DateTime birthdate) async {

  var response = await HttpRequest(
    tableName: TableName.user,
    useIdInJwt: true, 
    requestType: RequestType.patch,
    body: {
      "birthdate": "$birthdate",
      "sex": "${sex.id}"
    },
    ).exec();


  return response.success;
}


Future<bool> updateUserGeneralInfo(int id, Sex sex, DateTime birthdate) async {

  var response = await HttpRequest(
    tableName: TableName.user,
    id: id, 
    requestType: RequestType.patch,
    body: {
      "birthdate": "$birthdate",
      "sex": "${sex.id}"
    },
  ).exec();


  return response.success;
}

Future<bool> updateUserPassword(int id, String password) async {

  var response = await HttpRequest(
    tableName: TableName.user,
    id: id, 
    requestType: RequestType.patch,
    body: {
      "password": password,
    },
  ).exec();


  return response.success;
}

Future<List<UserData>> getAllUsersOfMyOrganization() async {
  UserData user = await getMyResearcher();
  var response = await HttpRequest(
    tableName: TableName.organization,
    requestType: RequestType.get,
    search: {
      "id": user.organizationId,
    },
    joinWith: TableName.user

  ).exec();

  var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
  
  if(jsonResponse.isEmpty) return [];

  var jsonUsers = jsonResponse[0]["users"] as List<dynamic>;
  return jsonUsers.map((json) => _jsonToUser(json)).toList();
}


Future<UserData> getUser(int id) async {

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    id: id
  ).exec();

  var jsonResponse = convert.jsonDecode(response.body);
  return _jsonToUser(jsonResponse);
}

Future<UserData> getMyUser() async {

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    useIdInJwt: true).exec();

  var jsonResponse = convert.jsonDecode(response.body);
  return _jsonToUser(jsonResponse);
}


Future<UserData> getMyResearcher() async {

  var response = await HttpRequest(
    tableName: TableName.researcher,
    requestType: RequestType.get,
    useIdInJwt: true).exec();

  var jsonResponse = convert.jsonDecode(response.body);
  return _jsonToUser(jsonResponse);
}

Future<bool> addMyChronotype(ChronoTypeData chronotype) async{

  Map<String, dynamic> body = {};
  for (var i = 1; i <= 19; i++) {
    body["q$i"] = "${chronotype.report[i-1]}";
  }

  Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenBox.get("jwt"));
  int id = decodedToken["sub"];
  body["user"] = id;


  var response = await HttpRequest(
    tableName: TableName.chronotype,
    requestType: RequestType.post,
    body: body
    ).exec();

  return response.success;
}


Future<bool> addMyPSQI(PSQIData psqi) async{
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

  Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenBox.get("jwt"));
  int id = decodedToken["sub"];
  body["user"] = id;

  var response = await HttpRequest(
    tableName: TableName.psqi,
    requestType: RequestType.post,
    body: body
  ).exec();

  return response.success;
}


Future<ChronoTypeData?> getMyChronotype() async {

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    joinWith: TableName.chronotype,
    useIdInJwt: true
    ).exec();


  var jsonResponse = convert.jsonDecode(response.body)["chronotypes"] as List<dynamic>;
  if(jsonResponse.isEmpty) return null;

  return _jsonToChronotype(jsonResponse[0]);
}


Future<bool> addDream(DreamData dream) async {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenBox.get("jwt"));
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
  ).exec();

  return response.success;
} 

Future<List<DreamData>> getMyDreams() async {

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    useIdInJwt: true,
    fields: ["dreams"],
    joinWith: TableName.dream
  ).exec();

  var jsonResponse = convert.jsonDecode(response.body)["dreams"] as List<dynamic>;

  List<DreamData> dreams = jsonResponse.map((e) => _jsonToDream(e)).toList();
  return dreams;
}

Future<String?> downloadDatabase() async {
  int id = JwtDecoder.decode(tokenBox.get("jwt"))["sub"];
  UserData user = await getMyResearcher();
  var response = await HttpRequest(
    tableName: TableName.userDownload,
    requestType: RequestType.post,
    body: {
      "organizationId": user.organizationId
    },
    ).exec();

  if(!response.success) return null;
  
  String fileName = "sogniario (${user.organizationName}) - ${DateTime.now()}.zip";

  if(kIsWeb){
    final blob = html.Blob([response.bodyBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;

    html.document.body!.children.add(anchor);
    anchor.click();

    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    return null;
  }

  final directory = await getApplicationDocumentsDirectory();
  final filePath = directory.path + "/${fileName}";
  if(filePath != null){
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
  }

  return filePath;


  
}