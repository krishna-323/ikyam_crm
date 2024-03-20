import 'dart:developer';
import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as xl;
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../class/arguments_class/argument_class.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_border_with_icon.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import '../widgets/custom_popup_dropdown/custom_popup_dropdown.dart';
import 'create_new_user.dart';

class UserList extends StatefulWidget {
  final UsersListArgs args;
  const UserList({super.key, required this.args});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final CollectionReference _users = FirebaseFirestore.instance.collection("users");
  /// This Function is Login with existing user account.
  Future<void> checkCredentials(String email,String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If sign-in is successful, delete the user account
      await userCredential.user!.delete();


    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again";
      if (e.code == 'user-not-found') {
        errorMessage = "Please enter valid Email";
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password. Try again or click Forgot password to reset it";
        print('Wrong password provided for that user.');
      }
      showErrorDialog(errorMessage);
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

  final _horizontalScrollController = ScrollController();
  final nameController=TextEditingController();
  final phoneController=TextEditingController();
  final roleController=TextEditingController();

  List usersStaticData = [
    {
      "id": 1,
      "name": "Aarav Patel",
      "email": "aarav.patel@example.com",
      "phone": "1234567890",
      "address": "Gujarat",
      "gender": "MALE",
      "pincode": "515405"
    },
    {
      "id": 2,
      "name": "Aaradhya Singh",
      "email": "aaradhya.singh@example.com",
      "phone": "9876543210",
      "address": "Uttar Pradesh",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 3,
      "name": "Ishaan Kumar",
      "email": "ishaan.kumar@example.com",
      "phone": "8765432109",
      "address": "Maharashtra",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 4,
      "name": "Aanya Gupta",
      "email": "aanya.gupta@example.com",
      "phone": "7654321098",
      "address": "Delhi",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 5,
      "name": "Advik Sharma",
      "email": "advik.sharma@example.com",
      "phone": "6543210987",
      "address": "Rajasthan",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 6,
      "name": "Ananya Mishra",
      "email": "ananya.mishra@example.com",
      "phone": "5432109876",
      "address": "Uttarakhand",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 7,
      "name": "Arnav Reddy",
      "email": "arnav.reddy@example.com",
      "phone": "4321098765",
      "address": "Telangana",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 8,
      "name": "Aadhya Gupta",
      "email": "aadhya.gupta@example.com",
      "phone": "3210987654",
      "address": "Punjab",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 9,
      "name": "Kabir Sharma",
      "email": "kabir.sharma@example.com",
      "phone": "2109876543",
      "address": "Haryana",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 10,
      "name": "Saanvi Verma",
      "email": "saanvi.verma@example.com",
      "phone": "1098765432",
      "address": "Madhya Pradesh",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 11,
      "name": "Vihaan Gupta",
      "email": "vihaan.gupta@example.com",
      "phone": "9988776655",
      "address": "Punjab",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 12,
      "name": "Zara Khan",
      "email": "zara.khan@example.com",
      "phone": "9876543211",
      "address": "Uttar Pradesh",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 13,
      "name": "Aarush Singh",
      "email": "aarush.singh@example.com",
      "phone": "8765432110",
      "address": "Maharashtra",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 14,
      "name": "Anvi Gupta",
      "email": "anvi.gupta@example.com",
      "phone": "7654321109",
      "address": "Delhi",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 15,
      "name": "Ansh Sharma",
      "email": "ansh.sharma@example.com",
      "phone": "6543210998",
      "address": "Rajasthan",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 16,
      "name": "Riya Mishra",
      "email": "riya.mishra@example.com",
      "phone": "5432109887",
      "address": "Uttarakhand",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 17,
      "name": "Pranav Reddy",
      "email": "pranav.reddy@example.com",
      "phone": "4321098776",
      "address": "Telangana",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 18,
      "name": "Aaliya Gupta",
      "email": "aaliya.gupta@example.com",
      "phone": "3210987665",
      "address": "Punjab",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 19,
      "name": "Shaurya Sharma",
      "email": "shaurya.sharma@example.com",
      "phone": "2109876554",
      "address": "Haryana",
      "gender": "",
      "pincode": ""
    },
    {
      "id": 20,
      "name": "Ishita Verma",
      "email": "ishita.verma@example.com",
      "phone": "1098765443",
      "address": "Madhya Pradesh",
      "gender": "",
      "pincode": ""
    }
  ];
  List filteredList =[];
  List displayList=[];
  int startVal=0;
  var expandedId="";

  @override
  void initState() {
    // TODO: implement initState.
   filteredList= usersStaticData;

    if(displayList.isEmpty){
      if(filteredList.length>15){
        for(int user=0;user<startVal+15;user++){
          displayList.add(filteredList[user]);
          displayList[user]['isExpanded']=false;
        }
      }
      else{
        for(int user=0;user<filteredList.length;user++){
          displayList.add(filteredList[user]);
          displayList[user]['isExpanded']=false;
        }
      }
    }

    super.initState();
  }


   deleteUserData(int removeMap){
    print('--index---');
    print(removeMap);
    setState(() {
      for(int i=0;i<displayList.length;i++){
        displayList.removeAt(displayList[i][removeMap]);
      }
      Navigator.of(context).pop();
    });
  }


 // Filtered Business PartnerName.
  List _filterBusinessPartnerName(String searchTerm, String key) {
    // FilteredList .
    List filteredList=[];
    // Bool For Declaration.

    bool hasMatch = false;
    // For Lop For Iterating.
    for(var bp in usersStaticData){

      // Matching Item With startsWith Method.
      if(bp[key].toLowerCase().startsWith(searchTerm.toLowerCase())){
        // If Matching Data Adding To Filtered List.
        filteredList.add(bp);
        // Making True For Checking Unmatched Data.
        hasMatch =true;
      }
    }
    // If Unmatched Data  Assigning Filtered List Empty.
    if(hasMatch==false){
      setState(() {
        filteredList=[];
      });
    }
    return filteredList;
  }

  //Fetch Customer Name.
  fetchByCustomerName(String controllerText, String key){
    if(displayList.isEmpty) {
      filteredList =  _filterBusinessPartnerName(controllerText,key);

      if (filteredList.length > 15) {
        for(int i=startVal;i<startVal + 15;i++){
          setState(() {
            displayList.add(filteredList[i]);
            displayList[i]['isExpanded']=false;
          });
        }
      }
      else {
        for(int i=startVal;i<filteredList.length;i++){
          setState(() {
            displayList.add(filteredList[i]);
            displayList[i]['isExpanded']=false;
          });
        }
      }
    }
  }

  ifEmpty(){
    setState(() {
      if(filteredList.length>15){
        for(int user=0;user<startVal+15;user++){
          displayList.add(filteredList[user]);
          displayList[user]['isExpanded']=false;
        }
      }
      else{
        for(int user=0;user<filteredList.length;user++){
          displayList.add(filteredList[user]);
          displayList[user]['isExpanded']=false;
        }
      }

    });
  }

  List <CustomPopupMenuEntry<String>> moreDropdown =<CustomPopupMenuEntry<String>>[
    const CustomPopupMenuItem(
      height: 40,
      value: 'Edit',
      child: Center(
          child: Text(
              'Edit',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14)
          )
      ),
    ),
    const CustomPopupMenuItem(
      height: 40,
      value: 'Delete',
      child: Center(
          child: Text(
              'Delete',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14)
          )
      ),
    ),
    const CustomPopupMenuItem(
      height: 40,
      value: 'Change Password',
      child: Center(
          child: Text(
              'Change Password',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14)
          )
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    double size= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),),
        body:  Row(children: [
        CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
        const VerticalDivider(
          width: 1,
          thickness: 1,
        ),
          if(size>1140)...{
            Expanded(
                child: tableStructure(context,size)
            ),
          }
          else...{
            Expanded(
              child: AdaptiveScrollbar(
                position: ScrollbarPosition.bottom,
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: Colors.grey.withOpacity(0.7),
                sliderActiveColor: Colors.grey,
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: tableStructure(context,1140),
                ),
              ),
            ),
          }
      ]),
    );
  }

  Widget tableStructure(BuildContext context,double screenWidth,){
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[50],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0,right: 40,top: 30,bottom: 30),
          child: Container(
            // Screen Width For Smaller Screen.
            width:screenWidth,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E0E0),)
            ),
            child: Column(children: [

              // Table Header With Names.
              Container(
                //height: 198,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                  ),

                  child: Column(
                    children: [
                      const SizedBox(height: 18,),
                      const Padding(
                        padding: EdgeInsets.only(left: 18.0,right: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Text("Users List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0),
                        child: SizedBox(height: 100,
                          child: Row(
                            children: [
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(  width: 190,height: 30, child: TextFormField(
                                    controller:nameController,
                                    onChanged: (value){
                                      if(value.isEmpty || value==""){
                                        startVal=0;
                                        displayList=[];
                                        filteredList = usersStaticData;
                                        ifEmpty();
                                      }
                                      else if(phoneController.text.isNotEmpty || roleController.text.isNotEmpty){
                                        phoneController.clear();
                                        roleController.clear();
                                      }
                                      else{
                                        startVal=0;
                                        displayList=[];

                                        fetchByCustomerName(nameController.text,"userName");
                                      }
                                    },
                                    style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,
                                    decoration: searchCustomerNameDecoration(hintText: 'Search By Name'),
                                  ),),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                        SizedBox(  width: 190,height: 30, child: TextFormField(
                                          controller:roleController,
                                          onChanged: (value){
                                            if(value.isEmpty || value==""){
                                              startVal=0;
                                              displayList=[];
                                              filteredList =usersStaticData;
                                              ifEmpty();
                                            }
                                            else if(phoneController.text.isNotEmpty || nameController.text.isNotEmpty){
                                              phoneController.clear();
                                              nameController.clear();
                                            }
                                            else{
                                              startVal=0;
                                              displayList=[];
                                              fetchByCustomerName(roleController.text,"role");
                                            }
                                          },
                                          style: const TextStyle(fontSize: 14),
                                          keyboardType: TextInputType.text,
                                          decoration: searchCityNameDecoration(hintText: 'Search By Role'),
                                        ),),
                                        const SizedBox(width: 10,),
                                        SizedBox(  width: 190,height: 30, child: TextFormField(
                                          controller:phoneController,
                                          onChanged: (value){
                                            if(value.isEmpty || value==""){
                                              startVal=0;
                                              displayList=[];
                                              filteredList= usersStaticData;
                                              ifEmpty();
                                            }
                                            else if(nameController.text.isNotEmpty || roleController.text.isNotEmpty){
                                              nameController.clear();
                                              roleController.clear();
                                            }
                                            else{
                                              try{
                                                startVal=0;
                                                displayList=[];
                                               // fetchByCustomerName(phoneController.text,"phone");
                                              }
                                              catch(e){
                                                log(e.toString());
                                              }
                                            }
                                          },
                                          style: const TextStyle(fontSize: 14),
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          maxLength: 10,
                                          decoration: searchCustomerPhoneNumber(hintText: 'Search By Phone'),
                                        ),
                                        ),
                                      ],),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: SizedBox(
                                          width: 100,
                                          height: 30,
                                          child: OutlinedMButton(
                                            text: '+ User',
                                            buttonColor:mSaveButton ,
                                            textColor: Colors.white,
                                            borderColor: mSaveButton,
                                            onTap: () {
                                              Navigator.of(context).push(PageRouteBuilder(
                                                  pageBuilder: (context,animation1,animation2)=>UserCreation(
                                                    drawerWidth: widget.args.drawerWidth,
                                                    selectedDestination: widget.args.selectedDestination,
                                                  ),
                                                  transitionDuration: Duration.zero,
                                                  reverseTransitionDuration: Duration.zero
                                              ));
                                            },

                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                      Container(color: Colors.grey[100],height: 32,
                        child:  IgnorePointer(
                          ignoring: true,
                          child: MaterialButton(
                            onPressed: (){},
                            hoverColor: Colors.transparent,
                            hoverElevation: 0,
                            child:  Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("Customer Name")
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(
                                            height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text('Email')
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("Phone Number")
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("Role")
                                        ),
                                      )),
                                  Padding(
                                    padding:  EdgeInsets.only(top:4,right: 10),
                                    child: Container(),
                                  )
                                  // Center(child: Padding(
                                  //   padding: EdgeInsets.only(right: 8),
                                  //   child: Icon(size: 18,
                                  //     Icons.more_vert,
                                  //     color: Colors.transparent,
                                  //   ),
                                  // ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),

                    ],
                  )
              ),
              ///static user.
              //           ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: displayList.length + 1, // +1 for the pagination row
        //     itemBuilder: (BuildContext context, int index) {
        //     if (index < displayList.length) {
        //       return Column(
        //         children: [
        //           AnimatedContainer(
        //             height: displayList[index]['isExpanded']?91:36,
        //             duration:const Duration(milliseconds: 500),
        //             child: MaterialButton(
        //               hoverColor: Colors.blue[50],
        //               onPressed: () {
        //                setState(() {
        //                  if(expandedId==""){
        //                    setState(() {
        //                      expandedId=displayList[index]['id'].toString();
        //                      displayList[index]['isExpanded']=true;
        //                    });
        //                  }
        //                  else if(expandedId==displayList[index]["id"].toString()){
        //                    setState(() {
        //                      displayList[index]['isExpanded']=false;
        //                      expandedId="";
        //                    });
        //                  }
        //                  else if(expandedId.isNotEmpty || expandedId!=""){
        //                    setState(() {
        //                      for(var val in displayList){
        //                        if(val["id"].toString()==expandedId){
        //                          setState(() {
        //                            val['isExpanded']=false;
        //                            expandedId=displayList[index]['id'].toString();
        //                            displayList[index]['isExpanded']=true;
        //                          });
        //                        }
        //                      }
        //                    });
        //                  }
        //                });
        //
        //               },
        //               child: Padding(
        //                 padding: const EdgeInsets.only(left: 18.0, top: 4, bottom: 3),
        //                 child: Row(
        //                   children: [
        //                     Expanded(
        //                       child: Column(
        //                         children: [
        //                           Row(
        //                             children: [
        //                               Expanded(
        //                                 child: Padding(
        //                                   padding: const EdgeInsets.only(top: 4.0),
        //                                   child: SizedBox(
        //                                     height: 25,
        //                                     child: Text(displayList[index]['name'] ?? ""),
        //                                   ),
        //                                 ),
        //                               ),
        //                               Expanded(
        //                                 child: Padding(
        //                                   padding: const EdgeInsets.only(top: 4),
        //                                   child: SizedBox(
        //                                     height: 25,
        //                                     child: Tooltip(
        //                                       message: displayList[index]['email'] ?? '',
        //                                       waitDuration: const Duration(seconds: 1),
        //                                       child: Text(displayList[index]['email'] ?? '', softWrap: true),
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                               Expanded(
        //                                 child: Padding(
        //                                   padding: const EdgeInsets.only(top: 4),
        //                                   child: SizedBox(
        //                                     height: 25,
        //                                     child: Text(displayList[index]['phone'] ?? ""),
        //                                   ),
        //                                 ),
        //                               ),
        //                               Expanded(
        //                                 child: Padding(
        //                                   padding: const EdgeInsets.only(top: 4),
        //                                   child: SizedBox(
        //                                     height: 25,
        //                                     child: Text(displayList[index]['address'] ?? ""),
        //                                   ),
        //                                 ),
        //                               ),
        //                               const Center(
        //                                 child: Padding(
        //                                   padding: EdgeInsets.only(right: 8),
        //                                   child: Icon(
        //                                     size: 18,
        //                                     Icons.arrow_circle_right,
        //                                     color: Colors.blue,
        //                                   ),
        //                                 ),
        //                               )
        //                             ],
        //                           ),
        //                           displayList[index]["isExpanded"]?
        //                           FutureBuilder (
        //                               future: _show(),
        //                               builder: (context,snapchat) {
        //                                 if(!snapchat.hasData){
        //                                   return const SizedBox();
        //                                 }
        //                                 return Column(
        //                                   children: [
        //                                     const SizedBox(height: 8,),
        //                                     Row(mainAxisAlignment: MainAxisAlignment.center,
        //                                       children: [
        //                                         SizedBox(
        //                                           height: 28,
        //                                           width:80,
        //                                           child: OutlinedBorderWithIcon(
        //                                             buttonText: 'Edit',
        //                                             iconData: Icons.edit,
        //                                             onTap: (){
        //                                               editScreenPopUp(context,displayList[index]);
        //                                           },),
        //                                         ),
        //                                         const SizedBox(width: 20,),
        //                                         SizedBox(   height: 28,
        //                                           width:100,
        //                                           child: OutlinedBorderColorForDelete(
        //                                             buttonText: 'Delete',
        //                                             iconData: Icons.delete,
        //                                              onTap: (){
        //                                               print('----id ------runtype---');
        //                                               print(displayList[index]['id'].runtimeType);
        //
        //                                                 deletePopUp(context,displayList[index]['id']);
        //                                              },),
        //                                         ),
        //                                         const SizedBox(width: 20,),
        //                                         SizedBox(  height: 28,
        //                                           width:160,
        //                                           child: OutlinedBorderWithIcon(
        //                                             buttonText: 'Change Password',
        //                                             iconData: Icons.change_circle_sharp,
        //                                              onTap: (){
        //
        //                                              },),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                     const SizedBox(height: 8,),
        //                                   ],
        //                                 );
        //
        //                               }
        //                           ):const SizedBox(),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
        //         ],
        //       );
        //     } else {
        //       // Pagination row
        //       return Column(
        //         children: [
        //           Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.end,
        //             children: [
        //               Text("${startVal+15>filteredList.length?filteredList.length:startVal+1}-${startVal+15>filteredList.length?filteredList.length:startVal+15} of ${filteredList.length}",style: const TextStyle(color: Colors.grey)),
        //               const SizedBox(width: 10),
        //               Material(
        //                 color: Colors.transparent,
        //                 child: InkWell(
        //                   hoverColor: mHoverColor,
        //                   child: const Padding(
        //                     padding: EdgeInsets.all(18.0),
        //                     child: Icon(Icons.arrow_back_ios_sharp, size: 12),
        //                   ),
        //                   onTap: () {
        //                     if (startVal > 14) {
        //                       displayList.clear();
        //                       startVal = startVal - 15;
        //                       for (int i = startVal; i < startVal + 15; i++) {
        //                         try {
        //                           setState(() {
        //                             displayList.add(filteredList[i]);
        //                           });
        //                         } catch (e) {
        //                           log(e.toString());
        //                         }
        //                       }
        //                     } else {
        //                       log('else');
        //                     }
        //                   },
        //                 ),
        //               ),
        //               const SizedBox(width: 10),
        //               Material(
        //                 color: Colors.transparent,
        //                 child: InkWell(
        //                   hoverColor: mHoverColor,
        //                   child: const Padding(
        //                     padding: EdgeInsets.all(18.0),
        //                     child: Icon(Icons.arrow_forward_ios, size: 12),
        //                   ),
        //                   onTap: () {
        //                     if (filteredList.length > startVal + 15) {
        //                       displayList.clear();
        //                       startVal = startVal + 15;
        //                       for (int i = startVal; i < startVal + 15; i++) {
        //                         try {
        //                           setState(() {
        //                             filteredList[i]['isExpanded']=false;
        //                             displayList.add(filteredList[i]);
        //                             expandedId="";
        //                           });
        //                         } catch (e) {
        //                           log(e.toString());
        //                         }
        //                       }
        //                     }
        //                     setState(() {});
        //                   },
        //                 ),
        //               ),
        //               const SizedBox(width: 20),
        //             ],
        //           ),
        //         ],
        //       );
        //     }
        //   },
        // ),
              ///firestore database
              StreamBuilder(
                stream: _users.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasData){
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                          return Column(
                            children: [

                              ///Animated Expander.
                              // AnimatedContainer(
                              //   height: displayList[index]['isExpanded']?91:36,
                              //   duration:const Duration(milliseconds: 500),
                              //   child: MaterialButton(
                              //     hoverColor: Colors.blue[50],
                              //     onPressed: () {
                              //       setState(() {
                              //         if(expandedId==""){
                              //           setState(() {
                              //             expandedId=displayList[index]['id'].toString();
                              //             displayList[index]['isExpanded']=true;
                              //           });
                              //         }
                              //         else if(expandedId==displayList[index]["id"].toString()){
                              //           setState(() {
                              //             displayList[index]['isExpanded']=false;
                              //             expandedId="";
                              //           });
                              //         }
                              //         else if(expandedId.isNotEmpty || expandedId!=""){
                              //           setState(() {
                              //             for(var val in displayList){
                              //               if(val["id"].toString()==expandedId){
                              //                 setState(() {
                              //                   val['isExpanded']=false;
                              //                   expandedId=displayList[index]['id'].toString();
                              //                   displayList[index]['isExpanded']=true;
                              //                 });
                              //               }
                              //             }
                              //           });
                              //         }
                              //       });
                              //
                              //     },
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(left: 18.0, top: 4, bottom: 3),
                              //       child: Row(
                              //         children: [
                              //           Expanded(
                              //             child: Column(
                              //               children: [
                              //                 Row(
                              //                   children: [
                              //                     Expanded(
                              //                       child: Padding(
                              //                         padding: const EdgeInsets.only(top: 4.0),
                              //                         child: SizedBox(
                              //                           height: 25,
                              //                           child: Text(documentSnapshot['userName']),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     Expanded(
                              //                       child: Padding(
                              //                         padding: const EdgeInsets.only(top: 4),
                              //                         child: SizedBox(
                              //                           height: 25,
                              //                           child: Tooltip(
                              //                             message: documentSnapshot['email'],
                              //                             waitDuration: const Duration(seconds: 1),
                              //                             child: Text(documentSnapshot['email'], softWrap: true),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     Expanded(
                              //                       child: Padding(
                              //                         padding: const EdgeInsets.only(top: 4),
                              //                         child: SizedBox(
                              //                           height: 25,
                              //                           child: Text(documentSnapshot['phone']??""),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     Expanded(
                              //                       child: Padding(
                              //                         padding: const EdgeInsets.only(top: 4),
                              //                         child: SizedBox(
                              //                           height: 25,
                              //                           child: Text(documentSnapshot['role']??""),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     const Center(
                              //                       child: Padding(
                              //                         padding: EdgeInsets.only(right: 8),
                              //                         child: Icon(
                              //                           size: 18,
                              //                           Icons.arrow_circle_right,
                              //                           color: Colors.blue,
                              //                         ),
                              //                       ),
                              //                     )
                              //                   ],
                              //                 ),
                              //                 displayList[index]["isExpanded"]?
                              //                 FutureBuilder (
                              //                     future: _show(),
                              //                     builder: (context,snapchat) {
                              //                       if(!snapchat.hasData){
                              //                         return const SizedBox();
                              //                       }
                              //                       return Column(
                              //                         children: [
                              //                           const SizedBox(height: 8,),
                              //                           Row(mainAxisAlignment: MainAxisAlignment.center,
                              //                             children: [
                              //                               SizedBox(
                              //                                 height: 28,
                              //                                 width:80,
                              //                                 child: OutlinedBorderWithIcon(
                              //                                   buttonText: 'Edit',
                              //                                   iconData: Icons.edit,
                              //                                   onTap: (){
                              //
                              //                                     editScreenPopUp(context,documentSnapshot);
                              //                                   },),
                              //                               ),
                              //                               const SizedBox(width: 20,),
                              //                               SizedBox(   height: 28,
                              //                                 width:100,
                              //                                 child: OutlinedBorderColorForDelete(
                              //                                   buttonText: 'Delete',
                              //                                   iconData: Icons.delete,
                              //                                   onTap: (){
                              //                                     deletePopUp(context,displayList[index]['id']);
                              //                                   },),
                              //                               ),
                              //                               const SizedBox(width: 20,),
                              //                               SizedBox(  height: 28,
                              //                                 width:160,
                              //                                 child: OutlinedBorderWithIcon(
                              //                                   buttonText: 'Change Password',
                              //                                   iconData: Icons.change_circle_sharp,
                              //                                   onTap: (){
                              //
                              //                                   },),
                              //                               ),
                              //                             ],
                              //                           ),
                              //                           const SizedBox(height: 8,),
                              //                         ],
                              //                       );
                              //
                              //                     }
                              //                 ):const SizedBox(),
                              //               ],
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              ///Button Expander.
                              AnimatedContainer(
                                height: 36,
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
                                                        child: Text(documentSnapshot['userName']),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left:10,top: 4),
                                                      child: SizedBox(
                                                        height: 25,
                                                        child: Tooltip(
                                                          message: documentSnapshot['email'],
                                                          waitDuration: const Duration(seconds: 1),
                                                          child: Text(documentSnapshot['email'], softWrap: true),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left:10,top: 4),
                                                      child: SizedBox(
                                                        height: 25,
                                                        child: Text(documentSnapshot['phone']??""),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left:10,top: 4),
                                                      child: SizedBox(
                                                        height: 25,
                                                        child: Text(documentSnapshot['role']??""),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: LayoutBuilder(
                                            builder: (BuildContext context, BoxConstraints constraints) {
                                              return CustomPopupMenuButton(
                                                decoration: iconDecoration(),
                                                elevation: 4,
                                                itemBuilder: (context) {
                                                  return moreDropdown;
                                                },
                                                hintText: '',
                                                childWidth: 150,
                                                offset: const Offset(1, 40),
                                                tooltip: '',
                                                onSelected: (value) {

                                                  setState(() {
                                                    if(value == "Edit"){
                                                      editScreenPopUp(context,documentSnapshot);
                                                    }
                                                    if(value=="Delete"){
                                                      deletePopUp(context,displayList[index]['id']);
                                                    }
                                                    if (value=="Change Password"){
                                                      print('----change password---');
                                                      //changePasswordDialog(context, index);
                                                    }
                                                  });
                                                },
                                                child: Container(),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                            ],
                          );

                        },),
                    );
                  }
                  else{

                  }
                  return const Center(
                    child: Text("Loading....."),
                  );
                },
              ),
          ]),
          ),
        ),
      ),
    );
  }

  Future _show() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Edit Screen.
   editScreenPopUp(BuildContext context,DocumentSnapshot displayList){
    return  showDialog(
      context: context,
      builder: (context) {
        var nameController = TextEditingController();
        var emailController = TextEditingController();
        var mobileController = TextEditingController();
        var addressController = TextEditingController();
        var pinCodeController = TextEditingController();
        final roleTypeController =TextEditingController();

        nameController.text=displayList['userName'];
        emailController.text=displayList['email'];
        mobileController.text=displayList['phone'];
        // addressController.text=displayList['address'];
        // pinCodeController.text=displayList['pincode'];
        roleTypeController.text=displayList['role'];

        List<String> roleType=['User','Admin'];
        String selectedRoleType='Select Role Type';
        bool  invalidName = false;
        bool invalidEmail = false;
        bool invalidMobile = false;
        bool invalidPin = false;
        bool invalidAddress = false;
        bool isRoleFocused=false;
        bool invalidGenderType=false;


        String? checkNameError(String? value) {
          if (value == null || value.isEmpty) {
            setState(() {
              invalidName=true;
            });
            return 'Please Enter Name';
          }
          setState(() {
            invalidName=false;
          });
          return null;
        }
        String? checkMobileError(String? value) {
          if(value == null || value.isEmpty) {
            setState(() {
              invalidMobile=true;
            });
            return 'Please Enter Mobile Number.';
          }
          setState(() {
            invalidMobile=false;
          });
          return null;
        }
        String? checkAddressError(String? value){
          if(value == null || value.isEmpty){
            setState(() {
              invalidAddress = true;
            });
            return "Please Enter Address";
          }
          setState(() {
            invalidAddress = false;
          });
          return null;
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
        String? checkPinError(String? value){
          if(value == null || value.isEmpty){
            setState(() {
              invalidPin = true;
            });
            return "Enter Pin";
          }
          setState(() {
            invalidPin = false;
          });
          return null;
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

        final editDetails = GlobalKey<FormState>();

        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {
              // Assigning variables.
              return SizedBox(
                width: 700,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: editDetails,
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                // Top container.
                                Container(color: Colors.grey[100],
                                  child: IgnorePointer(ignoring: true,
                                    child: MaterialButton(
                                      hoverColor: Colors.transparent,
                                      onPressed: () {

                                      },
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Edit User Details',
                                                style: TextStyle(fontWeight: FontWeight.bold,
                                                  fontSize: 16,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(height: 1,color:mTextFieldBorder),
                                FocusTraversalGroup(
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
                                                      decoration: textFieldDecoration(hintText: 'Enter Name',error:invalidName),
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
                                                      //validator: checkEmailError,
                                                      validator: (value){
                                                        if (value == null || value.isEmpty) {
                                                          setState(() {
                                                            invalidEmail = true;
                                                          });
                                                          return "Enter Email Id";
                                                        }
                                                        else if(!EmailValidator.validate(value)){
                                                          setState(() {
                                                            invalidEmail=true;
                                                          });
                                                          return 'Please enter a valid email address';
                                                        }
                                                        else {
                                                          setState(() {
                                                            invalidEmail = false;
                                                          });
                                                        }
                                                        return null;
                                                      },
                                                      decoration: textFieldDecoration(hintText: 'Enter Email',error: invalidEmail),
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
                                                      controller: mobileController,
                                                      validator: checkMobileError,
                                                      decoration: textFieldDecoration(hintText: 'Enter Mobile Number',error: invalidMobile),),
                                                    const SizedBox(height: 20,),

                                                    const Text("Role"),
                                                    const SizedBox(height: 6,),
                                                    Focus(
                                                      onFocusChange: (value) {
                                                        setState(() {
                                                          isRoleFocused = value;
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
                                                                    invalidGenderType=true;
                                                                  });
                                                                  return null;
                                                                }
                                                                return null;
                                                              },
                                                              decoration: customPopupDecoration(hintText: 'Select Role Type',error: invalidGenderType,isFocused: isRoleFocused),
                                                              hintText: selectedRoleType,
                                                              textController: roleTypeController,
                                                              childWidth: constraints.maxWidth,
                                                              shape:  RoundedRectangleBorder(
                                                                side: BorderSide(color:invalidGenderType? Colors.redAccent :mTextFieldBorder),
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
                                                                  selectedRoleType= value;
                                                                  invalidGenderType=false;
                                                                });

                                                              },
                                                              onCanceled: () {

                                                              },
                                                              child: Container(),
                                                            );
                                                          }
                                                      ),
                                                    ),

                                                    if(invalidGenderType)
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
                                  //     Row(
                                  //       children: [
                                  //         Flexible(
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.only(left: 68,top: 20,right: 68),
                                  //             child: Column(
                                  //               crossAxisAlignment: CrossAxisAlignment.start,
                                  //               children: [
                                  //                 const Text("Street Address"),
                                  //                 const SizedBox(height: 6,),
                                  //                 TextFormField(
                                  //                   onTap: (){
                                  //                     setState(() { });
                                  //                   },
                                  //                   validator: checkAddressError,
                                  //                   controller: addressController,
                                  //                   decoration: textFieldDecoration(hintText: 'Enter Your  Address',error: invalidAddress),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Flexible(
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.only(left: 68,top: 20,right: 68),
                                  //             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  //               children: [
                                  //                 const Text("Pin Code"),
                                  //                 const SizedBox(height: 6,),
                                  //                 TextFormField(
                                  //                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  //                   keyboardType: TextInputType.number,
                                  //                   maxLength: 6,
                                  //                   validator: checkPinError,
                                  //                   controller: pinCodeController,
                                  //                   decoration: textFieldDecoration(hintText: 'Enter Pin Code',error: invalidPin),
                                  //                 ),
                                  //                 const SizedBox(height: 20,),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //
                                  //
                                  //   ],
                                  // ),
                                  const SizedBox(height: 25,),
                                  Align(alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 120,
                                      height: 30,
                                      child: OutlinedMButton(
                                        textColor: mSaveButton,
                                        borderColor: mSaveButton,
                                        onTap: (){
                                          print('-------displayList---');
                                          print(displayList.id);
                                          if(editDetails.currentState!.validate()){
                                            Map customerDetails = {
                                              'userName':nameController.text,
                                              'email': emailController.text,
                                              'phone': mobileController.text,
                                              'role': roleTypeController.text,
                                              "userUid":displayList['userUid']
                                            };
                                            updateDocument(customerDetails);
                                            //Navigator.of(context).pop();
                                          }
                                        }, text: 'Save',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25,)
                                ],
                               ),
                               ),
                              ],
                            ),
                          ),
                        ),
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

  // DeletePopUp.
  deletePopUp(BuildContext context,int removeMap){
    return  showDialog(
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
                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
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
                                  fontSize: 16),
                            )),
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 50,
                              height:30,
                              child: OutlinedMButton(
                                text: 'Ok',
                                buttonColor:Colors.red ,
                                textColor: Colors.white,
                                borderColor: Colors.red,
                                onTap:(){
                                 setState((){
                                 //displayList.removeWhere((element) => element['id']==);
                                 });

                                    Navigator.of(context).pop();

                                  //deleteUserData(removeMap);
                                },
                              ),
                            ),
                            SizedBox(

                              width: 100,
                              height:30,
                              child: OutlinedMButton(
                                text: 'Cancel',
                                buttonColor:mSaveButton ,
                                textColor: Colors.white,
                                borderColor: mSaveButton,
                                onTap:(){
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),

                          ],
                        )
                      ],
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
  // Search textField Decoration.
  searchCustomerNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: nameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              nameController.clear();
              startVal=0;
              displayList=[];
             filteredList = usersStaticData;
              ifEmpty();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  searchCityNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: roleController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              roleController.clear();
              startVal=0;
              displayList=[];
             filteredList= usersStaticData;
             ifEmpty();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  searchCustomerPhoneNumber ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: phoneController.text.isEmpty? const Icon(Icons.search,size: 18,):InkWell(
          onTap: (){
            setState(() {
              setState(() {
                phoneController.clear();
                startVal=0;
                displayList=[];
                filteredList= usersStaticData;
                ifEmpty();
              });
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  iconDecoration() {
    return const InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: Icon(Icons.more_vert, color:Colors.black),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      constraints: BoxConstraints(maxHeight: 35),
      hintStyle: TextStyle(fontSize: 14, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: EdgeInsets.fromLTRB(12, 00, 0, 0),
    );
  }
 // Upload User async Function.
  Future _loadCSVorXlSX() async {
    // Wait Key Word ,For Selecting Type Of Files.(File type picking "csv" or "xlsx")
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["xlsx",],
        allowMultiple: true
    );
    final typeOfFile =result?.files.single.name;
    try{
      if(result==null || result.files.isEmpty){
        setState(() {
          // displayData=[];
          // newData=[];
        });
        return null;
      }
      else if(typeOfFile!.endsWith(".xlsx")){
        var bytes = result.files.single.bytes;
        if(bytes!=null){
          var excel = xl.Excel.decodeBytes(bytes);
          //newData=[];
          for (var table in excel.tables.keys) {
            for(int i=1;i<excel.tables[table]!.rows.length;i++){
              // print('-----check here---');
              // print(excel.tables[table]!.rows[i][0]!.props.first.toString());
              Map storeStaticUsers = {
                'id': excel.tables[table]!.rows[i][0]!.props.first.toString(),
                'name': excel.tables[table]!.rows[i][1]!.props.first.toString(),
                'email': excel.tables[table]!.rows[i][2]!.props.first.toString(),
                'phone': excel.tables[table]!.rows[i][3]!.props.first.toString(),
                'address': excel.tables[table]!.rows[i][4]!.props.first.toString(),
                'gender': excel.tables[table]!.rows[i][5]!.props.first.toString(),
                'pincode': excel.tables[table]!.rows[i][6]!.props.first.toString(),
              };
              setState(() {
                filteredList.add(storeStaticUsers);
              });
              // print('----------check this----');
              // print(usersStaticData.length);
            }
          }

        }
      }
      else{
        log('Unsupported file');
      }
    }
    catch(e){
      log(e.toString());
    }
  }

  ///Cloud Firestore and Firebase email Update.
  void updateDocument(Map displayList) async {
    try {
      // Get a reference to the document you want to update
      DocumentReference documentRef = FirebaseFirestore.instance.collection('users').doc(displayList["userUid"]);

      // Perform the update
      await documentRef.update({
        "userName": displayList['userName'],
        "email": displayList['email'],
        "phone":displayList['phone'],
        "role":displayList['role']
      });
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User Details Updated Successfully."),duration: Duration(milliseconds: 5000),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

}
