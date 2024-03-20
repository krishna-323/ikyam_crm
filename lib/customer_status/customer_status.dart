import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../class/arguments_class/argument_class.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';

class CustomerStatus extends StatefulWidget {

  final CustomerStatusArgs args;
  const CustomerStatus({super.key,
   required this.args});

  @override
  State<CustomerStatus> createState() => _CustomerStatusState();
}

class _CustomerStatusState extends State<CustomerStatus> {
  int draggedColumnIndex=0;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState.
    getCustomerFromAws();

  }
  List mainList=[];
  List awarenessListData = [];
  List interestListData = [];
  List considerationListData = [];
  List intentListData = [];
  List buyListData = [];
  ///aws Api call.
  Future<void> getCustomerFromAws() async {
    String url = "https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/customerdetails/get_all_customerdetails";
    final resData = await http.get(Uri.parse(url));
    final responseBody= jsonDecode(resData.body);
    try {

        mainList = responseBody;
        setState(() {
          for(int i=0;i<mainList.length;i++){
            if(mainList[i]['selectStage']=="Awareness"){
              awarenessListData.add(mainList[i]);
            }
            if(mainList[i]['selectStage']=="Interest"){
              interestListData.add(mainList[i]);
            }
            if(mainList[i]["selectStage"]=="Consideration"){
              considerationListData.add(mainList[i]);
            }
            if(mainList[i]['selectStage']=="Intent"){
              intentListData.add(mainList[i]);
            }
            if(mainList[i]['selectStage']=="Buy"){
              buyListData.add(mainList[i]);
            }
          }
        });

     // loading=false;
    } catch (e) {
      // Handle errors here
      log("Error fetching customers: $e");
    }
  }

  ///aws Patch api.
  awsPatchApi(Map requestData,String iD)async{

    String url ="https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/customerdetails/patch_customerdetails/$iD";

    final resData = await http.patch(Uri.parse(url),
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
                content: const SelectableText('Something went wrong!!!!!!!!!!'),
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
                content: SelectableText('Business Partner ID ${responseBody['customerDetailsId']} is Updated'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
                      //     CustomerList(arg: CustomerListArgs(
                      //         drawerWidth: widget.drawerWidth,
                      //         selectedDestination: widget.selectedDestination),),));
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
      log('--------Error------');
      log(e.toString());
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),),
      body: Row(
        children: <Widget>[
          CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),

          // Column(children: [
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       buildColumn(awarenessListData, 0,"AWARENESS",awarenessListData.length),
          //       buildColumn(interestListData, 1,"INTEREST",interestListData.length),
          //       buildColumn(considerationListData, 2, "CONSIDERATION",considerationListData.length),
          //       buildColumn(intentListData, 3, "INTENT",intentListData.length),
          //       buildColumn(buyListData, 4, "BUY",buyListData.length),
          //   ],)
          // ],)

          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: ScrollController(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        //minWidth: 1000,
                         minHeight: constraints.maxHeight,
                         minWidth: constraints.maxWidth,
                      ),
                      child: Row(
                        children: [
                          buildColumn(awarenessListData, 0, "AWARENESS", awarenessListData.length,constraints.maxWidth ),
                          buildColumn(interestListData, 1, "INTEREST", interestListData.length, constraints.maxWidth),
                          buildColumn(considerationListData, 2, "CONSIDERATION",considerationListData.length,constraints.maxWidth ),
                                buildColumn(intentListData, 3, "INTENT",intentListData.length,constraints.maxWidth ),
                                buildColumn(buyListData, 4, "BUY",buyListData.length,constraints.maxWidth),
                          // Add more buildColumn calls as needed for other stages
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }



  Widget buildColumn(List items, int columnIndex,String name, int length, double maxWidth,  ) {
    return DragTarget(
      onWillAccept: (data) {
         // Store the index of the column from which the item is being dragged.
        draggedColumnIndex = columnIndex;
        return true;
      },

      onAccept: (Map data) {
        String status ="";

        if(columnIndex ==0) status = "Awareness";
        if(columnIndex ==1) status ="Interest";
        if(columnIndex ==2) status = "Consideration";
        if(columnIndex ==3) status = "Intent";
        if(columnIndex ==4) status = "Buy";

        if (data['status'] != status) {

          Map tempData = {
              "customerDetailsId": data['customerDetailsId'],
              "customerName": data['customerName'],
              "district": data['district'],
              "email": data['email'],
              "mobileNumber": data['mobileNumber'],
              "pan": data['pan'],
              "pinCode": data['pinCode'],
              "projectValue": data['projectValue'],
              "selectStage": status,
              "state": data['state'],
              "streetAddress": data['streetAddress'],
          };

          Map patchMethod ={
            "selectStage": status
          };

          setState(() {
            //Update Api Call.
            awsPatchApi(patchMethod,data['customerDetailsId']);

            //Displaying Data In UI.
            items.add(tempData);
          });
        }

      },
      builder: (context, candidateData, rejectedData) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: SizedBox(
                  width: 270,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Adjust the radius value as needed
                      ),
                      child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name),
                        const SizedBox(width: 5,),
                        Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(border: Border.all(width: 0.5,color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(5))),
                            child: Center(child: Text(length.toString()))),
                      ],
                    ),
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height/1.3,
               width:  270,
                color: Colors.grey[200],
                child: items.isEmpty
                    ? const Center(child: Text(""))
                    : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                  return Draggable(
                    data: items[index],
                    feedback: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Adjust the radius value as needed
                        ),
                        child:
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${items[index]['customerName']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),),
                          //Text("Status: ${items[index]['selectStage']}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Value: ${items[index]['projectValue']}"),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text("${items[index]['selectStage']}.",
                                style:  TextStyle(
                                    color:columnIndex == 0? Colors.blue:
                                    columnIndex == 1? Colors.red[300]:
                                    columnIndex == 2? Colors.orange:
                                    columnIndex == 3? Colors.green:
                                    Colors.black),
                                ),
                              )
                            ],
                          )
                        ],
                    ),
                      )),
                    childWhenDragging: Container(),
                    onDragCompleted: () {
                              String status = "";
                              if (draggedColumnIndex == 0) status = "Awareness";
                              if (draggedColumnIndex == 1) status = "Interest";
                              if (draggedColumnIndex == 2) status = "Consideration";
                              if (draggedColumnIndex == 3) status = "Intent";
                              if (draggedColumnIndex == 4) status = "Buy";

                              if (items[index]['status'] != status) {
                                setState(() {
                                  items.removeAt(index);
                                });
                              }
                            },
                    child: Card(
                     child:
                         Padding(
                           padding: const EdgeInsets.all(12),
                           child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("${items[index]['customerName']}",
                               style: const TextStyle(fontWeight: FontWeight.bold),
                             ),
                            // Text("Status: ${items[index]['selectStage']}"),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text("Value: ${items[index]['projectValue']}"),
                                 Padding(
                                   padding: const EdgeInsets.only(right: 8.0),
                                   child: Text("${items[index]['selectStage']}.",
                                     style:  TextStyle(
                                         color:columnIndex == 0? Colors.blue:
                                         columnIndex == 1? Colors.red[300]:
                                         columnIndex == 2? Colors.orange:
                                         columnIndex == 3? Colors.green:
                                         Colors.black),
                                   ),
                                 )
                               ],
                             )
                     ]),
                         ),
                    ),
                  );
                },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}





