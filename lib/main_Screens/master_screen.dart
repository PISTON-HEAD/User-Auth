import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class masterScreen extends StatefulWidget {
  const masterScreen({Key? key}) : super(key: key);

  @override
  _masterScreenState createState() => _masterScreenState();
}

class _masterScreenState extends State<masterScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
            image: DecorationImage(image: NetworkImage("https://cdn.pixabay.com/photo/2018/10/16/07/07/stars-3750824_1280.png"),fit: BoxFit.fill,
            )
          ),
          child: Center(child: Text("Android Development Internship Project",style: TextStyle(fontSize: 20,color: Colors.white),)),
        ),
      ),
    ));
  }
}
