import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/main.dart';
import 'package:smart_franchise_pos/models/menu_item.dart';
import 'package:smart_franchise_pos/models/order_data.dart';
import 'package:smart_franchise_pos/services/format_service.dart';
import 'package:smart_franchise_pos/services/user_data.dart';
import 'components/topmenu.dart';
import 'strings/environment.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  double totalValue = 0;
  Dio dio = Dio();
  List<Widget> menus = [];

  // Function to fetch data from the API
  Future<void> fetchData() async {
    try {
      Map<String, dynamic> userData = await UserDataService.getUserData();
      print(userData);
      String queryString =
          "kodeToko=${userData['kodeToko']}&kodeCabang=${userData['kodeCabang'] ?? ''}";
      // Make a GET request using Dio
      Response response = await dio.get('$apiUrl/api/orders?$queryString');

      // Assuming the response data is a list of menu items
      List<dynamic> responseData = response.data;

      // Create _item widgets based on the fetched data
      menus = responseData.map((itemData) {
        OrderData orderData = OrderData(
          kodeToko: userData['kodeToko'],
          kodeCabang: userData['kodeCabang'] ?? '',
          tanggal: DateTime.parse(itemData['tanggal']),
          kodeBeli: itemData['kodeBeli'],
          atasNama: itemData['atasNama'],
          totalHarga: double.parse(itemData['totalHarga'].toString()),
          menus: convertMenus(itemData['menus']),
        );

        return _itemOrder(
          tanggal: orderData.tanggal.toString(),
          kodeBeli: orderData.kodeBeli,
          title: orderData.atasNama,
          price: orderData.totalHarga,
          order: orderData,
        );
      }).toList();
    } catch (error) {
      // Handle the error
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Column(
        children: [
          wTopMenu(action: Container(), context: context),
          const SizedBox(height: 20),
          FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: CircularProgressIndicator(),
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
          ),
        ],
      ),
    );
  }

  Widget _itemOrder({
    required String tanggal,
    required String kodeBeli,
    required String title,
    required double price,
    required OrderData order,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Color.fromARGB(255, 54, 54, 59),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kode Beli : $kodeBeli",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Tanggal: ${formatDateString(tanggal)}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$title',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatCurrency(price),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage(
                            movePage: "DetailHistory",
                            menuDetail: order,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
              ),
              child: Row(
                children: [
                  Icon(Icons.menu, color: Colors.white),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
