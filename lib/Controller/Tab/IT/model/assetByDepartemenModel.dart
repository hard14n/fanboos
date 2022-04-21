// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new, avoid_print

import 'dart:convert';

class AssetByDepartemen {
  // ignore: non_constant_identifier_names
  int no_urut;
  // ignore: non_constant_identifier_names
  String jenis_asset;
  // ignore: non_constant_identifier_names
  int jumlah_asset;

  AssetByDepartemen({
    // ignore: non_constant_identifier_names
    required this.no_urut,
    // ignore: non_constant_identifier_names
    required this.jenis_asset,
    // ignore: non_constant_identifier_names
    required this.jumlah_asset,
  });

  factory AssetByDepartemen.fromJson(Map<String, dynamic> parsedJson) {
    return AssetByDepartemen(
      no_urut: parsedJson['no_urut'],
      jenis_asset: parsedJson['jenis_asset'],
      jumlah_asset: parsedJson['jumlah_asset'],
    );
  }

  static List<AssetByDepartemen> listFromJson(List<dynamic> list) {
    List<AssetByDepartemen> rows =
        list.map((i) => AssetByDepartemen.fromJson(i)).toList();
    return rows;
  }

  static List<AssetByDepartemen> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<AssetByDepartemen>((json) => AssetByDepartemen.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'no_urut': no_urut,
        'jenis_asset': jenis_asset,
        'jumlah_asset': jumlah_asset,
      };
}
