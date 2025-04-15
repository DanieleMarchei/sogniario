import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/routes.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:universal_io/io.dart';

const sogniarioCert = '''
-----BEGIN CERTIFICATE-----
MIIGfzCCBOegAwIBAgIQRL9NkmDbkNeYJCYNuFlpujANBgkqhkiG9w0BAQsFADBgMQswCQYDVQQG
EwJHUjE3MDUGA1UECgwuSGVsbGVuaWMgQWNhZGVtaWMgYW5kIFJlc2VhcmNoIEluc3RpdHV0aW9u
cyBDQTEYMBYGA1UEAwwPR0VBTlQgVExTIFJTQSAxMB4XDTI1MDQxNDE1NDQwNVoXDTI2MDQxNDE1
NDQwNVowHjEcMBoGA1UEAwwTc29nbmlhcmlvLnVuaWNhbS5pdDCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBALI5CeH5lGK4faF4JH6ry2grb/OAM0L2V+NMbzTjW0w9LAdmtlIx16cn7722
zN/HteaUdAW16rA0mp8nOvKaw562zba8IFSAHWvcIczy392NwBpL6US1TICL7nUxz72zne2a3fwd
M13uQZ/xl8pWVRsPb5zLmGz5dyy6VLSkra2Ijo9yVfDJnckP7SfmTHOs9ub0adBYStMdzo0IHeHo
EUz1XMuMZj9Ga0vvOzreCJXJNHp/ww0XfMeUItiQGpPgaQfUMpp/3ZRwRs2zWuPoQEodNkJZYdBx
kvO8qjdT4xZOJd4FqGm+JhZrQrAD/fYHGAxDMFgZbM6ozqzaXW4wMeUCAwEAAaOCAvUwggLxMB8G
A1UdIwQYMBaAFIYBcj+MqXDiMQZTFs4BX1t5yDw7MG8GCCsGAQUFBwEBBGMwYTA4BggrBgEFBQcw
AoYsaHR0cDovL2NydC5oYXJpY2EuZ3IvSEFSSUNBLUdFQU5ULVRMUy1SMS5jZXIwJQYIKwYBBQUH
MAGGGWh0dHA6Ly9vY3NwLXRscy5oYXJpY2EuZ3IwHgYDVR0RBBcwFYITc29nbmlhcmlvLnVuaWNh
bS5pdDAtBgNVHSAEJjAkMAgGBmeBDAECATAIBgYEAI96AQYwDgYMKwYBBAGBzxEBAQEBMB0GA1Ud
JQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDATA9BgNVHR8ENjA0MDKgMKAuhixodHRwOi8vY3JsLmhh
cmljYS5nci9IQVJJQ0EtR0VBTlQtVExTLVIxLmNybDAdBgNVHQ4EFgQUBXQaucwk1/V94CPPUQCY
vsGPoywwDgYDVR0PAQH/BAQDAgWgMIIBfwYKKwYBBAHWeQIEAgSCAW8EggFrAWkAdgAlL5TCKynp
bp9BGnIHK2lcW1L/l6kNJUC7/NxR7E3uCwAAAZY1AgYqAAAEAwBHMEUCIDWonbcv0Cr5fEaQDVp7
QJnncuX9HF0G2uBdjsu9fdoSAiEAvqKwVXgUhWtNPO1UowgKpadN88EeWOAl3Zayfe7rcKEAdgAO
V5S8866pPjMbLJkHs/eQ35vCPXEyJd0hqSWsYcVOIQAAAZY1AgWhAAAEAwBHMEUCIQCzR3IqOtpF
ZJ9KlOJPQyw2Px/Lnvsah3mT6ub855l7wAIgHHqsY3cEuBlISxkdicrRsoxl0LwmrpRgBXZIF+OS
PJwAdwCWl2S/VViXrfdDh2g3CEJ36fA61fak8zZuRqQ/D8qpxgAAAZY1AgVxAAAEAwBIMEYCIQCB
gfeliZ8vc4Wx+aVffBHb1weJB2I7qz1bjvFXw+efjAIhAIoFBRvn2w+6VovaWLDi3hVCiOw3DftB
wnY08+kTExtMMA0GCSqGSIb3DQEBCwUAA4IBgQBPCqk/skYTSm/vsiniC33iY3vt03IdjLRI2H5o
rVSbenx0fJcRWMmbghx0uEvgaL9Qp3HuPsHQpUcSsgY9+hqzo/jOS9awyity0EDltj/Yohdz4Bmz
borIe0SttP0OwsQuWBzBkiVhME0eKmRVdNUVQjyg5a6Dr2HO0tLtzp3caJDO44kK4HqAD6gB3d/j
75+nFvjwfdsTPNHOiq56q22mqcgTOK7lNVZrxwX23Z9ffBk5Efo3gPRJolXA2HCw6fVylwEUA0kI
J8Lgk+BrlgvPDpmUZhCLB7wRfuoPSg5FN3GtkMerlfXujyRX4qyzrUeC2jCzNPkffaHzl+1XLwyL
rEpvKldKrsqCy4gR3TM8jIYqDTx8AGZ0uj0Zc2ySI+Ydqv4pTWCXl8vEFVh7csxADSmDDsDGBg4w
FSHmnFnGedh4VVM+9vFUZuu0OoH4WSyVHvPoZpVJfnsWP1axgiU44yYlT35ioeA61dNPIsu6nju3
zIss8twXGWyWT9jcg9U=
-----END CERTIFICATE-----
''';

void main() async {


  await Hive.initFlutter();
  await Hive.openBox('tokens');
  await Hive.openBox('userData');
  runApp(Frontend());
  SecurityContext.defaultContext
        .setTrustedCertificatesBytes(Uint8List.fromList(sogniarioCert.codeUnits));
}

class Frontend extends StatelessWidget {
  Frontend({super.key});

  late StreamSubscription<List<ConnectivityResult>> subscription;


  @override
  Widget build(BuildContext context) {
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
        if(result.contains(ConnectivityResult.none)){
          Fluttertoast.showToast(
            msg: "Errore durante la connessione ad internet.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0
          );
          // UserType userType = getMyUserType();
          ModalRoute? modalRoute = ModalRoute.of(context);
          if(modalRoute != null){
            print(modalRoute);
          }
        }
    });
    return MaterialApp.router(
      title: "Sogniario",
      onGenerateTitle: (context) => "Sogniario",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}