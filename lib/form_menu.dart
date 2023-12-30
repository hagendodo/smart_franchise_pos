import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/services/user_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_franchise_pos/components/topmenu.dart';
import 'package:smart_franchise_pos/main.dart';
import 'strings/environment.dart';

class FormMenu extends StatefulWidget {
  @override
  _FormMenuState createState() => _FormMenuState();
}

class _FormMenuState extends State<FormMenu> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  bool _uploadFromUrl = false;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() async {
    await UserDataService.getUserData().then((data) {
      userData = data;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      wTopMenu(
        context: context,
        action: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(
                    movePage: "Menus",
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange, // Button color
            ),
            child: const Row(
              children: [
                Text(
                  "Kembali",
                  selectionColor: Colors.white,
                )
              ],
            ),
          ),
        ]),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xff1f2029),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, 1), // Negative y offset for top shadow
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
                "Form Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              Text(
                "Nama Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.bold, // Adjust the font weight as needed
                ),
                textAlign: TextAlign.left,
              ),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'xxxx',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Harga",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.bold, // Adjust the font weight as needed
                ),
                textAlign: TextAlign.left,
              ),
              TextField(
                controller: _priceController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Rp. xxx',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Upload Method",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Row(
                children: [
                  Text("From URL", style: TextStyle(color: Colors.white)),
                  Switch(
                    value: _uploadFromUrl,
                    onChanged: (value) {
                      setState(() {
                        _uploadFromUrl = value;
                      });
                    },
                  ),
                  Text("From File", style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 16),
              if (!_uploadFromUrl) ...[
                Text(
                  "Image URL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                TextField(
                  controller: _imageUrlController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'https://example.com/image.jpg',
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ] else ...[
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    color: Colors.deepOrange,
                    child: Text(
                      'Choose Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
              //buildImageWidget(),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      primary: Colors.deepOrange,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ]);
  }

  Widget buildImageWidget() {
    if (_image != null) {
      // For mobile (Android and iOS), use Image.file
      return Image.file(
        _image!,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    } else {
      // For web, use Image.network
      return _image != null
          ? Image.network(
              'your_image_url', // Replace with the actual image URL or Firebase Storage URL
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            )
          : const Text(
              'No image selected.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            );
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Future<void> _getImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: false,
  //   );
  //   setState(() {
  //     if (result != null && result.files.isNotEmpty) {
  //       // For web, you get a list of files. Pick the first one.
  //       _image = File(result.files.first.path!);
  //     }
  //   });
  // }

  Future<void> _submitForm() async {
    // Validate form fields
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      // Show an error message or handle validation as needed
      return;
    }

    // Create FormData
    Map<String, dynamic> requestData = {
      'userId': userData['userId'],
      'kodeToko': userData['kodeToko'],
      'name': _nameController.text,
      'price': _priceController.text,
    };

    if (!_uploadFromUrl) {
      // Use image URL from _imageUrlController
      requestData['imageUrl'] = _imageUrlController.text;
    } else {
      // Use image from local file specified by _image
      requestData['image'] = await MultipartFile.fromFile(
        _image!.path,
        filename: 'image.jpg',
      );
    }

    try {
      Response response = await Dio().post(
        '$apiUrl/api/items',
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(
              movePage: "Menus",
            ),
          ),
        );
      }
    } catch (error) {
      // Handle the error
      print('Error: $error');
    }
  }
}
