// ignore_for_file: file_names

import 'dart:convert';

class ListingFeeModel {
  // ignore: non_constant_identifier_names
  String id;
  // ignore: non_constant_identifier_names
  String title;
  // ignore: non_constant_identifier_names
  int jumlah;

  ListingFeeModel({
    // ignore: non_constant_identifier_names
    required this.id,
    // ignore: non_constant_identifier_names
    required this.title,
    // ignore: non_constant_identifier_names
    required this.jumlah,
  });

  factory ListingFeeModel.fromJson(Map<String, dynamic> parsedJson) {
    return ListingFeeModel(
        id: parsedJson['id'],
        title: parsedJson['title'],
        jumlah: parsedJson['total']);
  }

  static List<ListingFeeModel> listFromJson(List<dynamic> list) {
    List<ListingFeeModel> rows =
        list.map((i) => ListingFeeModel.fromJson(i)).toList();
    return rows;
  }

  static List<ListingFeeModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ListingFeeModel>((json) => ListingFeeModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'jumlah': jumlah};
}
