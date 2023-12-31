import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_franchise_pos/models/menu_form.dart';
import 'package:smart_franchise_pos/services/user_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_franchise_pos/components/topmenu.dart';
import 'package:smart_franchise_pos/main.dart';
import 'strings/environment.dart';

class FormMenu extends StatefulWidget {
  final MenuForm? menuForm;

  const FormMenu({Key? key, this.menuForm}) : super(key: key);

  @override
  _FormMenuState createState() => _FormMenuState(menuFormItem: menuForm);
}

class _FormMenuState extends State<FormMenu> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  MenuForm? menuForm;
  bool isLoading = false;

  _FormMenuState({MenuForm? menuFormItem}) {
    menuForm = menuFormItem;
  }

  bool _uploadFromUrl = false;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _editMode = false;

  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() async {
    await UserDataService.getUserData().then((data) {
      userData = data;
      setState(() {
        if (menuForm != null) {
          _nameController.text = menuForm?.name ?? "";
          _priceController.text = menuForm?.price ?? "";
          _imageUrlController.text = menuForm?.imageUrl ?? "";
          _editMode = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(children: [
              wTopMenu(
                context: context,
                action:
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
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
                          fontWeight: FontWeight
                              .bold, // Adjust the font weight as needed
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
                          fontWeight: FontWeight
                              .bold, // Adjust the font weight as needed
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
                          Text("From URL",
                              style: TextStyle(color: Colors.white)),
                          Switch(
                            value: _uploadFromUrl,
                            onChanged: (value) {
                              setState(() {
                                _uploadFromUrl = value;
                              });
                            },
                          ),
                          Text("From File",
                              style: TextStyle(color: Colors.white)),
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
                              'Chooses Image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      buildImageWidget(),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _editMode
                                  ? _editSubmitForm(menuForm?.idMenu)
                                  : _submitForm();
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
            ]),
          );
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
              _imageUrlController.text,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            )
          : (_imageUrlController.text != ""
              ? Image.network(
                  _imageUrlController.text,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
              : const Text(
                  'No image selected.',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ));
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
    setState(() {
      isLoading = true;
    });
    // Validate form fields
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      // Show an error message or handle validation as needed
      return;
    }

    try {
      String imageUrl;
      if (!_uploadFromUrl) {
        // Use image URL from _imageUrlController
        imageUrl = _imageUrlController.text;
      } else {
        imageUrl = await _uploadImageToCloudinary();
      }
      // Upload image to Cloudinary

      // Make your API call
      Response apiResponse = await Dio().post(
        '$apiUrl/api/items',
        data: {
          'userId': userData['userId'],
          'kodeToko': userData['kodeToko'],
          'name': _nameController.text,
          'price': _priceController.text,
          'imageUrl': imageUrl,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (apiResponse.statusCode == 201) {
        Navigator.pushReplacement(
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

  Future<void> _editSubmitForm(id) async {
    setState(() {
      isLoading = true;
    });
    // Validate form fields
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      // Show an error message or handle validation as needed
      return;
    }

    try {
      String imageUrl;

      if (!_uploadFromUrl) {
        // Use image URL from _imageUrlController
        imageUrl = _imageUrlController.text;
      } else {
        imageUrl = await _uploadImageToCloudinary();
      }

      // Upload image to Cloudinary

      // Make your API call
      Response apiResponse = await Dio().patch(
        '$apiUrl/api/items/$id',
        data: {
          'name': _nameController.text,
          'price': _priceController.text,
          'imageUrl': imageUrl,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (apiResponse.statusCode == 200) {
        Navigator.pushReplacement(
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

  Future<String> _uploadImageToCloudinary() async {
    try {
      // Create Dio instance
      Dio dio = Dio();

      // Create FormData for image upload
      FormData formData = FormData.fromMap({
        'upload_preset': 'xhyhvxib', // Replace with your upload preset
        'file': await MultipartFile.fromFile(
          _image!.path,
          filename: 'file.jpg',
        ),
      });

      // Upload to Cloudinary
      Response response = await dio.post(
        'https://api.cloudinary.com/v1_1/dd9eegvnd/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        // Extract Cloudinary response data
        final responseData = response.data;
        return responseData['url']; // Return the Cloudinary URL
      } else {
        throw Exception('Failed to upload image to Cloudinary');
      }
    } catch (error) {
      // Handle the error
      print('Error uploading image to Cloudinary: $error');
      throw error;
    }
  }
}
