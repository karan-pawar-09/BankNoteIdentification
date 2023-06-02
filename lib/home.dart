import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<String> _labels = [
    "10 rupee note",
    "100 rupee note",
    "20 rupee note",
    "200 rupee note",
    "2000 rupee note",
    "50 rupee note",
    "500 rupee note"
  ];
  bool loading = true;
  File? _image;
  int? _output;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> detectImage(File image) async {
    // print("Start Detect Image");
    try {
      final url = Uri.parse('http://3.26.215.6/predict');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      final response = await request.send();
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseJson = json.decode(responseBody);
        final className = responseJson['class_name'];

        // print(className);
        //
        setState(() {
          _output = int.tryParse(className.toString());
          loading = false;
        });
      } else {
        return;
      }
    } catch(e) {
      print('Error: $e');
    }
  }

  void pickImage(ImageSource source) async {

    final image = await _imagePicker.pickImage(source: source);
    // File img_ = File(image!.path);
    // int? sz;
    // sz = img_.statSync().size;
    //print("Original size: $sz");
    if (image == null) {
      return null;
    } else {
      ImageProperties properties = await FlutterNativeImage.getImageProperties(image.path);
      File compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 80,
          targetWidth: 600,
          targetHeight: (properties.height! * 600 / properties.width!.toInt()).round());
      setState(() {
        _image = File(compressedFile.path);
      });
    }
    // sz = _image?.statSync().size;
    //print("Reduced size: $sz");
    detectImage(_image!);
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ML Classifier',
          style: GoogleFonts.roboto(),
        ),
      ),
      body: SizedBox(
        height: h,
        width: w,
        child: Column(
          children: [
            Container(
              height: 150,
              width: 150,
              padding: const EdgeInsets.all(10),
              child: Image.asset('assets/curr.png'),
            ),
            Text(
              'Indian Banknote Identification',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Capture',
                          style: GoogleFonts.roboto(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Gallery',
                          style: GoogleFonts.roboto(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!loading)
              Column(
                children: [
                  Container(
                    height: 220,
                    padding: const EdgeInsets.all(15),
                    child: Image.file(_image!),
                  ),
                  if (_output != null)
                    Text(
                      _labels[_output!],
                      style: GoogleFonts.roboto(fontSize: 18),
                    )
                  else
                    const Text(''),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
