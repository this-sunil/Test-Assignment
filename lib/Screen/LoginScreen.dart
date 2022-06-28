import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey=GlobalKey();
  FirebaseAuth auth=FirebaseAuth.instance;
  ImagePicker picker=ImagePicker();
  TextEditingController confirmPassword=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  File? image;
  pickUpImage() async{
    final pickImage=await picker.pickImage(source: ImageSource.gallery);
    if(pickImage==null){
      return "No Image Selected";
    }
    setState(() {
      image=File(pickImage.path).absolute;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: email,
                  validator: (value)=>value!.isNotEmpty?null:"Please enter your email",
                  decoration: InputDecoration(
                    hintText: "enter your email",
                    border: OutlineInputBorder(

                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: password,
                  validator: (value)=>value!.isNotEmpty?null:"Please enter your password",
                  decoration: InputDecoration(
                    hintText: "Enter your Password",
                      border: OutlineInputBorder(

                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: confirmPassword,
                  validator: (value)=>value!.isNotEmpty?null:"Please enter your password",
                  decoration: InputDecoration(
                      hintText: "Enter your confirm password",
                      border: OutlineInputBorder(

                      )
                  ),
                  onChanged: (String? value){
                    setState(() {
                      confirmPassword.text=value.toString();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: image==null?Text("No Image Selected"):Image.file(File(image!.path),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                ),
              ),
              Padding(padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text("Upload Image"),
                onPressed: (){
                  pickUpImage();
                },
              ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(

                    onPressed:() async{
                  if(formKey.currentState!.validate()){
                    auth.signInWithEmailAndPassword(email: email.text, password: password.text).then((value){
                      print("User email ${value.user!.email}");
                    });
                    await FirebaseFirestore.instance.collection("/Login").doc().set(
                        {
                          "email":email.text,
                          "password":confirmPassword.text,
                          "image":image?.path,
                        });
                  }
                }, child: Text("submit")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
