class MenuItem {
  String menuId;
  String menuName;
  int quantity;
  double price;

  MenuItem({
    required this.menuId,
    required this.quantity,
    required this.menuName,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'quantity': quantity,
      'price': price,
    };
  }
}

List<MenuItem> convertMenus(List<dynamic> menusData) {
  return menusData.map((menuItemData) {
    return MenuItem(
      menuId: menuItemData['menuId'],
      menuName: menuItemData['menuName'],
      quantity: menuItemData['quantity'],
      price: menuItemData['price'],
    );
  }).toList();
}
