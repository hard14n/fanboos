import 'dart:convert';

class Category {
  String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category(
      name: parsedJson['name'],
    );
  }

  static List<Category> listFromJson(List<dynamic> list) {
    List<Category> rows = list.map((i) => Category.fromJson(i)).toList();
    return rows;
  }

  static List<Category> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