// class _YourWidgetState extends State<YourWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Responsive Layout'),
//       ),
//       body: LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//           return SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: constraints.maxHeight,
//                 minWidth: constraints.maxWidth,
//               ),
//               child: Column(
//                 children: [
//                   buildColumn(awarenessListData, 0, "AWARENESS", awarenessListData.length),
//                   buildColumn(interestListData, 1, "INTEREST", interestListData.length),
//                   // Add more buildColumn calls as needed for other stages
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildColumn(List items, int columnIndex, String name, int length) {
//     return DragTarget(
//       onWillAccept: (data) {
//         // Store the index of the column from which the item is being dragged.
//         draggedColumnIndex = columnIndex;
//         return true;
//       },
//       onAccept: (Map data) {
//         String status = "";
//
//         if (columnIndex == 0)
//           status = "Awareness";
//         else if (columnIndex == 1)
//           status = "Interest";
//         // Add more conditions for other stages
//
//         if (data['status'] != status) {
//           Map tempData = {
//             "customerDetailsId": data['customerDetailsId'],
//             "customerName": data['customerName'],
//             "district": data['district'],
//             "email": data['email'],
//             "mobileNumber": data['mobileNumber'],
//             "pan": data['pan'],
//             "pinCode": data['pinCode'],
//             "projectValue": data['projectValue'],
//             "selectStage": status,
//             "state": data['state'],
//             "streetAddress": data['streetAddress'],
//           };
//
//           Map patchMethod = {
//             "selectStage": status
//           };
//
//           setState(() {
//             //Update Api Call.
//             awsPatchApi(patchMethod, data['customerDetailsId']);
//
//             //Displaying Data In UI.
//             items.add(tempData);
//           });
//         }
//       },
//       builder: (context, candidateData, rejectedData) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     name,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(width: 10), // Adjust as needed
//                       Text(length.toString()),
//                       SizedBox(width: 10), // Adjust as needed
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       return Draggable(
//                         data: items[index],
//                         feedback: Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "${items[index]['customerName']}",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Value: ${items[index]['projectValue']}"),
//                                     Padding(
//                                       padding: const EdgeInsets.only(right: 8.0),
//                                       child: Text(
//                                         "${items[index]['selectStage']}.",
//                                         style: TextStyle(
//                                           color: columnIndex == 0 ? Colors.blue :
//                                           columnIndex == 1 ? Colors.red[300] :
//                                           columnIndex == 2 ? Colors.orange :
//                                           columnIndex == 3 ? Colors.green :
//                                           Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         childWhenDragging: Container(),
//                         onDragCompleted: () {
//                           String status = "";
//                           if (draggedColumnIndex == 0) status = "Awareness";
//                           else if (draggedColumnIndex == 1) status = "Interest";
//                           // Add more conditions for other stages
//
//                           if (items[index]['status'] != status) {
//                             setState(() {
//                               items.removeAt(index);
//                             });
//                           }
//                         },
//                         child: Card(
//                           child: Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "${items[index]['customerName']}",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Value: ${items[index]['projectValue']}"),
//                                     Padding(
//                                       padding: const EdgeInsets.only(right: 8.0),
//                                       child: Text(
//                                         "${items[index]['selectStage']}.",
//                                         style: TextStyle(
//                                           color: columnIndex == 0 ? Colors.blue :
//                                           columnIndex == 1 ? Colors.red[300] :
//                                           columnIndex == 2 ? Colors.orange :
//                                           columnIndex == 3 ? Colors.green :
//                                           Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }





