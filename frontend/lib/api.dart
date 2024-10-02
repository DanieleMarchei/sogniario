import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import "package:universal_html/html.dart" as html;

bool isDevelopment = true;

String wsAuthority = isDevelopment ? (kIsWeb ? "localhost:2700" : "10.0.2.2:2700") : "sogniario.unicam.it:2700";

String authority = isDevelopment ? (kIsWeb ? "localhost:3000" : "10.0.2.2:3000") : "sogniario.unicam.it/api";
String server = isDevelopment ? "http://$authority" : "https://$authority";

var tokenBox = Hive.box('tokens');
var userDataBox = Hive.box('userData');

Future<bool> doIHaveJwt() async {
  if(!tokenBox.containsKey(HiveBoxes.jwt.label)) return false;
  bool validJwt = !JwtDecoder.isExpired(tokenBox.get(HiveBoxes.jwt.label));
  var response = await HttpRequest(
    tableName: TableName.checkJwt,
    requestType: RequestType.get)
  .exec();
  validJwt &= response.success;
  return validJwt;
}

bool doIHaveChronotype(){
  return userDataBox.containsKey(HiveBoxes.hasChronotype.label);
}

bool doIHaveGeneralInfo(){
  return userDataBox.containsKey(HiveBoxes.hasGeneralInfo.label);
}


enum UserType {
  admin,
  researcher,
  user,
  notLogged
}

Future<UserType> getMyUserType() async {
  if(! await doIHaveJwt()) return UserType.notLogged;

  var token = JwtDecoder.decode(tokenBox.get(HiveBoxes.jwt.label));
  if(![0,1,2].contains(token["type"])) return UserType.notLogged;

  return UserType.values[token["type"]];

}

