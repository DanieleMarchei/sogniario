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
subject=CN=sogniario.unicam.it
issuer=CN=GEANT TLS RSA 1, O=Hellenic Academic and Research Institutions CA, C=GR
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
subject=CN=GEANT TLS RSA 1, O=Hellenic Academic and Research Institutions CA, C=GR
issuer=CN=HARICA TLS RSA Root CA 2021, O=Hellenic Academic and Research Institutions CA, C=GR
-----BEGIN CERTIFICATE-----
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
V9IaUQGJ
-----END CERTIFICATE-----
subject=CN=HARICA TLS RSA Root CA 2021, O=Hellenic Academic and Research Institutions CA, C=GR
issuer=CN=Hellenic Academic and Research Institutions RootCA 2015, O=Hellenic Academic and Research Institutions Cert. Authority, L=Athens, C=GR
-----BEGIN CERTIFICATE-----
MIIGwDCCBKigAwIBAgIQKmCG1NTeRcleS5j7vy+/JjANBgkqhkiG9w0BAQsFADCBpjELMAkGA1UE
BhMCR1IxDzANBgNVBAcTBkF0aGVuczFEMEIGA1UEChM7SGVsbGVuaWMgQWNhZGVtaWMgYW5kIFJl
c2VhcmNoIEluc3RpdHV0aW9ucyBDZXJ0LiBBdXRob3JpdHkxQDA+BgNVBAMTN0hlbGxlbmljIEFj
YWRlbWljIGFuZCBSZXNlYXJjaCBJbnN0aXR1dGlvbnMgUm9vdENBIDIwMTUwHhcNMjEwOTAyMDc0
MTU1WhcNMjkwODMxMDc0MTU0WjBsMQswCQYDVQQGEwJHUjE3MDUGA1UECgwuSGVsbGVuaWMgQWNh
ZGVtaWMgYW5kIFJlc2VhcmNoIEluc3RpdHV0aW9ucyBDQTEkMCIGA1UEAwwbSEFSSUNBIFRMUyBS
U0EgUm9vdCBDQSAyMDIxMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAi8Lnr2WbBWeW
yQ0kudAOZPzO4iQYLIR/d1HLBBE2uF7taXGnnuQlCZdnwUfCz5EWNmI9OAThUYL/rNK0ad0u7BGj
Re5raztMv4yNpB6dEbnpOPl6DgyY4iMd0U5j1Oe4QUT7a69r2h/TxZGIW6SJktGB5ow5WKDWaUOp
rZhSWG7bCvtrz2j646ReOkVzmAfqXwJy3gyls5+uqR23HbP8ilnnbnJlrfUwlCMH84IWSzWYnFO7
L8rkWtnHjR38mJn7LKSCa/AqH44LX3FcXK5CeymJgcsDo5nKiJ4LQAlBM9vmWHr9rplwwFoP1hOG
cS92afyQ3dstbtHym/Uaa55vFYx68EsooCI4gCRsNqQ78jCR83gTz8E/NavxHREjtUMingGStxgC
5RHRgtsVAMxhN8EqfJrh0LqzUEbugqydMfj7I+IDAEhwowkmeRVTYPM4XK046oEAYxS5M17dC9ug
RQcaMwn4TbSnAqZp9MJZBYhlhVauS8vg3jx9LRrI6fsfo2FK1ioTrXdMGhibkQ9Y2AZUxZf4qj8g
iqaFpnf2pvwc4u5ulDMqg1CECuVPhvhQRXgAgetbaOMmjcx7XFH0FCxAvhpgHXpyYR0fYy2Iqs6i
RZAI/Gu+s1AqWv2oSBhG1pBAkpAKhF5oMfjr7Q3THcZ9mRhVVidlLo1FxSTszuMCAwEAAaOCASEw
ggEdMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUcRVnyMjJvXVdctA4GGqd83EkVAswTAYI
KwYBBQUHAQEEQDA+MDwGCCsGAQUFBzAChjBodHRwOi8vcmVwby5oYXJpY2EuZ3IvY2VydHMvSGFy
aWNhUm9vdENBMjAxNS5jcnQwEQYDVR0gBAowCDAGBgRVHSAAMB0GA1UdJQQWMBQGCCsGAQUFBwMC
BggrBgEFBQcDATA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vY3JsLmhhcmljYS5nci9IYXJpY2FS
b290Q0EyMDE1LmNybDAdBgNVHQ4EFgQUCkgjpmCkkgoz6pNbxVfqJU29Eu4wDgYDVR0PAQH/BAQD
AgGGMA0GCSqGSIb3DQEBCwUAA4ICAQDAze/rVni3cYGP1BWkxXnIVynqHcC6Cw7kbkXoXBZAqF9A
NQAKoz2YQ+WyzrparKVilMG6p6mdWTKeLy6eQDRhFSu9DrMYr4TBYxIp2e5ZLQBk96xbG3wSepBC
kTDA0MA0NybzM0gF5nTa82BMCED8EQXliWWsgqUorXuk7msadosX793M42llmAcj1zJkADzlyzi4
gcPvIc4skfmz1OW9jxxwyaR/41VYzPVyw7m0rsL9n3v5PCFJ1zrldYayKq9gOdwOZInNJQgPU6im
XEFBZWdqdR+xdL7qHVMkdzBRoFqnYjr2bonw87Rxk7dAsdzmUUPJTIayzDTdtU78XkOl0FivJWBX
DQPiVB2Z5NdOVPUANDnADA5octuC3YTG2ncpG9aNKM4ggAyr3imdnz5UZdioYkecv2TVJHT2lXE5
PH/ifJs8p9+WFgyzFsW97BUF1nKsZiUWvlyPY9C9PKuhI4OMeTEA99YIRXYjXDSZq300ko5sXUVK
VG2osAR4Sr3wqS5hLGNBfym7FZwsQ+/ja+fenEALAbAiEMpI9h71lpMpIhdx7rdRznNeSOok/pVM
aqvBZ0IvAq+yXb7d8C+tAND0IcUxYyyJqkE789RJdcGZO9JMXv4inBFIEuMAMlGPxzcroEx+ehDX
yGR0asw7CooV2DCfiEJlIsKzLcPZew==
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