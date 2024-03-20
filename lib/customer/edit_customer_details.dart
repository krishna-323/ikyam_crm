import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../class/arguments_class/argument_class.dart';
import '../dashboard/home_screen.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import '../widgets/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../widgets/custom_search_text_field/custom_search.dart';
import '../utils/static_files/list.dart';
import '../utils/static_files/static_colors.dart';
import 'package:http/http.dart'as http;

import 'list_customer.dart';

class EditCustomerDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final  Map storeData;
 const  EditCustomerDetails({super.key,
    required this.drawerWidth,
    required this.selectedDestination, required this.storeData,});

  @override
  State<EditCustomerDetails> createState() => _EditCustomerDetailsState();
}

class _EditCustomerDetailsState extends State<EditCustomerDetails> {
  @override
  void initState() {
    // TODO: implement initState
   ///BTP Fields Initialization.
  //nameController.text=widget.storeData['BusinessPartnerFullName']??"";
  //mobileController.text=widget.storeData['BusinessPartner']??"";
  //statusTypeController.text=widget.storeData["YY1_Value_busT"]??"";
  // emailController.text=widget.storeData['email'];
  // panController.text=widget.storeData['PAN'];
  // addressController.text=widget.storeData['address'];
  // pinCodeController.text=widget.storeData['pincode'];
  // stateController.text=widget.storeData['state'];
  // distController.text=widget.storeData['dist'];
    ///aws Fields Initialization.
    nameController.text=widget.storeData['customerName']??"";
    distController.text=widget.storeData['district']??"";
    emailController.text=widget.storeData['email']??"";
    mobileController.text=widget.storeData['mobileNumber']??"";
    panController.text=widget.storeData['pan']??"";
    pinCodeController.text=widget.storeData['pinCode']??"";
    projectValueController.text= widget.storeData['projectValue']??"";
    statusTypeController.text=widget.storeData["selectStage"]??"";
    stateController.text=widget.storeData['state']??"";
    addressController.text=widget.storeData['streetAddress']??"";

    super.initState();
  }
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var panController = TextEditingController();
  var mobileController = TextEditingController();
  var projectValueController = TextEditingController();
  var addressController = TextEditingController();
  var pinCodeController = TextEditingController();

  //This  declaration for state.
  final stateController=TextEditingController();
  final distController=TextEditingController();
  String selectedType='Select Type';

  bool  _invalidName = false;
  bool _invalidEmail = false;
  bool _invalidPan = false;
  bool _invalidMobile = false;
  bool _invalidProjectValue = false;
  bool _invalidPin = false;
  bool _invalidAddress = false;
  bool stateError=false;
  bool distError=false;

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

