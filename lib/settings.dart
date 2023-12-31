import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/components/topmenu.dart';
import 'package:smart_franchise_pos/main.dart';
import 'package:smart_franchise_pos/services/user_data.dart';
import 'strings/environment.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late Map<String, dynamic> userData;
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _kodeTokoController = TextEditingController();
  final TextEditingController _cabangNameController = TextEditingController();
  final TextEditingController _kodeCabangController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() async {
    await UserDataService.getUserData().then((data) {
      userData = data;
      setState(() {});

      _storeNameController.text = userData['namaToko'];
      _usernameController.text = userData['username'];
      _roleController.text = userData['role'];
      _kodeTokoController.text = userData['kodeToko'];
      _cabangNameController.text = userData['namaCabang'];
      _kodeCabangController.text = userData['kodeCabang'];
    });
  }

  Future<bool> _checkKodeCabang() async {
    bool result = true;
    await UserDataService.getUserData().then((data) {
      userData = data;

      if (userData['role'] == "cabang") {
        result = false;
        return;
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Column(children: [
        wTopMenu(
          context: context,
          action: FutureBuilder<bool>(
            future: _checkKodeCabang(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While the Future is still running, you can show a loading indicator.
                return Container();
              } else if (snapshot.hasError) {
                // If there's an error in the Future, handle it accordingly.
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == true) {
                // If the Future result is true, show the Column with Text and TextField.
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage(
                                      movePage: "ManageAccounts",
                                    )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // Button color
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Manage Accounts",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ],
                );
              } else {
                // If the Future result is false, don't show anything.
                return Container();
              }
            },
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xff1f2029),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        offset:
                            Offset(0, 1), // Negative y offset for top shadow
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profil Akun",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Kode Toko",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight
                                .bold, // Adjust the font weight as needed
                          ),
                          textAlign: TextAlign.left,
                        ),
                        TextField(
                          controller: _kodeTokoController,
                          readOnly: true,
                          style: TextStyle(color: Colors.deepOrange),
                          decoration: InputDecoration(
                            hintText: 'Role',
                            hintStyle: TextStyle(color: Colors.deepOrange),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        FutureBuilder<bool>(
                          future: _checkKodeCabang(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // While the Future is still running, you can show a loading indicator.
                              return Container();
                            } else if (snapshot.hasError) {
                              // If there's an error in the Future, handle it accordingly.
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.data == false) {
                              // If the Future result is true, show the Column with Text and TextField.
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Text(
                                    "Kode Cabang",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: _kodeCabangController,
                                    style: TextStyle(color: Colors.deepOrange),
                                    decoration: InputDecoration(
                                      hintText: "Nama Cabang",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              // If the Future result is false, don't show anything.
                              return Container();
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Username",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        TextField(
                          controller: _usernameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.white54),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        FutureBuilder<bool>(
                          future: _checkKodeCabang(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // While the Future is still running, you can show a loading indicator.
                              return Container();
                            } else if (snapshot.hasError) {
                              // If there's an error in the Future, handle it accordingly.
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.data == true) {
                              // If the Future result is true, show the Column with Text and TextField.
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              // If the Future result is false, don't show anything.
                              return Container();
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Status",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight
                                .bold, // Adjust the font weight as needed
                          ),
                          textAlign: TextAlign.left,
                        ),
                        TextField(
                          controller: _roleController,
                          readOnly: true,
                          style: TextStyle(color: Colors.deepOrange),
                          decoration: InputDecoration(
                            hintText: 'Role',
                            hintStyle: TextStyle(color: Colors.deepOrange),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        FutureBuilder<bool>(
                          future: _checkKodeCabang(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // While the Future is still running, you can show a loading indicator.
                              return Container();
                            } else if (snapshot.hasError) {
                              // If there's an error in the Future, handle it accordingly.
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.data == true) {
                              // If the Future result is true, show the Column with Text and TextField.
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _submitForm();
                                        },
                                        child: Text(
                                          'Simpan',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(20),
                                          primary: Colors.deepOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              // If the Future result is false, don't show anything.
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _logoutProcess();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.deepOrange,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.logout, color: Colors.deepOrange),
                              ],
                            ))
                      ]),
                )
              ],
            )),
      ]),
    ]));
  }

  void _logoutProcess() async {
    await UserDataService.clearUserData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(
          movePage: "Login",
        ),
      ),
    );
  }

  void _submitForm() async {
    // Check if controllers are empty
    if (_storeNameController.text.isEmpty || _usernameController.text.isEmpty) {
      // Show an alert for incomplete fields
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Incomplete Fields"),
            content: Text("Please fill in all required fields."),
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
      return;
    }

    // Prepare data for Dio patch request
    Map<String, dynamic> requestData = {
      'storeName': _storeNameController.text,
      'username': _usernameController.text,
    };

    // Add password to request data if it's not empty
    if (_passwordController.text.isNotEmpty) {
      requestData['password'] = _passwordController.text;
    }

    // Your Dio patch update logic here using the entered values
    try {
      Response response = await Dio().patch(
        '$apiUrl/api/users/${userData['userId']}',
        data: requestData,
      );

      if (response.statusCode == 200) {
        _logoutProcess();
      } else {
        print('Update failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Dio error: $error');
    }
  }
}
