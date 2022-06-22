// ignore_for_file: file_names
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new

import 'package:fanboos/Controller/Tab/IT/widget_it.dart';
import 'package:flutter/material.dart';

class TabIT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: ListView(
        children: [
          // quickButton(context),
          WidgetIT(),
        ],
      ),
    );
  }
}
