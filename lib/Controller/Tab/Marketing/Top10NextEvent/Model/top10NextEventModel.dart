// ignore_for_file: non_constant_identifier_names, camel_case_types, file_names

import 'dart:convert';

class top10NextEventModel {
  String no_proposal;
  String nama_kegiatan;
  String tempat;
  String kode_area;
  String tgl_mulai;
  String tgl_selesai;
  String total_biaya;

  top10NextEventModel({
    required this.no_proposal,
    required this.nama_kegiatan,
    required this.tempat,
    required this.kode_area,
    required this.tgl_mulai,
    required this.tgl_selesai,
    required this.total_biaya,
  });

  factory top10NextEventModel.fromJson(Map<String, dynamic> parsedJson) {
    return top10NextEventModel(
      no_proposal: parsedJson['no_proposal'],
      nama_kegiatan: parsedJson['nama_kegiatan'],
      tempat: parsedJson['tempat'],
      kode_area: parsedJson['kode_area'],
      tgl_mulai: parsedJson['tgl_mulai'],
      tgl_selesai: parsedJson['tgl_selesai'],
      total_biaya: parsedJson['total_biaya'],
    );
  }

  static List<top10NextEventModel> listFromJson(List<dynamic> list) {
    List<top10NextEventModel> rows =
        list.map((i) => top10NextEventModel.fromJson(i)).toList();
    return rows;
  }

  static List<top10NextEventModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<top10NextEventModel>((json) => top10NextEventModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'no_proposal': no_proposal,
        'nama_kegiatan': nama_kegiatan,
        'tempat': tempat,
        'kode_area': kode_area,
        'tgl_mulai': tgl_mulai,
        'tgl_selesai': tgl_selesai,
        'total_biaya': total_biaya,
      };
}
