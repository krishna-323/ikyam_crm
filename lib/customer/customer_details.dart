import 'dart:convert';
import 'dart:developer';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../class/arguments_class/argument_class.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import '../widgets/input_decoration_text_field.dart';
import 'customer_creation.dart';
import 'edit_customer_details.dart';
import 'package:http/http.dart'as http;

import 'list_customer.dart';

class ViewCustomerDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map displayData;
  final List<dynamic> customerList;
   const ViewCustomerDetails({super.key, required this.drawerWidth,
      required this.selectedDestination,
      required this.displayData,
     required this.customerList,
   });

  @override
  State<ViewCustomerDetails> createState() => _ViewCustomerDetailsState();
}

class _ViewCustomerDetailsState extends State<ViewCustomerDetails> {
  final _horizontalScrollController = ScrollController();
  Map storeStaticData={};



 late AutoScrollController controller=AutoScrollController();


 List staticCustomerData=[];

 String selectedId="";

  int scrollIndex=0;


  @override
  void initState() {
    // TODO: implement initState.
    // All Business Partner List.
    staticCustomerData = widget.customerList;

    // Displayed Item Data.
    storeStaticData = widget.displayData;

    // Matching Business Partner ID.
    selectedId = storeStaticData['customerDetailsId']??"";

    // Scrolling To Index.
    // if(staticCustomerData.isNotEmpty){
    //   Future.delayed(const Duration(milliseconds: 500),() {
    //     for(int i = 0; i < staticCustomerData.length; i++) {
    //       if(selectedId == staticCustomerData[i]['BusinessPartner']) {
    //         scrollToName(i);
    //       }
    //     }
    //   });
    // }

   /// Selected Index Displaying it In First Place.(BTP)
   //  for(int i=0;i<staticCustomerData.length;i++){
   //    if(storeStaticData['BusinessPartner']==staticCustomerData[i]['BusinessPartner'] ){
   //          staticCustomerData.removeAt(i);
   //          staticCustomerData.insert(0, storeStaticData);
   //    }
   //  }
    ///selected index displaying it in first place (aws).
    for(int i=0;i<staticCustomerData.length;i++){
      if(storeStaticData['customerDetailsId']==staticCustomerData[i]['customerDetailsId'] ){
        staticCustomerData.removeAt(i);
        staticCustomerData.insert(0, storeStaticData);
      }
    }

    super.initState();
  }


