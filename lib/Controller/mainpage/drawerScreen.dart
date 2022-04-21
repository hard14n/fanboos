// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
// import 'package:e_fansys/pages/activity/activity.dart';
// import 'package:e_fansys/pages/administration/administration.dart';
// import 'package:e_fansys/pages/profile/profile.dart';
// import 'package:e_fansys/pages/report/report.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    var mediaQueryData = MediaQuery.of(context);
    // ignore: unused_local_variable
    var hScreen = mediaQueryData.size.height;
    // ignore: unused_local_variable
    var wScreen = mediaQueryData.size.width;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              // color: kPrimaryColor,
              gradient:
                  LinearGradient(colors: [kPrimaryColor, kBackgroundColor]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, wScreen * 0.03, 0.0),
                  child: Image.asset("assets/images/logo_fs.png"),
                ),
                Text('Menu'),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Home',
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/menu_utama",
                  arguments: mytoken);
            },
          ),
          // Profile(),
          // Administration(),
          // Activity(),
          // Report(),
          ListTile(
            title: Text(
              'Logout',
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/loginpage");
              // Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
      ),
    );
  }
}
