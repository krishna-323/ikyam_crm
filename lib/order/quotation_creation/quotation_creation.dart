import 'dart:convert';
import 'dart:developer';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../pdf/pdf_generator.dart';
import '../../utils/customAppBar.dart';
import '../../utils/custom_drawer.dart';
import '../../utils/static_files/list.dart';
import '../../utils/static_files/static_colors.dart';
import '../../widgets/buttons_style/outlined-icon_mbutton.dart';
import '../../widgets/buttons_style/outlined_mbutton.dart';
import '../../widgets/custom_deviders/custom_vertical_divider.dart';
import '../../widgets/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../../widgets/custom_search_text_field/custom_search.dart';

class CreateQuotationOrder extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CreateQuotationOrder({Key? key,  required this.selectedDestination, required this.drawerWidth }) : super(key: key);

  @override
  State<CreateQuotationOrder> createState() => _CreateQuotationOrderState();
}

class _CreateQuotationOrderState extends State<CreateQuotationOrder> {

  bool loading = false;
  bool showVendorDetails = false;
  bool showWareHouseDetails = false;
  bool isVehicleSelected = false;
  bool copyFrom =false;
  //late double width ;



  var wareHouseController=TextEditingController();
  var vendorSearchController = TextEditingController();
  final brandNameController=TextEditingController();
  var modelNameController = TextEditingController();
  var variantController=TextEditingController();
  var salesInvoiceDate = TextEditingController();
  var subAmountTotal = TextEditingController();
  var subTaxTotal = TextEditingController();
  var subDiscountTotal = TextEditingController();
  final termsAndConditions=TextEditingController();
  final salesInvoice=TextEditingController();
  final additionalCharges=TextEditingController();
  bool notesFromDealerError=false;
  // Tax Codes.
  List taxCodes=[
    {
      "tax_id": "TAX_02224",
      "tax_code": "0",
      "tax_name": "TAX0",
      "tax_name1": "SGST",
      "tax_name2": "CGST",
      "tax_name3": "",
      "tax_name4": "",
      "tax_name5": "",
      "tax_percent": null,
      "tax_percent1": "0",
      "tax_percent2": "0",
      "tax_percent3": "",
      "tax_percent4": "",
      "tax_percent5": "",
      "tax_total": "0"
    },
    {
      "tax_id": "TAX_03312",
      "tax_code": "02",
      "tax_name": "TAX2",
      "tax_name1": "CGST",
      "tax_name2": "  SGST",
      "tax_name3": "",
      "tax_name4": "",
      "tax_name5": "",
      "tax_percent": null,
      "tax_percent1": "1.5",
      "tax_percent2": "1.5",
      "tax_percent3": "",
      "tax_percent4": "",
      "tax_percent5": "",
      "tax_total": "3"
    },
    {
      "tax_id": "TAX_16655",
      "tax_code": "03",
      "tax_name": "TAX3",
      "tax_name1": "CGST",
      "tax_name2": "SGST",
      "tax_name3": "",
      "tax_name4": "",
      "tax_name5": "",
      "tax_percent": "",
      "tax_percent1": "2.5",
      "tax_percent2": "2.5",
      "tax_percent3": "",
      "tax_percent4": "",
      "tax_percent5": "",
      "tax_total": "5"
    },
    {
      "tax_id": "TAX_16656",
      "tax_code": "04",
      "tax_name": "TAX4",
      "tax_name1": "CGST",
      "tax_name2": "SGST",
      "tax_name3": "",
      "tax_name4": "",
      "tax_name5": "",
      "tax_percent": null,
      "tax_percent1": "6",
      "tax_percent2": "6",
      "tax_percent3": "",
      "tax_percent4": "",
      "tax_percent5": "",
      "tax_total": "12"
    },
    {
      "tax_id": "TAX_16657",
      "tax_code": "05",
      "tax_name": "TAX5",
      "tax_name1": "CGST",
      "tax_name2": "SGST",
      "tax_name3": "",
      "tax_name4": "",
      "tax_name5": "",
      "tax_percent": "",
      "tax_percent1": "9",
      "tax_percent2": "9",
      "tax_percent3": "",
      "tax_percent4": "",
      "tax_percent5": "",
      "tax_total": "18"
    },
    {
      "tax_id": "TAX_16658",
      "tax_code": "06",
      "tax_name": "TAX6",
      "tax_name1": "CGST",
      "tax_name2": "SGST",
      "tax_name3": "",
      "tax_name4": "",
      "tax_name5": "",
      "tax_percent": "",
      "tax_percent1": "14",
      "tax_percent2": "14",
      "tax_percent3": "",
      "tax_percent4": "",
      "tax_percent5": "",
      "tax_total": "28"
    }
  ];
  List taxPercentage=[];
  List filteredList = [];
  final focusDealerNotes=FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredList = partsList;

    // Displaying Each Page 15 Items.
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

    salesInvoiceDate.text=DateFormat('dd-MM-yyyy').format(DateTime.now());
    getCustomerFromAws();


