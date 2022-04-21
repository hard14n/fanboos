// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names, avoid_unnecessary_containers, unused_local_variable

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';

class MRIT extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<MRIT> {
  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: Text(
            'Maintenance Request',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Container(
          child: Text('Data MR'),
        ),
      ),
    );
  }
}
