// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new
import 'dart:convert';

class FollowUp {
  String username;
  String tglupdate;
  String keterangan;
  // String pic;

  FollowUp({
    required this.username,
    required this.tglupdate,
    required this.keterangan,
    // required this.pic,
  });

  factory FollowUp.fromJson(Map<String, dynamic> parsedJson) {
    return FollowUp(
      username: parsedJson['username'],
      tglupdate: parsedJson['tglupdate'],
      keterangan: parsedJson['keterangan'],
      // pic: parsedJson['pic'],
    );
  }

  static List<FollowUp> listFromJson(List<dynamic> list) {
    List<FollowUp> rows = list.map((i) => FollowUp.fromJson(i)).toList();
    return rows;
  }

  static List<FollowUp> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<FollowUp>((json) => FollowUp.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'tglupdate': tglupdate,
        'keterangan': keterangan,
        // 'pic': pic
      };
}
