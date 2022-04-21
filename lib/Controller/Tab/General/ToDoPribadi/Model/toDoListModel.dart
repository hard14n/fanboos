// ignore_for_file: file_names

import 'dart:convert';

class TodoList {
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

  TodoList({
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

  factory TodoList.fromJson(Map<String, dynamic> parsedJson) {
    return TodoList(
      id_laporan_detail: parsedJson['id_laporan_detail'],
      deskripsi_topik: parsedJson['deskripsi_topik'],
      uraian_tindakan: parsedJson['uraian_tindakan'],
      due_date: parsedJson['due_date'],
      follow_up: parsedJson['follow_up'],
    );
  }

  static List<TodoList> listFromJson(List<dynamic> list) {
    List<TodoList> rows = list.map((i) => TodoList.fromJson(i)).toList();
    return rows;
  }

  static List<TodoList> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TodoList>((json) => TodoList.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        'id_laporan_detail': id_laporan_detail,
        'deskripsi_topik': deskripsi_topik,
        'uraian_tindakan': uraian_tindakan,
        'due_date': due_date,
        'follow_up': follow_up,
      };
}
