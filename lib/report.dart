import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/components/topmenu.dart';
import 'package:smart_franchise_pos/services/format_service.dart';
import 'package:smart_franchise_pos/services/user_data.dart';
import 'package:smart_franchise_pos/strings/environment.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  double totalValue = 0;
  List<Widget> reportItems = [];
  Dio dio = Dio();

  Future<void> fetchData() async {
    try {
      Map<String, dynamic> userData = await UserDataService.getUserData();

      Response response =
          await dio.get('$apiUrl/api/orders?kodeToko=${userData['kodeToko']}');

      // Assuming the response data is a list of menu items
      List<dynamic> responseData = response.data;

      Map<String, int> resultMap = {};

      for (var entry in responseData) {
        String kode = entry['kodeCabang'];
        int total = entry['totalHarga'] ?? 0;
        resultMap[kode] = (resultMap[kode] ?? 0) + total;
      }

      List<Map<String, dynamic>> outputArray = resultMap.entries
          .map((entry) => {"kodeCabang": entry.key, "totalHarga": entry.value})
          .toList();

      // Create _item widgets based on the fetched data
      reportItems = outputArray.map((itemData) {
        return _itemOrder(
            cabang: itemData['namaCabang'] ?? "",
            tanggal: itemData['kodeCabang'],
            total: itemData['totalHarga'].toDouble());
      }).toList();
    } catch (error) {
      // Handle the error
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                wTopMenu(action: Container(), context: context),
                const SizedBox(height: 20),
                Container(
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
                      const Text(
                        'Statistik Semua Cabang',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        height: 2,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Penjualan Terbaik',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '11-23',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rata-Rata Pendapatan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Rp. 13.000.000',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pendapatan',
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  child: Column(
                    children: reportItems,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _itemOrder({
    required String tanggal,
    required String cabang,
    required double total,
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
                  tanggal,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Cabang $cabang",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatCurrency(total),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                )
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(right: 10),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => MainPage(
          //                   movePage: "DetailHistory",
          //                 )),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.deepOrange,
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(Icons.file_download, color: Colors.white), // Delete icon
          //         // Some spacing between the icon and text
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
