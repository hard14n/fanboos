// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new

import 'package:fanboos/Controller/Tab/General/ToDoListDownLine/w_ToDoListDownline.dart';
import 'package:fanboos/Controller/Tab/General/ToDoPribadi/w_ToDoPribadi.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';

class Widget2DoList extends StatefulWidget {
  @override
  _Widget2DoListState createState() => _Widget2DoListState();
}

class _Widget2DoListState extends State<Widget2DoList> {
  @override
  void initState() {
    super.initState();

    currenttab = formActive == '2DOPribadi' ? 0 : 1;
    
    // print(formActive + ' >> ' + 'Init State');
  }

  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var wScreen = MediaQuery.of(context).size.width;

    // print(formActive);
    // print(currenttab);

    return DefaultTabController(
      initialIndex: currenttab,
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              height: 48,
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                // labelColor: kPrimaryColor,
                indicator: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)),
                tabs: [
                  Tab(
                    icon: Icon(Icons.article_outlined),
                    iconMargin: EdgeInsets.only(left: 0),
                    text: 'To Do List Pribadi',
                  ),
                  Tab(
                    icon: Icon(Icons.article_rounded),
                    iconMargin: EdgeInsets.only(left: 0),
                    text: 'To Do List Downline',
                  )
                ],
              ),
            ),
            Container(
              height: hScreen * 0.56,
              child: TabBarView(children: [
                WidgetToDoListPribadi(),
                WidgetToDoListDownline(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
