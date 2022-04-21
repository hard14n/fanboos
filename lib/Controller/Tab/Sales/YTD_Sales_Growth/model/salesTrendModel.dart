// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print

import 'dart:convert';

class SalesTrendModel {
  // ignore: non_constant_identifier_names
  int no_urut;
  // ignore: non_constant_identifier_names
  String tahun;
  // ignore: non_constant_identifier_names
  double total_sales;

  SalesTrendModel({
    // ignore: non_constant_identifier_names
    required this.no_urut,
    // ignore: non_constant_identifier_names
    required this.tahun,
    // ignore: non_constant_identifier_names
    required this.total_sales,
  });

  factory SalesTrendModel.fromJson(Map<String, dynamic> parsedJson) {
    return SalesTrendModel(
      no_urut: parsedJson['no_urut'],
      tahun: parsedJson['tahun'],
      total_sales: parsedJson['total_sales'],
    );
  }

  static List<SalesTrendModel> listFromJson(List<dynamic> list) {
    List<SalesTrendModel> rows =
        list.map((i) => SalesTrendModel.fromJson(i)).toList();
    return rows;
  }

  static List<SalesTrendModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<SalesTrendModel>((json) => SalesTrendModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'no_urut': no_urut,
        'tahun': tahun,
        'total_sales': total_sales,
      };
}
