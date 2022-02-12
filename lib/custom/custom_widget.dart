import 'package:flutter/material.dart';

InputDecoration textInputDecoration(String labelTxt, IconData iconData){
  return InputDecoration(
    labelText: "$labelTxt",
    labelStyle: textFieldStyle(),
    focusedBorder: UnderlineInputBorder(
        borderSide:BorderSide(color: Colors.white,
          width: 3.5,
        )),
    errorStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    prefixIcon: Icon(iconData,color: Colors.white,),
  );
}
TextStyle textFieldStyle() => TextStyle(color: Colors.white,fontSize: 15,);
