import 'package:flutter/material.dart';
import 'package:frontend/add_dream_with_s2t.dart';
import 'package:frontend/api.dart';
import 'package:frontend/chronotype.dart';
import 'package:frontend/dreams_list.dart';
import 'package:frontend/general_info.dart';
import 'package:frontend/home_researcher.dart';
import 'package:frontend/home_user.dart';
import 'package:frontend/info_privacy.dart';
import 'package:frontend/login.dart';
import 'package:frontend/manage_users.dart';
import 'package:frontend/psqi.dart';
import 'package:frontend/signUp.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/verify_otp.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

var userDataBox = Hive.box('userData');
var signUpBox = Hive.box('signUp');
UserType userType = UserType.notLogged;


class MyPageTransition extends CustomTransitionPage{
  MyPageTransition(key, child): super(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity:
              CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
  );

}

enum Routes {
  login(path: "/", name: "login"),

  homeResearcher(path: "/home_researcher", name: "homeResearcher"),
  manageUsers(path: "/manage_users", name: "manageUsers"),

  signUp(path: "/sign_up", name: "signUp"),
  otp(path: "/verify_otp", name: "verifyOTP"),
  
  homeUser(path: "/home_user", name: "homeUser"),
  psqi(path: "/psqi", name: "psqi"),
  chronotype(path: "/chronotype", name: "chronotype"),
  generalInfo(path: "/general_info", name: "generalInfo"),
  infoAndPrivacy(path: "/info_privacy", name: "infoAndPrivacy"),
  addDream(path: "/add_dream", name: "addDream"),
  myDreams(path: "/myDreams", name: "myDreams");

  const Routes({required this.path, required this.name});

  final String path;
  final String name;
}

List<String> researchRoutesNames = [
  Routes.homeResearcher.path,
  Routes.manageUsers.path
];

List<String> userRoutesNames = [
  Routes.homeUser.path,
  Routes.addDream.path,
  Routes.myDreams.path,
  Routes.psqi.path,
  Routes.chronotype.path,
  Routes.generalInfo.path,
  Routes.infoAndPrivacy.path
];

final routes = GoRouter(
  initialLocation: Routes.login.path,
  redirect: (context, state) async {
    if(state.fullPath == Routes.signUp.path){
      return Routes.signUp.path;
    }

    if(state.fullPath == Routes.otp.path){
      bool canUserCheckOTP = signUpBox.containsKey(HiveBoxes.signUpUUID.label) && signUpBox.containsKey(HiveBoxes.signUpEmail.label);
      if(canUserCheckOTP){
        return Routes.otp.path;
      }
    }

    userType = await getMyUserType();

    if(state.fullPath != Routes.addDream.path){
      WakelockPlus.disable();
    }
    
    if(userType == UserType.notLogged){
      if(state.fullPath == Routes.login.path) {
        return null;
      }else{
        return Routes.login.path;
      }
    }

    if(userType == UserType.researcher){
      bool validResearcherPath = researchRoutesNames.contains(state.fullPath!);
      if(validResearcherPath){
        return null;
      }else{
        return Routes.homeResearcher.path;
      }
    }
    
    if(userType == UserType.user){

      bool validUserPath = userRoutesNames.contains(state.fullPath!);
      if(!validUserPath) {
        return Routes.homeUser.path;
      }

      if (doIHaveGeneralInfo()) return null;
      
      DateTime? birthdate;
      Sex? sex;
      try{
        (birthdate, sex) = await getMyGeneralInfo();

      }catch(error){
        return Routes.login.path;
      }

      if(birthdate == null || sex == null) {
        userDataBox.delete(HiveBoxes.hasGeneralInfo.label);
        return Routes.generalInfo.path;
      }else{
        userDataBox.put(HiveBoxes.hasGeneralInfo.label, true);
      }

      // ChronoTypeData? chrono = await getMyChronotype();

      // if(chrono == null) {
      //   userDataBox.delete(HiveBoxes.hasChronotype.label);
      //   return Routes.chronotype.path;
      // }else{
      //   userDataBox.put(HiveBoxes.hasChronotype.label, true);
      // }
      
      return null;
    }

    // in any other case, return to login
    return Routes.login.path;

  },
  routes: [
    GoRoute(
      name: Routes.login.name,
      path: Routes.login.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const Login())
    ),
    GoRoute(
      name: Routes.signUp.name,
      path: Routes.signUp.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const SignUp())
    ),
    GoRoute(
      name: Routes.otp.name,
      path: Routes.otp.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const VerifyOTP())
    ),
    GoRoute(
      name: Routes.homeUser.name,
      path: Routes.homeUser.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const HomeUser())
    ),
    GoRoute(
      name: Routes.homeResearcher.name,
      path: Routes.homeResearcher.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const HomeResearcher())
    ),
    GoRoute(
      name: Routes.manageUsers.name,
      path: Routes.manageUsers.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const ManageUsers())
    ),
    GoRoute(
      name: Routes.psqi.name,
      path: Routes.psqi.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const PSQI())
    ),
    GoRoute(
      name: Routes.chronotype.name,
      path: Routes.chronotype.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const ChronoType())
    ),
    GoRoute(
      name: Routes.generalInfo.name,
      path: Routes.generalInfo.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const GeneralInfo())
    ),
    GoRoute(
      name: Routes.infoAndPrivacy.name,
      path: Routes.infoAndPrivacy.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, InfoAndPrivacy())
    ),
    GoRoute(
      name: Routes.addDream.name,
      path: Routes.addDream.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const AddDreamWithS2T())
    ),
    GoRoute(
      name: Routes.myDreams.name,
      path: Routes.myDreams.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, DreamsList())
    ),
  ],
);


Route<dynamic> errorPage() {
  return MaterialPageRoute(
      builder: (_) => const Scaffold(
            body: Center(
                child: Text('Page not found!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ))),
          ));
}
