import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:smart_franchise_pos/main.dart';
import 'package:shortid/shortid.dart';
import 'strings/environment.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Dio dio = Dio();

  TextEditingController namaTokoController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              controller: namaTokoController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nama Toko',
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
                _registerProcess();
              },
              child: Text('Register'),
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
                      movePage: "Login",
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Login Disini',
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

  _registerProcess() async {
    String namaToko = namaTokoController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (namaToko.isEmpty || username.isEmpty || password.isEmpty) {
      _showValidationFailedDialog("All fields are required.");
      return;
    }

    try {
      Response response = await dio.post(
        '$apiUrl/api/register',
        data: {
          'kodeToko': 'TK-${shortid.generate()}',
          'namaToko': namaToko,
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        // Registration successful, you can navigate to the login page or handle as needed
        print('Registration successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              movePage: "Login",
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
