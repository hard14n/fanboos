// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print

import 'dart:convert';

class AssetModel {
  // ignore: non_constant_identifier_names
  int no_urut;
  // ignore: non_constant_identifier_names
  String jenis_asset;
  // ignore: non_constant_identifier_names
  int jumlah_asset;

  AssetModel({
    // ignore: non_constant_identifier_names
    this.no_urut = 0,
    // ignore: non_constant_identifier_names
    this.jenis_asset = '',
    // ignore: non_constant_identifier_names
    this.jumlah_asset = 0,
  });

  factory AssetModel.fromJson(Map<String, dynamic> parsedJson) {
    return AssetModel(
      no_urut: int.parse(parsedJson['no_urut']),
      jenis_asset: parsedJson['jenis_asset'],
      jumlah_asset: int.parse(parsedJson['jumlah_asset']),
    );
  }

  static List<AssetModel> listFromJson(List<dynamic> list) {
    List<AssetModel> rows = list.map((i) => AssetModel.fromJson(i)).toList();
    return rows;
  }

  static List<AssetModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<AssetModel>((json) => AssetModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        'no_urut': no_urut,
        'jenis_asset': jenis_asset,
        'jumlah_asset': jumlah_asset,
      };
}
