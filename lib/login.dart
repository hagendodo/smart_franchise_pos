import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/main.dart';
import 'package:dio/dio.dart';
import 'package:smart_franchise_pos/services/user_data.dart';
import 'strings/environment.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Dio dio = Dio();

  TextEditingController kodeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _loginProcess() async {
    String kode = kodeController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (kode.isEmpty || username.isEmpty || password.isEmpty) {
      _showValidationFailedDialog("All fields are required.");
      return;
    }

    try {
      Response response = await dio.post(
        '$apiUrl/api/login',
        data: {
          'kode': kode,
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final String id = responseData['id'];
        final Map<String, dynamic> userData = responseData['data'];

        await UserDataService.storeUserData(id, userData);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              movePage: "Order",
            ),
          ),
        );
      } else {
        _showLoginFailedDialog();
      }
    } catch (error) {
      _showLoginFailedDialog();
      print('error: $error');
    }
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

  void _showLoginFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text("Invalid username or password. Please try again."),
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
  void _showLoginFailedServerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Server Error"),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xff1f2029),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 128),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Point Of Sale",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            TextField(
              controller: kodeController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Kode Cabang / Toko (untuk admin)',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _loginProcess();
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                primary: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 28),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      movePage: "Register",
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Register Disini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
