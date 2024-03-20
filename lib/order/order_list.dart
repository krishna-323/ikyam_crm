import 'dart:developer';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:ikyam_crm/order/view_order_details.dart';
import '../class/arguments_class/argument_class.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import 'create_order.dart';

class OrderList extends StatefulWidget {
  final ListOrderArgs args;

  const OrderList({super.key, required this.args});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  List vendorList= [
    {
      "estVehicleId": "SEVH_18606",
      "address": "string",
      "billAddressName": "Arka Media",
      "billAddressStreet": "4081 Evergreen Lane, 4525 Garrett Street",
      "billAddressCity": "Michigan",
      "billAddressState": "California",
      "billAddressZipcode": 91801.0,
      "shipAddressName": "Arka Media",
      "shipAddressStreet": "4081 Evergreen Lane, 4525 Garrett Street",
      "shipAddressCity": "Michigan",
      "shipAddressState": "California",
      "shipAddressZipcode": 91801.0,
      "serviceInvoice": "",
      "serviceInvoiceDate": "04-10-2023",
      "serviceDueDate": "",
      "subTotalDiscount": 0.0,
      "subTotalTax": 0.0,
      "subTotalAmount": 444544.0,
      "totalTaxableAmount": 0.0,
      "additionalCharges": 0.0,
      "total": 444544.0,
      "termsConditions": "Test User 2",
      "status": "Approved",
      "comment": "Approved",
      "userid": "USER_18598",
      "manager_id": "MNGR_00711",
      "org_id": "COM_18501",
      "items": [
        {
          "estItemId": "EIM_18609",
          "itemsService": "Honda 555",
          "quantity": 1.0,
          "priceItem": 444444.0,
          "discount": 0.0,
          "tax": 0.0,
          "amount": 444444.0,
          "estVehicleId": "SEVH_18606"
        },
        {
          "estItemId": "EIM_18610",
          "itemsService": "KIA55",
          "quantity": 1.0,
          "priceItem": 100.0,
          "discount": 0.0,
          "tax": 0.0,
          "amount": 100.0,
          "estVehicleId": "SEVH_18606"
        }
      ]
    },
    {
      "estVehicleId": "SEVH_20888",
      "address": "string",
      "billAddressName": "Wall Poster",
      "billAddressStreet": "2230 Fancher Drive, , Oakmound",
      "billAddressCity": "Dallas",
      "billAddressState": "Texas",
      "billAddressZipcode": 75217.0,
      "shipAddressName": "Wall Poster",
      "shipAddressStreet": "2230 Fancher Drive, , Oakmound",
      "shipAddressCity": "Dallas",
      "shipAddressState": "Texas",
      "shipAddressZipcode": 75217.0,
      "serviceInvoice": "",
      "serviceInvoiceDate": "11-10-2023",
      "serviceDueDate": "string",
      "subTotalDiscount": 400000.0,
      "subTotalTax": 600000.0,
      "subTotalAmount": 2.02E7,
      "totalTaxableAmount": 2.02E7,
      "additionalCharges": 123.0,
      "total": 2.0200123E7,
      "termsConditions": "Test",
      "status": "In-review",
      "comment": "",
      "userid": "MNGR_00711",
      "manager_id": "MNGR_00711",
      "org_id": "COM_05564",
      "items": [
        {
          "estItemId": "EIM_20889",
          "itemsService": "SIGNA 2823",
          "quantity": 2.0,
          "priceItem": 1.0E7,
          "discount": 2.0,
          "tax": 3.0,
          "amount": 2.02E7,
          "estVehicleId": "SEVH_20888"
        }
      ]
    },
    {
      "estVehicleId": "SEVH_20936",
      "address": "string",
      "billAddressName": "Arka Media",
      "billAddressStreet": "4081 Evergreen Lane, 4525 Garrett Street",
      "billAddressCity": "Michigan",
      "billAddressState": "California",
      "billAddressZipcode": 91801.0,
      "shipAddressName": "Arka Media",
      "shipAddressStreet": "4081 Evergreen Lane, 4525 Garrett Street",
      "shipAddressCity": "Michigan",
      "shipAddressState": "California",
      "shipAddressZipcode": 91801.0,
      "serviceInvoice": "",
      "serviceInvoiceDate": "12-10-2023",
      "serviceDueDate": "",
      "subTotalDiscount": 0.0,
      "subTotalTax": 0.0,
      "subTotalAmount": 1.54E7,
      "totalTaxableAmount": 0.0,
      "additionalCharges": 0.0,
      "total": 1.54E7,
      "termsConditions": "Dealer Notes",
      "status": "Approved",
      "comment": "Approved",
      "userid": "USER_20933",
      "manager_id": "MNGR_00711",
      "org_id": "COM_20930",
      "items": [
        {
          "estItemId": "EIM_20939",
          "itemsService": "T1 AMB",
          "quantity": 2.0,
          "priceItem": 7700000.0,
          "discount": 0.0,
          "tax": 0.0,
          "amount": 1.54E7,
          "estVehicleId": "SEVH_20936"
        }
      ]
    },
    {
      "estVehicleId": "SEVH_20951",
      "address": "string",
      "billAddressName": "ABC Motors",
      "billAddressStreet": "123 Evergreen Lane, Main Street",
      "billAddressCity": "Johannesburg",
      "billAddressState": "Gauteng",
      "billAddressZipcode": 2000.0,
      "shipAddressName": "ABC Motors",
      "shipAddressStreet": "123 Evergreen Lane, Main Street",
      "shipAddressCity": "Johannesburg",
      "shipAddressState": "Gauteng",
      "shipAddressZipcode": 2000.0,
      "serviceInvoice": "",
      "serviceInvoiceDate": "13-10-2023",
      "serviceDueDate": "string",
      "subTotalDiscount": 0.0,
      "subTotalTax": 0.0,
      "subTotalAmount": 1.0E7,
      "totalTaxableAmount": 1.0E7,
      "additionalCharges": 0.0,
      "total": 1.0E7,
      "termsConditions": "Notes",
      "status": "In-review",
      "comment": "",
      "userid": "USER_20949",
      "manager_id": "MNGR_00711",
      "org_id": "COM_20947",
      "items": [
        {
          "estItemId": "EIM_20952",
          "itemsService": "SIGNA 2823",
          "quantity": 1.0,
          "priceItem": 1.0E7,
          "discount": 0.0,
          "tax": 0.0,
          "amount": 1.0E7,
          "estVehicleId": "SEVH_20951"
        }
      ]
    },
    {
      "estVehicleId": "SEVH_20983",
      "address": "string",
      "billAddressName": "ABC Motors",
      "billAddressStreet": "123 Evergreen Lane, Main Street",
      "billAddressCity": "Johannesburg",
      "billAddressState": "Gauteng",
      "billAddressZipcode": 2000.0,
      "shipAddressName": "ABC Motors",
      "shipAddressStreet": "123 Evergreen Lane, Main Street",
      "shipAddressCity": "Johannesburg",
      "shipAddressState": "Gauteng",
      "shipAddressZipcode": 2000.0,
      "serviceInvoice": "",
      "serviceInvoiceDate": "13-10-2023",
      "serviceDueDate": "",
      "subTotalDiscount": 680000.0,
      "subTotalTax": 204000.0,
      "subTotalAmount": 6324000.0,
      "totalTaxableAmount": 0.0,
      "additionalCharges": 0.0,
      "total": 6324000.0,
      "termsConditions": "Test Notes",
      "status": "Approved",
      "comment": "Approved",
      "userid": "USER_20980",
      "manager_id": "MNGR_00711",
      "org_id": "COM_20977",
      "items": [
        {
          "estItemId": "EIM_20985",
          "itemsService": "KC3C1",
          "quantity": 1.0,
          "priceItem": 6800000.0,
          "discount": 10.0,
          "tax": 3.0,
          "amount": 6324000.0,
          "estVehicleId": "SEVH_20983"
        }
      ]
    }
  ];

  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();
  List displayList=[];
  int startVal=0;
  @override
  void initState() {
    // TODO: implement initState.
    if(displayList.isEmpty){
      if(vendorList.length>15){
        for(int i=0;i<=startVal+15;i++){
          displayList.add(vendorList[i]);
        }
      }
      else{
        for(int i=0;i<vendorList.length;i++){
          displayList.add(vendorList[i]);
        }
      }
    }
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // print('--------Screen Width-------');
    // print(screenWidth);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),),
      body: Row(children: [
        CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
        const VerticalDivider(
          width: 1,
          thickness: 1,
        ),
        if(screenWidth>1140)
        Expanded(child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[50],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0,right: 40,top: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0E0E0),)
                ),
                child: Column(children: [
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
                                const Text("Orders List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                                ),

                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: OutlinedMButton(
                                    text: '+Create Order',
                                    buttonColor:mSaveButton ,
                                    textColor: Colors.white,
                                    borderColor: mSaveButton,
                                    onTap: () {
                                      Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (context,animation1,animation2)=>CreatePartOrder(
                                            drawerWidth: widget.args.drawerWidth,
                                            selectedDestination: widget.args.selectedDestination,
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero
                                      ));
                                    },

                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18,),
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
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text("Vendor Name")
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: SizedBox(
                                                height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text('Ship To Name')
                                            ),
                                          )
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text("Date")
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text("Total Amount")
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text("Status")
                                            ),
                                          )),
                                      Center(child: Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(size: 18,
                                          Icons.more_vert,
                                          color: Colors.transparent,
                                        ),
                                      ),)
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
                  for(int i=0;i<=vendorList.length;i++)
                    Column(children: [
                      if(i!=vendorList.length)
                        MaterialButton(
                          hoverColor: Colors.blue[50],
                          onPressed: () {
                            Navigator.of(context).push(
                                PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
                                    PartOrderDetails(
                                      drawerWidth: widget.args.drawerWidth,
                                      selectedDestination: widget.args.selectedDestination,
                                      staticData: vendorList[i],
                                      transitionDuration: const Duration(milliseconds: 0),
                                      reverseTransitionDuration: const Duration(milliseconds: 0),
                                    ) ,)
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: SizedBox(height: 25,
                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: Text(vendorList[i]['billAddressName']??"")
                                      ),
                                    )),
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: SizedBox(
                                        height: 25,
                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                        child:

                                        Tooltip(message:vendorList[i]['shipAddressName']?? '',waitDuration: const Duration(seconds: 1),
                                            child: Text(vendorList[i]['shipAddressName']?? '',softWrap: true,)),
                                      ),
                                    )
                                ),
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: SizedBox(height: 25,
                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: Text(vendorList[i]['serviceInvoiceDate']??"")
                                      ),
                                    )),
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: SizedBox(height: 25,
                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: Text(vendorList[i]['subTotalAmount'].toString())
                                      ),
                                    )),
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: SizedBox(height: 25,
                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: Text(vendorList[i]['status'] ?? "")
                                      ),
                                    )),
                                const Center(child: Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(size: 18,
                                    Icons.arrow_circle_right,
                                    color: Colors.blue,
                                  ),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      if(i!=vendorList.length)
                        Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                      if(i==displayList.length)
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Text("${startVal+15>vendorList.length? vendorList.length:startVal+1}-"
                                "${startVal+15>vendorList.length?vendorList.length:startVal+15} of "
                                "${vendorList.length}",style: const TextStyle(color: Colors.grey)),

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
                                          displayList.add(vendorList[i]);
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
                                  if(vendorList.length>startVal+15){
                                    displayList=[];
                                    startVal=startVal+15;
                                    for(int i=startVal;i<startVal+15;i++){
                                      try{
                                        setState(() {
                                          displayList.add(vendorList[i]);
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

                ]),
              ),
            ),
          ),
        ))
        else...{
          Expanded(
            child: AdaptiveScrollbar(
              underColor: Colors.blueGrey.withOpacity(0.3),
              sliderDefaultColor: Colors.grey.withOpacity(0.7),
              sliderActiveColor: Colors.grey,
              controller:_verticalScrollController,
              child: AdaptiveScrollbar(
                position: ScrollbarPosition.bottom,
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: Colors.grey.withOpacity(0.7),
                sliderActiveColor: Colors.grey,
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      color: Colors.grey[50],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40,top: 30),
                        child: Container(
                          width: 1140,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE0E0E0),)

                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                              const Text("Orders List ", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                                              ),

                                              SizedBox(
                                                width: 100,
                                                height: 30,
                                                child: OutlinedMButton(
                                                  text: '+Create Order',
                                                  buttonColor:mSaveButton ,
                                                  textColor: Colors.white,
                                                  borderColor: mSaveButton,
                                                  onTap: () {
                                                    Navigator.of(context).push(PageRouteBuilder(
                                                        pageBuilder: (context,animation1,animation2)=>CreatePartOrder(
                                                          drawerWidth: widget.args.drawerWidth,
                                                          selectedDestination: widget.args.selectedDestination,
                                                        ),
                                                        // transitionDuration: Duration.zero,
                                                        // reverseTransitionDuration: Duration.zero
                                                    ));
                                                  },

                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 18,),
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
                                                    Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 4.0),
                                                          child: SizedBox(height: 25,
                                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                              child: Text("Vendor Name")
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 4),
                                                          child: SizedBox(
                                                              height: 25,
                                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                              child: Text('Ship To Name')
                                                          ),
                                                        )
                                                    ),
                                                    Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 4),
                                                          child: SizedBox(height: 25,
                                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                              child: Text("Date")
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 4),
                                                          child: SizedBox(height: 25,
                                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                              child: Text("Total Amount")
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 4),
                                                          child: SizedBox(height: 25,
                                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                              child: Text("Status")
                                                          ),
                                                        )),
                                                    Center(child: Padding(
                                                      padding: EdgeInsets.only(right: 8),
                                                      child: Icon(size: 18,
                                                        Icons.more_vert,
                                                        color: Colors.transparent,
                                                      ),
                                                    ),)
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
                                for(int i=0;i<=displayList.length;i++)
                                  Column(children: [
                                    if(i!=displayList.length)
                                      MaterialButton(
                                        hoverColor: Colors.blue[50],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
                                                  PartOrderDetails(
                                                    drawerWidth: widget.args.drawerWidth,
                                                    selectedDestination: widget.args.selectedDestination,
                                                    staticData: vendorList[i],
                                                    transitionDuration: const Duration(milliseconds: 0),
                                                    reverseTransitionDuration:const Duration(milliseconds: 0),
                                                  ) ,)
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text(vendorList[i]['billAddressName']??"")
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4),
                                                    child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child:

                                                      Tooltip(message:vendorList[i]['shipAddressName']?? '',waitDuration:const Duration(seconds: 1),
                                                          child: Text(vendorList[i]['shipAddressName']?? '',softWrap: true,)),
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text(vendorList[i]['serviceInvoiceDate']??"")
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text(vendorList[i]['subTotalAmount'].toString())
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text(vendorList[i]['status'] ?? "")
                                                    ),
                                                  )),
                                              const Center(child: Padding(
                                                padding: EdgeInsets.only(right: 8),
                                                child: Icon(size: 18,
                                                  Icons.arrow_circle_right,
                                                  color: Colors.blue,
                                                ),
                                              ),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    if(i!=displayList.length)
                                      Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                    if(i==displayList.length)
                                      Row(mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          Text("${startVal+15>vendorList.length? vendorList.length:startVal+1}-"
                                              "${startVal+15>vendorList.length?vendorList.length:startVal+15} of "
                                              "${vendorList.length}",style: const TextStyle(color: Colors.grey)),

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
                                                        displayList.add(vendorList[i]);
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
                                                if(vendorList.length>startVal+15){
                                                  displayList=[];
                                                  startVal=startVal+15;
                                                  for(int i=startVal;i<startVal+15;i++){
                                                    try{
                                                      setState(() {
                                                        displayList.add(vendorList[i]);
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
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        }
      ]),
    );
  }
}
