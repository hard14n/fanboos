// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fanboos/Model/constants.dart';

import 'ToDoListDownline.dart';
import 'ToDoListPribadi.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  void initState() {
    super.initState();

    currenttab = formActive == '2DOPribadi' ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    return DefaultTabController(
      initialIndex: currenttab,
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            TabBarTodolist(),
            Container(
              margin: const EdgeInsets.only(top: 5),
              color: Colors.white,
              height: hScreen - 195,
              child: const TabBarView(children: [
                ToDoListPribadi(),
                ToDoListDownline(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox TabBarTodolist() {
    return SizedBox(
      height: mytoolbarHeight,
      child: TabBar(
        unselectedLabelColor: Colors.grey,
        // labelColor: kPrimaryColor,
        indicator: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
        tabs: const [
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
    );
  }
}
