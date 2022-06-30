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
          Stack(
            clipBehavior: Clip.none,
            children: [
              Profile(hScreen, wScreen),
              QuickButtonContainer(wScreen),
            ],
          ),
        ],
      ),
    );
  }

  Container Profile(double hScreen, double wScreen) {
    return Container(
      alignment: Alignment.topCenter,
      height: hScreen * 0.15,
      width: wScreen,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0.0, 1.0),
          ),
        ],
        // color: kPrimaryColor,
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kPrimaryColor, kBackgroundColor]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
              child: Image.asset("assets/images/profile.png"),
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
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

  Padding QuickButtonContainer(double wScreen) {
    return Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                // spreadRadius: 1,
                color: Colors.grey,
                blurRadius: 1.0,
                offset: Offset(0.0, 1.0),
              ),
            ],
          ),
          height: 100,
          width: wScreen * 0.8,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Row(
                children: [
                  ButtonQuickView(Icons.add_task, 'MR'),
                  ButtonQuickView(Icons.checklist_rtl_outlined, 'Listing Fee'),
                  ButtonQuickView(Icons.note_add, 'Keluhan'),
                  ButtonQuickView(Icons.note_add, 'Keluhan'),
                  ButtonQuickView(Icons.note_add, 'Keluhan'),
                ],
              ),
            ],
          ),
        ),
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
