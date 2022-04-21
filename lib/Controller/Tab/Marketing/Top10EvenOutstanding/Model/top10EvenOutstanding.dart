// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

class Top10EvenOutstandingModel {
  String no_proposal;
  String nama_kegiatan;
  String tempat;
  String kode_area;
  String tgl_proposal;
  String total_biaya;
  String od;

  Top10EvenOutstandingModel({
    required this.no_proposal,
    required this.nama_kegiatan,
    required this.tempat,
    required this.kode_area,
    required this.tgl_proposal,
    required this.total_biaya,
    required this.od,
  });

  factory Top10EvenOutstandingModel.fromJson(Map<String, dynamic> parsedJson) {
    return Top10EvenOutstandingModel(
      no_proposal: parsedJson['no_proposal'],
      nama_kegiatan: parsedJson['nama_kegiatan'],
      tempat: parsedJson['tempat'],
      kode_area: parsedJson['kode_area'],
      tgl_proposal: parsedJson['tgl_proposal'],
      total_biaya: parsedJson['total_biaya'],
      od: parsedJson['od'],
    );
  }

  static List<Top10EvenOutstandingModel> listFromJson(List<dynamic> list) {
    List<Top10EvenOutstandingModel> rows =
        list.map((i) => Top10EvenOutstandingModel.fromJson(i)).toList();
    return rows;
  }

  static List<Top10EvenOutstandingModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<Top10EvenOutstandingModel>(
            (json) => Top10EvenOutstandingModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'no_proposal': no_proposal,
        'nama_kegiatan': nama_kegiatan,
        'tempat': tempat,
        'kode_area': kode_area,
        'tgl_proposal': tgl_proposal,
        'total_biaya': total_biaya,
        'od': od,
      };
}
