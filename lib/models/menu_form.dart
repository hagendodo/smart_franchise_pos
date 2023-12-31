import 'dart:convert';

class MenuForm {
  final String idMenu;
  final String name;
  final String price;
  final String imageUrl;

  MenuForm({
    required this.idMenu,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'idMenu': idMenu,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
