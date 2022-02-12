
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future newUser(String email , String pass, String username) async {
  try{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: pass);
    final fireUser = credential.user;
    final logger = (await FirebaseFirestore.instance.collection("Users").where("id",isEqualTo: fireUser!.uid).get()).docs;
    if(logger.length == 0){
      print("New User -- Initializing Cloud Collection....");
      fireUser.updateDisplayName(username);
      FirebaseFirestore.instance.collection("Users").doc(fireUser.uid).set({
        "Name":username,
        "Email":email,
        "Password":pass,
        "anonymous name":"Anonymous",
        "Created Time":DateTime.now().toString(),
        "Last SignedIn":DateTime.now().toString().toString().substring(0,16),
        "id":fireUser.uid,
      });
      sharedPreferences.setString("id",fireUser.uid);
      sharedPreferences.setString("Name",username);
      sharedPreferences.setString("Email",email);
      sharedPreferences.setString("Password",pass);
      sharedPreferences.setString("LoggedIn", "true");
    }
  }catch(error){
    print("error found: $error");
    if(error.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account."){
      print("true");
      return error.toString();
    }else{
      return null;
    }
  }
  }


Future logInUser(String email ,String password)async{
  try{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    final fireUser = credential.user;
    final logger = (await FirebaseFirestore.instance.collection("Ordinary_Users").where("id",isEqualTo: fireUser!.uid).get()).docs;
    if(logger.isNotEmpty){
      print("Old User Signing...");
      sharedPreferences.setString("id",logger[0]["id"]);
      sharedPreferences.setString("Name",logger[0]["Name"]);
      sharedPreferences.setString("Email",logger[0]["Email"]);
      sharedPreferences.setString("Password",logger[0]["Password"]);
      sharedPreferences.setString("LoggedIn", "true");
    }
  }catch(e){
    print("this is error $e");
    if(e.toString() == "[firebase_auth/wrong-password] The password is invalid or the user does not have a password." || e.toString() == "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."){
      print("true");
      return e.toString();
    }else{
      return null;
    }
  }
}