  // Scrolling To Particular Index Position.
  Future scrollToName(int index)async{
    await controller.scrollToIndex(index,preferPosition: AutoScrollPosition.values[scrollIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),),

      body: Row(
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(thickness: 1,width: 1,),

          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              if(constraints.maxWidth>=1140){
                return  Scaffold(
                  backgroundColor: Colors.white,
                  body: Row(
                    children: [
                      sideScroller(300),
                      const VerticalDivider(width: 1,),

                      Expanded(child: profileTab(context, 1140)),
                    ],
                  ),
                );
              }
              else{
                return
                  Scaffold(
                    backgroundColor: Colors.white,
                    body: Row(
                      children: [
                        sideScroller(200),
                      const VerticalDivider(width: 1,),

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
                            child: profileTab(context, 1140),
                          ),
                        ),
                      )
                    ],),
                  );
              }
            },),
          ),
        ],
      ),
    );
  }

  // Date Conversion Method.
  String convertDate(String dateString) {
    // Extract the timestamp from the string
    String timestampString = dateString.substring(6, dateString.length - 2);

    // Convert the timestamp string to an integer
    int timestamp = int.tryParse(timestampString) ?? 0;

    // Create a DateTime object from the timestamp
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format the date as desired
    String formattedDate = "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";

    return formattedDate;
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  ///btp profile tab.
  // Widget profileTab(BuildContext context,double screenWidth) {
  //
  //   return  SizedBox(
  //     width:screenWidth,
  //     child: Column(
  //       children: [
  //         const Divider(height: 1),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(left: 15.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(storeStaticData['BusinessPartnerFullName']??"",
  //                     style: const TextStyle(fontWeight: FontWeight.bold),),
  //                   Text(storeStaticData['BusinessPartner']??"")
  //                 ],
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Padding(
  //                     padding: const EdgeInsets.only(right: 14,bottom: 8,top: 8),
  //                     child: SizedBox(
  //                       width: 80,
  //                       height: 30,
  //                       child: OutlinedMButton(
  //                         text :"Edit",
  //                         borderColor: Colors.indigo,
  //                         textColor:  Colors.indigo,
  //                         onTap: (){
  //                           Navigator.push(context, PageRouteBuilder(
  //                             pageBuilder: (context, animation, secondaryAnimation) =>
  //                                 EditCustomerDetails(drawerWidth: widget.drawerWidth, selectedDestination: widget.selectedDestination,
  //                                   storeData: storeStaticData,
  //                                 ),
  //                           ));
  //                         },
  //
  //                       ),
  //                     )
  //                 ),
  //                 Padding(
  //                     padding: const EdgeInsets.only(right: 14,bottom: 8,top: 8),
  //                     child: SizedBox(
  //                       width: 100,
  //                       height: 30,
  //                       child: OutlinedMButton(
  //                         text :"Delete",
  //                         borderColor: Colors.redAccent,
  //                         textColor:  Colors.redAccent,
  //                         onTap: () {
  //                           showDialog(
  //                             context: context,
  //                             builder: (context) {
  //                               return Dialog(
  //                                 backgroundColor: Colors.transparent,
  //                                 child: StatefulBuilder(
  //                                   builder: (context, setState) {
  //                                     return SizedBox(
  //                                       height: 200,
  //                                       width: 300,
  //                                       child: Stack(children: [
  //                                         Container(
  //                                           decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
  //                                           margin:const EdgeInsets.only(top: 13.0,right: 8.0),
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.only(left: 20.0,right: 25),
  //                                             child: Column(
  //                                               children: [
  //                                                 const SizedBox(
  //                                                   height: 20,
  //                                                 ),
  //                                                 const Icon(
  //                                                   Icons.warning_rounded,
  //                                                   color: Colors.red,
  //                                                   size: 50,
  //                                                 ),
  //                                                 const SizedBox(
  //                                                   height: 10,
  //                                                 ),
  //                                                 const Center(
  //                                                     child: Text(
  //                                                       'Are You Sure, You Want To Delete ?',
  //                                                       style: TextStyle(
  //                                                           color: Colors.indigo,
  //                                                           fontWeight: FontWeight.bold,
  //                                                           fontSize: 15),
  //                                                     )),
  //                                                 const SizedBox(
  //                                                   height: 35,
  //                                                 ),
  //                                                 Row(
  //                                                   mainAxisAlignment:
  //                                                   MainAxisAlignment.spaceBetween,
  //                                                   children: [
  //                                                     MaterialButton(
  //                                                       color: Colors.red,
  //                                                       onPressed: () {
  //                                                         // print(userId);
  //                                                         //deleteCustomerData();
  //                                                       },
  //                                                       child: const Text(
  //                                                         'Ok',
  //                                                         style: TextStyle(color: Colors.white),
  //                                                       ),
  //                                                     ),
  //                                                     MaterialButton(
  //                                                       color: Colors.blue,
  //                                                       onPressed: () {
  //                                                         setState(() {
  //                                                           Navigator.of(context).pop();
  //                                                         });
  //                                                       },
  //                                                       child: const Text(
  //                                                         'Cancel',
  //                                                         style: TextStyle(color: Colors.white),
  //                                                       ),
  //                                                     )
  //                                                   ],
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         Positioned(right: 0.0,
  //
  //                                           child: InkWell(
  //                                             child: Container(
  //                                                 width: 30,
  //                                                 height: 30,
  //                                                 decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(15),
  //                                                     border: Border.all(
  //                                                       color:
  //                                                       const Color.fromRGBO(204, 204, 204, 1),
  //                                                     ),
  //                                                     color: Colors.blue),
  //                                                 child: const Icon(
  //                                                   Icons.close_sharp,
  //                                                   color: Colors.white,
  //                                                 )),
  //                                             onTap: () {
  //                                               setState(() {
  //                                                 Navigator.of(context).pop();
  //                                               });
  //                                             },
  //                                           ),
  //                                         ),
  //                                       ],
  //                                       ),
  //                                     );
  //                                   },
  //                                 ),
  //                               );
  //                             },
  //                           );
  //                         },
  //
  //                       ),
  //                     )
  //                 )
  //               ],)
  //           ],
  //         ),
  //         const Divider(height: 1,),
  //
  //         Expanded(child: Column(
  //           children: [
  //             const SizedBox(height: 25),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 60,right:20),
  //               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children:  [
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 170,
  //                         child: Text('BusinessPartnerFullName', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['BusinessPartnerFullName']??""),
  //                     ],
  //                   ),
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('BusinessPartner', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['BusinessPartner']??""),
  //                     ],
  //                   ),
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('CreatedByUser', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['CreatedByUser']??""),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 25),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             const Divider(),
  //             const SizedBox(height: 20),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 60,right:20),
  //               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children:  [
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('CreationDate', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['CreationDate']==null?"":convertDate(storeStaticData['CreationDate'])),
  //                     ],
  //                   ),
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('CreationTime', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['CreationTime']??""),
  //                     ],
  //                   ),
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('FormOfAddress', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['FormOfAddress']??""),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 25),
  //
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 60,right:20),
  //               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children:  [
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('LastChangeDate', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['LastChangeDate']==null?"":convertDate(storeStaticData['LastChangeDate']??"")),
  //                     ],
  //                   ),
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('LastChangeTime', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['LastChangeTime']??""),
  //                     ],
  //                   ),
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('LastChangedByUser', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['LastChangedByUser']??""),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 25),
  //
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 60,right:20),
  //               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children:  [
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('OrganizationBPName', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['OrganizationBPName1']??""),
  //                     ],
  //                   ),
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('ETag', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(storeStaticData['ETag']??""),
  //                     ],
  //                   ),
  //                   Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(
  //                         width: 150,
  //                         child: Text('SearchTerm1', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4,),
  //                       Text(
  //                           storeStaticData['SearchTerm1']??""),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         )),
  //
  //       ],),
  //   );
  // }
  ///aws profile tab.
  Widget profileTab(BuildContext context,double screenWidth) {

    return  SizedBox(
      width:screenWidth,
      child: Column(
        children: [
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 60.0,top: 10,bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(storeStaticData['customerName']??"",
                      style: const TextStyle(fontWeight: FontWeight.bold),),
                    Text(storeStaticData['email']??"")
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 14,bottom: 8,top: 8),
                      child: SizedBox(
                        width: 80,
                        height: 30,
                        child: OutlinedMButton(
                          text :"Edit",
                          borderColor: Colors.indigo,
                          textColor:  Colors.indigo,
                          onTap: (){
                            Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  EditCustomerDetails(drawerWidth: widget.drawerWidth, selectedDestination: widget.selectedDestination,
                                    storeData: storeStaticData,
                                  ),
                            ));
                          },

                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 14,bottom: 8,top: 8),
                      child: SizedBox(
                        width: 100,
                        height: 30,
                        child: OutlinedMButton(
                          text :"Delete",
                          borderColor: Colors.redAccent,
                          textColor:  Colors.redAccent,
                          onTap: () {
                            showDialog(
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
                                                          deleteCustomerData(storeStaticData['customerDetailsId']??"");
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
                          },

                        ),
                      )
                  )
                ],)
            ],
          ),
          const Divider(height: 1,),

          Expanded(child: Column(
            children: [
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 60,right:20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 170,
                          child: Text('Customer Name', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['customerName']??""),
                      ],
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('Email', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['email']??""),
                      ],
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('MobileNumber', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['mobileNumber']??""),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 60,right:20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('Pan', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['pan']??""),
                      ],
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('ProjectValue', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['projectValue']??""),
                      ],
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('Stage', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['selectStage']??""),
                      ],
                    ),
                    const SizedBox(height: 25),

                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 60,right:20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('State', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['state']??""),
                      ],
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('District', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['district']??""),
                      ],
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('PinCode', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['pinCode']??""),
                      ],
                    ),
                    const SizedBox(height: 25),

                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 60,right:20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text('Address', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text(storeStaticData['streetAddress']??""),
                      ],
                    ),
                    // Column(crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const SizedBox(
                    //       width: 150,
                    //       child: Text('ETag', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    //       ),
                    //     ),
                    //     const SizedBox(height: 4,),
                    //     Text(storeStaticData['ETag']??""),
                    //   ],
                    // ),
                    // Column(crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const SizedBox(
                    //       width: 150,
                    //       child: Text('SearchTerm1', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    //       ),
                    //     ),
                    //     const SizedBox(height: 4,),
                    //     Text(
                    //         storeStaticData['SearchTerm1']??""),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          )),

        ],),
    );
  }

  ///btp side scroller.
  // sideScroller(double width){
  //   return  SizedBox(
  //     width: width,
  //     child: Column(
  //       children: [
  //         Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(
  //                   left: 0, right: 0, top: 0, bottom: 0),
  //               child: Row(
  //                 // crossAxisAlignment: CrossAxisAlignment.end,
  //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   SizedBox(
  //                     width: width,
  //                     child: AppBar(
  //                       title: const Text("Customer",style: TextStyle(fontSize: 20)),
  //                       elevation: 1,
  //                       surfaceTintColor: Colors.white,
  //                       shadowColor: Colors.black,
  //                       backgroundColor: Colors.white,
  //                       actions: [
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child:     SizedBox(
  //                             width: 100,
  //                             height: 30,
  //                             child: OutlinedMButton(
  //                               text: '+ Customer',
  //                               // buttonColor:mSaveButton ,
  //                               textColor: Colors.black,
  //                               borderColor: mSaveButton,
  //                               onTap: () {
  //                                 Navigator.of(context).push(PageRouteBuilder(
  //                                     pageBuilder: (context,animation1,animation2)=>CustomerCreation(
  //                                       drawerWidth: widget.drawerWidth,
  //                                       selectedDestination: widget.selectedDestination,
  //                                     ),
  //                                     transitionDuration: Duration.zero,
  //                                     reverseTransitionDuration: Duration.zero
  //                                 ));
  //                               },
  //
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const Divider(height: 1),
  //             const SizedBox(height: 10,),
  //             Padding(
  //               padding: const EdgeInsets.only(
  //                   left: 10, right: 10, top: 4, bottom: 10),
  //               child: SizedBox(height: 30, child: TextFormField(
  //                 onChanged:(val){
  //                   if(val.trim().isEmpty || val==""){
  //                     for(int i=0;i<staticCustomerData.length;i++){
  //                       if(selectedId==staticCustomerData[i]['BusinessPartner']){
  //                         scrollToName(i);
  //                       }
  //                     }
  //                   }
  //                   else{
  //                     for(int i=0;i<staticCustomerData.length;i++){
  //                       String textLength = staticCustomerData[i]['BusinessPartner']??"";
  //                       try{
  //                         if(textLength==val){
  //                           scrollToName(i);
  //                         }
  //                       }
  //                       catch(e){
  //                         log(e.toString());
  //                       }
  //                     }
  //                   }
  //                 },
  //                 style: const TextStyle(fontSize: 14),
  //                 keyboardType: TextInputType.text,
  //                 decoration:decorationSearch('Search Customer'),  ),),
  //             ),
  //           ],
  //         ),
  //         const Divider(height: 1),
  //         //Side Scroller.
  //         Expanded(
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             controller: controller,
  //             itemCount: staticCustomerData.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return AutoScrollTag(
  //                 key: ValueKey(index),
  //                 controller: controller,
  //                 index: index,
  //                 child:   Column(
  //                   children: [
  //                     Container(
  //                       color:selectedId == staticCustomerData[index]['BusinessPartner'] ? Colors.blue[100] : Colors.transparent,
  //                       child: InkWell(
  //                         hoverColor: mHoverColor,
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(
  //                               left: 12.0, top: 12, bottom: 12),
  //                           child: Row(
  //                             children: [
  //                               Column(crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   SizedBox(
  //                                     width:180,
  //                                     child: Text(staticCustomerData[index]['BusinessPartnerFullName']??"",
  //                                       style: const TextStyle(fontWeight: FontWeight.bold),
  //                                       maxLines: 2,
  //                                       overflow: TextOverflow.ellipsis,
  //                                     ),
  //                                   ),
  //                                   Text(staticCustomerData[index]['BusinessPartner']??""),
  //                                   const SizedBox(height: 2,),
  //                                   // Text(customerList[index]['mobile'],),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           //selectedId = customerList[index]["customer_id"];
  //                           setState(() {
  //                             storeStaticData.addAll(staticCustomerData[index]);
  //                             // selectedIndex = index;
  //                             // customerDetailsBloc.fetchCustomerNetwork(customerList[index]['customer_id']);
  //                             // selectedId = customerList[index]['customer_id'];
  //                           });
  //
  //                         },
  //                       ),
  //                     ),
  //                     const Divider(height: 1,)
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }

 ///aws side scroller.
  sideScroller(double width){
    return  SizedBox(
      width: width,
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 0, bottom: 0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width,
                      child: AppBar(
                        title: const Text("Customer",style: TextStyle(fontSize: 20)),
                        elevation: 1,
                        surfaceTintColor: Colors.white,
                        shadowColor: Colors.black,
                        backgroundColor: Colors.white,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:     SizedBox(
                              width: 100,
                              height: 30,
                              child: OutlinedMButton(
                                text: '+ Customer',
                                // buttonColor:mSaveButton ,
                                textColor: Colors.black,
                                borderColor: mSaveButton,
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (context,animation1,animation2)=>CustomerCreation(
                                        drawerWidth: widget.drawerWidth,
                                        selectedDestination: widget.selectedDestination,
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
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 4, bottom: 10),
                child: SizedBox(height: 30, child: TextFormField(
                  onChanged:(val){
                    if(val.trim().isEmpty || val==""){
                      for(int i=0;i<staticCustomerData.length;i++){
                        if(selectedId==staticCustomerData[i]['customerDetailsId']){
                          scrollToName(i);
                        }
                      }
                    }
                    else{
                      for(int i=0;i<staticCustomerData.length;i++){
                        String textLength = staticCustomerData[i]['customerDetailsId']??"";
                        try{
                          if(textLength==val){
                            scrollToName(i);
                          }
                        }
                        catch(e){
                          log(e.toString());
                        }
                      }
                    }
                  },
                  style: const TextStyle(fontSize: 14),
                  keyboardType: TextInputType.text,
                  decoration:decorationSearch('Search Customer'),  ),),
              ),
            ],
          ),
          const Divider(height: 1),
          //Side Scroller.
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              controller: controller,
              itemCount: staticCustomerData.length,
              itemBuilder: (BuildContext context, int index) {
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller,
                  index: index,
                  child:   Column(
                    children: [
                      Container(
                        color:storeStaticData['customerDetailsId'] == staticCustomerData[index]['customerDetailsId'] ? Colors.blue[100] : Colors.transparent,
                        child: InkWell(
                          hoverColor: mHoverColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, top: 12, bottom: 12),
                            child: Row(
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:180,
                                      child: Text(staticCustomerData[index]['customerName']??"",
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(staticCustomerData[index]['customerDetailsId']??""),
                                    const SizedBox(height: 2,),
                                    // Text(customerList[index]['mobile'],),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            //selectedId = customerList[index]["customer_id"];
                            setState(() {
                              storeStaticData={
                                "customerDetailsId": staticCustomerData[index]["customerDetailsId"],
                                "customerName": staticCustomerData[index]["customerName"],
                                "email": staticCustomerData[index]["email"],
                                "pan":staticCustomerData[index]["pan"],
                                "mobileNumber": staticCustomerData[index]["mobileNumber"],
                                "projectValue": staticCustomerData[index]["projectValue"],
                                "selectStage": staticCustomerData[index]["selectStage"],
                                "streetAddress": staticCustomerData[index]["streetAddress"],
                                "pinCode": staticCustomerData[index]["pinCode"],
                                "state": staticCustomerData[index]["state"],
                                "district": staticCustomerData[index]["district"]
                              };
                            });

                          },
                        ),
                      ),
                      const Divider(height: 1,)
                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  //Delete Api Async Function.
  deleteCustomerData(String customerID)async{
    String deleteUrl="https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/customerdetails/delete_customerdetails_by_id/$customerID";
    final response = await http.delete(Uri.parse(deleteUrl),);
    dynamic responseBody=jsonDecode(response.body);
    if(response.statusCode ==200){
      try{
        if(responseBody['status']=="success"){
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Deleted Business Partner ID:$customerID"),duration: const Duration(seconds: 5),));
            Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
                CustomerList(arg: CustomerListArgs(
                    drawerWidth: widget.drawerWidth,
                    selectedDestination: widget.selectedDestination),

                 ) ,));
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
}

