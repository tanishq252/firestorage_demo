import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Screen2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Ho(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.greenAccent,
      ),
    );
  }
}

class Ho extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Ho> {
  Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  final CollectionReference users = FirebaseFirestore.instance.collection('Uu');
  String t = '';
  String imageUrl;
  TextEditingController imagename = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Image can be retrieved here",
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          return Scaffold(
            body: ListView(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: 270,
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
                              "If image not exists then you will get nothing 😕\n\nIf image exists then wait for a while to load 🙃\n\nBelow is the image you wanted ; )",
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
                  alignment: Alignment.center,
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
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () => dimg(),
                  iconSize: 50,
                  color: Colors.greenAccent,
                ),
                (imageUrl != null)
                    ? Image.network(imageUrl)
                    : Text(
                        "Image will be displayed if found and it may take few seconds",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  dimg() async {
    var fi = await users.doc(imagename.text).get();
    if (fi.exists) {
      setState(() {
        imageUrl = fi['url'];
        t = '✅ Downloaded Successfully';
      });
    } else {
      setState(() {
        t = '❗❗❗NO IMAGE AVAILABLE❗❗❗';
      });
      print('No image available');
    }
  }
}
