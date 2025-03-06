import 'dart:convert';
import 'dart:developer';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
//import 'home_screen.dart';
import 'kpi_card.dart';

class MyHomePage extends StatefulWidget {


  const MyHomePage({Key? key}) : super(key: key);
  // static String homeRoute = "/home";

  @override
  State <MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  double drawerWidth =190;
  String? role;
  getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role= prefs.getString("role");
    // print('--------Role-----');
    // print(role);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getInitialData();
  }
  Map snap ={};

  @override
  Widget build(BuildContext context) {
    //return AddNewPurchaseOrder(drawerWidth: 180,selectedDestination: 4.2,);
    return Scaffold(
      appBar: const PreferredSize(    preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(
        children: [
          CustomDrawer(drawerWidth,0),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          const Expanded(child: HomeScreen()),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {

  const HomeScreen( {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<_BarChartDataState> barChartKey = GlobalKey<_BarChartDataState>();
  final GlobalKey<_LineChartDataState> lineChartKey = GlobalKey<_LineChartDataState>();

  @override
  void initState() {
    super.initState();
    getPartsMaster();

  }
  getPartsMaster() async {
    dynamic response;
    String  url = "https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/customerdetails/get_all_customerdetails";
   // String authToken ="eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBZG1pbiIsIlJvbGVzIjpbeyJhdXRob3JpdHkiOiJNYW5hZ2VyIn1dLCJleHAiOjE3MDg1MzY1ODQsImlhdCI6MTcwODQ5MzM4NH0.BV3k_ieYfbzS1wS7mZT3t78_JFvjpuKsmAJyOyuzgElEIn8GSFAoRCxApijcl308SwgJKGrBlSidaOHPwXCRaw";
    response=await http.get(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
         // "Authorization": "Bearer $authToken"
        }
    );
    if(response.statusCode ==200){
      setState(() {
        partsList=jsonDecode(response.body);
        displayPoList=[];
        try{
          if(displayPoList.isEmpty){
            if(partsList.length>5){
              for(int i=0;i<second+5;i++){
                displayPoList.add(partsList[i]);
              }
            }
            else{
              for(int i=0;i<partsList.length;i++){
                displayPoList.add(partsList[i]);
              }
            }
          }
        }
        catch(e){
          log(e.toString());
        }
      });

    }
  }



   List partsList=[];
  List displayPoList=[];
  int second=0;
  final _horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    profileTab(double screenWidth){
      return SingleChildScrollView(
        child: SizedBox(
          width:screenWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 40,right: 40),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 12,),
                Row(
                  children:  [
                    Expanded(child: InkWell(
                      //mouseCursor: MouseCursor.,
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: (){
                          // Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 1.1,drawerWidth: 190));
                        },
                        child: const KpiCard(title: "New Customers",subTitle:'300',subTitle2: "134",icon:Icons.account_balance_wallet_outlined)

                    )),
                    const SizedBox(width: 30),
                    Expanded(child: InkWell(
                      onTap:(){
                        // Navigator.pushReplacementNamed(context, MotowsRoutes.docketList,arguments: DocketListArgs(selectedDestination: 0,drawerWidth: 190));
                      },
                      child: Card(
                          color: Colors.transparent,
                          elevation: 4,
                          child:  Container(
                            height: 130,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0,top: 20),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 55,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                        child: const Icon(Icons.account_balance_wallet_outlined,color: Colors.white,size: 30),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(child: Text("Enquiry",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Flexible(child: Text("1,300",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),
                                                  const Flexible(
                                                    child: Row(
                                                      children: [
                                                        Flexible(child: Icon(Icons.arrow_upward_sharp,color: Colors.green,size: 16)),
                                                        Flexible(child: Text("134",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.green,fontSize: 12,))),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Container(
                                  height: 40,decoration: BoxDecoration(
                                  color: const Color(0xffF9FAFB),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.transparent,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                  child:  const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                        child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    )),
                    const SizedBox(width: 30),
                    Expanded(child: Card(
                        color: Colors.transparent,
                        elevation: 4,
                        child:  Container(
                          height: 130,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(child: Padding(
                                padding: const EdgeInsets.only(left: 20.0,top: 20),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 55,
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                      child: const Icon(IconData(0xef6f, fontFamily: 'MaterialIcons'),color: Colors.white,size: 30),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Flexible(child: Text("Products Sold",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                          Flexible(
                                            child: Row(
                                              children: [
                                                Flexible(child: Text("300",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),
                                                const Flexible(
                                                  child: Row(
                                                    children: [
                                                      Flexible(child: Icon(Icons.arrow_upward_sharp,color: Colors.green,size: 16)),
                                                      Flexible(child: Text("134",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.green,fontSize: 12,))),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Container(
                                height: 40,decoration: BoxDecoration(
                                color: const Color(0xffF9FAFB),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.transparent,
                                  style: BorderStyle.solid,
                                ),
                              ),
                                child:  const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                      child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))),
                    const SizedBox(width: 30),
                    Expanded(child: InkWell(
                      //mouseCursor: MouseCursor.,
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: (){
                          // Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 1.1,drawerWidth: 190));
                        },
                        child: const KpiCard(title: "Payments",subTitle:'300',subTitle2: "134",icon:Icons.account_balance_wallet_outlined)

                    )),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Expanded(
                      child: Card(elevation: 8,
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                          height: 400,
                          child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14,),
                              const Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Text("Enquiry vs Sales In Month Wise"),
                              ),
                              SizedBox(height: 350,child: BarChartData(key: barChartKey,)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: Card(
                        elevation: 8,
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                          child:    Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14,),
                              const Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Text("Sales Employee Performance"),
                              ),
                              const SizedBox(height: 20,),
                              SizedBox(
                                  height: 300,
                                  child: PieChartData(barChartKey: barChartKey,lineChartKey:lineChartKey)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: Card(elevation: 8,
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                          height: 400,
                          child:   Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14,),
                              const Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Text("Product Wise Sales"),
                              ),
                              SizedBox(height: 350,child: LineChartData(key: lineChartKey,)),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 30,),
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   child: Column(children: [
                    //     Container(
                    //       decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.circular(10),
                    //           border: Border.all(color: const Color(0xFFE0E0E0),)
                    //       ),
                    //       child: Column(children: [
                    //         const  Padding(
                    //           padding:  EdgeInsets.all(15.0),
                    //           child:   Align(alignment: Alignment.topLeft,child: Text("Customer List ", style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold))),
                    //         ),
                    //         Container(
                    //             height: 32,
                    //             color: Colors.grey[100],
                    //             child:
                    //             IgnorePointer(ignoring: true,
                    //               child: MaterialButton(
                    //                 hoverColor:mHoverColor,
                    //                 hoverElevation: 0,
                    //                 onPressed: () {  },
                    //                 child: const Padding(
                    //                   padding: EdgeInsets.only(left:15.0),
                    //                   child: Row(
                    //                     children: [
                    //                       Expanded(
                    //                           child: Padding(
                    //                             padding: EdgeInsets.only(top: 4.0),
                    //                             child: SizedBox(height: 25,
                    //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                    //                                 child: Text("Name",style: TextStyle(color: Colors.black),)
                    //                             ),
                    //                           )),
                    //                       Expanded(
                    //                           child: Padding(
                    //                             padding: EdgeInsets.only(top: 4.0),
                    //                             child: SizedBox(height: 25,
                    //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                    //                                 child: Text("Email",style: TextStyle(color: Colors.black),)
                    //                             ),
                    //                           )),
                    //
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             )
                    //         ),
                    //         const SizedBox(height: 4,),
                    //         ListView.builder(
                    //             shrinkWrap:true,
                    //             itemCount: displayList.length+1,
                    //             itemBuilder: (context,int i){
                    //               if(i<displayList.length){
                    //                 return Column(children: [
                    //                   MaterialButton(
                    //                     hoverColor: Colors.blue[50],
                    //                     onPressed: () {  },
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.only(left:15.0),
                    //                       child: Row(
                    //                         children: [
                    //                           Expanded(
                    //                               child: Padding(
                    //                                 padding: const EdgeInsets.only(top: 4.0),
                    //                                 child: SizedBox(height: 25,
                    //                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                    //                                     child:Text(displayList[i]['customer_name'])
                    //                                 ),
                    //                               )),
                    //                           Expanded(
                    //                               child: Padding(
                    //                                 padding: const EdgeInsets.only(top: 4.0),
                    //                                 child: SizedBox(height: 25,
                    //                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                    //                                     child: Text(displayList[i]['email_id']??"")
                    //                                 ),
                    //                               )),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                    //                 ],);
                    //               }
                    //               else{
                    //                 return Column(children: [
                    //                   Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                    //                   Row(mainAxisAlignment: MainAxisAlignment.end,
                    //                     children: [
                    //
                    //                       Text("${endVal+5>customersList.length?customersList.length:endVal+1}-${endVal+5>customersList.length?customersList.length:endVal+5} of ${customersList.length}",style: const TextStyle(color: Colors.grey)),
                    //                       const SizedBox(width: 10,),
                    //                       //First backward arrow.
                    //
                    //                       Material(color: Colors.transparent,
                    //                         child: InkWell(
                    //                           hoverColor: mHoverColor,
                    //                           child: const Padding(
                    //                             padding: EdgeInsets.all(18.0),
                    //                             child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                    //                           ),
                    //                           onTap: (){
                    //                             if(endVal>4){
                    //                               displayList=[];
                    //                               endVal = endVal-5;
                    //                               for(int i=endVal;i<endVal+5;i++){
                    //                                 try{
                    //                                   setState(() {
                    //                                     displayList.add(customersList[i]);
                    //                                   });
                    //                                 }
                    //                                 catch(e){
                    //                                   log(e.toString());
                    //                                 }
                    //                               }
                    //                             }
                    //                           },
                    //                         ),
                    //                       ),
                    //                       const SizedBox(width: 10,),
                    //                       //second forward arrow
                    //                       Material(color: Colors.transparent,
                    //                         child: InkWell(
                    //                           hoverColor: mHoverColor,
                    //                           child: const Padding(
                    //                             padding: EdgeInsets.all(18.0),
                    //                             child: Icon(Icons.arrow_forward_ios,size: 12),
                    //                           ),
                    //                           onTap: (){
                    //                             if(endVal+1+5>customersList.length){
                    //                               log("Block");
                    //                             }
                    //                             else  if(customersList.length>endVal+5){
                    //                               displayList=[];
                    //                               endVal=endVal+5;
                    //                               for(int i=endVal;i<endVal+5;i++){
                    //                                 try{
                    //                                   setState(() {
                    //                                     displayList.add(customersList[i]);
                    //                                   });
                    //                                 }
                    //                                 catch(e){
                    //                                   log(e.toString());
                    //                                 }
                    //                               }
                    //                             }
                    //
                    //                           },
                    //                         ),
                    //                       ),
                    //                       const SizedBox(width: 20,)
                    //                     ],
                    //                   ),
                    //                 ],);
                    //               }
                    //             })
                    //       ]),
                    //     )
                    //   ]),
                    // ),



                    // const SizedBox(width: 50,),
                    Expanded(
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE0E0E0),)
                          ),
                          child: Column(children: [
                            const  Padding(
                              padding:  EdgeInsets.all(15.0),
                              child:   Align(alignment: Alignment.topLeft,child: Text("Customer List", style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold))),
                            ),
                            Container(
                                height: 32,
                                color: Colors.grey[100],
                                child:
                                IgnorePointer(ignoring: true,
                                  child: MaterialButton(
                                    hoverColor:mHoverColor,
                                    hoverElevation: 0,
                                    onPressed: () {  },
                                    child: const Padding(
                                      padding: EdgeInsets.only(left:15.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("Customer Name",style: TextStyle(color: Colors.black),)
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("Email",style: TextStyle(color: Colors.black),)
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("Mobile Number",style: TextStyle(color: Colors.black),)
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            const SizedBox(height: 4,),

                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: displayPoList.length+1,
                              itemBuilder: (BuildContext context, int i) {
                                if(i<displayPoList.length){
                                  return Column(children: [
                                    MaterialButton(
                                      hoverColor: Colors.blue[50],
                                      onPressed: () {  },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:15.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(displayPoList[i]['customerName']??"")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child:  Text(displayPoList[i]['email'].toString())
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child:Text(displayPoList[i]['mobileNumber']??"")
                                                  ),
                                                )),
                                            // const Center(child: Padding(
                                            //   padding: EdgeInsets.only(right: 8),
                                            //   child: Icon(size: 18,
                                            //     Icons.more_vert,
                                            //     color: Colors.black,
                                            //   ),
                                            // ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                  ],);
                                }
                                else{
                                  return Column(children: [
                                    Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                    Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Text("${second+5>partsList.length?partsList.length:second+1}-${second+5>partsList.length?partsList.length:second+5} of ${partsList.length}",style: const TextStyle(color: Colors.grey)),
                                        const SizedBox(width: 10,),
                                        Material(color: Colors.transparent,
                                          child: InkWell(
                                            hoverColor: mHoverColor,
                                            child: const Padding(
                                              padding: EdgeInsets.all(18.0),
                                              child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                            ),
                                            onTap: (){
                                              setState(() {
                                                // Ensure startVal is grater than or equal to 15.
                                                if(second >  4){
                                                  displayPoList=[];
                                                  second=second -5;
                                                  for(int i= second;i < second + 5; i ++){
                                                    if(i < partsList.length){
                                                      displayPoList.add(partsList[i]);
                                                    }
                                                    else{
                                                      break;
                                                    }
                                                  }
                                                }
                                                else {
                                                  log("else");
                                                }
                                              });
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
                                              setState(() {
                                                if(partsList.length > second + 5){
                                                  displayPoList=[];
                                                  second= second + 5;
                                                  for(int i= second;i<second +5; i++){
                                                    if(i < partsList.length){
                                                      displayPoList.add(partsList[i]);
                                                    }
                                                    else{
                                                      break;
                                                    }
                                                  }
                                                }
                                              });

                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                      ],
                                    ),
                                  ],);
                                }
                              },)
                          ]),
                        )
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30,),
          const Padding(
            padding: EdgeInsets.only(left:40.0,right: 40),
            child: Text("Dashboard",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          ),
          Expanded(child: LayoutBuilder(
            builder:(context, constraints) {
            return AnimatedSwitcher(duration:const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child:constraints.maxWidth > 1100 ?
              profileTab(MediaQuery.of(context).size.width,)
              : AdaptiveScrollbar(
                position: ScrollbarPosition.bottom,
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: Colors.grey.withOpacity(0.7),
                sliderActiveColor: Colors.grey,
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: profileTab(1100),
                ),
              ),
            );

          },))
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}


class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

//Bar Chart.
class BarChartData extends StatefulWidget {

  const BarChartData({Key? key,}) : super(key: key);

  @override
  State<BarChartData> createState() => _BarChartDataState();
}

class _BarChartDataState extends State<BarChartData> {
  late TooltipBehavior _tooltipBehavior;


  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true,animationDuration: 1);


    super.initState();
  }
   List<ChartData> barChartDataSales = [
    ChartData('Jan', 25, const Color.fromRGBO(9,0,136,1)),
    ChartData('Feb', 38, const Color.fromRGBO(147,0,119,1)),
    ChartData('Mar', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('April', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('May', 23, const Color.fromRGBO(228,0,124,1)),
    ChartData('Jun', 33, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 52, const Color.fromRGBO(255,189,57,1))
  ];

   List<ChartData> barChartDataEnquiry = [
    ChartData('Jan', 60, const Color.fromRGBO(9,0,136,1)),
    ChartData('Feb', 32, const Color.fromRGBO(147,0,119,1)),
    ChartData('Mar', 41, const Color.fromRGBO(228,0,124,1)),
    ChartData('April', 31, const Color.fromRGBO(228,0,124,1)),
    ChartData('May', 41, const Color.fromRGBO(228,0,124,1)),
    ChartData('Jun', 51, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 22, const Color.fromRGBO(255,189,57,1))
  ];

  void updateDataSales(List<ChartData> newData) {
    setState(() {
      barChartDataSales = newData; // Update the data with new list
    });
  }

  void updateDataEnquiry(List<ChartData> newData) {
    setState(() {
      barChartDataEnquiry = newData; // Update the data with new list
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SfCartesianChart(
      tooltipBehavior: _tooltipBehavior,
      isTransposed: true,
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        BarSeries<ChartData, String>(color: const Color(0xff747AF2),
          dataSource: barChartDataSales,name:"Sales" ,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        ),
        BarSeries<ChartData, String>(
          color:  const Color(0xffEF376E),
          dataSource: barChartDataEnquiry,
          name: "Enquiry",
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        ),
      ],
    );
  }
}
//Line Chart.
class LineChartData extends StatefulWidget {
  const LineChartData({Key? key}) : super(key: key);

  @override
  State<LineChartData> createState() => _LineChartDataState();
}

class _LineChartDataState extends State<LineChartData> {

  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 18),
    _SalesData('Mar', 32),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
    _SalesData('Jun', 29)
  ];

  List<_SalesData> data2 = [
    _SalesData('Jan', 30),
    _SalesData('Feb', 8),
    _SalesData('Mar', 34),
    _SalesData('Apr', 42),
    _SalesData('May', 45),
    _SalesData('Jun', 39)
  ];

  void item1Data(List<_SalesData> newData) {
    setState(() {
      data = newData; // Update the data with new list
    });
  }

  void item2Data(List<_SalesData> newData) {
    setState(() {
      data2 = newData; // Update the data with new list
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        // Enable legend
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<_SalesData, String>>[
          LineSeries<_SalesData, String>(
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.year,
              yValueMapper: (_SalesData sales, _) => sales.sales,
              name: 'Item 1',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true,
                  textStyle: TextStyle(color: Color(0xFF4B86B8)),
                  labelPosition: ChartDataLabelPosition.outside)),
          LineSeries<_SalesData, String>(
              dataSource: data2,
              xValueMapper: (_SalesData sales, _) => sales.year,
              yValueMapper: (_SalesData sales, _) => sales.sales,
              name: 'Item 2',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true,
                  textStyle: TextStyle(color: Color(0xFFBF6C83)),
                  labelPosition: ChartDataLabelPosition.outside
              ))
        ]
    );
  }
}

//Pie Chart.
class PieChartData extends StatefulWidget {
final GlobalKey<_BarChartDataState>barChartKey;
final GlobalKey<_LineChartDataState> lineChartKey;

  const PieChartData({Key? key, required this.barChartKey, required this.lineChartKey}) : super(key: key);

  @override
  State<PieChartData> createState() => _PieChartDataState();
}

class _PieChartDataState extends State<PieChartData> {
  late TooltipBehavior _tooltipBehavior;

  final List<ChartData2> pieChartData = [
    ChartData2('David', 25,10, 60, 30, const Color.fromRGBO(0, 37, 150, 190)),
    ChartData2('Steve', 38,11, 50, 20, const Color.fromRGBO(147, 0, 119, 1)),
    ChartData2('Jack', 34,15, 40, 25, const Color.fromRGBO(228, 0, 124, 1)),
    ChartData2('Krishna', 52,28, 30, 20, const Color.fromRGBO(255, 189, 57, 1)),
  ];

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(color: Colors.grey.shade100,
      duration: 2,
      //shadowColor: Colors.,
      opacity: 1,
      enable: true,
      animationDuration: 1,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        final ChartData2 chartData = data as ChartData2;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 150,
            height: 100,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chartData.x, style: const TextStyle(color: Colors.black)),
                Text('Targeted: ${chartData.targeted}L', style: const TextStyle(color: Colors.black)),
                Text('Achieved: ${chartData.achieved}L', style: const TextStyle(color: Colors.black)),
                Text('Enquiry: ${chartData.enquiry}', style: const TextStyle(color: Colors.blue)),
                Text('Sales: ${chartData.sales} Sales', style: const TextStyle(color: Colors.green)),
              ],
            ),
          ),
        );
      },
    );


    super.initState();
  }

  // Define a method for updating data in the BarChartData widget.
  void updateSalesData(List<ChartData> newData) {
    // Access the internal state and call its updateData method
    _BarChartDataState? state = widget.barChartKey.currentState;
    state?.updateDataSales(newData);
    // Update both sales and enquiry data
  }

  void updateEnquiryData(List<ChartData> newData) {
    // Access the internal state and call its updateData method
    _BarChartDataState? state = widget.barChartKey.currentState;
    state?.updateDataEnquiry(newData); // Update both sales and enquiry data
  }

  // Define a method for updating data in the LineChart widget.
  updatedItem1Data(List<_SalesData> newData){
    _LineChartDataState? state = widget.lineChartKey.currentState;
    state?.item1Data(newData);
  }
  updatedItem2Data(List<_SalesData> newData){
    _LineChartDataState? state = widget.lineChartKey.currentState;
    state?.item2Data(newData);
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      enableMultiSelection: true,
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.scroll,
      ),

      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<ChartData2, String>(
          onPointTap: (pointIndex) {
            final barChartState = widget.barChartKey.currentState;

            if (barChartState != null) {
              if(pointIndex.viewportPointIndex==0){
                //This is NewData For BarChart.
                updateSalesData([
                  ChartData('Jan', 211, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Feb', 13, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Mar', 42, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Apr', 75, const Color.fromRGBO(9, 0, 136, 1)),
                ]);
                updateEnquiryData([
                  ChartData('Jan', 23, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Feb', 43, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Mar', 232, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Apr', 322, const Color.fromRGBO(9, 0, 136, 1)),
                ]);

                //This Is NewData For LineChart.
                updatedItem1Data([
                    _SalesData('Jan', 28),
                    _SalesData('Feb', 22),
                    _SalesData('Mar', 32),
                    _SalesData('Apr', 21),
                    _SalesData('May', 23),
                    _SalesData('Jun', 29)
                  ]);
                updatedItem2Data([
                  _SalesData('Jan', 19),
                  _SalesData('Feb', 32),
                  _SalesData('Mar', 41),
                  _SalesData('Apr', 51),
                  _SalesData('May', 32),
                  _SalesData('Jun', 34)
                ]);
              }
              else if(pointIndex.viewportPointIndex==1){
                //This Is NewData For Barchart.
                updateSalesData([
                  ChartData('Jan', 21, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Feb', 11, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Mar', 31, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Apr', 41, const Color.fromRGBO(9, 0, 136, 1)),

                  ChartData('May', 31, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jun', 23, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jul', 14, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Aug', 75, const Color.fromRGBO(9, 0, 136, 1)),
                ]);
                updateEnquiryData([
                  ChartData('Jan', 41, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Feb', 12, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Mar', 31, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Apr', 32, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('May', 36, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jun', 24, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jul', 75, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Aug', 63, const Color.fromRGBO(9, 0, 136, 1)),
                ]);

                //This Is NewData For LineChart.
                updatedItem1Data([
                  _SalesData('Jan', 37),
                  _SalesData('Feb', 19),
                  _SalesData('Mar', 43),
                  _SalesData('Apr', 24),
                  _SalesData('May', 53),
                  _SalesData('Jun', 34),
                  _SalesData('Jul', 33)
                ]);
                updatedItem2Data([
                  _SalesData('Jan', 23),
                  _SalesData('Feb', 39),
                  _SalesData('Mar', 34),
                  _SalesData('Apr', 42),
                  _SalesData('May', 35),
                  _SalesData('Jun', 43),
                  _SalesData('Jul', 45)
                ]);

              }
              else if(pointIndex.viewportPointIndex==2){
                //This Is NewData For BarChart.
                updateSalesData([
                  ChartData('Jan', 21, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Feb', 11, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Mar', 31, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Apr', 41, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('May', 31, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jun', 23, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jul', 14, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Aug', 75, const Color.fromRGBO(9, 0, 136, 1)),

                  ChartData('Sep', 52, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Oct', 13, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Nov', 25, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Dec', 21, const Color.fromRGBO(9, 0, 136, 1)),
                ]);
                updateEnquiryData([
                  ChartData('Jan', 41, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Feb', 12, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Mar', 31, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Apr', 32, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('May', 36, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jun', 24, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jul', 75, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Aug', 63, const Color.fromRGBO(9, 0, 136, 1)),

                  ChartData('Sep', 63, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Oct', 42, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Nov', 46, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Dec', 61, const Color.fromRGBO(9, 0, 136, 1)),
                ]);

                //This Is NewData For LineChart.
                updatedItem1Data([
                  _SalesData('Jan', 32),
                  _SalesData('Feb', 27),
                  _SalesData('Mar', 33),
                  _SalesData('Apr', 26),
                  _SalesData('May', 31),
                  _SalesData('Jun', 37),
                  _SalesData('Jul', 33)
                ]);
                updatedItem2Data([
                  _SalesData('Jan', 23),
                  _SalesData('Feb', 36),
                  _SalesData('Mar', 25),
                  _SalesData('Apr', 30),
                  _SalesData('May', 41),
                  _SalesData('Jun', 34),
                  _SalesData('Jul', 23)
                ]);

              }
              else if(pointIndex.viewportPointIndex==3){

                //This Is NewData For BarChart.
                updateSalesData([
                  ChartData('Jan', 34, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Feb', 52, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Mar', 21, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Apr', 34, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('May', 53, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jun', 34, const Color.fromRGBO(9, 0, 136, 1)),
                ]);
                updateEnquiryData([
                  ChartData('Jan', 54, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Feb', 64, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Mar', 74, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Apr', 85, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('May', 43, const Color.fromRGBO(9, 0, 136, 1)),
                  ChartData('Jun', 75, const Color.fromRGBO(9, 0, 136, 1)),
                ]);

                //This Is NewData For LineChart.
                updatedItem1Data([
                  _SalesData('Jan', 26),
                  _SalesData('Feb', 37),
                  _SalesData('Mar', 23),
                  _SalesData('Apr', 29),
                  _SalesData('May', 22),
                  _SalesData('Jun', 30),
                  _SalesData('Jul', 25),
                  _SalesData('Aug', 35)
                ]);

                updatedItem2Data([
                  _SalesData('Jan', 33),
                  _SalesData('Feb', 27),
                  _SalesData('Mar', 25),
                  _SalesData('Apr', 21),
                  _SalesData('May', 32),
                  _SalesData('Jun', 42),
                  _SalesData('Jul', 35),
                  _SalesData('Aug', 42)
                ]);
              }
           }
          },
          enableTooltip: true,
          dataSource: pieChartData,
          pointColorMapper: (ChartData2 data, _) => data.color,
          xValueMapper: (ChartData2 data, _) => data.x,
          yValueMapper: (ChartData2 data, _) => data.enquiry,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Text(
                "${data.x}",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChartData2 {
  final String x;
  final double enquiry;
  final double sales;
  final double targeted;
  final double achieved;
  final Color color;

  ChartData2(this.x, this.enquiry,this.sales, this.targeted, this.achieved, this.color, );
}





