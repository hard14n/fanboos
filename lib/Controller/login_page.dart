// ignore_for_file: avoid_print, avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields, override_on_non_overriding_member, unused_local_variable, avoid_web_libraries_in_flutter, unused_import, prefer_adjacent_string_concatenation, unnecessary_import
// import 'dart:isolate';

import 'dart:ui';
import 'package:fanboos/Systems/connectivity_provider.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

// import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:provider/provider.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:fanboos/Systems/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
import 'package:new_version/new_version.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:url_launcher/url_launcher.dart';
// import 'package:simple_url_preview/simple_url_preview.dart';

bool newVersi = false;
String currVersi = '';

TextEditingController txtuser = TextEditingController();
TextEditingController txtpass = TextEditingController();

class LoginPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String TAG = '/';

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();

    // txtuser = TextEditingController(text: 'gracia.lityo');
    // txtpass =  TextEditingController(text: 'Fabindo1');
    // txtuser = TextEditingController(text: 'howard.lityo');
    // txtpass = TextEditingController(text: 'Fabindo1');
    txtuser = TextEditingController(text: 'hardian');
    txtpass = TextEditingController(text: 'itm');
    
    _checkVersion();

    super.initState();
    // deklarasiDownload();
  }

  // Future<void> deklarasiDownload() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await FlutterDownloader.initialize(
  //       debug: true // optional: set false to disable printing logs to console
  //       );
  // }

  // ReceivePort _port = ReceivePort();
  // @override
  // void initstate() {
  //   super.initState();

  //   IsolateNameServer.registerPortWithName(
  //       _port.sendPort, 'downloader_send_port');
  //   _port.listen((dynamic data) {
  //     String id = data[0];
  //     DownloadTaskStatus status = data[1];
  //     int progress = data[2];
  //     setState(() {});
  //   });

  //   FlutterDownloader.registerCallback(downloadCallback);
  // }

  // @override
  // void dispose() {
  //   IsolateNameServer.removePortNameMapping('downloader_send_port');
  //   super.dispose();
  // }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send!.send([id, status, progress]);
  // }

  void _checkVersion() async {
    final newVersion = NewVersion(androidId: "com.snapchat.android");
    final status = await newVersion.getVersionStatus();

    // print(status!.localVersion);
    setState(() {
      currVersi = status!.localVersion;
    });

    // print(alamaturl);

    final uri =
        Uri.parse(alamaturl + "/version/check?user_version=" + currVersi);

    final response =
        await http.get(uri, headers: {"Authorization": "Bearer $mytoken"});
    var _newVersion = jsonDecode(response.body);

    if (_newVersion['respon'] == 0) {
      // print(_newVersion['message']);
      showAlertVersi('Update Aplikasi', _newVersion['message'], 1);
    } else {
      if (_newVersion['respon'] == 1) {
        if (_newVersion['message'] == null) {
          print('Update Aplikasi >> ' + _newVersion['message'].toString());
        } else {
          // print(_newVersion['message']);
          showAlertVersi(
              'Update Aplikasi',
              _newVersion['message'].toString() +
                  '\n' +
                  'Perbaikan pada : ' +
                  '\n' +
                  _newVersion['data']['data_version'][0]['note'].toString(),
              0);
        }
      }
    }
  }

  void showAlertVersi(String mytitle, String msg, int mandatory) {
    showDialog(
      context: context,
      builder: (context) {
        if (mandatory == 1) {
          return AlertDialog(
            title: Text(mytitle),
            content: Text(msg),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    // goto class Proses Update
                    downloadFromUrl();
                  },
                  child: const Text('Update')),
            ],
          );
        } else {
          // ini alert untuk info update dan bisa skip saja
          return AlertDialog(
            title: Text(mytitle),
            content: Text(msg),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Skip'),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);

                  // goto class Proses Update
                  downloadFromUrl();
                },
                child: const Text('Update'),
              ),
            ],
          );
        }
      },
    );
  }

  downloadFromUrl() async {
    if (await canLaunch('https://fabindo.com/api/app-release.apk')) {
      await launch("https://fabindo.com/api/app-release.apk");
    } else {
      throw "Could Not Launch URL";
    }
  }

//   Future downloadUpdateVersion() async {
// // Proses Update Mandatory
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       final externalDir = await getExternalStorageDirectory();

//       // print(externalDir);
//       var _url = "https://fabindo.com/api/app-release.apk";
//       // "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4";
//       //  "http://api.fabindo.com/apk/app-release.apk"

//       // print(_url);

//       final id = await FlutterDownloader.enqueue(
//           url: _url,
//           savedDir: externalDir!.path,
//           fileName: "Fan-Mobs.apk",
//           showNotification: true,
//           openFileFromNotification: true,
//           saveInPublicStorage: true);

