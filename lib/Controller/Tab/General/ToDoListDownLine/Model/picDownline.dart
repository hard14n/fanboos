// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new

import 'dart:convert';

class PICDownline {
  // ignore: non_constant_identifier_names
  String id_user;
  // ignore: non_constant_identifier_names
  String nama_lengkap;

  PICDownline({
    // ignore: non_constant_identifier_names
    required this.id_user,
    // ignore: non_constant_identifier_names
    required this.nama_lengkap,
  });

  factory PICDownline.fromJson(Map<String, dynamic> parsedJson) {
    return PICDownline(
      id_user: parsedJson['id_user'],
      nama_lengkap: parsedJson['nama_lengkap'],
    );
  }

  static List<PICDownline> listFromJson(List<dynamic> list) {
    List<PICDownline> rows = list.map((i) => PICDownline.fromJson(i)).toList();
    return rows;
  }

  static List<PICDownline> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<PICDownline>((json) => PICDownline.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'id_user': id_user,
        'nama_lengkap': nama_lengkap,
      };
}
