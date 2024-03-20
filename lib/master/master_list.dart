import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ikyam_crm/master/view_master_details.dart';

import '../class/arguments_class/argument_class.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import 'create_master.dart';

class MasterList extends StatefulWidget {
  final MasterListArgs args;

  const MasterList({super.key, required this.args});

  @override
  State<MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<MasterList> {

  List partsList = [
    {
      "newitem_id": "NWITM_01039",
      "item_code": "257350009904",
      "name": "CV-TML",
      "unit": "BOX",
      "description": "TIE ROD-185 LONG",
      "selling_price": 92.95,
      "selling_account": "Discount",
      "tax_code": "09",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "General Income",
      "purchase_price": 2.0E7,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_01155",
      "item_code": "257432308602",
      "name": "CV-TML",
      "unit": "BOX",
      "description": "BUSH FRT S/ABS",
      "selling_price": 93.95,
      "selling_account": "Discount",
      "tax_code": "09",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "General Income",
      "purchase_price": 2.0E7,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_01965",
      "item_code": "257441109901",
      "name": "CV-TML",
      "unit": "BOX",
      "description": "GREASE NIPPLE",
      "selling_price": 94.95,
      "selling_account": "Discount",
      "tax_code": "09",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "General Income",
      "purchase_price": 2.0E7,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_05668",
      "item_code": "257450006904",
      "name": "CV-TML",
      "unit": "BOX",
      "description": "SPACER TUBE",
      "selling_price": 92.95,
      "selling_account": "Discount",
      "tax_code": "09",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "General Income",
      "purchase_price": 2.0E7,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_18480",
      "item_code": "257450006906",
      "name": "CV-TML",
      "unit": "BOX",
      "description": "SPACER TUBE 25.5MM",
      "selling_price": 96.95,
      "selling_account": "Discount",
      "tax_code": "09",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "General Income",
      "purchase_price": 2.0E7,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20890",
      "item_code": "257526406702",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "PIN",
      "selling_price": 9795.0,
      "selling_account": "Select",
      "tax_code": "Xyx",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 9795.0,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20891",
      "item_code": "257526808601",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SPACER",
      "selling_price": 9895.0,
      "selling_account": "Select",
      "tax_code": "1",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 9895.0,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20892",
      "item_code": "257533206301",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "DUST CAP STUB AXLE",
      "selling_price": 99.95,
      "selling_account": "Select",
      "tax_code": "1",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 99.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20893",
      "item_code": "257629508602",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SPACER",
      "selling_price": 100.95,
      "selling_account": "Select",
      "tax_code": "1",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 100.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20894",
      "item_code": "257632308604",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SPACER",
      "selling_price": 101.95,
      "selling_account": "Select",
      "tax_code": "1",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 101.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20895",
      "item_code": "257632309201",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "WASHER",
      "selling_price": 102.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 102.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20896",
      "item_code": "257632309201",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "WASHER",
      "selling_price": 102.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 102.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20897",
      "item_code": "257633109901",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "GREASE NIPPLE L TYPE",
      "selling_price": 103.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 103.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20898",
      "item_code": "257633207702",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "GASKET RING",
      "selling_price": 104.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 104.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20899",
      "item_code": "257633207702",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SEALING CAP STUB AXLE",
      "selling_price": 105.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 105.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20900",
      "item_code": "257633207702",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "THRUST WASHER 1.3MM THK",
      "selling_price": 106.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 106.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20901",
      "item_code": "257640209201",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SPHERICAL RING",
      "selling_price": 107.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 107.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20902",
      "item_code": "257641108002",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SCREW",
      "selling_price": 108.45,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 108.45,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20903",
      "item_code": "257641108002",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "CLAMP",
      "selling_price": 109.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 109.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20904",
      "item_code": "257641108002",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SPACER PLATE",
      "selling_price": 110.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 110.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20905",
      "item_code": "257642914201",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "CLAMP",
      "selling_price": 111.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 111.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20906",
      "item_code": "257681506302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "RUBBER PAD GRAB HANDLE",
      "selling_price": 112.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 112.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20907",
      "item_code": "257681506302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "PIN-SHOCK ABSORBER",
      "selling_price": 113.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 113.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20908",
      "item_code": "257681506302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SPACER TUBE",
      "selling_price": 114.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 114.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20909",
      "item_code": "257681506302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "CLEVIS PIN",
      "selling_price": 115.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 115.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20910",
      "item_code": "257681506302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SHIM 0.50MM",
      "selling_price": 116.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 116.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20911",
      "item_code": "257681506302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SHIM 0.10 MM",
      "selling_price": 117.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 117.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20912",
      "item_code": "257681506302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SHIM 0.20 MM",
      "selling_price": 118.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 118.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20913",
      "item_code": "261835608305",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SHIM 0.30 MM",
      "selling_price": 119.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 119.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20914",
      "item_code": "261835608310",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SHIM 0.15 THK",
      "selling_price": 120.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 120.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20915",
      "item_code": "261835608310",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "LOCK RING",
      "selling_price": 121.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 121.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20916",
      "item_code": "261842109203",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "WASHER",
      "selling_price": 122.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 122.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20917",
      "item_code": "261842109203",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "WASHER-HARDENED",
      "selling_price": 123.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 123.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20918",
      "item_code": "263246206302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "RUBBER BELLOW",
      "selling_price": 124.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 124.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20919",
      "item_code": "263246206302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "SPRING",
      "selling_price": 125.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 125.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20920",
      "item_code": "263246206302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "CLIP MASCOT",
      "selling_price": 126.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 126.95,
      "sac": "",
      "type": "Goods"
    },
    {
      "newitem_id": "NWITM_20921",
      "item_code": "263246206302",
      "name": "CV-TML",
      "unit": "DOZEN",
      "description": "BELLOW HOLDER",
      "selling_price": 127.95,
      "selling_account": "Select",
      "tax_code": "021111",
      "tax_preference": "Taxable",
      "exemption_reason": "",
      "purchase_account": "Select",
      "purchase_price": 127.95,
      "sac": "",
      "type": "Goods"
    }
  ];
  List displayList=[];
  int startVal=0;
  @override
  initState(){
    super.initState();

    if(displayList.isEmpty){
      if(partsList.length>5){
        for(int parts=0;parts<startVal+15;parts++){
         displayList.add(partsList[parts]);
        }
      }
      else{
        for(int part=0;part<partsList.length;part++){
          displayList.add(partsList[part]);
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
        CustomDrawer(widget.args.drawerWidth,widget.args.selectedDestination),
        const VerticalDivider(width: 1,thickness:1,),

        Expanded(child: tableStructure(context,MediaQuery.of(context).size.width))
      ]),
    );
  }

  Widget tableStructure(BuildContext context,double screenWidth,){
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[50],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0,right: 40,top: 30),
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
                            const Text("Parts List ", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(
                              width: 100,
                              height: 30,
                              child: OutlinedMButton(
                                text: '+ Master Part',
                                buttonColor:mSaveButton ,
                                textColor: Colors.white,
                                borderColor: mSaveButton,
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (context,animation1,animation2)=>CreateMaster(
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
                      // Padding(
                      //   padding: const EdgeInsets.only(left:18.0),
                      //   child: SizedBox(height: 100,
                      //     child: Row(
                      //       children: [
                      //         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             SizedBox(  width: 190,height: 30, child: TextFormField(
                      //               controller:customerNameController,
                      //               onChanged: (value){
                      //                 if(value.isEmpty || value==""){
                      //                   startVal=0;
                      //                   displayList=[];
                      //                   setState(() {
                      //                     if(staticCustomerData.length>5){
                      //                       for(int i=0;i<startVal+15;i++){
                      //                         displayList.add(staticCustomerData[i]);
                      //                       }
                      //                     }
                      //                     else{
                      //                       for(int i=0;i<staticCustomerData.length;i++){
                      //                         displayList.add(staticCustomerData[i]);
                      //                       }
                      //                     }
                      //                   });
                      //                 }
                      //                 else if(phoneController.text.isNotEmpty || emailController.text.isNotEmpty){
                      //                   phoneController.clear();
                      //                   emailController.clear();
                      //                 }
                      //                 else{
                      //                   startVal=0;
                      //                   displayList=[];
                      //
                      //                   fetchCustomerName(customerNameController.text);
                      //                 }
                      //               },
                      //               style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,
                      //               decoration: searchCustomerNameDecoration(hintText: 'Search By Name'),
                      //             ),),
                      //             const SizedBox(height: 20),
                      //             Row(
                      //               children: [
                      //
                      //                 SizedBox(  width: 190,height: 30, child: TextFormField(
                      //                   controller:emailController,
                      //                   onChanged: (value){
                      //                     if(value.isEmpty || value==""){
                      //                       startVal=0;
                      //                       displayList=[];
                      //                       // fetchListCustomerData();
                      //                     }
                      //                     else if(phoneController.text.isNotEmpty || customerNameController.text.isNotEmpty){
                      //                       phoneController.clear();
                      //                       customerNameController.clear();
                      //                     }
                      //                     else{
                      //                       startVal=0;
                      //                       displayList=[];
                      //                       // fetchCityNames(emailController.text);
                      //                     }
                      //                   },
                      //                   style: const TextStyle(fontSize: 14),
                      //                   keyboardType: TextInputType.text,
                      //                   decoration: searchCityNameDecoration(hintText: 'Search By Cityname'),
                      //                 ),),
                      //                 const SizedBox(width: 10,),
                      //
                      //                 SizedBox(  width: 190,height: 30, child: TextFormField(
                      //                   controller:phoneController,
                      //                   onChanged: (value){
                      //                     if(value.isEmpty || value==""){
                      //                       startVal=0;
                      //                       displayList=[];
                      //                       // fetchListCustomerData();
                      //                     }
                      //                     else if(customerNameController.text.isNotEmpty || emailController.text.isNotEmpty){
                      //                       customerNameController.clear();
                      //                       emailController.clear();
                      //                     }
                      //                     else{
                      //                       try{
                      //                         startVal=0;
                      //                         displayList=[];
                      //                         // fetchPhoneName(phoneController.text);
                      //                       }
                      //                       catch(e){
                      //                         log(e.toString());
                      //                       }
                      //                     }
                      //                   },
                      //                   style: const TextStyle(fontSize: 14),
                      //                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      //                   maxLength: 10,
                      //                   decoration: searchCustomerPhoneNumber(hintText: 'Search By Phone'),
                      //                 ),
                      //                 ),
                      //                 const SizedBox(width: 10,),
                      //               ],
                      //             ),
                      //           ],
                      //         )),
                      //       ],
                      //     ),
                      //   ),
                      // ),

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
                                            child: Text("Part Name")
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(
                                            height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text('Unit')
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("Selling Price")
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("Description")
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

              // Table Dynamic Content.
              for(int i=0;i<=displayList.length;i++)
                Column(children: [
                  if(i!=displayList.length)
                    MaterialButton(
                      hoverColor: Colors.blue[50],
                      onPressed: () {
                        Navigator.of(context).push(
                            PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
                                ViewMasterDetails(
                                  drawerWidth: widget.args.drawerWidth,
                                  selectedDestination: widget.args.selectedDestination,
                                  staticData: displayList[i],
                                ),
                                transitionDuration: const Duration(milliseconds: 0),
                                reverseTransitionDuration: const Duration(milliseconds: 0))
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
                                      child: Text(displayList[i]['name']??"")
                                  ),
                                )),
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SizedBox(
                                    height: 25,
                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                    child:

                                    Tooltip(message:displayList[i]['unit']?? '',waitDuration:const Duration(seconds: 1),
                                        child: Text(displayList[i]['unit']?? '',softWrap: true,)),
                                  ),
                                )
                            ),
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SizedBox(height: 25,
                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                      child: Text(displayList[i]['selling_price'].toString())
                                  ),
                                )),
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SizedBox(height: 25,
                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                      child: Text(displayList[i]['description']??"")
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

                        Text("${startVal+15>partsList.length?partsList.length:startVal+1}-"
                            "${startVal+15>partsList.length?partsList.length:startVal+15} of "
                            "${partsList.length}",style: const TextStyle(color: Colors.grey)),

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
                                      displayList.add(partsList[i]);
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
                              if(partsList.length>startVal+15){
                                displayList=[];
                                startVal=startVal+15;
                                for(int i=startVal;i<startVal+15;i++){
                                  try{
                                    setState(() {
                                      displayList.add(partsList[i]);
                                    });
                                  }
                                  catch(e){
                                    log(e.toString());
                                  }
                                }
                              }
                              setState(() {

                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 20,),

                      ],
                    ),
                  Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                ],),

            ]),
          ),
        ),
      ),
    );
  }
}
