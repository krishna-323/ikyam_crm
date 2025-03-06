import 'dart:convert';
import 'dart:developer';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../dashboard/home_screen.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';

class CreateMasterDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CreateMasterDetails({super.key, required this.drawerWidth, required this.selectedDestination});

  @override
  State<CreateMasterDetails> createState() => _CreateMasterDetailsState();
}

class _CreateMasterDetailsState extends State<CreateMasterDetails> {
  String userUid="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchImageUrls();
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    userUid=uid!;
    // print('-------curent user Uid-----');
    // print(userUid);
    //getProductsFireStoreDatabase(userUid);
    loading =true;
    //Get Master Items Data.
    masterItemData();
  }





  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  var nameController = TextEditingController();
  var imageController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();


  final roleTypeController=TextEditingController();
  List<String> roleType=["User","Admin"];
  String selectedType='Select Type';
  bool  _invalidName = false;
  bool imageUrlError = false;
  //bool _invalidEmail = false;
  bool _invalidMobile = false;
  // bool _invalidConfirmPassword = false;
  // bool _invalidPassword = false;
  // bool _isRoleFocused=false;
  // bool _invalidRoleType=false;

  //validators.
  String? checkNameError(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _invalidName=true;
      });
      return 'Please Product Name';
    }
    setState(() {
      _invalidName=false;
    });
    return null;
  }
  String? imageError(String? value){
    if (value == null || value.isEmpty) {
      setState(() {
        imageUrlError=true;
      });
      return 'Please Upload Image';
    }
    setState(() {
      imageUrlError=false;
    });
    return null;
  }
  String? checkMobileError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidMobile=true;
      });
      return 'Please Enter Product Description.';
    }
    setState(() {
      _invalidMobile=false;
    });
    return null;
  }
  // String? checkEmailError(String? value) {
  //   if(value == null || value.isEmpty) {
  //     setState(() {
  //       _invalidEmail=true;
  //     });
  //     return 'Please Enter Email.';
  //   }
  //   else if(!EmailValidator.validate(value)){
  //     setState(() {
  //       _invalidEmail=true;
  //     });
  //     return 'Please enter a valid email address';
  //   }
  //   else{
  //     setState(() {
  //       _invalidEmail=false;
  //     });
  //   }
  //
  //   return null;
  // }
  // String? checkPasswordError(String? value){
  //   if(value == null || value.isEmpty){
  //     setState(() {
  //       _invalidPassword = true;
  //     });
  //     return "Please Enter Password";
  //   }
  //   setState(() {
  //     _invalidPassword = false;
  //   });
  //   return null;
  // }
  // String? checkConfirmPasswordError(String? value){
  //   if(value == null || value.isEmpty){
  //     setState(() {
  //       _invalidConfirmPassword = true;
  //     });
  //     return "Please Confirm Password";
  //   }
  //   setState(() {
  //     _invalidConfirmPassword = false;
  //   });
  //   return null;
  // }

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
  final storageRef = FirebaseStorage.instance.ref();

  String storeDownloadedUrl='';
  Uint8List? storeImageBytes;

  ///Image Picker.
  Future<String?> filePicker() async {
    //Files Allowed Only Picker.
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png','webp'], // Specify allowed image file extensions
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      storeImageBytes = fileBytes;
      // print('-------storeImageBytes-------');
      // print(storeImageBytes);
      try {
        imageController.text = fileName;
        return fileName;
        //return downloadUrl;
      } catch (e) {
        print('Error uploading file: $e');
        return null;
      }
    }
    return null;
  }



  bool loading=false;
  ///Upload Data Through FireStoreDatabase.
  Future uploadingToFireStoreDatabase()async{
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    userUid =uid!;

    print('-----inside save---');
    print(storeDownloadedUrl);
    /// Uploading Master Data To Firestore Database.
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('products').add({
        'productName': nameController.text,
        'description': phoneController.text,
        'imageUrl': storeDownloadedUrl,
      });
    } catch (e) {
      print('Error adding product data: $e');
    }
  }
  List storeData=[];

  ///Get Data From FireStore Database.
  Future<List<Map<String, dynamic>>?> getProductsFireStoreDatabase(String userUid) async {
    try {
      QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('products')
          .get();


      List<Map<String, dynamic>> productsList = [];
      productsSnapshot.docs.forEach((doc) {
        productsList.add(doc.data() as Map<String, dynamic>);
        setState(() {
          storeData= productsList;
        });

      });

      return productsList;
    } catch (e) {
      print('Error getting products: $e');
      return null;
    }
  }

  ///Master Data Post Api Call.
  Future postApi(Map productDetails)async{
    // print('-----inside post Api----');
    // print(productDetails["imageUrl"]);
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    print('---------Current User UID-----------');
    print(uid);
    String url="https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/images/add_images";
    final response = await http.post(Uri.parse(url),
        headers:
        {
          "Content-Type" :"application/json",
        },
      body: jsonEncode(productDetails),
    );
    final responseBody= jsonDecode(response.body);
    if(response.statusCode ==200){

      try{
        log('---------postApi Response---');
        log(response.body);
        if(responseBody['status']=='success'){
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Master Data Added :${responseBody['id']}"),duration: const Duration(seconds: 5),));
          }
        }
        ///Storing Images In Firebase Storage.
        await FirebaseStorage.instance.ref().child('images/${uid!.substring(0, 5)}/${responseBody['id']}').putData(storeImageBytes!, SettableMetadata(contentType: "image/jpeg"));
        setState(() {
          nameController.clear();
          phoneController.clear();
          imageController.clear();
          masterItemData().whenComplete(() {
           return   setState(() {
              loading=false;
            });
          });

        });

       // return jsonDecode(response.body);
      }
      catch(e){
        log('-------postApi-----Exception--------');
        log(e.toString());
      }
    }
    else{
      log('-------Something Want Wrong!!!!!!!!!--------');
    }
  }


  List getMasterData=[];

  ///Master Data AWS Get API.
  Future masterItemData()async{
    String url="https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/images/get_all_images";
    final response = await http.get(Uri.parse(url));
      final responseBody = jsonDecode(response.body);

    if(response.statusCode==200){

      try{
        for(int i=0;i<responseBody.length;i++){
          // print('-------imageId----------');
          // print(responseBody[i]['imageId']);

          responseBody[i]['url']=await getImage(responseBody[i]['imageId'].toString());
        }
        setState(() {
          loading=false;
          getMasterData=[];
          getMasterData = responseBody;
          // print('-----responseBody-----');
          // print(getMasterData);
        });
      }
      catch(e){
      log('----getMasterItems Exception-----');
      log(e.toString());
      }
    }
    else{
      log('--------Something Want Wrong!!!!!!!!!---------');
    }
  }

  ///Show Dialog Box For Delete Message.
  Future delete(String masterID){
   return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 200,
                width: 300,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 25),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Icon(
                            Icons.warning_rounded,
                            color: Colors.red,
                            size: 50,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Center(
                              child: Text(
                                'Are You Sure, You Want To Delete ?',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )),
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                color: Colors.red,
                                onPressed: () {
                                  // print(userId);

                                  deleteMaster(masterID);
                                  deleteImagesInFirebase(masterID);
                                },
                                child: const Text(
                                  'Ok',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(right: 0.0,

                    child: InkWell(
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color:
                                const Color.fromRGBO(204, 204, 204, 1),
                              ),
                              color: Colors.blue),
                          child: const Icon(
                            Icons.close_sharp,
                            color: Colors.white,
                          )),
                      onTap: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
                ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  ///Delete Master Data In AWS API.
  Future deleteMaster(String masterId)async{
    String url="https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/images/delete_images_by_id/$masterId";
    final response = await http.delete(Uri.parse(url),);
    dynamic responseBody=jsonDecode(response.body);
    if(response.statusCode ==200){
      try{
        if(responseBody['status']=="success"){
          if(mounted){
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Deleted Masters Data:$masterId"),duration: const Duration(seconds: 5),));
            setState(() {
              getMasterData=[];
              masterItemData();
            });
          }
        }
        else if(responseBody['status']=="error"){
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something Went Wrong Please Check !!!"),duration: Duration(seconds: 5),));
          }
        }

      }
      catch(e){
        log('--------Exception---------');
        log(e.toString());
      }
    }
  }

  ///Images Deleting From Firebase.
  Future<void> deleteImagesInFirebase(String masterID) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    // Create a reference to the file to delete
    Reference reference = FirebaseStorage.instance.ref().child("images/${uid!.substring(0, 5)}/$masterID");

    try {
      // Delete the file
      await reference.delete();
      print('File deleted successfully');
    } catch (e) {
      print('Error deleting file: $e');
      // Handle errors
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
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
                    //Navigator.of(context).pop();
                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),));
                  }, icon: const Icon(Icons.arrow_back),),

                  elevation: 1,
                  surfaceTintColor: Colors.white,
                  shadowColor: Colors.black,
                  title: const Text("Master Details Creation Hare Krishna"),
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
                                Map productDetails={
                                  "productName":nameController.text,
                                  "productDescription":phoneController.text,
                                  'imageUrl':imageController.text
                                };
                                setState(() {
                                  loading=true;
                                });
                                ///Uploading TO PostApi.
                                postApi(productDetails);

                                ///Uploading To FireStore Database.
                                //uploadingToFireStoreDatabase().whenComplete(() => getProductsFireStoreDatabase(userUid));

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
                  title: const Text("Master Details Creation"),
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
                              Map productDetails={
                                "productName":nameController.text,
                                "productDescription":phoneController.text,
                                'imageUrl':storeDownloadedUrl
                              };
                              ///Uploading TO PostApi.
                              postApi(productDetails);

                              ///Uploading To FireStore Database.
                              //uploadingToFireStoreDatabase().whenComplete(() => getProducts(userUid));

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
                      child: Row(children: [Text("Create Master Item Details",style: TextStyle(fontWeight: FontWeight.bold),),],
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
                            const Text("Product Name"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              autofocus: true,
                              controller: nameController,
                              validator:checkNameError,
                              decoration: textFieldDecoration(hintText: 'Product Name',error:_invalidName),
                              onChanged: (value){
                                nameController.value=TextEditingValue(
                                  text:capitalizeFirstWord(value),
                                  selection: nameController.selection,
                                );
                              },
                            ),
                            const SizedBox(height: 20,),

                            MaterialButton(
                                color: Colors.blue,
                                child:const Text('Upload Image',style: TextStyle(color: Colors.white),),
                                onPressed: (){
                                  filePicker();
                            }),
                               const SizedBox(width: 10,),


                            // const Text("Email"),
                            // const SizedBox(height: 6,),
                            // TextFormField(
                            //   inputFormatters: [LowerCaseTextFormatter()],
                            //   textCapitalization: TextCapitalization.characters,
                            //   textInputAction: TextInputAction.next,
                            //   controller: emailController,
                            //   validator: checkEmailError,
                            //   decoration: textFieldDecoration(hintText: 'Enter Email',error: _invalidEmail),
                            // ),
                            // const SizedBox(height: 20,),
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
                            const Text("Product Description"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              //keyboardType: TextInputType.number,
                              //maxLength: 10,
                              controller: phoneController,
                              validator: checkMobileError,
                              decoration: textFieldDecoration(hintText: 'Description',error: _invalidMobile),),
                            const SizedBox(height: 20,),

                            TextFormField(readOnly: true,
                              // autofocus: true,
                              controller: imageController,
                              validator:imageError,
                              decoration: textFieldDecoration(hintText: 'filename',error:imageUrlError),
                              onChanged: (value){

                              },
                            ),

                            // const Text("Role"),
                            // const SizedBox(height: 6,),
                            // Focus(
                            //   onFocusChange: (value) {
                            //     setState(() {
                            //       _isRoleFocused = value;
                            //     });
                            //   },
                            //   skipTraversal: true,
                            //   descendantsAreFocusable: true,
                            //   child: LayoutBuilder(
                            //       builder: (BuildContext context, BoxConstraints constraints) {
                            //         return CustomPopupMenuButton(elevation: 4,
                            //           validator: (value) {
                            //             if(value==null||value.isEmpty){
                            //               setState(() {
                            //                 _invalidRoleType=true;
                            //               });
                            //               return null;
                            //             }
                            //             return null;
                            //           },
                            //           decoration: customPopupDecoration(hintText: 'Select type',error: _invalidRoleType,isFocused: _isRoleFocused),
                            //           hintText: selectedType,
                            //           textController: roleTypeController,
                            //           childWidth: constraints.maxWidth,
                            //           shape:  RoundedRectangleBorder(
                            //             side: BorderSide(color:_invalidRoleType? Colors.redAccent :mTextFieldBorder),
                            //             borderRadius: const BorderRadius.all(
                            //               Radius.circular(5),
                            //             ),
                            //           ),
                            //           offset: const Offset(1, 40),
                            //           tooltip: '',
                            //           itemBuilder:  (BuildContext context) {
                            //             return roleType.map((value) {
                            //               return CustomPopupMenuItem(
                            //                 value: value,
                            //                 text:value,
                            //                 child: Container(),
                            //               );
                            //             }).toList();
                            //           },
                            //
                            //           onSelected: (String value)  {
                            //             setState(() {
                            //               roleTypeController.text=value;
                            //               selectedType= value;
                            //               _invalidRoleType=false;
                            //             });
                            //
                            //           },
                            //           onCanceled: () {
                            //
                            //           },
                            //           child: Container(),
                            //         );
                            //       }
                            //   ),
                            // ),
                            //
                            // if(_invalidRoleType)
                            //   const Padding(
                            //     padding: EdgeInsets.only(left: 10),
                            //     child: Column(
                            //       children: [
                            //         SizedBox(height: 6,),
                            //         Text("Please Select Gender",style: TextStyle(color:mErrorColor,fontSize: 12)),
                            //         SizedBox(height: 6,),
                            //       ],
                            //     ),
                            //   ),
                            // const SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ///images displaying through FireStore Database.

              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: storeData.length,
              //   itemBuilder: (context, index) {
              //     // print('-----index---');
              //     // print(storeData[index]['productName']);
              //     // print(storeData);
              //     return Column(
              //       children: [
              //         const SizedBox(height: 5,),
              //         ///Button Expander.
              //         AnimatedContainer(
              //           height: 210,
              //           duration:const Duration(milliseconds: 0),
              //           child: MaterialButton(
              //             hoverColor: Colors.blue[50],
              //             onPressed: () {  },
              //             child: Padding(
              //               padding: const EdgeInsets.only(left: 18.0),
              //               child: Row(
              //                 children: [
              //                   Expanded(
              //                     child: Column(
              //                       children: [
              //                         Row(
              //                           children: [
              //                             Expanded(
              //                               child: Padding(
              //                                 padding: const EdgeInsets.only(left:10,top: 4.0),
              //                                 child: SizedBox(
              //                                   height: 25,
              //                                   child: Text(storeData[index]['productName']),
              //                                 ),
              //                               ),
              //                             ),
              //                             Expanded(
              //                               child: Padding(
              //                                 padding: const EdgeInsets.only(left:10,top: 4),
              //                                 child: SizedBox(
              //                                   height: 25,
              //                                   child:  Text(storeData[index]['description']),
              //                                 ),
              //                               ),
              //                             ),
              //
              //                             Expanded(
              //                               child: Padding(
              //                                 padding: const EdgeInsets.only(left:10,top: 4),
              //                                 child: SizedBox(
              //                                   height: 200,
              //                                   width: 250,
              //                                   child: Image.network(storeData[index]['imageUrl']),
              //                                 ),
              //                               ),
              //                             ),
              //                             // Expanded(
              //                             //   child: Padding(
              //                             //     padding: const EdgeInsets.only(left:10,top: 4),
              //                             //     child: SizedBox(
              //                             //       height: 25,
              //                             //       child: Text(documentSnapshot['role']??""),
              //                             //     ),
              //                             //   ),
              //                             // ),
              //
              //                           ],
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //
              //                   // SizedBox(
              //                   //   width: 25,
              //                   //   height: 25,
              //                   //   child: LayoutBuilder(
              //                   //     builder: (BuildContext context, BoxConstraints constraints) {
              //                   //       return CustomPopupMenuButton(
              //                   //         decoration: iconDecoration(),
              //                   //         elevation: 4,
              //                   //         itemBuilder: (context) {
              //                   //           return moreDropdown;
              //                   //         },
              //                   //         hintText: '',
              //                   //         childWidth: 150,
              //                   //         offset: const Offset(1, 40),
              //                   //         tooltip: '',
              //                   //         onSelected: (value) {
              //                   //
              //                   //           setState(() {
              //                   //             if(value == "Edit"){
              //                   //               editScreenPopUp(context,documentSnapshot);
              //                   //             }
              //                   //             if(value=="Delete"){
              //                   //               deletePopUp(context,displayList[index]['id']);
              //                   //             }
              //                   //             if (value=="Change Password"){
              //                   //               print('----change password---');
              //                   //               //changePasswordDialog(context, index);
              //                   //             }
              //                   //           });
              //                   //         },
              //                   //         child: Container(),
              //                   //       );
              //                   //     },
              //                   //   ),
              //                   // )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //         Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
              //       ],
              //     );
              //
              //   },),

             ///Images Displaying From Firebase Storage.
             //  ListView.builder(
             //    shrinkWrap: true,
             //    itemCount: imageUrls.length,
             //    itemBuilder: (context, index) {
             //      // print('-------url----');
             //      // print(imageUrls[index]);
             //      print(imageUrls[index].substring(1, imageUrls[index].length - 1));
             //      String store =imageUrls[index].substring(1, imageUrls[index].length - 1);
             //      return Padding(
             //        padding: EdgeInsets.all(8.0),
             //        child: Container(
             //            height: 300,
             //            width: 250,
             //            child: Image.network(imageUrls[index]),)
             //      );
             //    },
             //  ),

              ///Images Displaying Through Get Api.
              loading?const Center(child:  CircularProgressIndicator()): ListView.builder(
                shrinkWrap: true,
                itemCount: getMasterData.length,
                itemBuilder: (context, index) {

                  return Column(
                    children: [
                      const SizedBox(height: 5,),
                      ///Button Expander.
                      AnimatedContainer(
                        height: 210,
                        duration:const Duration(milliseconds: 0),
                        child: MaterialButton(
                          hoverColor: Colors.blue[50],
                          onPressed: () {  },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4.0),
                                              child: SizedBox(
                                                height: 25,
                                                child: Text(getMasterData[index]['productName']??""),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4),
                                              child: SizedBox(
                                                height: 25,
                                                child:  Text(getMasterData[index]['productDescription']??""),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4),
                                              child: SizedBox(
                                                height: 200,
                                                width: 250,
                                                child:
                                                Image.network(getMasterData[index]['url']??""),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: (){
                                                delete(getMasterData[index]['imageId']??"");
                                                //deleteMaster(getMasterData[index]['imageId']);

                                              },
                                              child:const Icon(Icons.delete,color: Colors.black,)),

                                          // Expanded(
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(left:10,top: 4),
                                          //     child: SizedBox(
                                          //       height: 25,
                                          //       child: Text(documentSnapshot['role']??""),
                                          //     ),
                                          //   ),
                                          // ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // SizedBox(
                                //   width: 25,
                                //   height: 25,
                                //   child: LayoutBuilder(
                                //     builder: (BuildContext context, BoxConstraints constraints) {
                                //       return CustomPopupMenuButton(
                                //         decoration: iconDecoration(),
                                //         elevation: 4,
                                //         itemBuilder: (context) {
                                //           return moreDropdown;
                                //         },
                                //         hintText: '',
                                //         childWidth: 150,
                                //         offset: const Offset(1, 40),
                                //         tooltip: '',
                                //         onSelected: (value) {
                                //
                                //           setState(() {
                                //             if(value == "Edit"){
                                //               editScreenPopUp(context,documentSnapshot);
                                //             }
                                //             if(value=="Delete"){
                                //               deletePopUp(context,displayList[index]['id']);
                                //             }
                                //             if (value=="Change Password"){
                                //               print('----change password---');
                                //               //changePasswordDialog(context, index);
                                //             }
                                //           });
                                //         },
                                //         child: Container(),
                                //       );
                                //     },
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                    ],
                  );

                },),
            ],
          ),

          // const SizedBox(height: 40,),
          //
          // ///Address Details
          // const Divider(height: 1,color: mTextFieldBorder),
          // Column(
          //   children: [
          //     ///Address Header
          //     const SizedBox(
          //       height: 42,
          //       child: Row(children: [Padding(padding: EdgeInsets.only(left: 20),
          //         child: Text("Password",
          //             style: TextStyle(fontWeight: FontWeight.bold)),
          //       ),
          //       ],
          //       ),
          //     ),
          //     const Divider(height: 1,color: mTextFieldBorder),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 60,top: 10,right: 60),
          //       child:
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           ///Left Field
          //           Flexible(
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   const Text("Password"),
          //                   const SizedBox(height: 6,),
          //                   TextFormField(
          //                     obscureText: passWordHindBool,
          //                     enableSuggestions: false,
          //                     controller: passwordController,
          //                     onTap: (){
          //                       setState(() {
          //                         isFocused=true;
          //                       });
          //                     },
          //                     validator: checkPasswordError,
          //                     decoration:  textFieldPasswordDecoration(hintText:"Password", passWordHind:passWordHindBool, error: _invalidPassword, passwordHideAndView: passwordHideAndViewFunc,),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 30,),
          //           ///Right Fields
          //           Flexible(
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   const Text("Confirm Password"),
          //                   const SizedBox(height: 6,),
          //                   TextFormField(
          //                     obscureText: confirmPasswordHide,
          //                     validator: checkConfirmPasswordError,
          //                     controller: confirmPasswordController,
          //                     decoration: textFieldPasswordDecoration(hintText: 'Confirm Password',
          //                         passWordHind: confirmPasswordHide, error: _invalidConfirmPassword, passwordHideAndView: confirmPasswordHideAndViewFunc),
          //                   ),
          //                   const SizedBox(height: 20,),
          //
          //                 ],
          //               ),
          //             ),
          //           )
          //         ],
          //       ),
          //     )
          //   ],
          // ),
          // const SizedBox(height: 50,),
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
      if(userCredential.credential != null){
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
  ///Get Image URL From Firebase storage.
  Future<String?> getImage(masterData) async{
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
   FirebaseStorage storage = FirebaseStorage.instance;
   Reference  ref = storage.ref().child('images/${uid!.substring(0,5)}/$masterData');
 try{
   String downloadURL = await ref.getDownloadURL();
   // print('----downloadURL---');
   // print(downloadURL);
   return downloadURL;
 }
 catch(e){
   return "";
 }
  }

}

