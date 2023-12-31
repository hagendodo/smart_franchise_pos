import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/main.dart';
import 'package:smart_franchise_pos/models/order_data.dart';
import 'package:smart_franchise_pos/services/format_service.dart';
import 'components/topmenu.dart';

class DetailHistory extends StatefulWidget {
  final OrderData? itemMenu;
  const DetailHistory({Key? key, this.itemMenu}) : super(key: key);

  @override
  State<DetailHistory> createState() =>
      _DetailHistoryState(menuDetail: itemMenu);
}

class _DetailHistoryState extends State<DetailHistory> {
  double totalValue = 0;
  OrderData? itemMenu;
  List<Widget> orderMenus = [];

  _DetailHistoryState({OrderData? menuDetail}) {
    itemMenu = menuDetail;
    orderMenus = (menuDetail?.menus ?? [])
        .map((data) => _itemOrder(
              title: data.menuName,
              qty: data.quantity.toString(),
              price: data.price,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          wTopMenu(
            context: context,
            action: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainPage(
                              movePage: "History",
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange, // Button color
                ),
                child: const Row(
                  children: [
                    Text(
                      "Kembali",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xff1f2029),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, -1), // Negative y offset for top shadow
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  itemMenu?.atasNama ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
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
                      'Kode Beli',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      itemMenu?.kodeBeli ?? "",
                      style: const TextStyle(
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
                      'Tanggal',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      formatDateString(itemMenu?.tanggal.toString() ??
                          DateTime.now().toString()),
                      style: const TextStyle(
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
                      'Total (PPN 10%)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      formatCurrency(itemMenu?.totalHarga.toDouble() ?? 0),
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
          Expanded(
            child: Column(
              children: orderMenus,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemOrder({
    required String title,
    required String qty,
    required double price,
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
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Harga Menu: ${formatCurrency(price)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatCurrency(price * int.parse(qty)),
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
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              'X $qty',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
