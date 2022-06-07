// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var hScreen = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var wScreen = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        children: [
          Header(wScreen),
          Detail(wScreen),
        ],
      ),
    );
  }

  ListTile Detail(double wScreen) {
    return ListTile(
      title: Column(
        children: [
          Container(
            // color: Colors.blue,
            // height: 100,
            width: wScreen,
            margin: EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alamat : ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  alamat,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          Text(''),
          Container(
            // color: Colors.blue,
            // height: 100,
            width: wScreen,
            margin: EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status : ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  statuskaryawan,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          Text(''),
          Container(
            // color: Colors.blue,
            // height: 100,
            width: wScreen,
            margin: EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Departemen : ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  departemen,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          Text(''),
          Container(
            // color: Colors.blue,
            // height: 100,
            width: wScreen,
            margin: EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Office email : ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DrawerHeader Header(double wScreen) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        gradient:
            LinearGradient(colors: const [kPrimaryColor, kBackgroundColor]),
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(30),
        //   bottomRight: Radius.circular(30),
        // ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, wScreen * 0.03, 0.0),
            child: Image.asset("assets/images/profile.png"),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
