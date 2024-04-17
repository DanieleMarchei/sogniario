import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import "package:universal_html/html.dart" as html;

// String server = "http://localhost:3000";
// String authority = "localhost:3000";
// String authority = "sogniario.unicam.it:3000";
String authority = kIsWeb ? "localhost:3000" : "10.0.2.2:3000";
// String authority = "192.168.115.2:3000";
String server = "http://$authority";

var tokenBox = Hive.box('tokens');

bool doIHaveJwt(){
  if(!tokenBox.containsKey("jwt")) return false;
  bool validJwt = !JwtDecoder.isExpired(tokenBox.get("jwt"));
  return validJwt;
}

void deleteJwt(){
  if(!tokenBox.containsKey("jwt")) return;
  tokenBox.delete("jwt");
}


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
  
  organization(label: "Organization", needJwt: true, deletable: false),

  downloadApk(label: "file/apk", needJwt: false, deletable: false);

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

    if(this.search.isNotEmpty && id == null){
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

Map<String, dynamic> myJwtData(){
  return JwtDecoder.decode(tokenBox.get("jwt"));
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


Future<bool> addUser(UserData user) async {

  int organizationId = myJwtData()["organization"];

  var body = {
    "username": user.username,
    "password": user.password,
    "organization": organizationId
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
  UserData user = await getUser(id);
  var response = await HttpRequest(
    tableName: TableName.user,
    id: id, 
    requestType: RequestType.patch,
    body: {
      "deleted": true,
      "username": "deleted_${user.username}"
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

Future<UserData> getUser(int id) async {

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    id: id
  ).exec();

  var jsonResponse = convert.jsonDecode(response.body);
  return _jsonToUser(jsonResponse);
}

Future<void> downloadDatabaseDesktop() async {
  if(!kIsWeb) return;

  int id = myJwtData()["sub"];
  UserData user = await getMyResearcher();
  var response = await HttpRequest(
    tableName: TableName.userDownload,
    requestType: RequestType.post,
    body: {
      "organizationId": user.organizationId
    },
    ).exec();

  if(!response.success) return;
  
  String fileName = "sogniario (${user.organizationName}) - ${DateTime.now()}.zip";

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

  return;
}


Future<void> downloadAndroidApp() async {
  if(!kIsWeb) return;

  var response = await HttpRequest(
    tableName: TableName.downloadApk,
    requestType: RequestType.get
  ).exec();

  final blob = html.Blob([response.bodyBytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = "sogniario.apk";

  html.document.body!.children.add(anchor);
  anchor.click();

  html.document.body!.children.remove(anchor);
  html.Url.revokeObjectUrl(url);


  return;
}