// ignore_for_file: unused_import, camel_case_types
// Definisi versioning
// Metode X.Y.Z punya aturan sbagai berikut :
// X versi Mayor (Perubahan arsitektur/fitur besar besaran)
// Y versi Minor (Penambahan beberapa fitur seperti penambahan widget/menu/aplikasi form/report)
// Z versi perbaikan/patch/bugfix. (perbaikan /bugfix,security fix dsb).

import 'dart:async';
import 'package:fanboos/Routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Controller/login_page.dart';
import 'Controller/mainpage/menu_utama.dart';
import 'Systems/connectivity_provider.dart';
import 'package:get/get.dart';

void main() {
  runApp(const fanboos());
}

class fanboos extends StatelessWidget {
  const fanboos({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var setPreferredOrientations = SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // ignore: unnecessary_new
    return new MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
          child: const LoginPage(),
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
        getPages: getRoutePages,
        routes: <String, WidgetBuilder>{
          '/menu_utama': (BuildContext context) => const MenuUtama(),
        },
      ),
    );
  }
}