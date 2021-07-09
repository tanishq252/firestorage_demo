import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestorage_image_2/screen2.dart';
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
// change name of the collectionreference to ensure proper working

  final CollectionReference users = FirebaseFirestore.instance.collection('Uu');

  Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  String imageUrl;
  String t = '';
  TextEditingController imagename = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Image can be uploaded here",
                )
              ],
            ),
          ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                height: 330,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(120.0),
                      bottomRight: Radius.circular(120.0),
                      topLeft: Radius.circular(120.0),
                      topRight: Radius.circular(120.0),
                    ),
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.greenAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                      child: Column(
                        children: [
                          Text(
                            "Please Enter any name else the image will not be stored on the firestore\n\nClick on Camera icon to select the image it will directly take you to gallery and also note that after selecting the image it will directly store it on firebase so select carefully\n\nName must be entered first then image to be selected",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        hintText: "Name of image",
                        labelText: "Image Name",
                        prefixIcon: Icon(Icons.image),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                alignment: Alignment.center,
                child: Text(
                  '$t',
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.camera_enhance_outlined),
                onPressed: () => uploadImage(),
                iconSize: 50,
                color: Colors.greenAccent,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Text(
                        "Screen To Retrieve Image",
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new Screen2()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
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
        if (imagename.text.isNotEmpty) {
          var snapshot =
              await _storage.ref().child(imagename.text).putFile(file);
          var downloadurl = await snapshot.ref.getDownloadURL();
          users.doc(imagename.text).set({
            'url': downloadurl,
          });

          setState(() {
            imageUrl = downloadurl;
            t = "✅ Uploaded Successfully";
          });
        } else {
          print("No path received");
          setState(() {
            t = '❗❗❗❗ Name not Entered ❗❗❗❗';
          });
        }
      } else {
        print("Grant permissions and try again");
        setState(() {
          t = '❗❗❗❗ Name not Entered ❗❗❗❗';
        });
      }
    } else {
      print("Please Enter the name");
      setState(() {
        t = '❗❗❗❗ Name not Entered ❗❗❗❗';
      });
    }

    //upload to firebase
  }
}