//Lower Case Converter Class.
class LowerCaseTextFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toLowerCase(),selection: newValue.selection);
  }
}



// {
//   String userUid="";
//
//   @override
//   initState(){
//     super.initState();
//     getProducts(FirebaseAuth.instance.currentUser!.uid);
//   }
//   //Creating Storage Reference.
//   final storageRef = FirebaseStorage.instance.ref();
//   final CollectionReference _users = FirebaseFirestore.instance.collection("users");
//
//   Future<String?> filePicker(String productName,String description)async {
//     User? user = FirebaseAuth.instance.currentUser;
//     String? uid = user?.uid;
//     userUid=uid!;
//     print('----uid---');
//     print(uid.substring(0,5));
//
//     //File Picker.
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       Uint8List? fileBytes = result.files.first.bytes;
//       String fileName = result.files.first.name;
//
//       try {
//         // Upload file
//         TaskSnapshot taskSnapshot = await storageRef.child('images/${uid.substring(0,5)}/$fileName').putData(fileBytes!);
//
//         // Get download URL
//         String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//
//         print('--------download URl-----');
//         print(downloadUrl.toString());
//
//         ///This Is Checking Current User.
//         try {
//
//           await FirebaseFirestore.instance.collection('users').doc(uid).collection('products').add({
//             'productName': productName,
//             'description': description,
//             'imageUrl': downloadUrl,
//           });
//         } catch (e) {
//           print('Error adding product data: $e');
//         }
//         return downloadUrl;
//       } catch (e) {
//         print('Error uploading file: $e');
//         return null;
//       }
//     }
//     return null;
//   }
//   List storeData=[];
//   Future<List<Map<String, dynamic>>?> getProducts(String userUid) async {
//     try {
//       QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userUid)
//           .collection('products')
//           .get();
//
//
//       List<Map<String, dynamic>> productsList = [];
//       productsSnapshot.docs.forEach((doc) {
//         productsList.add(doc.data() as Map<String, dynamic>);
//         setState(() {
//           storeData= productsList;
//         });
//
//       });
//
//       return productsList;
//     } catch (e) {
//       print('Error getting products: $e');
//       return null;
//     }
//   }
//
//   Future<void> fetchImageData() async {
//     try {
//       // Replace 'imageUrl' with the actual URL of the image in Firebase Storage
//       String imageUrl = 'https://firebasestorage.googleapis.com/v0/b/ikyam-crm.appspot.com/o/images%2FJf1kK%2Fimage3.jfif?alt=media&token=2b480065-ed86-4ae1-9f56-ad5ed93cc27b';
//       final response = await http.get(Uri.parse(imageUrl));
//       print('----');
//       print(response.bodyBytes.runtimeType);
//       //imageData = response.bodyBytes;
//
//       setState(() {});
//     } catch (e) {
//       print('Error fetching image data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: CustomAppBar(),),
//
//       body: Row(children: [
//         CustomDrawer(widget.drawerWidth, widget.selectedDestination),
//         const VerticalDivider(
//           width: 1,
//           thickness: 1,
//         ),
//         Expanded(child: Column(children: [
//           MaterialButton(
//               color: Colors.blue,
//               child:const Text("Upload And Check"),
//               onPressed: (){
//                 filePicker("Ganesh","Govinda").whenComplete(() => getProducts(userUid));
//           }),
//          const Text("Uploaded Master Data"),
//
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: storeData.length,
//               itemBuilder: (context, index) {
//                 print('-----index---');
//                 print(storeData[index]['productName']);
//                 print(storeData);
//                   return Column(
//                     children: [
//                       const SizedBox(height: 5,),
//
//
//                       ///Button Expander.
//                       AnimatedContainer(
//                         height: 200,
//                         duration:const Duration(milliseconds: 0),
//                         child: MaterialButton(
//                           hoverColor: Colors.blue[50],
//                           onPressed: () {  },
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 18.0),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left:10,top: 4.0),
//                                               child: SizedBox(
//                                                 height: 25,
//                                                 child: Text(storeData[index]['productName']),
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left:10,top: 4),
//                                               child: SizedBox(
//                                                 height: 25,
//                                                 child:  Text(storeData[index]['description']),
//                                               ),
//                                             ),
//                                           ),
//
//                                           // Expanded(
//                                           //   child: Padding(
//                                           //     padding: const EdgeInsets.only(left:10,top: 4),
//                                           //     child: SizedBox(
//                                           //       height: 200,
//                                           //       width: 250,
//                                           //       child: Image.memory(storeData[index]['imageUrl']),
//                                           //     ),
//                                           //   ),
//                                           // ),
//                                           // Expanded(
//                                           //   child: Padding(
//                                           //     padding: const EdgeInsets.only(left:10,top: 4),
//                                           //     child: SizedBox(
//                                           //       height: 25,
//                                           //       child: Text(documentSnapshot['role']??""),
//                                           //     ),
//                                           //   ),
//                                           // ),
//
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//
//                                 // SizedBox(
//                                 //   width: 25,
//                                 //   height: 25,
//                                 //   child: LayoutBuilder(
//                                 //     builder: (BuildContext context, BoxConstraints constraints) {
//                                 //       return CustomPopupMenuButton(
//                                 //         decoration: iconDecoration(),
//                                 //         elevation: 4,
//                                 //         itemBuilder: (context) {
//                                 //           return moreDropdown;
//                                 //         },
//                                 //         hintText: '',
//                                 //         childWidth: 150,
//                                 //         offset: const Offset(1, 40),
//                                 //         tooltip: '',
//                                 //         onSelected: (value) {
//                                 //
//                                 //           setState(() {
//                                 //             if(value == "Edit"){
//                                 //               editScreenPopUp(context,documentSnapshot);
//                                 //             }
//                                 //             if(value=="Delete"){
//                                 //               deletePopUp(context,displayList[index]['id']);
//                                 //             }
//                                 //             if (value=="Change Password"){
//                                 //               print('----change password---');
//                                 //               //changePasswordDialog(context, index);
//                                 //             }
//                                 //           });
//                                 //         },
//                                 //         child: Container(),
//                                 //       );
//                                 //     },
//                                 //   ),
//                                 // )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
//                     ],
//                   );
//
//               },),
//           ),
//         ],))
//       ]),
//     );
//   }
// }





