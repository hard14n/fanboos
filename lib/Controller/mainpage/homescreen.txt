// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, unused_import, non_constant_identifier_names, unused_local_variable, avoid_print, unused_field

import 'dart:ffi';

import 'package:fanboos/Controller/ButtonQuickView.dart';
import 'package:fanboos/Controller/Tab/tabMarketing.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'package:fanboos/Controller/Tab/tabGeneral.dart';
import 'package:fanboos/Controller/Tab/tabIT.dart';
import 'package:fanboos/Controller/Tab/tabSales.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;
    TabController _tabController = TabController(length: 4, vsync: this);
    return Container(
      child: Column(
        children: [
          Container(
            height: 100,
            width: wScreen,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    ButtonQuickView(Icons.add_task, 'MR'),
                    ButtonQuickView(
                        Icons.checklist_rtl_outlined, 'Listing Fee'),
                    // ButtonQuickView(Icons.note_add, 'Keluhan'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: TabBar(
              controller: _tabController,
              labelColor: kPrimaryColor,
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimaryColor,
              tabs: <Widget>[
                Container(width: 90, child: Tab(text: 'General')),
                Container(width: 90, child: Tab(text: 'Sales')),
                Container(width: 90, child: Tab(text: 'Marketing')),
                Container(width: 90, child: Tab(text: 'IT')),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                TabGeneral(),
                TabSales(),
                TabMarketing(),
                TabIT(),
              ],
            ),
          )
        ],
      ),
    );
  }

  DefaultTabController TabHomeController() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: TabBar(
            labelColor: Colors.white,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Container(width: 90, child: Tab(text: 'General')),
              Container(width: 90, child: Tab(text: 'Sales')),
              Container(width: 90, child: Tab(text: 'Marketing')),
              Container(width: 90, child: Tab(text: 'IT')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            TabGeneral(),
            TabSales(),
            TabMarketing(),
            TabIT(),
          ],
        ),
      ),
    );
  }
}