  String? checkPanError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidPan=true;
      });
      return 'Please Enter Pan Number.';
    }
    setState(() {
      _invalidPan=false;
    });
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

  String? checkProjectValueError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidProjectValue=true;
      });
      return 'Please Enter GST.';
    }
    setState(() {
      _invalidProjectValue=false;
    });
    return null;
  }

  String? checkAddressError(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidAddress = true;
      });
      return "Please Enter Address";
    }
    setState(() {
      _invalidAddress = false;
    });
    return null;
  }

  String? checkPinError(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidPin = true;
      });
      return "Enter Pin";
    }
    setState(() {
      _invalidPin = false;
    });
    return null;
  }
  String? stateCheck(String ?value){
    if(value==null || value.isEmpty){
      setState(() {
        stateError=true;
      });
      return 'Select State';
    }
    setState(() {
      stateError=false;
    });
    return null;

  }
  String? distCheck(String ?value){
    if(value==null || value.isEmpty){
      setState(() {
        distError=true;
      });
      return 'Select Dist';
    }
    setState(() {
      distError=false;
    });
    return null;

  }


  List storeDist=[];

  //This two are async function (state,dist).
  Future getStateNames()async{
    List list=[];
    for(int i=0;i<states.length;i++){
      list.add(SearchState.fromJson(states[i]));
    }
    return list;
  }

  Future getDistName()async{
    List storeDistNames=[];

    for(int i=0;i<storeDist.length;i++){
      //Here adding each and every name.
      storeDistNames.add(SearchDist.fromJson(storeDist[i]));
    }
    return storeDistNames;
  }

  bool isFocused =false;
  final _formKey=GlobalKey<FormState>();


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
  final _horizontalScrollController = ScrollController();
  //Business Partner Status Dropdown Declaration.
  final statusTypeController =TextEditingController();
  bool _isTypeFocused =false;
  bool _invalidStatusType =false;
  String selectedStatusType="Select Stage";
  List<String> selectStatusType=[
    "Awareness",
    "Interest",
    "Consideration",
    "Intent",
    'Buy',
    // "Opportunity",
    // "Proposal",
    // "Demo",
    // "Negotiation",
    // "Closed Won",
    // "Closed Lost"
  ];

  ///aws postApi.
  awsUpdateApi()async{
    String url ="https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/customerdetails/update_customerdetails";
    Map requestData={
      "customerDetailsId": widget.storeData["customerDetailsId"]??"",
      "customerName":nameController.text ,
      "district": distController.text,
      "email": emailController.text,
      "mobileNumber":mobileController.text,
      "pan": panController.text,
      "pinCode": pinCodeController.text,
      "projectValue": projectValueController.text,
      "selectStage": statusTypeController.text,
      "state": stateController.text,
      "streetAddress": addressController.text,
    };

    final resData = await http.put(Uri.parse(url),
        headers: {
          "Content-Type":"application/json",
        },
        body:jsonEncode(requestData));
    final responseBody =jsonDecode(resData.body);

    try{
      if(responseBody.containsKey('error')){
        if(mounted){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return  AlertDialog(
                title: const Text('Error'),
                content: const SelectableText('Somthing went wrong!!!!!!!!!!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
      else{

        if(mounted){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: SelectableText('Business Partner ID ${responseBody['id']} is Updated'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
                          CustomerList(arg: CustomerListArgs(
                              drawerWidth: widget.drawerWidth,
                              selectedDestination: widget.selectedDestination),),));
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
      return jsonDecode(resData.body);
    }
    catch(e){
      print('--------Error------');
      print(e);
    }


  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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

          if(screenWidth>1100)...{
            Expanded(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: AppBar(automaticallyImplyLeading: false,
                    leading: IconButton(onPressed: (){
                      Navigator.of(context).pop();
                     // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),));
                    },
                      icon: const Icon(Icons.arrow_back),),
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Edit Customer Details"),
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
                                //Calling Update Api.
                                awsUpdateApi();
                              }
                            }, text: 'Update',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
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
          }
         else...{
            Expanded(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: AppBar(automaticallyImplyLeading: false,
                    leading: IconButton(onPressed: (){
                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),));
                    }, icon: const Icon(Icons.arrow_back),),
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Customer Details Entry Form"),
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
                                  "city":stateController.text,
                                  "email_id" : emailController.text,
                                  "gstin" : projectValueController.text,
                                  "location":distController.text,
                                  "mobile" :mobileController.text,
                                  "pan_number" : panController.text,
                                  "pin_code" : pinCodeController.text,
                                  "street_address" : addressController.text,
                                  "type" : selectedType
                                };

                                Navigator.of(context).pop();
                                print(customerDetails);
                              }
                            }, text: 'Update',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Center(
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
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                              width: 1100,
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
          }


        ],),

    );
  }

  Widget buildCustomerCard(){
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Customer Details
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
                      child: Row(children: [Text("Customer Details",style: TextStyle(fontWeight: FontWeight.bold),),],
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
                            const Text("Customer Name"),
                           // const Text("BusinessPartnerFullName"),
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
                            // const Text("Status Type"),
                            // const SizedBox(height: 6,),
                            // Focus(
                            //   onFocusChange: (value) {
                            //     setState(() {
                            //       _isTypeFocused = value;
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
                            //                 _invalidStatusType=true;
                            //               });
                            //               return null;
                            //             }
                            //             return null;
                            //           },
                            //           decoration: customPopupDecoration(hintText: 'Select type',error: _invalidStatusType,isFocused: _isTypeFocused),
                            //           hintText: selectedStatusType,
                            //           textController: statusTypeController,
                            //           childWidth: constraints.maxWidth,
                            //           shape:  RoundedRectangleBorder(
                            //             side: BorderSide(color:_invalidStatusType? Colors.redAccent :mTextFieldBorder),
                            //             borderRadius: const BorderRadius.all(
                            //               Radius.circular(5),
                            //             ),
                            //           ),
                            //           offset: const Offset(1, 40),
                            //           tooltip: '',
                            //           itemBuilder:  (BuildContext context) {
                            //             return selectStatusType.map((value) {
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
                            //               statusTypeController.text=value;
                            //               selectedStatusType= value;
                            //               _invalidStatusType=false;
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
                            // const SizedBox(height: 20,),
                            const Text("PAN"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              controller: panController,
                              validator: checkPanError,
                              decoration: textFieldDecoration(hintText: 'Enter Pan Number',error: _invalidPan),
                            )

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
                           // const Text("BusinessPartner"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              controller: mobileController,
                              validator: checkMobileError,
                              decoration: textFieldDecoration(hintText: 'Enter Mobile Number',error: _invalidMobile),),
                            const SizedBox(height: 20,),

                            const Text("Project Value"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                              ],
                              controller: projectValueController,
                              validator: checkProjectValueError,
                              decoration: textFieldDecoration(hintText: 'Enter Project Value',error: _invalidProjectValue),),
                            const SizedBox(height: 20,),

                            const Text("Select Stage"),
                            const SizedBox(height: 6,),
                            Focus(
                              onFocusChange: (value) {
                                setState(() {
                                  _isTypeFocused = value;
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
                                            _invalidStatusType=true;
                                          });
                                          return null;
                                        }
                                        return null;
                                      },
                                      decoration: customPopupDecoration(hintText: 'Select Stage',error: _invalidStatusType,isFocused: _isTypeFocused),
                                      hintText: selectedStatusType,
                                      textController: statusTypeController,
                                      childWidth: constraints.maxWidth,
                                      shape:  RoundedRectangleBorder(
                                        side: BorderSide(color:_invalidStatusType? Colors.redAccent :mTextFieldBorder),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      offset: const Offset(1, 40),
                                      tooltip: '',
                                      itemBuilder:  (BuildContext context) {
                                        return selectStatusType.map((value) {
                                          return CustomPopupMenuItem(
                                            value: value,
                                            text:value,
                                            child: Container(),
                                          );
                                        }).toList();
                                      },

                                      onSelected: (String value)  {
                                        setState(() {
                                          statusTypeController.text = value;
                                          selectedStatusType= value;
                                          _invalidStatusType=false;
                                        });

                                      },
                                      onCanceled: () {

                                      },
                                      child: Container(),
                                    );
                                  }
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
                  child: Text("Address Details",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ],
                ),
              ),
              const Divider(height: 1,color: mTextFieldBorder),
              Padding(
                padding: const EdgeInsets.only(left: 68,top: 20,right: 68),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Street Address"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      onTap: (){
                        setState(() {
                          isFocused=true;
                        });
                      },
                      validator: checkAddressError,
                      controller: addressController,
                      decoration: textFieldDecoration(hintText: 'Enter Your  Address',error: _invalidAddress),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60,top: 12,right: 60),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Pin Code"),
                              const SizedBox(height: 6,),
                              TextFormField(
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                validator: checkPinError,
                                controller: pinCodeController,
                                decoration: textFieldDecoration(hintText: 'Enter Pin Code',error: _invalidPin),
                              ),
                              const SizedBox(height: 20,),
                              const Text("Dist"),
                              const SizedBox(height: 6,),
                              CustomTextFieldSearch(
                                validator: distCheck,
                                showAdd: false,
                                getSelectedValue: (SearchDist dist){
                                  setState(() {
                                    distController.text=distController.text;
                                  });
                                },
                                decoration: textFieldDistSelect(hintText: 'Search Dist',error: distError),
                                future: (){
                                  return getDistName();
                                },
                                controller: distController,
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(width: 30,),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("State"),
                          const SizedBox(height: 6,),
                          CustomTextFieldSearch(
                            validator: stateCheck,
                            showAdd: false,
                            decoration: textFieldStateName(hintText: 'Search State',error: stateError),
                            // initialList: states,
                            future: (){
                              return getStateNames();
                            },
                            controller: stateController,
                            getSelectedValue: (SearchState value){
                              setState(() {
                                storeDist=distName[stateController.text];
                              });
                              // print('------------inside-----');
                              // print(storeDist);
                            },

                          ),
                          const SizedBox(height: 20,),

                        ],
                      ),
                    ))
                  ],
                ),
              )

            ],
          ),
          const SizedBox(height: 50,),

          const SizedBox(height: 20,),
        ],
      ),
    );
  }
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
  textFieldStateName({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: stateController.text.isEmpty?const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.search,),
      ):
      InkWell(onTap: (){
        setState(() {
          stateController.clear();
          distController.clear();
        });

      },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.close,color: Colors.grey,),
          )),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldDistSelect({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: distController.text.isEmpty?const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.search,),
      ):InkWell(onTap: (){
        setState(() {
          distController.clear();
        });

      },child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.close,color: Colors.grey,),
      )),

      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toLowerCase(),selection: newValue.selection);
  }
}

// class.
class SearchDist{
  final String label;
  dynamic value;
  SearchDist({required this.label,required this.value});
  factory SearchDist.fromJson(String distName){
    return SearchDist(label: distName,
      value: distName,
    );
  }
}

class SearchState {
  final String label;
  dynamic value;

  SearchState({required this.label, this.value});

  factory SearchState.fromJson(String stateName) {
    return SearchState(label: stateName, value: stateName);
  }
}