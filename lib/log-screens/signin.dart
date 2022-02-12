import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_creation/auth/firebase_auth.dart';
import 'package:my_creation/custom/custom_widget.dart';
import 'package:my_creation/main_Screens/master_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_pass.dart';

class signIn extends StatefulWidget {
  const signIn({Key? key}) : super(key: key);
  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {

  TextEditingController emailController =  TextEditingController();
  TextEditingController usernameController =  TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool seePassword = true;
  IconData passwordVisibility = Icons.visibility_off;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool loader = false;
  late String errorMsg="";
  bool switcher = true;

  SignMeUp(){
    if(formKey.currentState!.validate()){
      setState(() {
        loader = true;
      });
      newUser(emailController.text,passwordController.text,usernameController.text).then((value) async {
        if(value != null){
          setState(() {

            loader = false;
            for (int i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                errorMsg = value.toString().substring(i + 2);
                print("the error message $i  $errorMsg");
              }
              if(errorMsg == "The password is invalid or the user does not have a password."){
                errorMsg = "The password entered is invalid";
              }else if(errorMsg == "There is no user record corresponding to this identifier. The user may have been deleted."){
                errorMsg = "User id is invalid";
              }
            }
          });
        }else{
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("LoggedIn", "true");
          Navigator.push(context, MaterialPageRoute(builder: (context) => masterScreen()));
        }
      });
    }
  }


  logMeIn(){
    errorMsg = "";
    if(formKey.currentState!.validate()){
      setState(() {
        loader = true;

      });
      logInUser(emailController.text,passwordController.text).then((value) async {
        if(value != null){
          setState(() {
            for (int i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                errorMsg = value.toString().substring(i + 2);
                print("the error message $i  $errorMsg");
              }
              if(errorMsg == "The password is invalid or the user does not have a password."){
                errorMsg = "The password entered is invalid";
              }else if(errorMsg == "There is no user record corresponding to this identifier. The user may have been deleted."){
                errorMsg = "User id is invalid";
              }
            }
          });
          setState(() {
            loader = false;
          });
        }else{
          FirebaseFirestore.instance
              .collection("Ordinary_Users")
              .doc(firebaseAuth.currentUser!.uid)
              .update({
            "Password": passwordController.text,
            "Last SignedIn":DateTime.now(),
          });
          setState(() {
            loader = false;
          });
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("LoggedIn", "true");
          Navigator.push(context, MaterialPageRoute(builder: (context) => masterScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            loader?Positioned(child: Center(
              child: Container(
                height: 100,
                width: 100,
                child:CircularProgressIndicator(color: Colors.redAccent,
                  strokeWidth: 4,),
                ),
            ),
            ):SizedBox(),
            Opacity(
              alwaysIncludeSemantics: true,
              opacity: loader?0.5:1,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                  Color.fromARGB(255,255,138,120),
                    Color.fromARGB(255,255,66,112),
                  ],stops: [0.4,1],
                  begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //for the app icon
                      Container(
                        height: 150,
                        width: 150,
                        child: Material(
                          elevation: 10,
                          color: Color.fromARGB(255, 255,146,134),
                          borderRadius: BorderRadius.circular(20),
                          borderOnForeground: true,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color:Colors.white,width: 2),
                                ),
                                child: Image(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_jN-TL9KXIF2wLju3NqLM7IE05LNNVoWTBA&usqp=CAU"),fit: BoxFit.fill,)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      //App name or sign Up Login
                      Text(switcher?"Signup":"Login",style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.bold),),
                      //a small message on wat that page does
                      SizedBox(
                          height:loader?0:25,
                          child: Text(loader?"":"$errorMsg",style:TextStyle(fontSize:18, color: Colors.black,fontWeight: FontWeight.bold))),

                      //for textfields
                      Form(
                        key: formKey,
                        child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration:BoxDecoration(
                              color: Color.fromARGB(255, 255,109,123),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color:Colors.white,width: 2),
                            ),
                            child: TextFormField(
                              cursorColor: Colors.limeAccent,
                              cursorWidth: 2,
                              controller: emailController,
                              validator: (value) {
                                if (value!.contains(" ")) {
                                  return "Enter an email without space";
                                } else if(RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return null;
                                }else{
                                  return "Enter valid Email";
                                }
                              },
                              style: textFieldStyle(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: textInputDecoration("Email",Icons.alternate_email),
                            ),
                          ),
                          SizedBox(height: 20,),

                         switcher? Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration:BoxDecoration(
                              color: Color.fromARGB(255, 255,109,123),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color:Colors.white,width: 2),
                            ),
                            child: TextFormField(
                              cursorColor: Colors.limeAccent,
                              cursorWidth: 2,
                              controller: usernameController,
                              validator: (value) {
                                return value.toString().length <= 4
                                    ? "Minimum character required is 5"
                                    : value.toString().length >22 ?"Username length limit reached":null;
                              },
                              style: textFieldStyle(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: textInputDecoration("User name",Icons.person_rounded),
                            ),
                          ):SizedBox(),
                          switcher?SizedBox(height: 20,):SizedBox(),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration:BoxDecoration(
                              color: Color.fromARGB(255, 255,109,123),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color:Colors.white,width: 2),
                            ),

                            child: TextFormField(
                              obscureText: seePassword,
                              cursorColor: Colors.white,
                              cursorWidth: 2,
                              controller: passwordController,
                              validator: (value) {
                                String val = value.toString().toLowerCase();
                                int charCounter = 0;
                                if (value!.isEmpty || value.length < 8) {
                                  return "character required is 8";
                                } else {
                                  for (int i = 0; i < value.length; i++) {
                                    if (val.codeUnitAt(i) >= 97 &&
                                        val.codeUnitAt(i) <= 122) {}
                                    else {
                                      charCounter++;
                                    }
                                  }
                                  return charCounter != 0
                                      ? null
                                      : "Enter characters other than alphabets, ex: 1,/,-...";
                                }
                              },
                              style: textFieldStyle(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: textFieldStyle(),
                                focusedBorder:const UnderlineInputBorder(
                                    borderSide:BorderSide(color: Colors.white,
                                      width: 3.5,
                                    )),
                                enabledBorder:const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisibility,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (seePassword == true) {
                                        passwordVisibility = Icons.visibility;
                                        seePassword = !true;
                                      } else {
                                        passwordVisibility = Icons.visibility_off;
                                        seePassword = true;
                                      }
                                    });
                                  },
                                ),
                                errorStyle:const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                prefixIcon:const Icon(
                                  FontAwesomeIcons.key,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),),
                      switcher==false?Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => forgot_password()));
                              },
                              child:const Text("forgot password?",style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),)
                          ),
                        ],
                      ):SizedBox(height:20),
                      //button to signIn
                      MaterialButton(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(child: Text(switcher?"Sign Up":"Login",style: TextStyle(color: Colors.pinkAccent,fontSize: 20),)),
                        ),
                          onPressed: (){
                          switcher?SignMeUp():logMeIn();
                          }),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text(switcher?"Already have an account?":"Don't have an account?",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
                          TextButton(
                            onPressed: (){
                              setState(() {
                                switcher = !switcher;
                              });
                            }, child: Text(switcher?"Login now":"Signup now",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w900,),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
