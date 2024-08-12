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
MIIHYTCCBUmgAwIBAgIQXUOJl3A5I6ywIcP0BfyixDANBgkqhkiG9w0BAQwFADBE
MQswCQYDVQQGEwJOTDEZMBcGA1UEChMQR0VBTlQgVmVyZW5pZ2luZzEaMBgGA1UE
AxMRR0VBTlQgT1YgUlNBIENBIDQwHhcNMjQwNDIyMDAwMDAwWhcNMjUwNDIyMjM1
OTU5WjBsMQswCQYDVQQGEwJJVDERMA8GA1UECBMITWFjZXJhdGExLDAqBgNVBAoM
I1VuaXZlcnNpdMOgIGRlZ2xpIFN0dWRpIGRpIENhbWVyaW5vMRwwGgYDVQQDExNz
b2duaWFyaW8udW5pY2FtLml0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEA23NvIQkytsxvDAwy24yu052NMSz+hYvda+j3+NuU2wTsvVU8uvW/b6PLmMTD
0vwW/DOr5LWBESIGi866NjKisNso04YObty9mThFqhy68kIHdELZWcMGZPcZJfq+
CSJhotfMtG2QrLvBK11S7cO9tmHrMXl/tDeO9DV4nylQEjKHwIio+f+X4TAwmtPi
CiQByLorztMY7rBnTCCUwwRLhz6bSorYrmhbi3fG0mbIe8+BKmWE/PScfXBh0SfC
nYx70OkCae7uDC3Cxhl6fdxagX/lXRk+B5VuuNksCliFAVMwDubHQVgA6N3WJqCI
jUkvbyiEp4HtkclIGJCwU8ZvnwIDAQABo4IDJTCCAyEwHwYDVR0jBBgwFoAUbx01
SRBsMvpZoJ68iugflb5xegwwHQYDVR0OBBYEFIZiZJz5II0HpgXQyhydXIKQSG4m
MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMBBggrBgEFBQcDAjBJBgNVHSAEQjBAMDQGCysGAQQBsjEBAgJPMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMAgGBmeBDAECAjA/BgNVHR8E
ODA2MDSgMqAwhi5odHRwOi8vR0VBTlQuY3JsLnNlY3RpZ28uY29tL0dFQU5UT1ZS
U0FDQTQuY3JsMHUGCCsGAQUFBwEBBGkwZzA6BggrBgEFBQcwAoYuaHR0cDovL0dF
QU5ULmNydC5zZWN0aWdvLmNvbS9HRUFOVE9WUlNBQ0E0LmNydDApBggrBgEFBQcw
AYYdaHR0cDovL0dFQU5ULm9jc3Auc2VjdGlnby5jb20wggF9BgorBgEEAdZ5AgQC
BIIBbQSCAWkBZwB2AM8RVu7VLnyv84db2Wkum+kacWdKsBfsrAHSW3fOzDsIAAAB
jwX2X2IAAAQDAEcwRQIhAPB7yrZM0j1XCZgAbf6l6iDahlcDC/pnFyPZFJEkOCM5
AiBKcRskrxW7xOUjIMWWe63isE35+TFGHksUsCSy8pg3uAB2AKLjCuRF772tm344
7Udnd1PXgluElNcrXhssxLlQpEfnAAABjwX2XygAAAQDAEcwRQIgaydgstTOH9cN
v1Fu3Z/LV7qGVzeJQ2QT6ByDzSA4NH8CIQCKPopKHZkhNN9O5uwKWz56l9sn1XR0
FjGmiH+aNLoytwB1AE51oydcmhDDOFts1N8/Uusd8OCOG41pwLH6ZLFimjnfAAAB
jwX2XvcAAAQDAEYwRAIgIjHQLbuzBSqKOCJ1OfPdnl4U6yDD4NsSvC2n34mLi6MC
ICnRjZcqIo3zSTBnK26dVPEQRXUPPsuI9NZThB4iXei7MB4GA1UdEQQXMBWCE3Nv
Z25pYXJpby51bmljYW0uaXQwDQYJKoZIhvcNAQEMBQADggIBACPbb2iJZ4eiJabj
El0YAooXdh5zjXBEPlj/HC/LSW2FpEitrg/qeWAu51W/63rsBrWpssgk4MlXNtPZ
5fXMqO2cq64Mh3w5G0NkP9Na92DYM8WaEUn6P4QFvZral1/KKmFr+oVSA5eT95sv
jDGoLZIMdQf8b3V+9aOKqnvR9l4eWBsLGadxcUJOsT83TBW5Rq07e5OViCjn+XS1
JWALZ/FjesysLjwSe38Wv3sX3DiPLazy/eHFJD7fwtDz+gHa5pYq4TtGnhXOoVSn
nczm6g4Y/udTrNkVQqLGwHrR5SvPl/8pUA8Ci4S/C+mkog2q2+6HPUl486aN+ZBc
gcGQJjkFayBV5vCcjw8XgoZEaUyB2PlAaO0L0lO8/MN6nyUqpN3DDPFTaLi7jxbt
4Q3qsbe1C6pzuSsfqMvUouFByHPZGuPHVpiyPd5wM10KvU7bpx0S34V6Dc8+AM+W
Yw45zXW17EsuejVaDqtW/OYD8zDJgHIX+7iFsuF9Qf0CAgAvWp/aQ507SZ3e+G6s
TlYGljkJGIfsPUiE6p0VLpaENruAhOc6L12dF+6ilFkHJjZ7/6KBtQDoDDdSp5cr
35LyWgzBuTbeAV8sScPDluXzwu6b3I3383Y15QJ2qp5hHwvfvY5XPjy1KG5imJ0V
UX75qGX4EfSV9hx44ljHWj2il+jG
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
          UserType userType = getMyUserType();
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