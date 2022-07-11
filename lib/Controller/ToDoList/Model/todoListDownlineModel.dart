// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new

import 'dart:convert';

class TodoListDownline {
  // ignore: non_constant_identifier_names
  String nama_lengkap;
  // ignore: non_constant_identifier_names
  String pic;
  // ignore: non_constant_identifier_names
  String id_laporan_detail;
  // ignore: non_constant_identifier_names
  String deskripsi_topik;
  // ignore: non_constant_identifier_names
  String uraian_tindakan;
  // ignore: non_constant_identifier_names
  String due_date;
  // ignore: non_constant_identifier_names
  String follow_up;

  TodoListDownline({
    // ignore: non_constant_identifier_names
    required this.nama_lengkap,
    // ignore: non_constant_identifier_names
    required this.pic,
    // ignore: non_constant_identifier_names
    required this.id_laporan_detail,
    // ignore: non_constant_identifier_names
    required this.deskripsi_topik,
    // ignore: non_constant_identifier_names
    required this.uraian_tindakan,
    // ignore: non_constant_identifier_names
    required this.due_date,
    // ignore: non_constant_identifier_names
    required this.follow_up,
  });

  factory TodoListDownline.fromJson(Map<String, dynamic> parsedJson) {
    return TodoListDownline(
      nama_lengkap: parsedJson['nama_lengkap'],
      pic: parsedJson['pic'],
      id_laporan_detail: parsedJson['id_laporan_detail'],
      deskripsi_topik: parsedJson['deskripsi_topik'],
      uraian_tindakan: parsedJson['uraian_tindakan'],
      due_date: parsedJson['due_date'],
      follow_up: parsedJson['follow_up'],
    );
  }

  static List<TodoListDownline> listFromJson(List<dynamic> list) {
    List<TodoListDownline> rows =
        list.map((i) => TodoListDownline.fromJson(i)).toList();
    return rows;
  }

  static List<TodoListDownline> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<TodoListDownline>((json) => TodoListDownline.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'nama_lengkap': nama_lengkap,
        'pic': pic,
        'id_laporan_detail': id_laporan_detail,
        'deskripsi_topik': deskripsi_topik,
        'uraian_tindakan': uraian_tindakan,
        'due_date': due_date,
        'follow_up': follow_up,
      };
}
