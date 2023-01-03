import "dart:io";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';



import 'package:flutter_chat/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;
  bool _isLoading =false;

  void _submitAuthForm(String email, String userName, String password, bool isLogin,BuildContext aaa,File image) async{
    UserCredential authresult;

    try{
      setState(() {
        _isLoading = true;
      });
      if(isLogin){
        authresult = await _auth.signInWithEmailAndPassword(email: email, password: password);
        // print("image : $image");
      }else{
        authresult = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        // final ref = FirebaseStorage.instance.refFromURL("gs://flutterchat-52c33.appspot.com/project_training6").child("user_image").child("${authresult.user!.uid}.jpg");
        // UploadTask upload = ref.putFile(image);


        // upload.then((res) {
        //    res.ref.getDownloadURL();
        // });
        final ref = FirebaseStorage.instance.refFromURL("gs://flutterchat-52c33.appspot.com/project_training6").child("user_image").child("${authresult.user!.uid}.jpg");

        UploadTask upload = ref.putFile(image);
        // print("upload : $upload");



        // final String url = await upload.then((res) async{
        //   return res.ref.getDownloadURL();
        // });
        String? url;

        await upload.whenComplete(() async{
           url = await ref.getDownloadURL();
        });

        // print("url : $url");


        // String url =geturl as String;

        await FirebaseFirestore.instance.collection("users").doc(authresult.user!.uid).set({
          "username" : userName,
          "email" : email,
          "image_url" :url,
        });
      }

    } on PlatformException catch(err){
      String msg = "An Error occured. Please check your credential.";
      if(err.message != null){
        msg = err.message!;
      }
      ScaffoldMessenger.of(aaa).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }catch (error){
      // print("Hello : $error");
      ScaffoldMessenger.of(aaa).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
