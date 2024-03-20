import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import '../widgets/input_decoration_text_field.dart';
import 'create_master.dart';
import 'edit_master_details.dart';


class ViewMasterDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map staticData;

  const ViewMasterDetails({super.key, required this.drawerWidth,
    required this.selectedDestination,
    required this.staticData,});

  @override
  State<ViewMasterDetails> createState() => _ViewMasterDetailsState();
}

class _ViewMasterDetailsState extends State<ViewMasterDetails> {
  final _horizontalScrollController = ScrollController();
  Map storeStaticData={};

  List partsDetailsList=[
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

  String selectedId="";
  @override
  void initState() {
    // TODO: implement initState
    storeStaticData.addAll(widget.staticData);

    selectedId=storeStaticData['newitem_id']??"";
    controller=AutoScrollController();
    super.initState();
  }
  late   AutoScrollController controller=AutoScrollController();

  // Go To Edit Master Page Method.
  gotoEditMasterDetailsPage(){
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          EditMasterDetails(drawerWidth: widget.drawerWidth, selectedDestination: widget.selectedDestination,
            storeData: storeStaticData,
          ),
    ));
  }

  // Go to Create Master.
  gotoCreateMasterPage(){
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context,animation1,animation2)=>CreateMaster(
          drawerWidth: widget.drawerWidth,
          selectedDestination: widget.selectedDestination,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero
    ));
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),),

      body: Row(
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(thickness: 1,width: 1,),

          if(sizeWidth>1100)...{
            Expanded(child: Scaffold(
              backgroundColor: Colors.white,
              body: Row(
                children: [
                  SizedBox(
                    width: 300,
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
                                    width: 300,
                                    child: AppBar(
                                      title: const Text("Master Details",style: TextStyle(fontSize: 20)),
                                      elevation: 1,
                                      surfaceTintColor: Colors.white,
                                      shadowColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:   SizedBox(
                                            width: 100,
                                            height: 30,
                                            child: OutlinedMButton(
                                              text: '+ Master',
                                              //buttonColor:mSaveButton ,
                                              textColor: Colors.black,
                                              borderColor: mSaveButton,
                                              onTap: () {
                                                gotoCreateMasterPage();
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
                              child: SizedBox(height: 30, child: TextFormField(  style: const TextStyle(fontSize: 14),
                                keyboardType: TextInputType.text,
                                decoration:decorationSearch('Search Part Master'),  ),),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: partsDetailsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AutoScrollTag(
                                key: ValueKey(index),
                                controller: controller,
                                index: index,
                                child:   Column(
                                  children: [
                                    Container(
                                      color: selectedId == partsDetailsList[index]["newitem_id"] ? Colors.blue[100] : Colors.transparent,
                                      child: InkWell(
                                        hoverColor: mHoverColor,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 12, bottom: 12),
                                          child: Row(
                                            children: [
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(partsDetailsList[index]['name'],
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(partsDetailsList[index]['description']),
                                                  const SizedBox(height: 2,),
                                                  // Text(customerList[index]['mobile'],),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // onTap: () {
                                        //   selectedId = customerList[index]["customer_id"];
                                        //   setState(() {
                                        //     selectedIndex = index;
                                        //     customerDetailsBloc.fetchCustomerNetwork(customerList[index]['customer_id']);
                                        //     selectedId = customerList[index]['customer_id'];
                                        //   });
                                        //
                                        // },
                                      ),
                                    ),
                                    const Divider(height: 1,)
                                  ],
                                ),
                              );
                            },
                            // children: customerList.map((data){
                            //  // if(selectedId == data["newcustomer_id"]){
                            //
                            //     // stop= int.parse(data["newcustomer_id"]
                            //     // );
                            // //  }
                            //   print(data['newcustomer_id']);
                            //   return ;
                            // }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1,),
                  Expanded(
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(storeStaticData['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),),
                                  Text(storeStaticData['description'])
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
                                          gotoEditMasterDetailsPage();
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
                                                                        //deleteCustomerData();
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

                        Flexible(child: profileTab()),

                      ],),
                  ),
                ],
              ),
            )),
          }
          else...{
            Expanded(child: Scaffold(
              backgroundColor: Colors.white,
              body: Row(children: [
                SizedBox(
                  width: 200,
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
                                  width: 200,
                                  child: AppBar(
                                    title: const Text("Master Details",style: TextStyle(fontSize: 20)),
                                    elevation: 1,
                                    surfaceTintColor: Colors.white,
                                    shadowColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:  SizedBox(
                                          width: 100,
                                          height: 30,
                                          child: OutlinedMButton(
                                            text: '+ Master',
                                            //buttonColor:mSaveButton ,
                                            textColor: Colors.black,
                                            borderColor: mSaveButton,
                                            onTap: () {
                                              gotoCreateMasterPage();
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

                          // const Divider(height: 1),
                          // const SizedBox(height: 10,),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 10, right: 10, top: 4, bottom: 10),
                          //   child: SizedBox(height: 30, child: TextFormField(  style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,
                          //     decoration:decorationSearch('Search Customer'),  ),),
                          // ),
                        ],
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount: partsDetailsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AutoScrollTag(
                              key: ValueKey(index),
                              controller: controller,
                              index: index,
                              child:   Column(
                                children: [
                                  Container(
                                    color: selectedId == partsDetailsList[index]["name"] ? Colors.blue[100] : Colors.transparent,
                                    child: InkWell(
                                      hoverColor: mHoverColor,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, top: 12, bottom: 12),
                                        child: Row(
                                          children: [
                                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(partsDetailsList[index]['name'],
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(partsDetailsList[index]['description'],
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                                const SizedBox(height: 2,),
                                                // Text(customerList[index]['mobile'],),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // onTap: () {
                                      //   selectedId = customerList[index]["customer_id"];
                                      //   setState(() {
                                      //     selectedIndex = index;
                                      //     customerDetailsBloc.fetchCustomerNetwork(customerList[index]['customer_id']);
                                      //     selectedId = customerList[index]['customer_id'];
                                      //   });
                                      //
                                      // },
                                    ),
                                  ),
                                  const Divider(height: 1,)
                                ],
                              ),
                            );
                          },
                          // children: customerList.map((data){
                          //  // if(selectedId == data["newcustomer_id"]){
                          //
                          //     // stop= int.parse(data["newcustomer_id"]
                          //     // );
                          // //  }
                          //   print(data['newcustomer_id']);
                          //   return ;
                          // }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1,),
                Expanded(child: AdaptiveScrollbar(
                  position: ScrollbarPosition.bottom,
                  underColor: Colors.blueGrey.withOpacity(0.3),
                  sliderDefaultColor: Colors.grey.withOpacity(0.7),
                  sliderActiveColor: Colors.grey,
                  controller: _horizontalScrollController,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child:  SizedBox(
                      width: 1100,
                      child: Column(
                        children: [
                          const Divider(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(storeStaticData['name'],
                                      style: const TextStyle(fontWeight: FontWeight.bold),),
                                    Text(storeStaticData['description'])
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
                                            gotoEditMasterDetailsPage();
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
                                                                          //deleteCustomerData();
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
                          profileTab(),
                        ],
                      )
                    ),
                  ),
                ),)
              ],),),),
          }
        ],
      ),
    );
  }

  Widget profileTab() {
    return  Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 60,right:20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Part Name', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['name']),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Item Code', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['item_code']),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('UOM Type', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['unit']),
                ],
              ),
            ],
          ),
        ),
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
                    child: Text('Description', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['description']),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Selling Price', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['selling_price'].toString()),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Purchase Price', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['purchase_price'].toString()),
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
                    child: Text('Tax Preference', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['tax_preference']),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Exemption Reason', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['exemption_reason']),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Goods Type', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(storeStaticData['type']),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ],
    );
  }
}

