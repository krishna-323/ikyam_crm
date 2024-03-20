import 'dart:convert';
import 'dart:developer';
import 'dart:js_interop';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ikyam_crm/utils/static_files/static_colors.dart';
import 'package:ikyam_crm/widgets/input_decoration_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final userName = TextEditingController();
  final password = TextEditingController();

  bool passWordHindBool=true;

  void passwordHideAndViewFunc() {
    setState(() {
      passWordHindBool = !passWordHindBool;
    });
  }
  ///BTP HandleLogin
  void _handleLogin(){
    final username = userName.text.trim();
    final pass = password.text.trim();
    if(username.isNotEmpty && pass.isNotEmpty){
      fetchBusinessPartnerDetails();
      log("Logging in with username: $username and password: $pass");
    }else{
      showErrorDialog("Username and Password are required");
      log("Username and Password are required");
    }
  }

  /// BTP Api login.
  Future fetchBusinessPartnerDetails()async{
    String url="https://firstapp-boisterous-crocodile-uu.cfapps.in30.hana.ondemand.com/api/login";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String basicAuth = 'Basic ${base64Encode(utf8.encode('${userName.text}:${password.text}'))}';

    final response =await http.get(Uri.parse(url),
    headers: {
      "content-type": "application/json;charset=utf-8",
      'authorization': basicAuth
    });

    if(response.statusCode==200){
      if(mounted){
        Navigator.pushReplacementNamed(context, "/customerList");
        prefs.setString("basicAuth", basicAuth);
      }

    }
     if(response.statusCode ==401){
      showErrorDialog("Invalid UserName Or Password");
    }
  }

  // Show DialogBox.
  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(Icons.error,color: Colors.red,),
              Text(errorMessage,style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 10,),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: Container(height: 220,width: 500,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        decoration:  const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          color: Color(0xff00004d),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Image.asset("assets/logo/Inverse Ikyam White Logo PNG.png"),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 4,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Welcome",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                              SizedBox(height: 30,
                                child: TextField(onTap: () {
                                  // setState(() {
                                  //   passWordHindBool=true;
                                  // });
                                },
                                  onChanged: (value) {

                                },
                                  controller: userName,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: decorationInput3("User Name"),
                                ),
                              ),
                              SizedBox(height: 30,
                                child: TextField(
                                  obscureText: passWordHindBool,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: password,
                                  onChanged: (value){

                                },
                                  style: const TextStyle(fontSize: 12),
                                  decoration: decorationInputPassword("Password", passWordHindBool,passwordHideAndViewFunc,),
                                  onSubmitted: (v)  {}
                                ),
                              ),
                             Row(
                               mainAxisAlignment:MainAxisAlignment.spaceBetween,
                               children: [
                               // Container(
                               //   decoration: const BoxDecoration(
                               //     borderRadius: BorderRadius.all(Radius.circular(10)),
                               //     color: Color(0xff00004d),
                               //   ),
                               //   child: TextButton(
                               //       onPressed: () async {
                               //         // /// Create User Firebase Authentication, and storage.
                               //         // if(userName.text.isEmpty || password.text.isEmpty){
                               //         //   showErrorDialog("Please Enter User Email Or Password");
                               //         // }
                               //         // else{
                               //         //   registerWithEmailAndPassword(userName.text,password.text);
                               //         // }
                               //
                               //       }, child: const Text("Register",style:  TextStyle(color: Colors.white,),)),
                               // ),
                               Container(
                                 decoration: const BoxDecoration(
                                   borderRadius: BorderRadius.all(Radius.circular(10)),
                                   color: Color(0xff00004d),
                                 ),
                                 child: TextButton(
                                     onPressed: () async {
                                       /// BTP Login api call function.
                                       //_handleLogin();
                                       ///Firebase Authentication login Function call.
                                       _handleLogin1();
                                       // if(mounted) {
                                       //   // Navigator.pushReplacementNamed(context, "/home");
                                       //    // Navigator.pushReplacementNamed(context, "/customerList");
                                       // }
                                     }, child: const Text("Login",style:  TextStyle(color: Colors.white,),)),
                               ),
                             ],)
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
  decorationInputPassword(String hintString, bool passWordHind,  passwordHideAndView, ) {
    return InputDecoration(
        label: Text(
          hintString,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            passWordHind ? Icons.visibility : Icons.visibility_off,size: 20,
          ),
          onPressed: passwordHideAndView,
        ),suffixIconColor: const Color(0xff00004d),
        // suffixIconColor:val?  const Color(0xff00004d):Colors.grey,
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
        hintText: hintString,labelStyle: const TextStyle(fontSize: 12,),

        disabledBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:  Colors.white)),
        enabledBorder:const OutlineInputBorder(borderSide:  BorderSide(color: mTextFieldBorder)),
        focusedBorder:  const OutlineInputBorder(borderSide:  BorderSide(color: Color(0xff00004d))),
        border:   const OutlineInputBorder(borderSide:  BorderSide(color: Color(0xff00004d)))

    );
  }

  /// Firebase Handle-login.
  void _handleLogin1(){
    final username = userName.text.trim();
    final pass = password.text.trim();
    if(username.isNotEmpty && pass.isNotEmpty){
      checkCredentials();
      log("Logging in with username: $username and password: $pass");
    }else{
      showErrorDialog("Username and Password are required");
      log("Username and Password are required");
    }
  }
  ///Firebase
  Future<void> checkCredentials() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userName.text,
          password: password.text
      );

      if(credential.user!=null){
        if(mounted){
          Navigator.pushReplacementNamed(context, "/home");
          //Navigator.pushReplacementNamed(context, "/customerList");
        }
      }
    } on FirebaseAuthException catch (e) {

      String tempErrorMsg=e.code;
      print(tempErrorMsg);
      switch (tempErrorMsg) {
        // case1.
        case   "invalid-email" || "invalid-credential": {
          showErrorDialog("Please Enter Valid Email Or Password.");
        } break;
        //case2.
        case   "configuration-not-found": {
          showErrorDialog("Credential Not Found. (Or) Invalid Email Or Password.");
        } break;
        //default case.
        default: {
          showErrorDialog("Something Went Wrong.");
        } break;
      }
    }
  }

}
