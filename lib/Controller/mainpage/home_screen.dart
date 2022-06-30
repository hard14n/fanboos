// ignore_for_file: camel_case_types, unused_local_variable, avoid_unnecessary_containers, non_constant_identifier_names
// import 'dart:ffi';
import 'package:fanboos/Controller/ButtonQuickView.dart';
import 'package:fanboos/Controller/Tab/IT/widget_it.dart';
import 'package:fanboos/Controller/Tab/Sales/SalesTrend/w_sales_Trend.dart';
import 'package:fanboos/Controller/Tab/Sales/YTD_Sales_Growth/W_YTD_Sales_Growth.dart';
import 'package:fanboos/Model/constants.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    var hScreen = MediaQuery.of(context).size.height;
    var wScreen = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Profile(hScreen, wScreen),
              QuickButtonContainer(wScreen),
            ],
          ),
        ),
        SizedBox(
          height: hScreen * 0.52,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              ContainerWidget("Sales", hScreen, wScreen),
              ContainerWidgetIT("Information Technology", hScreen, wScreen),
            ],
          ),
        )
      ],
    );
  }

  Column ContainerWidget(
      String judulContainer, double hScreen, double wScreen) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            // color: Colors.greenAccent,
            border: Border(
              bottom: BorderSide(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
            ),
          ),
          height: hScreen * 0.35,
          width: wScreen,
          margin: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                // height: hScreen * 0.03,
                margin: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 2.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.point_of_sale,
                      color: kPrimaryColor,
                    ),
                    const Text('   '),
                    Text(
                      judulContainer,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: hScreen * 0.3,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    judulContainer == 'Sales'
                        ? Row(
                            children: [
                              SalesContainer(
                                  'YTD Sales Growth', hScreen, wScreen),
                              SalesContainer('Sales Trend', hScreen, wScreen),
                            ],
                          )
                        : judulContainer == 'Information Technology'
                            ? Row(
                                children: [
                                  ITContainer('Asset IT', hScreen, wScreen),
                                ],
                              )
                            : const Text('Kosong')
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column ContainerWidgetIT(
      String judulContainer, double hScreen, double wScreen) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            // color: Colors.greenAccent,
            border: Border(
              bottom: BorderSide(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
            ),
          ),
          height: hScreen * 0.47,
          width: wScreen,
          margin: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                // height: hScreen * 0.03,
                margin: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 2.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.screen_search_desktop_outlined,
                      color: kPrimaryColor,
                    ),
                    const Text('   '),
                    Text(
                      judulContainer,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: hScreen * 0.4,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ITContainer('Asset IT', hScreen, wScreen),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Container SalesContainer(String judulWidget, double hScreen, double wScreen) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: Colors.white,
              blurRadius: 1.0,
              offset: Offset(0.0, 1.0),
            ),
          ],
          border: Border(
            right: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
            left: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
            top: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
            bottom: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            // color: Colors.red,
            // height: 20,
            width: wScreen * 0.8,
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
            child: Text(
              judulWidget,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              color: Colors.white,
              height: hScreen * 0.27,
              width: wScreen * 0.8,
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
              child: judulWidget == "YTD Sales Growth"
                  ? Widget_YTD_Sales_Growth()
                  : judulWidget == "Sales Trend"
                      ? w_sales_Trend()
                      : judulWidget == 'Information Technology'
                          ? WidgetIT()
                          : const Text("data")),
        ],
      ),
    );
  }

  Container ITContainer(String judulWidget, double hScreen, double wScreen) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: Colors.white,
              blurRadius: 1.0,
              offset: Offset(0.0, 1.0),
            ),
          ],
          border: Border(
            right: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
            left: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
            top: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
            bottom: BorderSide(
                color: Colors.grey, width: 1, style: BorderStyle.solid),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            // color: Colors.red,
            // height: 20,
            width: wScreen * 0.8,
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
            child: Text(
              judulWidget,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              color: Colors.white,
              // height: hScreen * 0.5,
              width: wScreen * 0.8,
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
              child: WidgetIT()),
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
                children: const [
                  ButtonQuickView(Icons.add_task, 'MR'),
                  ButtonQuickView(Icons.checklist_rtl_outlined, 'Listing Fee'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container Profile(double hScreen, double wScreen) {
    return Container(
      width: wScreen,
      height: hScreen * 0.18,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0.0, 1.0),
          ),
        ],
        color: kPrimaryColor,
        // gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [kPrimaryColor, kBackgroundColor]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            width: 60,
            child: Image.asset("assets/images/profile.png"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
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
