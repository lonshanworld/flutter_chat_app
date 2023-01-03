import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_chat/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {

  const AuthForm(this._submitFn,this.isLoading);

  final void Function(String email,String userName, String password, bool _isLogin, BuildContext AFctx, File image) _submitFn;
  final bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";
  File? _userImageFile;

  void _pickedImage(File image){
    _userImageFile = image;
  }

  void _trySubmit(){
    final isvalid = _formKey.currentState!.validate();
    // print("is valid : $isvalid");
    // print("userImageFile : $_userImageFile");
    FocusScope.of(context).unfocus();

    if(_userImageFile == null && !_isLogin){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please pick an Image."), backgroundColor: Colors.lime,));
      return;
    }

    File _checkImage(File? file){
      if(file == null){
        file = File("");
        return file;
      }else{
        return file;
      }
    }

    if(isvalid){
       _formKey.currentState?.save();
       widget._submitFn(_userEmail.trim(),_userName.trim(),_userPassword.trim(),_isLogin,context,_checkImage(_userImageFile));
       // Use those values to send our auth request...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: const ValueKey("Email"),
                    validator: (value){
                      if(value!.isEmpty || !value.contains("@")){
                        return "Please enter the valid email address.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (value){
                      _userEmail = value!;
                    },
                  ),
                  if(!_isLogin)
                  TextFormField(
                    key: const ValueKey("UserName"),
                    validator: (value){
                      if(value!.isEmpty || value.length < 2){
                        return "Username must have at least 2 characters.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                    onSaved: (value){
                      _userName = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey("Password"),
                    validator: (value){
                      if(value!.isEmpty || value.length < 7){
                        return "Password must have at least 7 characters.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    onSaved: (value){
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(height: 10,),
                  if(widget.isLoading)const CircularProgressIndicator(),
                  if(!widget.isLoading)ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? "Login" : "Sign Up"),
                  ),
                  if(!widget.isLoading)TextButton(
                    onPressed: (){
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin ? "Create New Account" : "I already have an account!"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
