import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/services/user_data.dart';

Widget wTopMenu({
  required Widget action,
  required BuildContext context,
}) {
  return FutureBuilder<Map<String, dynamic>>(
    future: UserDataService.getUserData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // You can return a loading indicator here if needed
        return CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        // Handle the error
        return Text('Error: ${snapshot.error}');
      }

      Map<String, dynamic> userData = snapshot.data!;

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData['namaToko'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                userData['namaCabang'] != ""
                    ? 'Cabang ${userData['namaCabang']}'
                    : "Owner",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Expanded(flex: 1, child: Container(width: double.infinity)),
          Expanded(flex: 5, child: action),
        ],
      );
    },
  );
}
