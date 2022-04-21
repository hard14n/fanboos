// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new

import 'dart:convert';

class PICList {
  // ignore: non_constant_identifier_names
  String id_user;
  // ignore: non_constant_identifier_names
  String nama_lengkap;

  PICList({
    // ignore: non_constant_identifier_names
    required this.id_user,
    // ignore: non_constant_identifier_names
    required this.nama_lengkap,
  });

  factory PICList.fromJson(Map<String, dynamic> parsedJson) {
    return PICList(
      id_user: parsedJson['id_user'],
      nama_lengkap: parsedJson['nama_lengkap'],
    );
  }

  static List<PICList> listFromJson(List<dynamic> list) {
    List<PICList> rows = list.map((i) => PICList.fromJson(i)).toList();
    return rows;
  }

  static List<PICList> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PICList>((json) => PICList.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        'id_user': id_user,
        'nama_lengkap': nama_lengkap,
      };
}
