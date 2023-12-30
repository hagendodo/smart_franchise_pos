import 'dart:convert';

import 'package:smart_franchise_pos/models/menu_item.dart';

class OrderData {
  final String kodeToko;
  final String kodeCabang;
  final String kodeBeli;
  final DateTime tanggal;
  final String atasNama;
  final double totalHarga;
  final List<MenuItem> menus;

  OrderData({
    required this.kodeToko,
    required this.kodeCabang,
    required this.kodeBeli,
    required this.tanggal,
    required this.atasNama,
    required this.totalHarga,
    required this.menus,
  });

  Map<String, dynamic> toMap() {
    return {
      'kodeToko': kodeToko,
      'kodeCabang': kodeCabang,
      'kodeBeli': kodeBeli,
      'tanggal': tanggal.toIso8601String(),
      'atasNama': atasNama,
      'totalHarga': totalHarga,
      'menus': menus.map((menu) => menu.toMap()).toList(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
