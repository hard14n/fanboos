// ignore_for_file: file_names, unused_import
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new

import 'package:fanboos/Controller/Tab/Marketing/Top10EvenOutstanding/Top10EvenOutstanding.dart';
import 'package:fanboos/Controller/Tab/Marketing/Top10NextEvent/Top10NextEvent.dart';
import 'package:flutter/material.dart';

class TabMarketing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: ListView(
        children: [
          Top10eventOutstanding(),
          Top10NextEvent(),
        ],
      ),
    );
  }
}
