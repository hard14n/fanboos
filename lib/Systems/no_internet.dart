// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_con
//st_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new
import '../Model/constants.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return formActive == 'Form Login'
        ? Scaffold(
            appBar: AppBar(
              title: Text('Internet Connection'),
              backgroundColor: kPrimaryColor,
            ),
            body: NoInternetpage(),
          )
        : Scaffold(
            body: NoInternetpage(),
          );
  }

  // ignore: non_constant_identifier_names
  Center NoInternetpage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Icon(
              Icons.wifi_off,
              color: Colors.green,
              size: 50.0,
            ),
          ),
          Container(
            child: Text(
              'No Network Connection',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Container(
            child: Text(
                'No Internet Connection. Connect to the internet and try again.'),
          ),
        ],
      ),
    );
  }
}
