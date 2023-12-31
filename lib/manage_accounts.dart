import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/components/topmenu.dart';
import 'package:smart_franchise_pos/main.dart';
import 'package:smart_franchise_pos/services/user_data.dart';
import 'package:shortid/shortid.dart';
import 'strings/environment.dart';

class ManageAccounts extends StatefulWidget {
  @override
  _ManageAccountsState createState() => _ManageAccountsState();
}

class _ManageAccountsState extends State<ManageAccounts> {
  final Dio dio = Dio();
  List<Widget> accounts = [];

  TextEditingController namaCabangController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                            movePage: "Settings",
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
              const Text(
                'Form Tambah Akun Cabang',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 2,
                width: double.infinity,
                color: Colors.white,
              ),
              TextField(
                controller: namaCabangController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nama Cabang',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: usernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _registerProcess();
                },
                child: Text('Buat Cabang'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  primary: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'List Cabang',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading ...',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(children: accounts);
            }
          },
        )
      ],
    ));
  }

  Widget _itemCabang({
    required String id,
    required String namaCabang,
    required String kodeCabang,
    required String username,
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
                  namaCabang,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  kodeCabang,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  username,
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
            margin: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content: Text('Are you sure you want to delete?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteData(id);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
              ),
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.white), // Delete icon
                  // Some spacing between the icon and text
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> deleteData(String itemId) async {
    try {
      // Make a DELETE request using Dio
      Response response = await dio.delete('$apiUrl/api/cabang/$itemId');

      if (response.statusCode != 200) {
        print('Error deleting item. Status code: ${response.statusCode}');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MainPage(
                  movePage: "ManageAccounts",
                )),
      );
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  Future<void> fetchData() async {
    try {
      Map<String, dynamic> userData = await UserDataService.getUserData();

      Response response =
          await dio.get('$apiUrl/api/cabang/${userData['kodeToko']}');

      // Assuming the response data is a list of menu items
      List<dynamic> responseData = response.data;

      // Create _item widgets based on the fetched data
      accounts = responseData.map((itemData) {
        return _itemCabang(
            id: itemData['id'],
            namaCabang: itemData['namaCabang'],
            kodeCabang: itemData['kodeCabang'],
            username: itemData['username']);
      }).toList();
    } catch (error) {
      // Handle the error
      print('Error fetching data: $error');
    }
  }

  _registerProcess() async {
    String namaCabang = namaCabangController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (namaCabang.isEmpty || username.isEmpty || password.isEmpty) {
      _showValidationFailedDialog("All fields are required.");
      return;
    }

    try {
      Map<String, dynamic> userData = await UserDataService.getUserData();

      Response response = await dio.post(
        '$apiUrl/api/register',
        data: {
          'kodeToko': userData['kodeToko'],
          'kodeCabang': 'CB-${shortid.generate()}',
          'namaCabang': namaCabang,
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        // Registration successful, you can navigate to the login page or handle as needed
        _showSucessCreateDialog("Register Cabang");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              movePage: "ManageAccounts",
            ),
          ),
        );
      } else {
        _showRegistrationFailedDialog();
      }
    } catch (error) {
      _showServerErrorDialog();
      print('Dio error: $error');
    }
  }

  void _showSucessCreateDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showValidationFailedDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Validation Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showRegistrationFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Registration Failed"),
          content: Text("Failed to register. Please try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to show an alert when login fails
  void _showServerErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text("Server Error! Please try again later."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
