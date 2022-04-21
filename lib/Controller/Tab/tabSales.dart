// ignore_for_file: file_names, unused_import
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new

import 'package:fanboos/Controller/Tab/Sales/YTD_Sales_Growth/W_YTD_Sales_Growth.dart';
import 'package:fanboos/Controller/Tab/Sales/SalesTrend/w_sales_Trend.dart';
import 'package:flutter/material.dart';

class TabSales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: ListView(
        children: [
          Widget_YTD_Sales_Growth(),
          w_sales_Trend(),
        ],
      ),
    );
  }
}
