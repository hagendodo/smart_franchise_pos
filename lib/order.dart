import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:smart_franchise_pos/main.dart';
import 'package:smart_franchise_pos/models/menu_item.dart';
import 'package:smart_franchise_pos/models/order_data.dart';
import 'package:smart_franchise_pos/services/format_service.dart';
import 'package:smart_franchise_pos/services/user_data.dart';
import 'package:shortid/shortid.dart';
import 'components/topmenu.dart';
import 'package:input_quantity/input_quantity.dart';
import 'strings/environment.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double totalValue = 0;
  List<MenuItem> menuItems = [];
  List<Widget> menus = [];
  Dio dio = Dio();
  final _nameController = TextEditingController();

  void calculateTotal() {
    double total = 0.0;

    for (var menuItem in menuItems) {
      total += menuItem.quantity * menuItem.price;
    }

    setState(() {
      totalValue = total;
    });
  }

  Future<void> _submitForm(BuildContext context) async {
    // Validate form fields
    if (_nameController.text.isEmpty) {
      // Show an error message or handle validation as needed
      return;
    }

    // Create Dio instance
    final dio = Dio();
    Map<String, dynamic> userData = await UserDataService.getUserData();

    menuItems.removeWhere((data) => data.quantity == 0);

    OrderData orderData = OrderData(
      kodeToko: userData['kodeToko'],
      kodeCabang: userData['kodeCabang'],
      kodeBeli: shortid.generate(),
      tanggal: DateTime.now(),
      atasNama: _nameController.text,
      totalHarga: totalValue,
      menus: menuItems,
    );

    try {
      // Make POST request
      final response = await dio.post(
        '$apiUrl/api/orders',
        data: orderData.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Check the response status
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              movePage: "History",
            ),
          ),
        );
      } else {
        // Handle other response statuses if needed
        print('Unexpected response status: ${response.statusCode}');
      }
    } catch (error) {
      // Handle the error
      print('Error: $error');
    }
  }

  // Function to fetch data from the API
  Future<void> fetchData() async {
    try {
      Map<String, dynamic> userData = await UserDataService.getUserData();
      String queryString = "kodeToko=${userData['kodeToko']}";
      // Make a GET request using Dio
      Response response = await dio.get('$apiUrl/api/items?$queryString');

      // Assuming the response data is a list of menu items
      List<dynamic> responseData = response.data;

      // Create _item widgets based on the fetched data
      menus = responseData.map((itemData) {
        return _itemOrder(
          id: itemData['id'],
          image: itemData['imageUrl'],
          title: itemData['name'],
          qty: 0.toString(),
          price: double.parse(itemData['price']),
        );
      }).toList();

      menuItems = responseData.map((itemData) {
        return MenuItem(
          menuId: itemData['id'],
          menuName: itemData['name'],
          quantity: 0,
          price: double.parse(itemData['price']),
        );
      }).toList();

      calculateTotal();
    } catch (error) {
      // Handle the error
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const SizedBox(height: 20),
          menuItems.isEmpty
              ? FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: const CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Expanded(
                        child: ListView(
                          children: menus,
                        ),
                      );
                    }
                  },
                )
              : Expanded(
                  child: ListView(
                    children: menus,
                  ),
                ),
          menuItems.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xff1f2029),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        offset:
                            Offset(0, -1), // Negative y offset for top shadow
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(137, 92, 92, 92),
                        ),
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 6, left: 12),
                            hintText: 'Atas Nama',
                            hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 14),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        height: 2,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Rp ${totalValue.toStringAsFixed(2)}', // Format the total value as needed
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _submitForm(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 6),
                            Text(
                              'Pesan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _itemOrder({
    required String id,
    required String image,
    required String title,
    required String qty,
    required double price,
  }) {
    int initValue = 0;
    if (menuItems.isNotEmpty) {
      MenuItem existingItem = menuItems.firstWhere((item) => item.menuId == id);
      initValue = existingItem.quantity;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Color.fromARGB(255, 54, 54, 59),
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  formatCurrency(price),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color to white
              borderRadius: BorderRadius.circular(
                  8), // Adjust the border radius as needed
            ),
            child: InputQty(
              maxVal: 10,
              initVal: initValue,
              minVal: 0,
              steps: 1,
              onQtyChanged: (val) {
                setState(() {
                  for (int i = 0; i < menuItems.length; i++) {
                    if (menuItems[i].menuId == id) {
                      menuItems[i].quantity = val.toInt();
                      return;
                    }
                  }
                });
                calculateTotal();
              },
            ),
          )
        ],
      ),
    );
  }
}