void deleteJwtAndUserData(){
  tokenBox.delete(HiveBoxes.jwt.label);
  userDataBox.delete(HiveBoxes.hasGeneralInfo.label);
  userDataBox.delete(HiveBoxes.hasChronotype.label);
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
  authRegisterUser(label: "auth/register/user", needJwt: true, deletable: false),
  authLoginResearcher(label: "auth/login/researcher", needJwt: false, deletable: false),
  authRegisterResearcher(label: "auth/register/researcher", needJwt: true, deletable: false),

  authResetPasswordUser(label: "auth/reset-password/user", needJwt: true, deletable: false),
  authResetPasswordResearcher(label: "auth/reset-password/researcher", needJwt: true, deletable: false),

  chronotype(label: "chronotype", needJwt: true, deletable: false),
  dream(label: "dream", needJwt: true, deletable: false),
  psqi(label: "psqi", needJwt: true, deletable: false),

  researcher(label: "researcher", needJwt: true, deletable: true),


  user(label: "user", needJwt: true, deletable: true),
  userDownload(label: "user/download", needJwt: true, deletable: false),
  
  organization(label: "Organization", needJwt: true, deletable: false),

  downloadApk(label: "file/apk", needJwt: false, deletable: false),

  checkJwt(label: "auth/check-jwt", needJwt: true, deletable: false);

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
      this.jwt = tokenBox.get(HiveBoxes.jwt.label);
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

extension DurationPostgres on Duration {
  String get asPostgresString {
    List<String> ps = [];
    if(inDays != 0) ps.add("$inDays days");
    if(inHours.remainder(24) != 0) ps.add("${inHours.remainder(24)} hours");
    if(inMinutes.remainder(60) != 0) ps.add("${inMinutes.remainder(60)} minutes");
    if(inSeconds.remainder(60) != 0) ps.add("${inSeconds.remainder(60)} seconds");

    return ps.join(" ");

  }
}

String jwtHeader(String jwt){
  return "Bearer $jwt";
}

Map<String, dynamic> myJwtData(){
  return JwtDecoder.decode(tokenBox.get(HiveBoxes.jwt.label));
}

UserData _jsonToUser(Map<String, dynamic> json){
  UserData user = UserData();
  user.id = json["id"];
  user.username = json["username"];
  user.password = json["password"];
  user.birthdate = json["birthdate"] != null ? DateTime.parse(json["birthdate"]).toLocal() : null;
  user.sex = json["sex"] != null ? Sex.values[json["sex"]] : null;
  user.organizationId = json["organization"] != null ? json["organization"]["id"] : null;
  user.organizationName = json["organization"] != null ? json["organization"]["name"] : null;

  return user;
}

DreamData _jsonToDream(Map<String, dynamic> json){
  DreamData dream = DreamData();
  dream.dreamText = json["text"];
  dream.report[0] = json["emotional_content"];
  dream.report[1] = json["conscious"];
  dream.report[2] = json["control"];
  dream.report[3] = json["percived_elapsed_time"];
  dream.report[4] = json["hours_of_sleep"];
  dream.report[5] = json["sleep_quality"];
  dream.createdAt = json["created_at"] != null ? DateTime.parse(json["created_at"]).toLocal() : null;

  return dream;
}

ChronoTypeData _jsonToChronotype(Map<String, dynamic> json){
  ChronoTypeData chronotype = ChronoTypeData();
  for (var i = 1; i <= 19; i++) {
    chronotype.report[i-1] = json["q$i"]; 
  }
  return chronotype;
}

PSQIData _jsonToPSQI(Map<String, dynamic> json){
  PSQIData psqi = PSQIData();

  psqi.compiled_date = DateTime.parse(json["compiled_date"]).toLocal();

  // List<int> todTimeToBed = (json["q1"] as String).split(":").map((e) => int.parse(e)).toList();
  final formatHm = DateFormat.Hm();
  psqi.timeToBed = TimeOfDay.fromDateTime(formatHm.parse(json["q1"]));

  psqi.minutesToFallAsleep = json["q2"];
  psqi.timeWokeUp = TimeOfDay.fromDateTime(formatHm.parse(json["q3"]));
  
  int h = json["q4"].containsKey("hours") ? json["q4"]["hours"]! : 0;
  int m = json["q4"].containsKey("minutes") ? json["q4"]["minutes"]! : 0;
  int s = json["q4"].containsKey("seconds") ? json["q4"]["seconds"]! : 0;
  psqi.timeAsleep = Duration(hours: h, minutes: m, seconds: s);

  psqi.notFallAsleepWithin30Minutes = json["q5a"];
  psqi.wakeUpWithoutFallingAsleepAgain = json["q5b"];
  psqi.goToTheBathroom = json["q5c"];
  psqi.notBreethingCorrectly = json["q5d"];
  psqi.coughOrSnort = json["q5e"];
  psqi.tooCold = json["q5f"];
  psqi.tooHot = json["q5g"];
  psqi.badDreams = json["q5h"];
  psqi.havingPain = json["q5i"];

  psqi.otherProblems = json["q5j"];
  psqi.optionalText = json["q5j_text"];
  psqi.otherProblemsFrequency = json["q5j_frequency"];

  psqi.sleepQuality = json["q6"];
  psqi.drugs = json["q7"];
  psqi.difficultiesBeingAwake = json["q8"];
  psqi.enoughEnergies = json["q9"];


  return psqi;

}

List<PSQIData> _jsonToPSQIs(List<Map<String, dynamic>> json){
  List<PSQIData> psqis = [];
  for (var j in json) {
    psqis.add(_jsonToPSQI(j));
  }
  
  return psqis;
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
  tokenBox.put(HiveBoxes.jwt.label, token!);

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
  tokenBox.put(HiveBoxes.jwt.label, token!);

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

Future<bool> updateUserPassword(String username, String password) async {

  var response = await HttpRequest(
    tableName: TableName.authResetPasswordUser,
    requestType: RequestType.post,
    body: {
      "username": username,
      "new_password": password,
    },
  ).exec();


  return response.success;
}

Future<List<UserData>> getAllUsersOfMyOrganization() async {
  int organizationId = myJwtData()["organization"];

  var response = await HttpRequest(
    tableName: TableName.organization,
    requestType: RequestType.get,
    id: organizationId,
    // search: {
    //   "id": organizationId,
    // },
    joinWith: TableName.user

  ).exec();

  var jsonResponse = convert.jsonDecode(response.body);
  
  if(jsonResponse["users"].isEmpty) return [];

  var jsonUsers = jsonResponse["users"] as List<dynamic>;
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

  int id = myJwtData()["sub"];
  body["user"] = id;


  var response = await HttpRequest(
    tableName: TableName.chronotype,
    requestType: RequestType.post,
    body: body
    ).exec();

  return response.success;
}


// Future<bool> addMyPSQIOld(PSQIData psqi) async{
//   Map<String, dynamic> body = {};
//   for (var i = 0; i < 19; i++) {
//     late var value;
//     if(psqi.report[i] is TimeOfDay){
//       TimeOfDay tod = psqi.report[i] as TimeOfDay;
//       DateTime date = DateTime.utc(1, 1, 1, tod.hour, tod.minute);
//       value = date.toIso8601String();
//     }else{
//       value = psqi.report[i];
//     }
    
//     body["q${i+1}"] = value;
//   }

//   body["q15_text"] = psqi.optionalText;

//   int id = myJwtData()["sub"];
//   body["user"] = id;

//   var response = await HttpRequest(
//     tableName: TableName.psqi,
//     requestType: RequestType.post,
//     body: body
//   ).exec();

//   return response.success;
// }

Future<bool> addMyPSQI(PSQIData psqi) async{
  Map<String, dynamic> body = {};
  body["q1"] = timeOfDaytoString(psqi.timeToBed!);
  body["q2"] = psqi.minutesToFallAsleep;
  body["q3"] = timeOfDaytoString(psqi.timeWokeUp!);
  body["q4"] = psqi.timeAsleep!.asPostgresString;

  body["q5a"] = psqi.notFallAsleepWithin30Minutes;
  body["q5b"] = psqi.wakeUpWithoutFallingAsleepAgain;
  body["q5c"] = psqi.goToTheBathroom;
  body["q5d"] = psqi.notBreethingCorrectly;
  body["q5e"] = psqi.coughOrSnort;
  body["q5f"] = psqi.tooCold;
  body["q5g"] = psqi.tooHot;
  body["q5h"] = psqi.badDreams;
  body["q5i"] = psqi.havingPain;

  body["q5j"] = psqi.otherProblems;
  body["q5j_text"] = psqi.optionalText;
  body["q5j_frequency"] = psqi.otherProblemsFrequency;

  body["q6"] = psqi.sleepQuality;
  body["q7"] = psqi.drugs;
  body["q8"] = psqi.difficultiesBeingAwake;
  body["q9"] = psqi.enoughEnergies;

  // body["q1"] = timeOfDaytoString(psqi.timeToBed!);
  // body["q2"] = psqi.minutesToFallAsleep;
  // body["q3"] = timeOfDaytoString(psqi.timeWokeUp!);
  // body["q4"] = psqi.timeAsleep!.asPostgresString;
  // body["q5"] = psqi.notFallAsleepWithin30Minutes;
  // body["q6"] = psqi.wakeUpWithoutFallingAsleepAgain;
  // body["q7"] = psqi.goToTheBathroom;
  // body["q8"] = psqi.notBreethingCorrectly;
  // body["q9"] = psqi.coughOrSnort;
  // body["q10"] = psqi.tooCold;
  // body["q11"] = psqi.tooHot;
  // body["q12"] = psqi.badDreams;
  // body["q13"] = psqi.havingPain;
  // body["q13text"] = psqi.optionalText;
  // body["q14"] = psqi.sleepQuality;
  // body["q15"] = psqi.drugs;
  // body["q16"] = psqi.difficultiesBeingAwake;
  // body["q17"] = psqi.enoughEnergies;

  int id = myJwtData()["sub"];
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

Future<List<PSQIData>> getMyPSQIs() async {

  var response = await HttpRequest(
    tableName: TableName.user,
    requestType: RequestType.get,
    joinWith: TableName.psqi,
    useIdInJwt: true
    ).exec();

  var body = convert.jsonDecode(response.body)["psqis"];
  var jsonResponse = body as List<dynamic>;
  List<PSQIData> psqis = jsonResponse.map((e) => _jsonToPSQI(e)).toList();

  return psqis;
}


Future<bool> addDream(DreamData dream) async {
  int id = myJwtData()["sub"];
  
  var body = {
    "text": dream.dreamText,
    "emotional_content": dream.report[0],
    "emotional_intensity": dream.report[1],
    "concious": dream.report[2],
    "control": dream.report[3],
    "percived_elapsed_time": (dream.report[4] as Duration).asPostgresString,
    "hours_of_sleep": (dream.report[5] as Duration).inHours,
    "sleep_quality": dream.report[6],
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

List<UserType> allowedToDownload = [UserType.admin, UserType.researcher];

Future<void> downloadDatabaseDesktop() async {
  if(!allowedToDownload.contains(await getMyUserType())) return;
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

enum MobileDBDownloadState {
  fileAlreadyExists,
  downloadFinished,
  downloadFailed
}


Future<(File, MobileDBDownloadState)?> downloadDatabaseMobile() async {
  if(!allowedToDownload.contains(getMyUserType())) return null;

  UserData user = await getMyResearcher();
  String fileName = "sogniario (${user.organizationName}) - ${DateTime.now()}.zip";

  Directory? directory = await getDownloadsDirectory();
  directory ??= await getTemporaryDirectory();

  final filePath = "${directory.path}/${fileName}";
  var file = File(filePath);
  if(file.existsSync()){
    return (file, MobileDBDownloadState.fileAlreadyExists);
  }else{
    var state = await downloadDatabaseMobileConfirmed(file);
    return (file, state!);
  }
}

Future<MobileDBDownloadState?> downloadDatabaseMobileConfirmed(File file) async {
  if(!allowedToDownload.contains(getMyUserType())) return null;

  int organizationId = myJwtData()["organization"];
  var response = await HttpRequest(
    tableName: TableName.userDownload,
    requestType: RequestType.post,
    body: {
      "organizationId": organizationId
    },
    ).exec();

  if(!response.success) return MobileDBDownloadState.downloadFailed;

  await file.writeAsBytes(response.bodyBytes);
  return MobileDBDownloadState.downloadFinished;
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

