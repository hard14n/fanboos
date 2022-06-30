// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, deprecated_member_use, avoid_print

// import 'package:fanboos/Controller/ShowAlertScreen.dart';
import 'package:fanboos/Controller/Tab/General/WidgetToDoList.dart';
import 'package:flutter/material.dart';

class TabGeneral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var wScreen = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0.0),
      color: Colors.blueAccent,
      child: ListView(
        children: [
          Widget2DoList(),
        ],
      ),
    );
  }
}