//       SystemNavigator.pop();
//     } else {
//       showAlert('Download', 'Permission deined', 0);
//     }
//   }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var mediaQueryData = MediaQuery.of(context);
    var hScreen = mediaQueryData.size.height;
    var wScreen = mediaQueryData.size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pageUI(size, wScreen, context, hScreen),
    );
  }

  Widget pageUI(size, wScreen, context, hScreen) {
    return Consumer<ConnectivityProvider>(
      builder: (context, model, child) {
        // ignore: unnecessary_null_comparison
        if (model.isOnline != null) {
          return model.isOnline
              ? GoodInternet(size, wScreen, context, hScreen)
              : NoInternet();
        }
        return Container(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Column GoodInternet(size, wScreen, BuildContext context, hScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildStackHeader(size, wScreen, context),
        boxLogin(hScreen, wScreen),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't Have an Account ?  "),
              GestureDetector(
                onTap: () {
                  showAlert(context,
                      "Register Account",
                      "Untuk Register Account, Silahkan Hubungi Administrator Anda");
                },
                child: Text(
                  "Register",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2),
        )
      ],
    );
  }

  Container boxLogin(hScreen, wScreen) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, hScreen * 0.07, 0.0, 0.0),
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: wScreen * 0.8,
              margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 10,
                    color: kPrimaryColor.withOpacity(0.25),
                  ),
                ],
              ),
              child: TextField(
                controller: txtuser,
                decoration: InputDecoration(
                  hintText: 'Masukan Nomer Induk Karyawan',
                  prefixIcon: Icon(Icons.people),
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white70,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  // labelText: 'hardian',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, hScreen * 0.03, 0.0, 0.0),
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: wScreen * 0.8,
              margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 10,
                    color: kPrimaryColor.withOpacity(0.25),
                  ),
                ],
              ),
              child: TextField(
                controller: txtpass,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Masukan Password Anda',
                  prefixIcon: Icon(Icons.lock),
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white70,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.fromLTRB(wScreen * 0.6, hScreen * 0.04, 0.0, 0.0),
            child: Text('Forgot Password ?'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, hScreen * 0.1, 0.0, 0.0),
            // ignore: deprecated_member_use
            child: RaisedButton(
              child: Text('Login'),
              textColor: Colors.white,
              color: kPrimaryButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              onPressed: () {
                // print('Masuk');
                _login(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _login(context) async {
    // ignore: non_constant_identifier_names
    if (txtuser.text.isEmpty || txtuser.text == '') {
      showAlert(context,"Warning Message",
          "Masukan Nomer Induk Karyawan anda atau User Login anda");
      exit(context);
    }

    if (txtpass.text.isEmpty || txtpass.text == '') {
      showAlert(context, "Warning Message", "Password Masih Belum di Input");
      exit(context);
    }
    // print(alamaturl);
    // print (url, body: {"username": txtuser.text, "password": txtpass.text});

    try {
      final uri = Uri.parse(alamaturl + "/auth/login");
      final response = await http.post(uri,
          body: {"username": txtuser.text, "password": txtpass.text});
      
      var dataResult = json.decode(response.body);

      Map<String, dynamic> map = dataResult;

      if (map['respon'] == 0) {
          showAlert(context, "Err MESSAGE", "Login Fail");
          exit(context);
      } else {
        setState(() {
          userID = map['data']['user']['id_user'];
          username = map['data']['user']['nama_lengkap'];
          namaLengkap = map['data']['karyawan_new']['nama_lengkap'];
          alamat = map['data']['karyawan_new']['alamat'];

          title = map['data']['karyawan_new']['title'];
          departemen = map['data']['karyawan_new']['departemen'];
          statuskaryawan = map['data']['karyawan_new']['status_karyawan'];

          email = map['data']['user']['email'];

          mytoken = map['token'];

          print(mytoken);

          formActive = '2DOPribadi';

          // ===========================================
        });

        // Get.offNamed(MenuUtama.TAG);

        Navigator.pushReplacementNamed(context, "/menu_utama",
            arguments: mytoken);
      }
    } on Exception catch (_) {
      print("throwing new error");
      // throw Exception("Error on server");
      
      // ignore: dead_code
      showAlert(context, "MESSAGE", "Login Fail !!" + "\n" + "Periksa User Password dan Koneksi Jaringan Anda"  );

    }

    return 'Sukses';
  }

  Stack buildStackHeader(Size size, double wScreen, BuildContext context) {
    return Stack(
      children: [
        Container(
          height: size.height * 0.2,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(wScreen * 0.2, 0.0, 0.0, 0.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "mileadilan",
                          fontSize: 35,
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, wScreen * 0.03, 0.0),
                    child: Image.asset(
                      "assets/images/logo_fs.png",
                      fit: BoxFit.contain,
                      width: 50,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // color: Colors.green,
                margin: const EdgeInsets.only(right: 20.0),
                alignment: Alignment.bottomRight,
                child: Text('Current Version. ' + currVersi),
              )
            ],
          ),
        ),
      ],
    );
  }

  
}
