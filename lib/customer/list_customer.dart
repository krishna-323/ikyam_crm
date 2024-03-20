import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../apis_calling/getApi.dart';
import '../class/arguments_class/argument_class.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/custom_loader.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import 'customer_creation.dart';
import 'customer_details.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:http/http.dart' as http;

class CustomerList extends StatefulWidget {
  final CustomerListArgs arg;
  const CustomerList({super.key, required this.arg});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final _horizontalScrollController = ScrollController();
  //final _verticalScrollController = ScrollController();
  final customerNameController=TextEditingController();
  final creationDateController=TextEditingController();
  final businessPartner=TextEditingController();

  bool loading = false;
  List responseData=[];

 List filteredList=[];


  List displayList=[];
  int startVal=0;


  ///BTP get Api call.
  Future<void> getCustomers() async {
    String url = "https://firstapp-boisterous-crocodile-uu.cfapps.in30.hana.ondemand.com/api/sap_odata_get/API_BUSINESS_PARTNER/A_BusinessPartner";
    try {
      List<dynamic> tempStoreData = await fetchGetApiData(url);
      setState(() {
        // responseData = tempStoreData;
        // filteredList = tempStoreData;


        if (displayList.isEmpty) {
          if (filteredList.length > 15) {
            for (int i = 0; i < startVal + 15; i++) {
              displayList.add(filteredList[i]);
            }
          } else {
            for (int i = 0; i < filteredList.length; i++) {
              displayList.add(filteredList[i]);
            }
          }
        }
      });
      loading=false;
    } catch (e) {
      // Handle errors here
      log("Error fetching customers: $e");
    }
  }
  ///aws Api call.
  Future<void> getCustomerFromAws() async {
    String url = "https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/customerdetails/get_all_customerdetails";
    final resData = await http.get(Uri.parse(url));
    final responseBody= jsonDecode(resData.body);
    try {
    //  List<dynamic> tempStoreData = await fetchGetApiData(url);
      setState(() {
        responseData = responseBody;
        filteredList = responseBody;


        if (displayList.isEmpty) {
          if (filteredList.length > 15) {
            for (int i = 0; i < startVal + 15; i++) {
              displayList.add(filteredList[i]);
            }
          } else {
            for (int i = 0; i < filteredList.length; i++) {
              displayList.add(filteredList[i]);
            }
          }
        }
      });
      loading=false;
    } catch (e) {
      // Handle errors here
      log("Error fetching customers: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState.
    //getCustomers();
    getCustomerFromAws();
    loading=true;
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
    responseData=[];
    filteredList=[];

  }


  ifEmpty(){
    setState(() {
      if(filteredList.length>15){
        for(int i=0;i<startVal+15;i++){
          displayList.add(filteredList[i]);
        }
      }
      else{
        for(int i=0;i<filteredList.length;i++){
          displayList.add(filteredList[i]);
        }
      }
    });
  }

  //Filtered Business PartnerName.
  List _filterBusinessPartnerName(String searchTerm, String key) {
    // FilteredList .
    List filteredList=[];
    // Bool For Declaration.

    bool hasMatch = false;
    // For Lop For Iterating.
    for(var bp in responseData){

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

  // Fetch Customer Name.
  fetchByCustomerName(String controllerText, String key){
    if(displayList.isEmpty) {
      filteredList=  _filterBusinessPartnerName(controllerText,key);

    if (filteredList.length > 15) {
      for(int i=startVal;i<startVal + 15;i++){
        setState(() {
          displayList.add(filteredList[i]);
        });
      }
    }
    else {
      for(int i=startVal;i<filteredList.length;i++){
        setState(() {
          displayList.add(filteredList[i]);
        });
      }
    }
  }
  }

   //Filtered By Creation Date.
  List _filterDate(String searchTerm, String key) {
    // Filter the business partners based on the search term
    List filteredList = [];
    bool hasMatch = false; // Flag to track if any matches are found

    for (var bp in responseData) {
      if (convertDate(bp[key]).startsWith(searchTerm)) {
        filteredList.add(bp);
        hasMatch = true; // Set the flag to true if a match is found
      }
    }

    // If no matches found, assign filteredList to an empty list
    if (hasMatch==false) {
      filteredList = [];
    }

    return filteredList;
  }

  // Fetch Customer Date.
  fetchByDate(String controllerText, String key){
    if(displayList.isEmpty) {
      filteredList=  _filterDate(controllerText,key);
      if (filteredList.length > 15) {
        for(int i=startVal;i<startVal + 15;i++){
          setState(() {
            displayList.add(filteredList[i]);
          });
        }
      }
      else {
        for(int i=startVal;i<filteredList.length;i++){
          setState(() {
            displayList.add(filteredList[i]);
          });
        }
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),),
      body: Row(children: [
        CustomDrawer(widget.arg.drawerWidth, widget.arg.selectedDestination),
        const VerticalDivider(
          width: 1,
          thickness: 1,
        ),

        Expanded(
          child: CustomLoader(
           // inAsyncCall: false,
            inAsyncCall: loading,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1140) {
                  return tableStructure(context, constraints.maxWidth);
                } else {
                  return AdaptiveScrollbar(
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
                  );
                }
              },
            ),
          ),
        ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0,right: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            const Text("Customer List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),),

                          ],
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0),
                        child: SizedBox(height: 100,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(  width: 190,height: 30, child: TextFormField(
                                controller:customerNameController,
                                onChanged: (value){
                                  if(value.isEmpty || value==""){
                                      startVal=0;
                                      displayList=[];
                                      filteredList = responseData;
                                      ifEmpty();
                                  }
                                  else if(creationDateController.text.isNotEmpty || businessPartner.text.isNotEmpty){
                                    creationDateController.clear();
                                    businessPartner.clear();
                                  }
                                  else{
                                      startVal=0;
                                      displayList=[];
                                      ///BTP search by business partner name
                                      //fetchByCustomerName(customerNameController.text,"BusinessPartnerName");
                                    ///aws search by customer name.
                                    fetchByCustomerName(customerNameController.text,"customerName");
                                  }
                                },
                                style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,
                                decoration: searchCustomerNameDecoration(hintText: 'Search By Name'),
                              ),),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                    Row(children: [
                                      ///BTP Text Fields.
                                      // SizedBox(width: 190,height: 30, child: TextFormField(
                                      //   controller:businessPartner,
                                      //   onChanged: (value){
                                      //     if(value.isEmpty || value==""){
                                      //       startVal=0;
                                      //       displayList=[];
                                      //       filteredList = responseData;
                                      //       ifEmpty();
                                      //     }
                                      //     else if(creationDateController.text.isNotEmpty || customerNameController.text.isNotEmpty){
                                      //       creationDateController.clear();
                                      //       customerNameController.clear();
                                      //     }
                                      //     else{
                                      //       startVal=0;
                                      //       displayList=[];
                                      //       fetchByCustomerName(businessPartner.text,"BusinessPartner");
                                      //     }
                                      //   },
                                      //   style: const TextStyle(fontSize: 14),
                                      //   keyboardType: TextInputType.text,
                                      //   decoration: searchCityNameDecoration(hintText: 'Search By Business Partner'),
                                      // ),),
                                      // const SizedBox(width: 10,),
                                      // SizedBox(  width: 190,height: 30, child: TextFormField(
                                      //   controller:creationDateController,
                                      //   //readOnly: true,
                                      //   onTap: ()async{
                                      //     DateTime? pickedDate=await showDatePicker(context: context,
                                      //         initialDate: DateTime.now(),
                                      //         firstDate: DateTime(1999),
                                      //         lastDate: DateTime.now()
                                      //
                                      //     );
                                      //     if(pickedDate==null){
                                      //       startVal=0;
                                      //       displayList=[];
                                      //       filteredList = responseData;
                                      //       ifEmpty();
                                      //     }
                                      //     else if(businessPartner.text.isNotEmpty || customerNameController.text.isNotEmpty){
                                      //       businessPartner.clear();
                                      //       customerNameController.clear();
                                      //     }
                                      //     else{
                                      //       String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
                                      //       setState(() {
                                      //         creationDateController.text=formattedDate;
                                      //       });
                                      //       startVal=0;
                                      //       displayList=[];
                                      //       fetchByDate(creationDateController.text,"CreationDate");
                                      //     }
                                      //   },
                                      //   style: const TextStyle(fontSize: 14),
                                      //   decoration: searchCreationDate(hintText: 'Search By Creation Date'),
                                      // ),),
                                      ///aws text fields.
                                      SizedBox(width: 190,height: 30, child: TextFormField(
                                        inputFormatters: [  FilteringTextInputFormatter.digitsOnly],
                                        controller:businessPartner,
                                        onChanged: (value){
                                          if(value.isEmpty || value==""){
                                            startVal=0;
                                            displayList=[];
                                            filteredList = responseData;
                                            ifEmpty();
                                          }
                                          else if(creationDateController.text.isNotEmpty || customerNameController.text.isNotEmpty){
                                            creationDateController.clear();
                                            customerNameController.clear();
                                          }
                                          else{
                                            startVal=0;
                                            displayList=[];
                                            fetchByCustomerName(businessPartner.text,"mobileNumber");
                                          }
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        keyboardType: TextInputType.text,
                                        decoration: searchCityNameDecoration(hintText: 'Search By Phone'),
                                      ),),

                                      const SizedBox(width: 10,),
                                      SizedBox(width: 190,height: 30, child: TextFormField(
                                        controller:creationDateController,
                                        onChanged: (value){
                                          if(value.isEmpty || value==""){
                                            startVal=0;
                                            displayList=[];
                                            filteredList = responseData;
                                            ifEmpty();
                                          }
                                          else if(businessPartner.text.isNotEmpty || customerNameController.text.isNotEmpty){
                                            businessPartner.clear();
                                            customerNameController.clear();
                                          }
                                          else{
                                            startVal=0;
                                            displayList=[];
                                            fetchByCustomerName(creationDateController.text,"selectStage");
                                          }
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        keyboardType: TextInputType.text,
                                        decoration: searchCreationDate(hintText: 'Search By Stage'),
                                      ),),
                                    ],),

                                   Padding(
                                     padding: const EdgeInsets.only(right: 20.0),
                                     child: SizedBox(
                                      width: 100,
                                      height: 30,
                                      child: OutlinedMButton(
                                        text: '+ Customer',
                                        buttonColor:mSaveButton ,
                                        textColor: Colors.white,
                                        borderColor: mSaveButton,
                                        onTap: () {
                                          ///BTP return api call.
                                          // Navigator.of(context).push(PageRouteBuilder(
                                          //     pageBuilder: (context,animation1,animation2)=>CustomerCreation(
                                          //       drawerWidth: widget.arg.drawerWidth,
                                          //       selectedDestination: widget.arg.selectedDestination,
                                          //     ),
                                          //     transitionDuration: Duration.zero,
                                          //     reverseTransitionDuration: Duration.zero
                                          // )).then((value) => getCustomers());
                                          ///aws return api call.
                                          Navigator.of(context).push(PageRouteBuilder(
                                              pageBuilder: (context,animation1,animation2)=>CustomerCreation(
                                                drawerWidth: widget.arg.drawerWidth,
                                                selectedDestination: widget.arg.selectedDestination,
                                              ),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero
                                          )).then((value) => getCustomerFromAws());
                                        },

                                      ),
                                  ),
                                   ),
                                ],
                              ),

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
                            child: const Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Row(
                                children: [
                                  /// aws headers fields.
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child:
                                            //Text("Customer Name")
                                            Text('Customer Name')
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(
                                            height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child:
                                            //Text('Email')
                                            Text("Email")
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("Mobile Number")
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("Project Value")
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("Stage")
                                        ),
                                      )),
                                  Center(child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(size: 18,
                                      Icons.more_vert,
                                      color: Colors.transparent,
                                    ),
                                  ),)

                                  ///BTP header fields.
                                  // Expanded(
                                  //     child: Padding(
                                  //       padding: EdgeInsets.only(top: 4.0),
                                  //       child: SizedBox(height: 25,
                                  //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  //           child:
                                  //           //Text("Customer Name")
                                  //         Text('Business Partner Full Name')
                                  //       ),
                                  //     )),
                                  // Expanded(
                                  //     child: Padding(
                                  //       padding: EdgeInsets.only(top: 4),
                                  //       child: SizedBox(
                                  //           height: 25,
                                  //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  //           child:
                                  //           //Text('Email')
                                  //         Text("BusinessPartner")
                                  //       ),
                                  //     )
                                  // ),
                                  // Expanded(
                                  //     child: Padding(
                                  //       padding: EdgeInsets.only(top: 4),
                                  //       child: SizedBox(height: 25,
                                  //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  //           child: Text("Supplier")
                                  //       ),
                                  //     )),
                                  // Expanded(
                                  //     child: Padding(
                                  //       padding: EdgeInsets.only(top: 4),
                                  //       child: SizedBox(height: 25,
                                  //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  //           child: Text("CreationDate")
                                  //       ),
                                  //     )),
                                  // Expanded(
                                  //     child: Padding(
                                  //       padding: EdgeInsets.only(top: 4),
                                  //       child: SizedBox(height: 25,
                                  //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  //           child: Text("Status")
                                  //       ),
                                  //     )),
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

              ListView.builder(
                shrinkWrap: true,
                itemCount:displayList.length + 1,
                itemBuilder: (context, i) {
                  if(i<displayList.length){
                    return Column(children: [
                     MaterialButton(
                        hoverColor: Colors.blue[50],
                        onPressed: () {
                          Navigator.of(context).push(
                              PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
                                  ViewCustomerDetails(
                                    drawerWidth: widget.arg.drawerWidth,
                                    selectedDestination: widget.arg.selectedDestination,
                                    displayData: displayList[i]??"",
                                    customerList: responseData,
                                  ),
                                  transitionDuration: const Duration(milliseconds: 0),
                                  reverseTransitionDuration: const Duration(milliseconds: 0))
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                          child: Row(
                            children: [
                              ///aws fields.
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: SizedBox(height: 25,
                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                        child: SelectableText(displayList[i]['customerName']??"")
                                    ),
                                  )),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: SizedBox(
                                      height: 25,
                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                      child:
                                      Tooltip(message:displayList[i]['email']?? '',waitDuration:const Duration(seconds: 1),
                                          child: Text(displayList[i]['email']?? '',softWrap: true,)),
                                    ),
                                  )
                              ),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: SizedBox(height: 25,
                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                        child: Text(displayList[i]['mobileNumber']??"")
                                    ),
                                  )),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: SizedBox(height: 25,
                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                        child: Text(displayList[i]['projectValue']??"")
                                    ),
                                  )),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: SizedBox(height: 25,
                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                      child: Text(displayList[i]['selectStage']??""),
                                    ),
                                  )),
                              const Center(child: Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(size: 18,
                                  Icons.arrow_circle_right,
                                  color: Colors.blue,
                                ),
                              ),)

                              ///BTP fields.
                              // Expanded(
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(top: 4.0),
                              //       child: SizedBox(height: 25,
                              //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                              //           child: SelectableText(displayList[i]['BusinessPartnerName']??"")
                              //       ),
                              //     )),
                              // Expanded(
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(top: 4),
                              //       child: SizedBox(
                              //         height: 25,
                              //         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                              //         child:
                              //         Tooltip(message:displayList[i]['BusinessPartner']?? '',waitDuration:const Duration(seconds: 1),
                              //             child: Text(displayList[i]['BusinessPartner']?? '',softWrap: true,)),
                              //       ),
                              //     )
                              // ),
                              // Expanded(
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(top: 4),
                              //       child: SizedBox(height: 25,
                              //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                              //           child: Text(displayList[i]['Supplier']??"")
                              //       ),
                              //     )),
                              // Expanded(
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(top: 4),
                              //       child: SizedBox(height: 25,
                              //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                              //           child: Text(convertDate(displayList[i]['CreationDate']??""))
                              //       ),
                              //     )),
                              // Expanded(
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(top: 4),
                              //       child: SizedBox(height: 25,
                              //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                              //           child: Text(displayList[i]['YY1_Value_bus']=="101"?"Opportunity":
                              //                       displayList[i]['YY1_Value_bus']=="102"?"Proposal":
                              //                       displayList[i]['YY1_Value_bus']=="103"?"Demo":
                              //                       displayList[i]['YY1_Value_bus']=="104"?"Negotiation":
                              //                       displayList[i]['YY1_Value_bus']=="105"?"Closed Won":
                              //                       displayList[i]['YY1_Value_bus']=="106"?"Closed Lost":""),
                              //       ),
                              //     )),
                              // const Center(child: Padding(
                              //   padding: EdgeInsets.only(right: 8),
                              //   child: Icon(size: 18,
                              //     Icons.arrow_circle_right,
                              //     color: Colors.blue,
                              //   ),
                              // ),)
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                    ],

                    );
                  }
                  else{
                    return Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          Text("${startVal+15>filteredList.length?filteredList.length:startVal+1}-${startVal+15>filteredList.length?filteredList.length:startVal+15} of ${filteredList.length}",style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10,),
                          Material(color: Colors.transparent,
                            child: InkWell(
                              hoverColor: mHoverColor,
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                              ),
                              onTap: (){
                                if(startVal>14){
                                  displayList=[];
                                  startVal = startVal-15;
                                  for(int i=startVal;i<startVal+15;i++){
                                    try{
                                      setState(() {
                                        displayList.add(filteredList[i]);
                                      });
                                    }
                                    catch(e){
                                      log(e.toString());
                                    }
                                  }
                                }
                                else{
                                  log('else');
                                }

                              },
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Material(color: Colors.transparent,
                            child: InkWell(
                              hoverColor: mHoverColor,
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Icon(Icons.arrow_forward_ios,size: 12),
                              ),
                              onTap: (){
                                if(filteredList.length>startVal+15){
                                  displayList=[];
                                  startVal=startVal+15;
                                  for(int i=startVal;i<startVal+15;i++){
                                    try{
                                      setState(() {
                                        displayList.add(filteredList[i]);
                                      });
                                    }
                                    catch(e){
                                      log(e.toString());
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 20,),

                        ],
                      ),
                      Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                    ],);
                  }
              },)

            ]),
          ),
        ),
      ),
    );
  }

  // Search textField Decoration.
  searchCustomerNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: customerNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayList=[];
              customerNameController.clear();
              filteredList = responseData;
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
      suffixIcon: businessPartner.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayList=[];
              businessPartner.clear();
              filteredList = responseData;
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

  searchCreationDate ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: creationDateController.text.isEmpty? const Icon(Icons.search,size: 18,):InkWell(
          onTap: (){
              setState(() {
                startVal=0;
                displayList=[];
                creationDateController.clear();
                filteredList = responseData;
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

  // Date Conversion.
  String convertDate(String dateString) {
    // Extract the timestamp from the string
    String timestampString = dateString.substring(6, dateString.length - 2);

    // Convert the timestamp string to an integer
    int timestamp = int.parse(timestampString);

    // Create a DateTime object from the timestamp
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format the date as desired.
    String formattedDate = "${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}";

    return formattedDate;
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

}

// Reusable Table Design Class.
class CustomTableWidget extends StatefulWidget {

  final List dynamicData;
  final double screenWidth;
  final List<String> staticHeaders;
  final List dynamicHeaders;
  final Function(int i) onViewDetails;
  final Function newPage;


    const CustomTableWidget({
    Key? key,
    required this.screenWidth,
    required this.staticHeaders,
    required this.onViewDetails,
     required this.dynamicHeaders,
     required this.dynamicData,
      required this.newPage,
  }) : super(key: key);

  @override
  State<CustomTableWidget> createState() => _CustomTableWidgetState();
}

class _CustomTableWidgetState extends State<CustomTableWidget> {
  late int startVal=0;
 List displayList=[];
 List storeDynamicData=[];

 @override
  void initState() {
    // TODO: implement initState.
   storeDynamicData=widget.dynamicData;
   if(displayList.isEmpty){
     if(storeDynamicData.length>5){
       for(int i=0;i<startVal+15;i++){
         displayList.add(storeDynamicData[i]);
       }
     }
     else{
       for(int i=0;i<storeDynamicData.length;i++){
         displayList.add(storeDynamicData[i]);
       }
     }
   }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[50],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40, top: 30),
          child: Container(
            width: widget.screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),

            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Business Partner List",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            MaterialButton(
                                color: Colors.blue,
                                child: const Text('+ Customer',
                                    style: TextStyle(color:Colors.white)),
                                onPressed: (){
                                  widget.newPage();
                                 // widget.onViewCustomerDetails(0);
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Search fields
                      // You can add search fields here if needed
                      Divider(
                        height: 0.5,
                        color: Colors.grey[500],
                        thickness: 0.5,
                      ),
                    ],
                  ),
                ),

                // Table Header
                Container(
                  color: Colors.grey[100],
                  height: 32,
                  child: IgnorePointer(
                    ignoring: true,
                    child: MaterialButton(
                      onPressed: () {},
                      hoverColor: Colors.transparent,
                      hoverElevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Row(
                          children: [
                            for (String staticHeader in widget.staticHeaders)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: SizedBox(
                                    height: 25,
                                    child: Text(staticHeader),
                                  ),
                                ),
                              ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  size: 18,
                                  Icons.more_vert,
                                  color: Colors.transparent,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[500],
                  thickness: 0.5,
                ),

                // Table Dynamic Content.
                for (int i = 0; i <= displayList.length; i++)
                  Column(
                    children: [
                      if(i!=displayList.length)
                      MaterialButton(
                        hoverColor: Colors.blue[50],
                        onPressed: () {
                          widget.onViewDetails(i);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 4, bottom: 3),
                          child: Row(
                            children: [
                              for (String dynamicHeader in widget.dynamicHeaders)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: SizedBox(
                                      height: 25,
                                      child: Text(displayList[i][dynamicHeader] ?? ""),
                                    ),
                                  ),
                                ),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    size: 18,
                                    Icons.arrow_circle_right,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                       if(i!=displayList.length)
                       Divider(
                        height: 0.5,
                        color: Colors.grey[300],
                        thickness: 0.5,
                      ),

                       if(i==displayList.length)
                         Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Text("${startVal+15>storeDynamicData.length?storeDynamicData.length:startVal+1}-"
                                "${startVal+15>storeDynamicData.length?storeDynamicData.length:startVal+15}"
                                " of ${storeDynamicData.length}",style: const TextStyle(color: Colors.grey)),

                            const SizedBox(width: 10,),
                            Material(color: Colors.transparent,
                              child: InkWell(
                                hoverColor: mHoverColor,
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                ),
                                onTap: (){
                                  if(startVal>14){
                                    displayList=[];
                                    startVal = startVal-15;
                                    for(int i=startVal;i<startVal+15;i++){
                                      try{
                                        setState(() {
                                          displayList.add(storeDynamicData[i]);
                                        });
                                      }
                                      catch(e){
                                        log(e.toString());
                                      }
                                    }
                                  }
                                  else{
                                    log('else');
                                  }

                                },
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Material(color: Colors.transparent,
                              child: InkWell(
                                hoverColor: mHoverColor,
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Icon(Icons.arrow_forward_ios,size: 12),
                                ),
                                onTap: (){
                                  if(storeDynamicData.length>startVal+15){
                                    displayList=[];
                                    startVal=startVal+15;
                                    for(int i=startVal;i<startVal+15;i++){
                                      try{
                                        setState(() {
                                          displayList.add(storeDynamicData[i]);
                                        });
                                      }
                                      catch(e){
                                        log(e.toString());
                                      }

                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 20,),
                          ],
                        ),
                        Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                    ],
                  ),

                // Pagination controls or additional data.
              ],
            ),
          ),
        ),
      ),
    );
  }
}