    if(taxCodes.isNotEmpty){
      for(int i=0;i<taxCodes.length;i++){
        taxPercentage.add(taxCodes[i]['tax_total']);
      }
      // print('------taxCodes----');
      // print(taxPercentage);
    }
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
    for(var bp in partsList){

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
  fetchByData(String controllerText, String key){
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

  ///aws Api call.
  Future<void> getCustomerFromAws() async {
    String url = "https://snvvlfyg7f.execute-api.ap-south-1.amazonaws.com/stage1/api/customerdetails/get_all_customerdetails";
    final resData = await http.get(Uri.parse(url));
    final responseBody= jsonDecode(resData.body);
    try {
      //  List<dynamic> tempStoreData = await fetchGetApiData(url);
      setState(() {
        customerList= responseBody;
        // print(customerList);
      });
      loading=false;
    } catch (e) {
      // Handle errors here
      log("Error fetching customers: $e");
    }
  }
  String role ='';
  String userId ='';
  String managerId ='';
  String orgId ='';



  List vendorList = [
    {
      "new_vendor_id": "NWVND_02479",
      "company_name": "Arka Media",
      "vendor_display_name": "",
      "vendor_email": "arka@email.com",
      "vendor_mobile_phone": "9009990002",
      "gst": "GSTINAAA0009",
      "pan": "PAN0000ZZZZ",
      "contact_persons_name": "Shobu",
      "contact_persons_email_id": "shobu@email.com",
      "contact_persons_mobile": "8800880088",
      "vendor_address1": "",
      "vendor_address2": "",
      "vendor_state": "",
      "vendor_zip": "",
      "vendor_region": "",
      "vendor_city": "",
      "vendor_gst": "",
      "vendor_pan": "",
      "payto_address1": "4081 Evergreen Lane",
      "payto_address2": "4525 Garrett Street",
      "payto_state": "California",
      "payto_zip": "91801",
      "payto_region": "United States",
      "payto_city": "Michigan",
      "payto_gst": "GSTINAAA0009",
      "payto_pan": "PAN0000ZZZZ",
      "shipto_address1": "461 Oakmound Drive",
      "shipto_address2": "3920 Sunset Drive",
      "shipto_state": "Arkansas",
      "shipto_zip": "60617",
      "shipto_region": "United States",
      "shipto_city": "Chicago",
      "shipto_gst": "GSTINAAA0009",
      "shipto_pan": "PAN0000ZZZZ",
      "vendor_type": "Corporate",
      "vendor_code": "007",
      "pay_to_name": "S.S.Rajamouli",
      "ship_to_name": "M.M.Keeravani"
    },
    {
      "new_vendor_id": "NWVND_02490",
      "company_name": "Wall Poster",
      "vendor_display_name": "",
      "vendor_email": "wall@email.com",
      "vendor_mobile_phone": "98397857884",
      "gst": "GGGGZZZZZTTTTT",
      "pan": "PANMASALA",
      "contact_persons_name": "Nani",
      "contact_persons_email_id": "nani@email.com",
      "contact_persons_mobile": "8888888888",
      "vendor_address1": "",
      "vendor_address2": "",
      "vendor_state": "",
      "vendor_zip": "",
      "vendor_region": "",
      "vendor_city": "",
      "vendor_gst": "",
      "vendor_pan": "",
      "payto_address1": "2230 Fancher Drive, ",
      "payto_address2": "Oakmound",
      "payto_state": "Texas",
      "payto_zip": "75217",
      "payto_region": "United States",
      "payto_city": "Dallas",
      "payto_gst": "GGGGZZZZZTTTTT",
      "payto_pan": "PANMASALA",
      "shipto_address1": "461 Oakmound Drive, 4081 Evergreen Lane, D-1, Naaz Building, D Bhadkamkar Rd, Girgaon",
      "shipto_address2": "3920 Sunset Drive, 4525 Garrett Street, 1, Meghdoot, Sir P Mehta Road, Vile Parle(e)",
      "shipto_state": "Arkansas",
      "shipto_zip": "73660",
      "shipto_region": "United States",
      "shipto_city": "Reydon",
      "shipto_gst": "GGGGZZZZZTTTTT",
      "shipto_pan": "PANMASALA",
      "vendor_type": "Corporate",
      "vendor_code": "777",
      "pay_to_name": "Vishwak Sen",
      "ship_to_name": "Adavi Sesh"
    },
    {
      "new_vendor_id": "NWVND_04427",
      "company_name": "krishna",
      "vendor_display_name": "",
      "vendor_email": "krishna@gmail.com",
      "vendor_mobile_phone": "7780644962",
      "gst": "434343",
      "pan": "EGJPR3544H",
      "contact_persons_name": "krishna",
      "contact_persons_email_id": "kundhukuri@gmail.com",
      "contact_persons_mobile": "9980756544",
      "vendor_address1": "",
      "vendor_address2": "",
      "vendor_state": "",
      "vendor_zip": "",
      "vendor_region": "",
      "vendor_city": "",
      "vendor_gst": "",
      "vendor_pan": "",
      "payto_address1": "kolar",
      "payto_address2": "kolar",
      "payto_state": "karnataka",
      "payto_zip": "7576757754",
      "payto_region": "India",
      "payto_city": "bangalore",
      "payto_gst": "34343434",
      "payto_pan": "EGJPR3544H",
      "shipto_address1": "karnataka",
      "shipto_address2": "kolar",
      "shipto_state": "karnatka",
      "shipto_zip": "7575756",
      "shipto_region": "India",
      "shipto_city": "Bangalore",
      "shipto_gst": "88768",
      "shipto_pan": "EGJPR3544H",
      "vendor_type": "Individual",
      "vendor_code": "KRISH323",
      "pay_to_name": "rahul",
      "ship_to_name": "krishna reddy"
    },
    {
      "new_vendor_id": "NWVND_04487",
      "company_name": "Srikantha",
      "vendor_display_name": "",
      "vendor_email": "srikantha@",
      "vendor_mobile_phone": "45345345",
      "gst": "dgds",
      "pan": "tt",
      "contact_persons_name": "madhu",
      "contact_persons_email_id": "madhu@gmail.com",
      "contact_persons_mobile": "6564",
      "vendor_address1": "",
      "vendor_address2": "",
      "vendor_state": "",
      "vendor_zip": "",
      "vendor_region": "",
      "vendor_city": "",
      "vendor_gst": "",
      "vendor_pan": "",
      "payto_address1": "tumkuru",
      "payto_address2": "Tumkuru",
      "payto_state": "HYD",
      "payto_zip": "6664",
      "payto_region": "India",
      "payto_city": "HYd",
      "payto_gst": "df",
      "payto_pan": "ttref",
      "shipto_address1": "tumkuru",
      "shipto_address2": "tumkuru",
      "shipto_state": "karnatka",
      "shipto_zip": "456464",
      "shipto_region": "india",
      "shipto_city": "bangalore",
      "shipto_gst": "434",
      "shipto_pan": "JHHIH555A",
      "vendor_type": "Individual",
      "vendor_code": "4554",
      "pay_to_name": "madhu",
      "ship_to_name": "Madhu"
    },
    {
      "new_vendor_id": "NWVND_18481",
      "company_name": "Mythri Makers",
      "vendor_display_name": "",
      "vendor_email": "mythri@makers.com",
      "vendor_mobile_phone": "9191933333",
      "gst": "GSTIN009MMM",
      "pan": "MMMPA0909M",
      "contact_persons_name": "Ravi Shankar",
      "contact_persons_email_id": "ravi@shankar.com",
      "contact_persons_mobile": "8881818180",
      "vendor_address1": "",
      "vendor_address2": "",
      "vendor_state": "",
      "vendor_zip": "",
      "vendor_region": "",
      "vendor_city": "",
      "vendor_gst": "",
      "vendor_pan": "",
      "payto_address1": "Survey no-44, Guttala, Begumpet, Kavuri Hills",
      "payto_address2": "Kanchan Baug",
      "payto_state": "Telangana",
      "payto_zip": "500033",
      "payto_region": "India",
      "payto_city": "Hyderabad",
      "payto_gst": "GSTIN009MMM",
      "payto_pan": "MMMPA0909M",
      "shipto_address1": "\tP. G. Road, Ibsl, Ground Floor, Krishna Castle",
      "shipto_address2": "Saketh Rd, Jai Jawan Colony, Kapra",
      "shipto_state": "Telangana",
      "shipto_zip": "500003",
      "shipto_region": "India",
      "shipto_city": "Secunderabad",
      "shipto_gst": "GSTIN009MMM",
      "shipto_pan": "MMMPA0909M",
      "vendor_type": "Individual",
      "vendor_code": "mmm0023",
      "pay_to_name": "Naveen",
      "ship_to_name": "Chandni Peter Mitra"
    },
    {
      "new_vendor_id": "NWVND_20946",
      "company_name": "ABC Motors",
      "vendor_display_name": "",
      "vendor_email": "7100830183",
      "vendor_mobile_phone": "7100830183",
      "gst": "ABC1234",
      "pan": "7100830183",
      "contact_persons_name": "ABC Motors",
      "contact_persons_email_id": "7100830183",
      "contact_persons_mobile": "7100830183",
      "vendor_address1": "",
      "vendor_address2": "",
      "vendor_state": "",
      "vendor_zip": "",
      "vendor_region": "",
      "vendor_city": "",
      "vendor_gst": "",
      "vendor_pan": "",
      "payto_address1": "123 Evergreen Lane",
      "payto_address2": "Main Street",
      "payto_state": "Gauteng",
      "payto_zip": "2000",
      "payto_region": "South Africa",
      "payto_city": "Johannesburg",
      "payto_gst": "1234511212",
      "payto_pan": "1234442",
      "shipto_address1": "123 Evergreen Lane",
      "shipto_address2": "Main Street",
      "shipto_state": "Gauteng",
      "shipto_zip": "2000",
      "shipto_region": "South Africa",
      "shipto_city": "Johannesburg",
      "shipto_gst": "12345",
      "shipto_pan": "12214234",
      "vendor_type": "Corporate",
      "vendor_code": "7100830183",
      "pay_to_name": "ABC Motors",
      "ship_to_name": "ABC Motors"
    }
  ];
  List customerList=[];

  Map vendorData ={
    'Name':'',
    'city': '',
    'state': '',
    'street': '',
    'zipcode': '',
    "phone":""
  };

  Map wareHouse ={
    'Name':'',
    'city': '',
    'state': '',
    'street': '',
    'zipcode': '',
    "phone":''
  };

  // List partsList = [
  //   {
  //     "newitem_id": "NWITM_01039",
  //     "item_code": "257350009904",
  //     "name": "CV-TML",
  //     "unit": "BOX",
  //     "description": "TIE ROD-185 LONG",
  //     "selling_price": 92.95,
  //     "selling_account": "Discount",
  //     "tax_code": "09",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "General Income",
  //     "purchase_price": 2.0E7,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_01155",
  //     "item_code": "257432308602",
  //     "name": "CV-TML",
  //     "unit": "BOX",
  //     "description": "BUSH FRT S/ABS",
  //     "selling_price": 93.95,
  //     "selling_account": "Discount",
  //     "tax_code": "09",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "General Income",
  //     "purchase_price": 2.0E7,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_01965",
  //     "item_code": "257441109901",
  //     "name": "CV-TML",
  //     "unit": "BOX",
  //     "description": "GREASE NIPPLE",
  //     "selling_price": 94.95,
  //     "selling_account": "Discount",
  //     "tax_code": "09",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "General Income",
  //     "purchase_price": 2.0E7,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_05668",
  //     "item_code": "257450006904",
  //     "name": "CV-TML",
  //     "unit": "BOX",
  //     "description": "SPACER TUBE",
  //     "selling_price": 92.95,
  //     "selling_account": "Discount",
  //     "tax_code": "09",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "General Income",
  //     "purchase_price": 2.0E7,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_18480",
  //     "item_code": "257450006906",
  //     "name": "CV-TML",
  //     "unit": "BOX",
  //     "description": "SPACER TUBE 25.5MM",
  //     "selling_price": 96.95,
  //     "selling_account": "Discount",
  //     "tax_code": "09",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "General Income",
  //     "purchase_price": 2.0E7,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20890",
  //     "item_code": "257526406702",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "PIN",
  //     "selling_price": 9795.0,
  //     "selling_account": "Select",
  //     "tax_code": "Xyx",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 9795.0,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20891",
  //     "item_code": "257526808601",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SPACER",
  //     "selling_price": 9895.0,
  //     "selling_account": "Select",
  //     "tax_code": "1",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 9895.0,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20892",
  //     "item_code": "257533206301",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "DUST CAP STUB AXLE",
  //     "selling_price": 99.95,
  //     "selling_account": "Select",
  //     "tax_code": "1",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 99.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20893",
  //     "item_code": "257629508602",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SPACER",
  //     "selling_price": 100.95,
  //     "selling_account": "Select",
  //     "tax_code": "1",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 100.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20894",
  //     "item_code": "257632308604",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SPACER",
  //     "selling_price": 101.95,
  //     "selling_account": "Select",
  //     "tax_code": "1",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 101.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20895",
  //     "item_code": "257632309201",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "WASHER",
  //     "selling_price": 102.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 102.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20896",
  //     "item_code": "257632309201",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "WASHER",
  //     "selling_price": 102.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 102.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20897",
  //     "item_code": "257633109901",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "GREASE NIPPLE L TYPE",
  //     "selling_price": 103.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 103.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20898",
  //     "item_code": "257633207702",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "GASKET RING",
  //     "selling_price": 104.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 104.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20899",
  //     "item_code": "257633207702",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SEALING CAP STUB AXLE",
  //     "selling_price": 105.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 105.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20900",
  //     "item_code": "257633207702",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "THRUST WASHER 1.3MM THK",
  //     "selling_price": 106.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 106.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20901",
  //     "item_code": "257640209201",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SPHERICAL RING",
  //     "selling_price": 107.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 107.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20902",
  //     "item_code": "257641108002",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SCREW",
  //     "selling_price": 108.45,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 108.45,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20903",
  //     "item_code": "257641108002",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "CLAMP",
  //     "selling_price": 109.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 109.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20904",
  //     "item_code": "257641108002",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SPACER PLATE",
  //     "selling_price": 110.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 110.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20905",
  //     "item_code": "257642914201",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "CLAMP",
  //     "selling_price": 111.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 111.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20906",
  //     "item_code": "257681506302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "RUBBER PAD GRAB HANDLE",
  //     "selling_price": 112.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 112.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20907",
  //     "item_code": "257681506302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "PIN-SHOCK ABSORBER",
  //     "selling_price": 113.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 113.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20908",
  //     "item_code": "257681506302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SPACER TUBE",
  //     "selling_price": 114.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 114.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20909",
  //     "item_code": "257681506302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "CLEVIS PIN",
  //     "selling_price": 115.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 115.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20910",
  //     "item_code": "257681506302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SHIM 0.50MM",
  //     "selling_price": 116.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 116.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20911",
  //     "item_code": "257681506302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SHIM 0.10 MM",
  //     "selling_price": 117.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 117.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20912",
  //     "item_code": "257681506302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SHIM 0.20 MM",
  //     "selling_price": 118.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 118.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20913",
  //     "item_code": "261835608305",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SHIM 0.30 MM",
  //     "selling_price": 119.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 119.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20914",
  //     "item_code": "261835608310",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SHIM 0.15 THK",
  //     "selling_price": 120.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 120.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20915",
  //     "item_code": "261835608310",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "LOCK RING",
  //     "selling_price": 121.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 121.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20916",
  //     "item_code": "261842109203",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "WASHER",
  //     "selling_price": 122.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 122.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20917",
  //     "item_code": "261842109203",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "WASHER-HARDENED",
  //     "selling_price": 123.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 123.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20918",
  //     "item_code": "263246206302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "RUBBER BELLOW",
  //     "selling_price": 124.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 124.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20919",
  //     "item_code": "263246206302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "SPRING",
  //     "selling_price": 125.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 125.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20920",
  //     "item_code": "263246206302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "CLIP MASCOT",
  //     "selling_price": 126.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 126.95,
  //     "sac": "",
  //     "type": "Goods"
  //   },
  //   {
  //     "newitem_id": "NWITM_20921",
  //     "item_code": "263246206302",
  //     "name": "CV-TML",
  //     "unit": "DOZEN",
  //     "description": "BELLOW HOLDER",
  //     "selling_price": 127.95,
  //     "selling_account": "Select",
  //     "tax_code": "021111",
  //     "tax_preference": "Taxable",
  //     "exemption_reason": "",
  //     "purchase_account": "Select",
  //     "purchase_price": 127.95,
  //     "sac": "",
  //     "type": "Goods"
  //   }
  // ];




  List displayList=[];
  int startVal=0;
  List selectedVehicle=[];

  var units = <TextEditingController>[];
  var discountRupees = <TextEditingController>[];
  var discountPercentage = <TextEditingController>[];
  var tax = <TextEditingController>[];
  var lineAmount = <TextEditingController>[];
  List items=[];
  Map postDetails={};
  // Error Validation.
  int indexNumber=0;
  bool searchVendor=false;
  bool searchWarehouse=false;
  bool tableLineDataBool=false;
  final formValidation=GlobalKey<FormState>();
  List<String> generalId=[];
  String storeId="";
  bool matchVehicleId=false;

  late double width;
  bool checkLineItems(){
    if(selectedVehicle.isEmpty){
      setState(() {
        tableLineDataBool=true;
      });
      return false;
    }
    return true;
  }

  final _horizontalScrollController = ScrollController();
  //final _verticalScrollController = ScrollController();

  ///pdf downloader async function.
  Future downloadPdf(Map<dynamic, dynamic> postDetails)async{

    final Uint8List pdfBytes = await generatePdf2(postDetails);
    print('-----Uint8List-----');
    print(pdfBytes.runtimeType);

    // Create a blob from the PDF bytes
    final blob = html.Blob([pdfBytes]);

    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "document.pdf")
      ..text = "Download PDF";

    // Append the anchor element to the body
    html.document.body?.append(anchor);

    // Click the anchor to initiate download
    anchor.click();

    // Clean up resources
    html.Url.revokeObjectUrl(url);
    anchor.remove();
  }

  // Future<void> uploadPdfToFirebaseStorage(Map<dynamic, dynamic> postDetails) async {
  //   try {
  //     final Uint8List pdfBytes = await generatePdf2(postDetails);
  //
  //     // Generate a unique filename
  //     String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //     String fileName = 'document_$timestamp.pdf';
  //
  //     // Initialize Firebase Storage
  //     firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  //
  //     // Create a reference to the location you want to upload to
  //     firebase_storage.Reference ref = storage.ref().child('pdfs').child(fileName);
  //
  //     // Upload the file to Firebase Storage
  //     await ref.putData(pdfBytes);
  //
  //     print('PDF uploaded to Firebase Storage');
  //   } catch (e) {
  //     print('Error uploading PDF to Firebase Storage: $e');
  //   }
  // }


  ///Upload Pdf to Firebase Storage.
  // Future<void> uploadPdfToFirebaseStorage(Map<dynamic, dynamic> postDetails) async {
  //   try {
  //     final Uint8List pdfBytes = await generatePdf2(postDetails);
  //
  //     // Generate a unique filename
  //     String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //     String fileName = 'document_$timestamp.pdf';
  //
  //     // Initialize Firebase Storage
  //     firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  //
  //     // Create a reference to the location you want to upload to
  //     firebase_storage.Reference ref = storage.ref().child('pdfs').child(fileName);
  //
  //     // Upload the file to Firebase Storage
  //     await ref.putData(pdfBytes);
  //
  //     // Get the download URL for the PDF
  //     String downloadUrl = await ref.getDownloadURL();
  //
  //     // print('PDF uploaded to Firebase Storage');
  //     // print('Download URL: $downloadUrl');
  //
  //     //Success Message Dialog.
  //     showMessageDialog("Successfully Uploaded",downloadUrl,postDetails);
  //
  //     // Now you can use this URL to provide download functionality in your Flutter app
  //     // For example, you can display it as a clickable link that opens the PDF in a webview
  //
  //   } catch (e) {
  //     print('Error uploading PDF to Firebase Storage: $e');
  //   }
  // }

  Future<void> uploadPdfToFirebaseStorage(Map<dynamic, dynamic> postDetails) async {
    try {
      // Generate the PDF bytes
      final Uint8List pdfBytes = await generatePdf2(postDetails);

      // Generate a unique filename
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = 'document_$timestamp.pdf';

      // Initialize Firebase Storage
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      // Create a reference to the location you want to upload to
      firebase_storage.Reference ref = storage.ref().child('pdfs').child(fileName);

      // Set content type metadata
      firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(contentType: 'application/pdf',);

      // Upload the file to Firebase Storage with metadata
      await ref.putData(pdfBytes, metadata);

      // Get the download URL for the PDF
      String downloadUrl = await ref.getDownloadURL();

      // Success Message Dialog
      showMessageDialog("Successfully Uploaded", downloadUrl, postDetails);

      // Now you can use this URL to provide download functionality in your Flutter app
      // For example, you can display it as a clickable link that opens the PDF in a webview
    } catch (e) {
      print('Error uploading PDF to Firebase Storage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    width =MediaQuery.of(context).size.width;
    print(width);
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body:
      Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),

          width>1260? Expanded(
            child:
            Scaffold(
              backgroundColor: const Color(0xffF0F4F8),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(88.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: AppBar(
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Create New Parts Purchase Order"),
                    actions: [
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,height: 28,
                            child: OutlinedMButton(
                              text: 'Save',
                              buttonColor:mSaveButton ,
                              textColor: Colors.white,
                              borderColor: mSaveButton,
                              onTap: ()async{
                                checkLineItems();
                                focusDealerNotes.requestFocus();
                                if(formValidation.currentState!.validate() && checkLineItems()){
                                  double tempTotal =0;
                                  try{
                                    tempTotal = (double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text) + double.parse(additionalCharges.text.isEmpty?"":additionalCharges.text));
                                  }
                                  catch (e){
                                    tempTotal = double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text);
                                  }

                                  postDetails= {
                                    "additionalCharges": additionalCharges.text,
                                    "address": "string",
                                    "billAddressCity": vendorData['city']??"",
                                    "billAddressName": vendorData['Name']??"",
                                    "billAddressState": vendorData['state']??"",
                                    "billAddressStreet": vendorData['street']??"",
                                    "billAddressZipcode": vendorData['zipcode']??"",
                                    //added.
                                    'billToPhone':vendorData['phone']??"",
                                    "serviceDueDate": "string",
                                    "serviceInvoice": salesInvoice.text,
                                    "serviceInvoiceDate": salesInvoiceDate.text,
                                    "shipAddressCity": wareHouse['city']??"",
                                    "shipAddressName": wareHouse['Name']??"",
                                    "shipAddressState": wareHouse['state']??"",
                                    "shipAddressStreet": wareHouse['street']??"",
                                    "shipAddressZipcode": wareHouse['zipcode']??"",
                                    //added.
                                    'shipToPhone':wareHouse['phone']??"",
                                    "subTotalAmount": subAmountTotal.text.isEmpty?0 :subAmountTotal.text,
                                    "subTotalDiscount": subDiscountTotal.text.isEmpty?0:subDiscountTotal.text,
                                    "subTotalTax": subTaxTotal.text.isEmpty?0:subTaxTotal.text,
                                    "termsConditions": termsAndConditions.text,
                                    "total": tempTotal.toString(),
                                    "totalTaxableAmount": subAmountTotal.text.isEmpty?0 :subAmountTotal.text,
                                    "status": "In-review",
                                    "comment": "",
                                    "freight_amount":additionalCharges.text,
                                    "manager_id": managerId,
                                    "userid": userId,
                                    "org_id": orgId,
                                    "items": [

                                    ]
                                  };
                                  for (int i = 0; i < selectedVehicle.length; i++) {
                                    postDetails['items'].add(
                                        {
                                          "amount": lineAmount[i].text,
                                          "discount": discountPercentage[i].text,
                                          "itemsService": selectedVehicle[i]['Name'],
                                          //adding New.
                                          "collection":selectedVehicle[i]["Collection"],
                                          "type":selectedVehicle[i]["Type"],
                                          "priceItem": selectedVehicle[i]['Price']??"",
                                          "quantity": units[i].text,
                                          "tax": tax[i].text,
                                          //"newitem_id": selectedVehicle[i]['newitem_id']??"",
                                        }
                                    );

                                  }
                                  // print('-------postDetails------');
                                  // print(postDetails);
                                  uploadPdfToFirebaseStorage(postDetails);

                                }

                              },

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ),
              body:
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,left: 68,bottom: 30,right: 68),
                  child: Form(
                    key:formValidation,
                    child: Column(
                      children: [
                        Column(children: [
                          buildHeaderCard(),
                          const SizedBox(height: 10,),
                          buildContentCard(),
                        ],)

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ):Expanded(
            child:
            Scaffold(
              backgroundColor: const Color(0xffF0F4F8),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(88.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: AppBar(
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Create New Parts Purchase Order"),
                    actions: [
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,height: 28,
                            child: OutlinedMButton(
                              text: 'Save',
                              buttonColor:mSaveButton ,
                              textColor: Colors.white,
                              borderColor: mSaveButton,
                              onTap: (){
                                checkLineItems();
                                focusDealerNotes.requestFocus();
                                if(formValidation.currentState!.validate() && checkLineItems()){
                                  double tempTotal =0;
                                  try{
                                    tempTotal = (double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text) + double.parse(additionalCharges.text.isEmpty?"":additionalCharges.text));
                                  }
                                  catch (e){
                                    tempTotal = double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text);
                                  }

                                  postDetails= {
                                    "additionalCharges": additionalCharges.text,
                                    "address": "string",
                                    "billAddressCity": vendorData['city']??"",
                                    "billAddressName": vendorData['Name']??"",
                                    "billAddressState": vendorData['state']??"",
                                    "billAddressStreet": vendorData['street']??"",
                                    "billAddressZipcode": vendorData['zipcode']??"",
                                    //added.
                                    'billToPhone':vendorData['phone']??"",
                                    "serviceDueDate": "string",
                                    "serviceInvoice": salesInvoice.text,
                                    "serviceInvoiceDate": salesInvoiceDate.text,
                                    "shipAddressCity": wareHouse['city']??"",
                                    "shipAddressName": wareHouse['Name']??"",
                                    "shipAddressState": wareHouse['state']??"",
                                    "shipAddressStreet": wareHouse['street']??"",
                                    "shipAddressZipcode": wareHouse['zipcode']??"",
                                    //added.
                                    'shipToPhone':wareHouse['phone']??"",
                                    "subTotalAmount": subAmountTotal.text.isEmpty?0 :subAmountTotal.text,
                                    "subTotalDiscount": subDiscountTotal.text.isEmpty?0:subDiscountTotal.text,
                                    "subTotalTax": subTaxTotal.text.isEmpty?0:subTaxTotal.text,
                                    "termsConditions": termsAndConditions.text,
                                    "total": tempTotal.toString(),
                                    "totalTaxableAmount": subAmountTotal.text.isEmpty?0 :subAmountTotal.text,
                                    "status": "In-review",
                                    "comment": "",
                                    "freight_amount":additionalCharges.text,
                                    "manager_id": managerId,
                                    "userid": userId,
                                    "org_id": orgId,
                                    "items": [

                                    ]
                                  };
                                  for (int i = 0; i < selectedVehicle.length; i++) {
                                    postDetails['items'].add(
                                        {
                                          "amount": lineAmount[i].text,
                                          "discount": discountPercentage[i].text,
                                          "itemsService": selectedVehicle[i]['Name'],
                                          //adding New.
                                          "collection":selectedVehicle[i]["Collection"],
                                          "type":selectedVehicle[i]["Type"],
                                          "priceItem": selectedVehicle[i]['Price']??"",
                                          "quantity": units[i].text,
                                          "tax": tax[i].text,
                                          //"newitem_id": selectedVehicle[i]['newitem_id']??"",
                                        }
                                    );

                                  }
                                  // print('-------postDetails------');
                                  // print(postDetails);
                                  uploadPdfToFirebaseStorage(postDetails);
                                }

                              },

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ),
              body:
              AdaptiveScrollbar(
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
                      width: 1260,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10,left: 68,bottom: 30,right: 68),
                        child: Form(
                          key:formValidation,
                          child: Column(
                            children: [
                              Column(children: [
                                buildHeaderCard(),
                                const SizedBox(height: 10,),
                                buildContentCard(),
                              ],)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),

    );
  }


  Widget buildHeaderCard(){
    return  Card(color: Colors.white,surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///Header Details
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Address",style: TextStyle(fontSize: 18)),
                const SizedBox(height: 5,),
                SizedBox(
                  width: width/2.8,
                  child: const Text("Ikyam Solutions Private Limited #742, RJ Villa, Cross, 8th A Main Rd, Koramangala 4th Block, Koramangala, Bengaluru, Karnataka 560034",maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.grey)),
                ),
                const Text("9087877767",style: TextStyle(fontSize: 14,color: Colors.grey))

              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 42,
                  child: Icon(Icons.car_rental,color: Color(0xffCCBA13),size: 90),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }




  Widget buildContentCard(){
    return Card(color: Colors.white,surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Bill to Details
              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,top: 8,right: 8,bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2,top: 2),
                            child: Text("Bill to Address"),
                          ),
                          if(showVendorDetails)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    copyFrom=false;
                                    showVendorDetails=false;
                                    vendorSearchController.clear();
                                  });
                                },
                              ),
                            )

                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    if(showVendorDetails==false)
                      const SizedBox(height: 30,),
                    if(showVendorDetails==false)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: CustomTextFieldSearch(
                            validator: (value){
                              if(value==null || value.trim().isEmpty){
                                setState(() {
                                  searchVendor=true;
                                });
                                return "Search Vendor Address";
                              }
                              return null;

                            },
                            showAdd: false,
                            decoration:decorationVendorAndWarehouse(hintText: 'Search Address', error: searchVendor),
                            controller: vendorSearchController,
                            future: fetchCustomerData,
                            getSelectedValue: (CustomerDetails value) {
                              setState(() {
                                copyFrom=true;
                                showVendorDetails=true;
                                vendorData ={
                                  'Name':value.label,
                                  'city': value.city,
                                  'state': value.state,
                                  'street': value.street,
                                  'zipcode': value.zipcode,
                                  "phone":value.phone
                                };
                                searchVendor=false;
                              });
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height:5),
                    if(showVendorDetails)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vendorData['Name']??"",style: const TextStyle(fontWeight: FontWeight.bold)),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child:  Text("Street")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['street']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("City")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['city']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("State")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['state']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("ZipCode :")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['zipcode']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("Phone :")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['phone']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const CustomVDivider(height: 220, width: 1, color: mTextFieldBorder),

              ///Ship to Details
              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,top: 8,right: 8,bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2,top: 2),
                            child: Text("Ship to Address"),
                          ),

                          if(showWareHouseDetails==true)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    copyFrom=true;
                                    showWareHouseDetails=false;
                                    wareHouseController.clear();
                                  });
                                },
                              ),
                            ),

                          if(copyFrom)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Copy From',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.copy_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showWareHouseDetails=true;
                                    wareHouse = vendorData;
                                    //searchWarehouse=false;
                                    copyFrom = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    if(showWareHouseDetails==false)
                      const SizedBox(height: 30,),
                    if(showWareHouseDetails==false)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: CustomTextFieldSearch(
                            validator: (value){
                              if(value==null || value.trim().isEmpty){
                                setState(() {
                                  searchWarehouse=true;
                                });
                                return "Search Warehouse Address";
                              }
                              return null;
                            },
                            showAdd: false,
                            decoration:decorationVendorAndWarehouse(hintText: 'Search Address', error: searchWarehouse),
                            controller: wareHouseController,
                            future: fetchData,
                            getSelectedValue: (VendorModelAddress value) {
                              setState(() {
                                showWareHouseDetails=true;
                                wareHouse ={
                                  'Name':value.label,
                                  'city': value.city,
                                  'state': value.state,
                                  'street': value.street,
                                  'zipcode': value.zipcode,
                                  "phone":value.phone
                                };
                                searchWarehouse=false;

                              });
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 5,),
                    if(showWareHouseDetails)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                                builder: (context) {
                                  return Text(wareHouse['Name']??"",style: const TextStyle(fontWeight: FontWeight.bold));
                                }
                            ),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child:  Text("Street")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['street']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("City")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['city']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("State")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['state']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("ZipCode :")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['zipcode']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("Phone :")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['phone']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const CustomVDivider(height: 220, width: 1, color: mTextFieldBorder),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children:  [
                      Container(
                        height: 200,
                        width: 400,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Sales Invoice Date'),
                                        const SizedBox(height: 10,),
                                        Container(
                                          width: 140,
                                          height: 32,
                                          color: Colors.grey[200],
                                          child: TextFormField(showCursor: false,
                                            controller: salesInvoiceDate,
                                            onTap: ()async{
                                              DateTime? pickedDate=await showDatePicker(context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1999),
                                                  lastDate: DateTime.now()

                                              );
                                              if(pickedDate!=null){
                                                String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
                                                setState(() {
                                                  salesInvoiceDate.text=formattedDate;
                                                });
                                              }
                                              else{
                                                log('Date not selected');
                                              }
                                            },
                                            decoration: textFieldSalesInvoiceDate(hintText: 'Invoice Date'),
                                          ),
                                        )
                                      ],)
                                  ]),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: mTextFieldBorder,height: 1),
          const SizedBox(height: 18,),
          buildLineCard(),
        ],
      ),
    );
  }

  Widget buildLineCard(){
    return SizedBox(

      child: Column(
        children: [

          ///-----------------------------Table Starts-------------------------
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder,),
          ),
          Container(color: Color(0xffF3F3F3),),
          Padding(
            padding: const EdgeInsets.only(left: 18,right: 18),
            child: Container(color: const Color(0xffF3F3F3),
              height: 34,
              child: const Row(
                children:  [
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text('SL No'))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Name"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Collection"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex:2,child: Center(child: Text("Type"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Qty"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Price"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Discount"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Tax %"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Amount"))),
                  SizedBox(width: 30,height: 30,),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                ],
              ),
            ),
          ),
          if(selectedVehicle.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 18,right: 18),
              child: Divider(height: 1,color: mTextFieldBorder,),
            ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedVehicle.length,
            itemBuilder: (context, index) {

              double tempTax =0;
              double tempLineData=0;
              double tempDiscount=0;
              double priceAmount=double.parse(selectedVehicle[index]['Price'].substring(1).replaceAll(',', ''));


              try{indexNumber = index+1;

              lineAmount[index].text=(double.parse(priceAmount.toString())* (double.parse(units[index].text))).toString();

              if(discountPercentage[index].text!='0'||discountPercentage[index].text!=''||discountPercentage[index].text.isNotEmpty)
              {
                tempDiscount = ((double.parse(discountPercentage[index].text)/100) *  double.parse( lineAmount[index].text));
                tempLineData =(double.parse(lineAmount[index].text)-tempDiscount);

                tempTax = ((double.parse(tax[index].text)/100) *  double.parse( lineAmount[index].text));
                lineAmount[index].text =(tempLineData+tempTax).toStringAsFixed(1);
              }
              }
              catch (e){
                log('----------Exception-----------');
                log(e.toString());
              }
              if(index==0){
                subAmountTotal.text='0';
                subTaxTotal.text='0';
                subDiscountTotal.text='0';
                subTaxTotal.text= (double.parse(subTaxTotal.text.toString())+ tempTax).toStringAsFixed(1);
                subDiscountTotal.text= (double.parse(subDiscountTotal.text.toString())+ tempDiscount).toStringAsFixed(1);
                subAmountTotal.text = (double.parse(subAmountTotal.text.toString())+ double.parse( lineAmount[index].text)).toStringAsFixed(1);
              }else {
                subDiscountTotal.text= (double.parse(subDiscountTotal.text.toString())+ tempDiscount).toStringAsFixed(1);
                subTaxTotal.text= (double.parse(subTaxTotal.text.toString())+ tempTax).toStringAsFixed(1);
                subAmountTotal.text = (double.parse(subAmountTotal.text.toString())+ double.parse( lineAmount[index].text)).toStringAsFixed(1);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18,right: 18),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children:  [
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Text('${index+1}'))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Text("${selectedVehicle[index]['Name']}"))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Text("${selectedVehicle[index]['Collection']}"))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(flex:2,child: Center(child: Text("${selectedVehicle[index]['Type']}"))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                                decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                                height: 32,
                                child: TextField(
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  controller: units[index],
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: 12,right: 8,top: 2),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent))
                                  ),

                                  onChanged: (v) {
                                    setState(() {
                                      subAmountTotal.text=subAmountTotal.text;
                                      discountPercentage[index].text='0';
                                    });
                                  },
                                )),
                          )),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Text(selectedVehicle[index]['Price'].substring(1)))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child:  Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child: TextField(
                                controller: discountPercentage[index],
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                    hintText: "%",
                                    contentPadding: EdgeInsets.only(bottom: 12,right: 8,top: 2),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent))
                                ),
                                onChanged: (v) {
                                  double tempValue=0.0;
                                  setState(() {

                                  });
                                  if(v.isNotEmpty || v!=""){
                                    try{
                                      tempValue=double.parse(v.toString());
                                      if(tempValue>100){
                                        discountPercentage[index].clear();
                                      }
                                    }
                                    catch(e){
                                      discountPercentage[index].clear();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child:
                            Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child:LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  return CustomPopupMenuButton(childHeight: 200,
                                    elevation: 4,
                                    decoration: InputDecoration(
                                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
                                      hintText: tax[index].text.isEmpty || tax[index].text == '' ? "Tax" : tax[index].text,
                                      contentPadding: const EdgeInsets.only(bottom: 15, right: 8),
                                      border: InputBorder.none,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                      ),
                                    ),
                                    hintText: '',
                                    childWidth: constraints.maxWidth,
                                    textAlign: TextAlign.right,
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide(color: mTextFieldBorder),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    offset: const Offset(1, 40),
                                    tooltip: '',
                                    itemBuilder: (BuildContext context) {
                                      return taxPercentage.map((value) {
                                        // print('-----values -----');
                                        // print(value);
                                        return CustomPopupMenuItem(
                                          textStyle: const TextStyle(color: Colors.black),
                                          textAlign: MainAxisAlignment.end,
                                          value: value.toString(),
                                          text: value.toString(),
                                          child: Container(),
                                        );
                                      }).toList();
                                    },
                                    onSelected: (String value) {
                                      // print('--------what it is getting ------------');
                                      // print(value);
                                      setState(() {
                                        tax[index].text = value;
                                        // print('-----assigned Value-----');
                                        // print(tax[index].text);
                                      });
                                    },
                                    onCanceled: () {},
                                    child: Container(),
                                  );
                                },
                              ),
                            ),
                          ),)),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child: TextField(
                                controller: lineAmount[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                    hintText: 'Total amount',
                                    contentPadding: EdgeInsets.only(bottom: 12,top: 2),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent))
                                ),
                                onChanged: (v) {},
                              ),
                            ),
                          ),)),
                          InkWell(onTap: (){
                            setState(() {
                              for(int i=0;i<indexNumber.bitLength;i++){
                                if(i==0){
                                  setState(() {
                                    tableLineDataBool=true;
                                  });
                                }
                                else{
                                  setState(() {
                                    tableLineDataBool=false;
                                  });
                                }
                              }
                              selectedVehicle.removeAt(index);
                              units.removeAt(index);
                              discountRupees.removeAt(index);
                              discountPercentage.removeAt(index);
                              tax.removeAt(index);
                              lineAmount.removeAt(index);

                            });
                          },hoverColor: mHoverColor,child: const SizedBox(width: 30,height: 30,child: Center(child: Icon(Icons.delete,color: Colors.red,size: 18,)))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18,right: 18),
                    child: Divider(height: 1,color: mTextFieldBorder,),
                  )
                ],
              );


            },),
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder,),
          ),

          const SizedBox(height: 40,),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: SizedBox(
                  height: 38,
                  child: Row(
                    children:  [
                      const Expanded(child: Center(child:Text(""))),
                      Expanded(
                          flex: 4,
                          child: Center(
                              child: OutlinedMButton(
                                text: "+ Add Item/ Service",
                                borderColor:tableLineDataBool?const Color(0xffB2261E): mSaveButton,
                                // borderColor: if(tableLineDataBool),
                                textColor: mSaveButton,
                                onTap: () {
                                  if(displayList.isNotEmpty){
                                    tableLineDataBool=false;
                                  }
                                  brandNameController.clear();
                                  modelNameController.clear();
                                  variantController.clear();
                                  // displayList=partsList;
                                  showDialog(
                                    context: context,
                                    builder: (context) => showDialogBox(),
                                  ).then((value) {
                                    if(value!=null){
                                      setState(() {
                                        if(matchVehicleId){
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              backgroundColor: Colors.transparent,
                                              child: StatefulBuilder(
                                                builder: (context, setState) {
                                                  return SizedBox(
                                                    width: 300,
                                                    height: 220,
                                                    child: Stack(children: [
                                                      Container(
                                                        decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(5)),
                                                        margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(15),
                                                          child: Container(
                                                            decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder,width: 1)),
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
                                                                const Column(
                                                                  children:  [
                                                                    Center(
                                                                        child: Text(
                                                                          'Part Already Added',
                                                                          style: TextStyle(
                                                                              color: Colors.indigo,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        )),
                                                                    SizedBox(height:5),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 60,
                                                                      height: 30,
                                                                      child: OutlinedMButton(
                                                                        onTap: (){
                                                                          Navigator.of(context).pop();
                                                                          matchVehicleId=false;
                                                                        },
                                                                        text: 'Ok',
                                                                        borderColor: mSaveButton,
                                                                        textColor:mSaveButton,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
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
                                            ),
                                          );
                                        }
                                        else{
                                          isVehicleSelected=true;
                                          units.add(TextEditingController(text: '1'));
                                          discountRupees.add(TextEditingController(text: '0'));
                                          discountPercentage.add(TextEditingController(text: '0'));
                                          tax.add(TextEditingController(text: '0'));
                                          lineAmount.add(TextEditingController());
                                          subAmountTotal.text='0';
                                          selectedVehicle.add(value);
                                        }
                                      });
                                    }
                                  });

                                  for(int i=0;i<selectedVehicle.length;i++){
                                    generalId.add(selectedVehicle[i]["Name"]);
                                  }

                                },
                              ))),
                      const Expanded(flex: 5,child: Center(child: Text(""),))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              if(tableLineDataBool==true)
                const Padding(
                  padding: EdgeInsets.only(left:200.0),
                  child: Text('Please Add Part Line Item',style: TextStyle(color:Color(0xffB2261E)),),
                ),
            ],
          ),
          const SizedBox(height: 40,),
          ///-----------------------------Table Ends-------------------------

          ///SUB TOTAL
          const Divider(height: 1,color: mTextFieldBorder),
          Container(
            color: const Color(0xffF3F3F3),
            height: 34,
            child: Padding(
              padding: const EdgeInsets.only(left: 18,right: 18),
              child: Row(
                children:   [
                  const Expanded(child: Center(child: Text(''))),
                  const Expanded(flex: 4,child: Center(child: Text(""))),
                  const Expanded(child: Center(child: Text(""))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  const Expanded(child: Center(child: Text("Sub Total"))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Builder(
                      builder: (context) {
                        return Text("₹ ${subDiscountTotal.text.isEmpty?0:subDiscountTotal.text}");
                      }
                  ))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Builder(
                      builder: (context) {
                        return Text("₹ ${subTaxTotal.text.isEmpty?0:subTaxTotal.text}");
                      }
                  ))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Builder(
                      builder: (context) {
                        return Text("₹ ${subAmountTotal.text.isEmpty?0 :subAmountTotal.text}");
                      }
                  ))),
                  const SizedBox(width: 30,height: 30,),

                ],
              ),
            ),
          ),
          const Divider(height: 1,color: mTextFieldBorder,),
          ///------Foooter----------
          buildFooter(),
          const Divider(height: 1,color: mTextFieldBorder,),

        ],
      ),
    );
  }

  Widget showDialogBox(){
    return AlertDialog(
      backgroundColor:
      Colors.transparent,
      content:Builder(
          builder: (context) {
            return StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width/1.5,
                    height: MediaQuery.of(context).size.height/1.1,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.only(top: 13.0, right: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Card(surfaceTintColor: Colors.white,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10,),
                                  ///search Fields
                                  Row(
                                    children: [
                                      const SizedBox(width: 10,),
                                      SizedBox(width: 250,
                                        child: TextFormField(
                                          controller: brandNameController,
                                          //decoration: textFieldBrandNameField(hintText: 'Search Brand'),
                                          decoration: InputDecoration(
                                            suffixIcon:  brandNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
                                              setState(() {
                                                startVal=0;
                                                displayList = [];
                                                filteredList= partsList;
                                                ifEmpty();
                                                brandNameController.clear();
                                              });

                                            },
                                                child: const Icon(Icons.close,size: 18,)
                                            ),
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide(color:  Colors.blue)),
                                            constraints: const BoxConstraints(maxHeight:35),
                                            // hintText: hintText,
                                            hintText: "Search Brand",
                                            hintStyle: const TextStyle(fontSize: 14),
                                            counterText: '',
                                            contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
                                            enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if(value.isEmpty || value==""){
                                                startVal=0;
                                                displayList = [];
                                                filteredList= partsList;
                                                ifEmpty();
                                              }
                                              else if(modelNameController.text.isNotEmpty || variantController.text.isNotEmpty){
                                                modelNameController.clear();
                                                variantController.clear();
                                              }
                                              else{
                                                startVal=0;
                                                displayList=[];
                                                fetchByData(brandNameController.text,"Name");
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          //decoration:  textFieldModelNameField(hintText: 'Search By Type'),
                                          decoration: InputDecoration(
                                            suffixIcon:  modelNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
                                              setState(() {
                                                startVal=0;
                                                displayList=[];
                                                modelNameController.clear();
                                                filteredList = partsList;
                                                ifEmpty();
                                              });
                                            },
                                                child: const Icon(Icons.close,size: 18,)
                                            ),
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide(color:  Colors.blue)),
                                            constraints:const BoxConstraints(maxHeight:35),
                                            // hintText: hintText,
                                            hintText: "Search By Type",
                                            hintStyle: const TextStyle(fontSize: 14),
                                            counterText: '',
                                            contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                          ),
                                          controller: modelNameController,
                                          onChanged: (value) {
                                            setState(() {
                                              if(value.isEmpty || value==""){
                                                startVal=0;
                                                displayList=[];
                                                filteredList = partsList;
                                                ifEmpty();
                                              }
                                              else if(brandNameController.text.isNotEmpty || variantController.text.isNotEmpty){
                                                brandNameController.clear();
                                                variantController.clear();

                                              }
                                              else{
                                                startVal=0;
                                                displayList=[];
                                                fetchByData(modelNameController.text,"Type");
                                              }

                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      SizedBox(width: 250,
                                        child: TextFormField(
                                          controller: variantController,
                                          decoration: textFieldVariantNameField(hintText: 'Search Variant'),
                                          onChanged: (value) {
                                            setState(() {
                                              if(value.isEmpty || value==""){
                                                displayList=filteredList;
                                              }
                                              else if(modelNameController.text.isNotEmpty || brandNameController.text.isNotEmpty){
                                                modelNameController.clear();
                                                brandNameController.clear();
                                              }
                                              else{
                                                //fetchVariantName(variantController.text);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  ///Table Header
                                  Container(
                                    height: 40,
                                    color: Colors.grey[200],
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 18.0),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text("Name")),
                                          Expanded(child: Text("Collection")),
                                          Expanded(child: Text("Type")),
                                          Expanded(child: Text("Price")),
                                          // Expanded(child: Text("Type")),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4,),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child:ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: displayList.length+1,
                                          itemBuilder: (context,int i){
                                            if(i<displayList.length){
                                              return  Column(children: [
                                                MaterialButton(
                                                  hoverColor: mHoverColor,
                                                  onPressed: () {
                                                    setState(() {
                                                      storeId = displayList[i]["Name"];
                                                      for(var tempId in generalId){
                                                        if(tempId == storeId){
                                                          matchVehicleId=true;
                                                        }
                                                      }
                                                      Navigator.pop(context,displayList[i]);
                                                    });

                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 18.0),
                                                    child: SizedBox(height: 30,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 20,
                                                              child: Text(displayList[i]['Name']),
                                                            ),
                                                          ),

                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 20,
                                                              child: Text(
                                                                  displayList[i]['Collection']),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 20,
                                                              child: Text(displayList[i]['Type']),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: SizedBox(
                                                              height: 20,
                                                              child: Text(displayList[i]['Price'].substring(1)),
                                                            ),
                                                          ),
                                                          // Expanded(
                                                          //   child: SizedBox(
                                                          //     height: 20,
                                                          //     child: Text(displayList[i]['type']),
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
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
                                                          setState(() {
                                                            if(filteredList.length>startVal+15){
                                                              displayList=[];
                                                              startVal=startVal+15;
                                                              for(int i=startVal;i<startVal+15 && i< filteredList.length;i++){
                                                                try{
                                                                  setState(() {
                                                                    displayList.add(filteredList[i]);
                                                                  });
                                                                }
                                                                catch(e){
                                                                  log("Expected Type Error $e ");
                                                                  log(e.toString());
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
                                                Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                              ],);
                                            }
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          child: InkWell(
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: const Color.fromRGBO(204, 204, 204, 1),
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
                }
            );
          }
      ),
    );
  }

  Widget buildFooter(){
    return Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.only(left:10.0),
                  child: Text("Notes From Dealer"),
                ),
                const SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(focusNode: focusDealerNotes,
                    validator: (value){
                      if(value==null || value.trim().isEmpty){
                        setState(() {
                          notesFromDealerError=true;
                        });
                        return "Enter Dealer Notes";
                      }
                      return null;
                    },
                    maxLines: 5,
                    controller: termsAndConditions,
                    decoration:textFieldDecoration(hintText: 'Enter Dealer Notes', error:notesFromDealerError ) ,
                  ),
                ),
                const SizedBox(height: 5,),

              ],
            ),
          ),
        ),
        const CustomVDivider(height: 250, width: 1, color: mTextFieldBorder),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Taxable Amount"),
                  Builder(
                      builder: (context) {
                        return Text("₹ ${subAmountTotal.text.isEmpty?0 :subAmountTotal.text}");
                      }
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Additional Charges",style: TextStyle(color: mSaveButton)),
                  Container(
                      decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                      height: 32,width: 100,
                      child: TextField(
                        controller: additionalCharges,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(

                            contentPadding: EdgeInsets.only(bottom: 12,right: 8,top: 2),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent))
                        ),
                        onChanged: (v) {
                          setState(() {
                            try{
                              double.parse(v.toString());
                            }
                            catch(e){
                              additionalCharges.clear();
                            }
                          });
                        },
                      )),
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(color: mTextFieldBorder),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total"),
                  Builder(
                      builder: (context) {
                        double tempValue= 0;
                        try {
                          tempValue= (double.parse(subAmountTotal.text) + double.parse(additionalCharges.text));
                        }
                        catch(e){
                          if(subAmountTotal.text.isEmpty){
                            tempValue =0;
                          }
                          else{
                            tempValue =double.parse(subAmountTotal.text);
                          }

                          log(e.toString());
                        }
                        return Text("₹ $tempValue");
                      }
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  decorationVendorAndWarehouse({required String hintText, required bool error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.search,size: 18),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error? Colors.red: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldDecoration({required String hintText, required bool error}) {
    return  InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldBrandNameField({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon:  brandNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          startVal=0;
          displayList = [];
          filteredList= partsList;
          ifEmpty();
          brandNameController.clear();
        });

      },
          child: const Icon(Icons.close,size: 18,)
      ),
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
  textFieldModelNameField({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon:  modelNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          startVal=0;
          displayList=[];
          modelNameController.clear();
          filteredList = partsList;
          ifEmpty();
        });

      },
          child: const Icon(Icons.close,size: 18,)
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldVariantNameField({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon:  variantController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        variantController.clear();
      },
          child: const Icon(Icons.close,size: 18,)
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldSalesInvoiceDate({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.calendar_month_rounded,size: 12,color: Colors.grey,),
      border: InputBorder.none,
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(10, 00, 0, 0),
    );
  }

  fetchData() async {

    List list = [];
    // create a list of 3 objects from a fake json response
    for(int i=0;i<vendorList.length;i++){
      list.add( VendorModelAddress.fromJson({
        "label":vendorList[i]['company_name'],
        "value":vendorList[i]['company_name'],
        "city":vendorList[i]['payto_city'],
        "state":vendorList[i]['payto_state'],
        "zipcode":vendorList[i]['payto_zip'],
        "street":vendorList[i]['payto_address1']+", "+vendorList[i]['payto_address2'],
        'phone':vendorList[i]['contact_persons_mobile'],
      }));
    }

    return list;
  }

  fetchCustomerData() async {

    List list = [];
    // create a list of 3 objects from a fake json response
    for(int i=0;i<customerList.length;i++){
      list.add( CustomerDetails.fromJson({
        "label":customerList[i]['customerName'],
        "value":customerList[i]['customerName'],
        "city":customerList[i]['district'],
        "state":customerList[i]['state'],
        "zipcode":customerList[i]['pinCode'],
        "street":customerList[i]['streetAddress'],
        "mobileNumber":customerList[i]['mobileNumber']
      }));
    }

    return list;
  }

  // Show DialogBox.
  void showMessageDialog(String message,String url,Map orderDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              //const Icon(Icons.error,color: Colors.red,),
              Text(message,style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 10,),
              MaterialButton(
                onPressed: () {
                  //Calling What's App Function.
                  createWhatsappAlert(url,orderDetails);
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },);
  }

  ///Creating Whatsapp Alert.
  Future createWhatsappAlert(String url,Map orderDetails) async {

    Map requestBody = {
      // "messaging_product": "whatsapp",
      // "to": "91${orderDetails['billToPhone']}",
      // "type": "template",
      // "template": {
      //   "name": "motows_estimates",
      //   "language": {
      //     "code": "en_US"
      //   },
      //   "components": [
      //     {
      //       "type": "header",
      //       "parameters": [
      //         {
      //           "type": "document",
      //           "document": {
      //             //firebase storage url.
      //             //"link": url,
      //             "link":"https://firebasestorage.googleapis.com/v0/b/motows-11f2b.appspot.com/o/JBC_03846%2Fdoc%2Festimate?alt=media&token=ba04815c-12a8-4c0b-95f2-367f1290c835",
      //             //file name.
      //             "filename": "Estimate receipt"
      //           }
      //         }
      //       ]
      //     },
      //     {
      //       "type": "body",
      //       "parameters": [
      //         {
      //           "type": "text",
      //           "text": "${orderDetails["billAddressName"]}"
      //         },
      //         {
      //           "type": "text",
      //           "text": 'jobCardId'
      //         }
      //       ]
      //     }
      //   ]
      // }

      /////Old json. (website link also retrieving).

      "messaging_product": "whatsapp",
      "to": "91${orderDetails['billToPhone']}",
      "type": "template",
      "template": {
        // after changing name causing error.
        "name": "order_details",
        "language": {
          "code": "en_US"
        },
        "components": [
          {
            "type": "header",
            "parameters": [
              {
                "type": "document",
                "document": {
                  "link": url,
                  "filename": "Customer Order"
                }
              }
            ]
          },
          {
            "type": "body",
            "parameters": [
              {
                "type": "text",
                "text":"${orderDetails["billAddressName"]}"
              }
            ]
          }
        ]
      }

    };
    final response = await http.post(
        Uri.parse("https://graph.facebook.com/v15.0/100902122971578/messages"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer EAAI0EXaoaZBkBAKBaZCZBz5pI7EAR9BaclWghsZAn6aMVZCh6fZCiGMd1FJZAZA9L3iGehWA5EClk4ff8yYVn7JgWCaDQsh0H036UgRWync7K1yKWg1ERAUoZCLm15qnZAzOSmq9EjAtXZC0wet7MmDUElGvYJ21tVjV6lOZCZAZC8Fsquj0dxdc6Ym8udkNVpZBUnMnvfSOdV6wrQVQAZDZD'
        },
        body: json.encode(requestBody)
    );

    if (response.statusCode == 200) {

      log('Response from whatsapp Api');
      log (response.body.toString());
      // print('---------url from firebase storage-----');
      // print(requestBody['template']['components'][0]['parameters'][0]['document']['link']);

      if(mounted){
        Navigator.of(context).pop();
      }

      //ToastMessage.short("${i+1} Jobs Added");
    }
    else {

      log(response.body);
      log(response.statusCode.toString());
    }
  }
}

//Vendor.
class VendorModelAddress {
  String label;
  String city;
  String state;
  String zipcode;
  String street;
  String phone;
  dynamic value;
  VendorModelAddress({
    required this.label,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.street,
    required this.phone,
    this.value
  });

  factory VendorModelAddress.fromJson(Map<String, dynamic> json) {
    return VendorModelAddress(
        label: json['label'],
        value: json['value'],
        city: json['city'],
        state: json['state'],
        street: json['street'],
        zipcode: json['zipcode'],
        phone:json['phone']
    );
  }
}

//Customer Details.
class CustomerDetails {
  String label;
  String city;
  String state;
  String zipcode;
  String street;
  String phone;
  dynamic value;
  CustomerDetails({
    required this.label,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.street,
    required this.phone,
    this.value
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
        label: json['label'],
        value: json['value'],
        city: json['city'],
        state: json['state'],
        street: json['street'],
        zipcode: json['zipcode'],
        phone:json['mobileNumber']
    );
  }
}


