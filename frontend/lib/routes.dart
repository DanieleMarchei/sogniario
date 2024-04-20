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
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

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
    var userType = getMyUserType();
    if(userType == UserType.notLogged && state.fullPath == Routes.login.path){
      return null;
    }

    if(userType == UserType.notLogged && state.fullPath != Routes.login.path) return Routes.login.path;

    if(userType == UserType.researcher && !researchRoutesNames.contains(state.fullPath!)) return Routes.homeResearcher.path;

    // these should be cached

    DateTime? birthdate;
    Sex? sex;
    (birthdate, sex) = await getMyGeneralInfo();

    if(userType == UserType.user && (birthdate == null || sex == null)) return Routes.generalInfo.path;

    ChronoTypeData? chrono = await getMyChronotype();

    if(userType == UserType.user && chrono == null) return Routes.chronotype.path;
    
    if(userType == UserType.user && !userRoutesNames.contains(state.fullPath!)) return Routes.homeUser.path;



    return null;

  },
  routes: [
    GoRoute(
      name: Routes.login.name,
      path: Routes.login.path,
      pageBuilder: (context, state) => MyPageTransition(state.pageKey, const Login())
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
