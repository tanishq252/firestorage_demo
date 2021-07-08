import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: H(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.greenAccent,
      ),
    );
  }
}

class H extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<H> {
  String imageUrl;
  TextEditingController imagename = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Uploader"),
      ),
      body: ListView(
        children: [
          (imageUrl != null)
              ? Image.network(imageUrl)
              : Placeholder(
                  fallbackHeight: 200,
                  fallbackWidth: double.infinity,
                ),
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                TextField(
                  autocorrect: true,
                  controller: imagename,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "name of image",
                    labelText: "Image Name",
                    prefixIcon: Icon(Icons.image),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(160, 0, 160, 0),
            child: SizedBox(
              height: 50,
              width: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => uploadImage(),
                child: Icon(Icons.camera_alt_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;

    final _picker = ImagePicker();
    PickedFile image;

    // Check permissions

    if (PermissionStatus.granted != null) {
      // Select Image

      image = await _picker.getImage(source: ImageSource.gallery);

      var file = File(image.path);

      if (image != null) {
        // upload to storage

        var snapshot = await _storage.ref().child(imagename.text).putFile(file);

        var downloadurl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadurl;
        });
      } else {
        print("No path received");
      }
    } else {
      print("Grant permissions and try again");
    }

    //upload to firebase
  }
}
