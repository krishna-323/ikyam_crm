import 'dart:js_interop';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/home_screen.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import '../widgets/custom_popup_dropdown/custom_popup_dropdown.dart';


class UserCreation extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const UserCreation({super.key,
    required this.drawerWidth,
    required this.selectedDestination,});

  @override
  State<UserCreation> createState() => _UserCreationState();
}

class _UserCreationState extends State<UserCreation> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();


  final roleTypeController=TextEditingController();
  List<String> roleType=["User","Admin"];
  String selectedType='Select Type';
  bool  _invalidName = false;
  bool _invalidEmail = false;
  bool _invalidMobile = false;
  bool _invalidConfirmPassword = false;
  bool _invalidPassword = false;
  bool _isRoleFocused=false;
  bool _invalidRoleType=false;

  //validators.
  String? checkNameError(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _invalidName=true;
      });
      return 'Please Enter Name';
    }
    setState(() {
      _invalidName=false;
    });
    return null;
  }
  String? checkEmailError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidEmail=true;
      });
      return 'Please Enter Email.';
    }
    else if(!EmailValidator.validate(value)){
      setState(() {
        _invalidEmail=true;
      });
      return 'Please enter a valid email address';
    }
    else{
      setState(() {
        _invalidEmail=false;
      });
    }

    return null;
  }
  String? checkMobileError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidMobile=true;
      });
      return 'Please Enter Mobile Number.';
    }
    setState(() {
      _invalidMobile=false;
    });
    return null;
  }
  String? checkPasswordError(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidPassword = true;
      });
      return "Please Enter Password";
    }
    setState(() {
      _invalidPassword = false;
    });
    return null;
  }
  String? checkConfirmPasswordError(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidConfirmPassword = true;
      });
      return "Please Confirm Password";
    }
    setState(() {
      _invalidConfirmPassword = false;
    });
    return null;
  }

  bool isFocused =false;
  final _formKey=GlobalKey<FormState>();
  //Password Declarations.
  bool passWordHindBool=true;
  bool confirmPasswordHide=true;

  void passwordHideAndViewFunc() {
    setState(() {
      passWordHindBool = !passWordHindBool;
    });
  }

  void confirmPasswordHideAndViewFunc() {
    setState(() {
      confirmPasswordHide = !confirmPasswordHide;
    });
  }

  String capitalizeFirstWord(String value){
    if(value.isNotEmpty){
      var result =value[0].toUpperCase();
      for(int i=1;i<value.length;i++){
        if(value[i-1]=='1'){
          result=result+value[i].toUpperCase();
        }
        else{
          result=result+value[i];
        }
      }
      return result;
    }
    return "";
  }

  final _horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination,),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),

          screenWidth>1100? Expanded(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: AppBar(automaticallyImplyLeading: false,
                  leading: IconButton(onPressed: (){
                    Navigator.of(context).pop();
                    //Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),));
                  }, icon: const Icon(Icons.arrow_back),),

                  elevation: 1,
                  surfaceTintColor: Colors.white,
                  shadowColor: Colors.black,
                  title: const Text("User Creation"),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: SizedBox(
                        width: 120,
                        height: 30,
                        child: OutlinedMButton(
                          textColor: mSaveButton,
                          borderColor: mSaveButton,
                          onTap: ()async{
                            if(_formKey.currentState!.validate()){
                              if(passwordController.text == confirmPasswordController.text){
                                Map newUser={
                                  "userName": nameController.text,
                                  "email":emailController.text,
                                  "password": passwordController.text,
                                  "active": true,
                                  "role": roleTypeController.text,
                                  "phone":phoneController.text
                                };
                                await registerWithEmailAndPassword(newUser);
                              }
                             else{
                                showErrorDialogPasswordMatch("Password Doesn't Match,Please Check");
                            }
                            }
                          }, text: 'Save',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0,bottom: 20),
                  child: Center(
                    child: Card(
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),

                      child: SizedBox(
                          width: 1000,
                          child: Form(
                              key: _formKey,
                              child: buildCustomerCard())),
                    ),
                  ),
                ),
              ),
            ),
          ) :Expanded(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(onPressed: (){
                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),));
                  }, icon: const Icon(Icons.arrow_back),),

                  elevation: 1,
                  surfaceTintColor: Colors.white,
                  shadowColor: Colors.black,
                  title: const Text("User Creation"),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: SizedBox(
                        width: 120,
                        height: 30,
                        child: OutlinedMButton(
                          textColor: mSaveButton,
                          borderColor: mSaveButton,
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              Map customerDetails = {
                                "customer_name" : nameController.text,
                                "email_id" : emailController.text,
                                "mobile" :phoneController.text,
                                "pin_code" : confirmPasswordController.text,
                                "street_address" : passwordController.text,
                                "type" : selectedType
                              };

                              Navigator.of(context).pop();
                              print(customerDetails);
                            }
                          }, text: 'Save',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              body: Padding(
                padding: const EdgeInsets.only(top: 20.0,bottom: 20),
                child: Center(
                  child: Card(
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                        side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),

                    child: AdaptiveScrollbar(
                      position: ScrollbarPosition.bottom,
                      underColor: Colors.blueGrey.withOpacity(0.3),
                      sliderDefaultColor: Colors.grey.withOpacity(0.7),
                      sliderActiveColor: Colors.grey,
                      controller: _horizontalScrollController,
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _horizontalScrollController,
                          child: SizedBox(
                              width: 1000,
                              child: Form(
                                  key: _formKey,
                                  child: buildCustomerCard())),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],),

    );
  }

  Widget buildCustomerCard(){
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///User Details
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///header
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 42,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20,),
                      child: Row(children: [Text("User Details",style: TextStyle(fontWeight: FontWeight.bold),),],
                      ),
                    ),
                  ),

                ],
              ),

              const Divider(height: 1,color: mTextFieldBorder),
              Padding(
                padding: const EdgeInsets.only(left: 60,top: 10,right: 60),
                child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Left Field
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("User Name"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              autofocus: true,
                              controller: nameController,
                              validator:checkNameError,
                              decoration: textFieldDecoration(hintText: 'Enter Name',error:_invalidName),
                              onChanged: (value){
                                nameController.value=TextEditingValue(
                                  text:capitalizeFirstWord(value),
                                  selection: nameController.selection,
                                );
                              },
                            ),
                            const SizedBox(height: 20,),

                            const Text("Email"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              inputFormatters: [LowerCaseTextFormatter()],
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              validator: checkEmailError,
                              decoration: textFieldDecoration(hintText: 'Enter Email',error: _invalidEmail),
                            ),
                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 30,),
                    ///Right Fields
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Mobile Number"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              controller: phoneController,
                              validator: checkMobileError,
                              decoration: textFieldDecoration(hintText: 'Enter Mobile Number',error: _invalidMobile),),
                            const SizedBox(height: 20,),

                            const Text("Role"),
                            const SizedBox(height: 6,),
                            Focus(
                              onFocusChange: (value) {
                                setState(() {
                                  _isRoleFocused = value;
                                });
                              },
                              skipTraversal: true,
                              descendantsAreFocusable: true,
                              child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return CustomPopupMenuButton(elevation: 4,
                                      validator: (value) {
                                        if(value==null||value.isEmpty){
                                          setState(() {
                                            _invalidRoleType=true;
                                          });
                                          return null;
                                        }
                                        return null;
                                      },
                                      decoration: customPopupDecoration(hintText: 'Select type',error: _invalidRoleType,isFocused: _isRoleFocused),
                                      hintText: selectedType,
                                      textController: roleTypeController,
                                      childWidth: constraints.maxWidth,
                                      shape:  RoundedRectangleBorder(
                                        side: BorderSide(color:_invalidRoleType? Colors.redAccent :mTextFieldBorder),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      offset: const Offset(1, 40),
                                      tooltip: '',
                                      itemBuilder:  (BuildContext context) {
                                        return roleType.map((value) {
                                          return CustomPopupMenuItem(
                                            value: value,
                                            text:value,
                                            child: Container(),
                                          );
                                        }).toList();
                                      },

                                      onSelected: (String value)  {
                                        setState(() {
                                          roleTypeController.text=value;
                                          selectedType= value;
                                          _invalidRoleType=false;
                                        });

                                      },
                                      onCanceled: () {

                                      },
                                      child: Container(),
                                    );
                                  }
                              ),
                            ),

                            if(_invalidRoleType)
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    SizedBox(height: 6,),
                                    Text("Please Select Gender",style: TextStyle(color:mErrorColor,fontSize: 12)),
                                    SizedBox(height: 6,),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )

            ],
          ),
          const SizedBox(height: 40,),

          ///Address Details
          const Divider(height: 1,color: mTextFieldBorder),
          Column(
            children: [
              ///Address Header
              const SizedBox(
                height: 42,
                child: Row(children: [Padding(padding: EdgeInsets.only(left: 20),
                  child: Text("Password",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ],
                ),
              ),
              const Divider(height: 1,color: mTextFieldBorder),
              Padding(
                padding: const EdgeInsets.only(left: 60,top: 10,right: 60),
                child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Left Field
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Password"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              obscureText: passWordHindBool,
                              enableSuggestions: false,
                              controller: passwordController,
                              onTap: (){
                                setState(() {
                                  isFocused=true;
                                });
                              },
                              validator: checkPasswordError,
                              decoration:  textFieldPasswordDecoration(hintText:"Password", passWordHind:passWordHindBool, error: _invalidPassword, passwordHideAndView: passwordHideAndViewFunc,),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 30,),
                    ///Right Fields
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Confirm Password"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              obscureText: confirmPasswordHide,
                              validator: checkConfirmPasswordError,
                              controller: confirmPasswordController,
                              decoration: textFieldPasswordDecoration(hintText: 'Confirm Password',
                                  passWordHind: confirmPasswordHide, error: _invalidConfirmPassword, passwordHideAndView: confirmPasswordHideAndViewFunc),
                            ),
                            const SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }

  //TextField Decorations.
  textFieldDecoration({required String hintText, bool? error}) {
    return  InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldPasswordDecoration({required String hintText, required bool passWordHind,required bool error,required passwordHideAndView}) {
    return  InputDecoration(
      suffixIcon: IconButton(
        icon: Icon(
          passWordHind ? Icons.visibility : Icons.visibility_off,size: 20,
        ),
        onPressed: passwordHideAndView,
      ),suffixIconColor: const Color(0xff00004d),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35,),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  customPopupDecoration({required String hintText, bool? error, bool? isFocused}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon:  const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isFocused == true ? Colors.blue : error == true ? mErrorColor : mTextFieldBorder)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: error == true ? mErrorColor : mTextFieldBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: error == true ? mErrorColor : Colors.blue)),
    );
  }

  /// This Function is creating new user.
  Future registerWithEmailAndPassword(Map newUser) async {

    try {
      /// Three Lines Are Creating Creating New User.
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: newUser['email'],
        password: newUser['password'],
      );
      /// This is a FireStore database Users are Adding.
      if(userCredential.isDefinedAndNotNull){
        await usersCollection.doc(userCredential.user!.uid).set({
          "userName":newUser['userName'],
          "email": userCredential.user?.email,
          "password": newUser['password'],
          "userUid":userCredential.user!.uid,
          'role':newUser['role'],
          "phone":newUser['phone'],
          "delete":false
        });
        showErrorDialog("User Register Successfully.Try To Login");
        return true;
        // Store user data in fire store
      }
      return false;
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('--------e code-----');
        print(e.code);
        if (e.code == 'email-already-in-use') {
          showErrorDialogPasswordMatch("This Email Address Is Registered, Please Try Another.");
        }
        if(e.code =="weak-password"){
          showErrorDialogPasswordMatch("Week Password");
        }
      } else {
        throw "Error: $e";
      }
    }
  }

  // Show DialogBox.
  void showErrorDialog(String errorMessage,) {
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
                 Navigator.pushReplacementNamed(context,"/usersList");
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },);
  }

  // Show DialogBox.
  void showErrorDialogPasswordMatch(String errorMessage,) {
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
}

//Lower Case Converter Class.
class LowerCaseTextFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toLowerCase(),selection: newValue.selection);
  }
}


