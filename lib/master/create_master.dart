import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import '../utils/customAppBar.dart';
import '../utils/custom_drawer.dart';
import '../utils/static_files/static_colors.dart';
import '../widgets/buttons_style/outlined_mbutton.dart';
import '../widgets/custom_popup_dropdown/custom_popup_dropdown.dart';


class CreateMaster extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CreateMaster({super.key,
    required this.drawerWidth,
    required this.selectedDestination});

  @override
  State<CreateMaster> createState() => _CreateMasterState();
}

class _CreateMasterState extends State<CreateMaster> {

  var itemCodeController = TextEditingController();
  var sellingPriceController = TextEditingController();
  var purchaseController = TextEditingController();
  var partNameController = TextEditingController();
  var descriptionController = TextEditingController();
  var exemptionController =TextEditingController();

  //This  declaration for state.
  final stateContainer=TextEditingController();
  final distController=TextEditingController();
  var partUOMTypeController =  TextEditingController();
  var goodsTypeController =TextEditingController();
  var taxPreController=TextEditingController();

  String selectedType='Select Type';
  String selectedTaxPreType="Select Tax Preference";
  String selectedGoodsType="Select Goods";

  List <String> selectType =[
    'BOX',
    'DOZEN'
  ];
  List <String> selectTaxPreference =[
    'TAXABLE',
    'NON TAXABLE'
  ];
  List <String> typeOfGoods =[
    'GOODS',
    'INVENTORY'
  ];

  bool  _invalidName = false;
  bool _invalidSelling = false;
  bool _invalidPurchase = false;
  bool _invalidPartName = false;
  bool _invalidDescription = false;
  bool _isTypeFocused = false;
  bool _isGoodsFocused=false;
  bool  _invalidType=false;
  bool _invaliedGoodsType=false;
  bool _isTaxPreferenceFocused=false;
  bool _isTaxPreference=false;
  bool _isexemptionReason=false;

  String? checkItemCodeError(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _invalidName=true;
      });
      return 'Please Item Code';
    }
    setState(() {
      _invalidName=false;
    });
    return null;
  }
  String? checkSellingError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidSelling=true;
      });
      return 'Please Enter Selling Price.';
    }
    setState(() {
      _invalidSelling=false;
    });
    return null;
  }
  String? checkPurchaseError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidPurchase=true;
      });
      return 'Please Enter Purchase Price.';
    }
    setState(() {
      _invalidPurchase=false;
    });
    return null;
  }

  String? checkPartName(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidPartName=true;
      });
      return 'Please Enter PartName';
    }
    setState(() {
      _invalidPartName=false;
    });
    return null;
  }
  String? checkDescriptionError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidDescription=true;
      });
      return 'Please Enter Description';
    }
    setState(() {
      _invalidDescription=false;
    });
    return null;
  }

  String? checkExemptionReason(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _isexemptionReason=true;
      });
      return 'Please Exemption Reason';
    }
    setState(() {
      _isexemptionReason=false;
    });
    return null;
  }

  List storeDist=[];

  // //This two are async function (state,dist).
  // Future getStateNames()async{
  //   List list=[];
  //   for(int i=0;i<states.length;i++){
  //     list.add(SearchState.fromJson(states[i]));
  //   }
  //   return list;
  // }
  //
  // Future getDistName()async{
  //   List storeDistNames=[];
  //
  //   for(int i=0;i<storeDist.length;i++){
  //     //Here adding each and every name.
  //     storeDistNames.add(SearchDist.fromJson(storeDist[i]));
  //   }
  //   return storeDistNames;
  // }

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

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;

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
          screenWidth>1100? Expanded(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: AppBar(automaticallyImplyLeading: false,
                  leading: IconButton(onPressed: (){
                    Navigator.of(context).pop();
                    //Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),));
                  }, icon: const Icon(Icons.arrow_back),),

                  elevation: 1,
                  surfaceTintColor: Colors.white,
                  shadowColor: Colors.black,
                  title: const Text("Parts Details Entry Form"),
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
                              Map partDetails = {
                                "item_code":itemCodeController.text,
                                "name": partNameController.text,
                                "unit":partUOMTypeController.text,
                                "description": descriptionController.text,
                                "selling_price": sellingPriceController.text,
                                "selling_account": "",
                                "tax_code": " ",
                                "tax_preference": taxPreController.text,
                                "exemption_reason": exemptionController.text,
                                "purchase_account": "",
                                "purchase_price":purchaseController.text,
                                "sac": "",
                                "type": goodsTypeController.text
                              };

                              //Navigator.of(context).pop();
                              print(partDetails);
                            }
                          }, text: 'Save',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0,bottom: 20),
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
          ) :
          Expanded(child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  // leading: IconButton(onPressed: (){
                  //   Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),));
                  // }, icon: const Icon(Icons.arrow_back),),

                  elevation: 1,
                  surfaceTintColor: Colors.white,
                  shadowColor: Colors.black,
                  title: const Text("Parts Details Entry Form"),
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
                          }, text: 'Save',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              body: Padding(
                padding: const EdgeInsets.only(top: 20.0,bottom: 20),
                child: Center(
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
                          scrollDirection: Axis.horizontal,
                          controller: _horizontalScrollController,
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
              ),
            ),
          ),
        ],),

    );
  }

  Widget buildCustomerCard(){
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Parts Details
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
                      child: Row(children: [Text("Parts Details",style: TextStyle(fontWeight: FontWeight.bold),),],
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
                            const Text("Item Code"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              autofocus: true,
                              controller: itemCodeController,
                              validator:checkItemCodeError,
                              decoration: textFieldDecoration(hintText: 'Enter ItemCode',error:_invalidName),
                              onChanged: (value){
                                itemCodeController.value=TextEditingValue(
                                  text:capitalizeFirstWord(value),
                                  selection: itemCodeController.selection,
                                );
                              },
                            ),
                            const SizedBox(height: 20,),
                            const Text("Selling Price"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              controller: sellingPriceController,
                              validator: checkSellingError,
                              decoration: textFieldDecoration(hintText: 'Enter Selling Price',error: _invalidSelling),
                            ),
                            const SizedBox(height: 20,),
                            const Text("Purchase Price"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              controller: purchaseController,
                              validator: checkPurchaseError,
                              decoration: textFieldDecoration(hintText: 'Enter Purchase Price',error: _invalidPurchase),
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
                            const Text("Part Name"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              controller: partNameController,
                              validator: checkPartName,
                              decoration: textFieldDecoration(hintText: 'Enter Part Name',error: _invalidPartName),),
                            const SizedBox(height: 20,),
                            const Text("Unit Type"),
                            const SizedBox(height: 6,),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                                _invalidType=true;
                                              });
                                              return null;
                                            }
                                            return null;
                                          },
                                          decoration: customPopupDecoration(hintText: 'Select type',error: _invalidType,isFocused: _isTypeFocused),
                                          hintText: selectedType,
                                          textController: partUOMTypeController,
                                          childWidth: constraints.maxWidth,
                                          shape:  RoundedRectangleBorder(
                                            side: BorderSide(color:_invalidType? Colors.redAccent :mTextFieldBorder),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          offset: const Offset(1, 40),
                                          tooltip: '',
                                          itemBuilder:  (BuildContext context) {
                                            return selectType.map((value) {
                                              return CustomPopupMenuItem(
                                                value: value,
                                                text:value,
                                                child: Container(),
                                              );
                                            }).toList();
                                          },

                                          onSelected: (String value)  {
                                            setState(() {
                                              partUOMTypeController.text=value;
                                              selectedType= value;
                                              _invalidType=false;
                                            });

                                          },
                                          onCanceled: () {

                                          },
                                          child: Container(),
                                        );
                                      }
                                  ),
                                ),
                               const SizedBox(height: 6,),
                                if(_invalidType)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text("Select Type",style: TextStyle(color: Color(0xffB83730),fontSize: 13),),
                                  ),
                                Container(color: Colors.white,)
                              ],
                            ),
                            const SizedBox(height: 20,),
                            const Text("Description"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              controller: descriptionController,
                              validator: checkDescriptionError,
                              decoration: textFieldDecoration(hintText: 'Enter Description',error: _invalidDescription),),

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
                        const SizedBox(height: 20,),
                        const Text("Tax Preference"),
                        const SizedBox(height: 6,),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Focus(
                              onFocusChange: (value) {
                                setState(() {
                                  _isTaxPreferenceFocused = value;
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
                                            _isTaxPreference=true;
                                          });
                                          return null;
                                        }
                                        return null;
                                      },
                                      decoration: customPopupDecoration(hintText: 'Select Tax Preference',error: _isTaxPreference,isFocused: _isTaxPreferenceFocused),
                                      hintText: selectedTaxPreType,
                                      textController: taxPreController,
                                      childWidth: constraints.maxWidth,
                                      shape:  RoundedRectangleBorder(
                                        side: BorderSide(color:_invalidType? Colors.redAccent :mTextFieldBorder),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      offset: const Offset(1, 40),
                                      tooltip: '',
                                      itemBuilder:  (BuildContext context) {
                                        return selectTaxPreference.map((value) {
                                          return CustomPopupMenuItem(
                                            value: value,
                                            text:value,
                                            child: Container(),
                                          );
                                        }).toList();
                                      },

                                      onSelected: (String value)  {
                                        setState(() {
                                          taxPreController.text=value;
                                          selectedTaxPreType= value;
                                          _isTaxPreference =false;
                                        });

                                      },
                                      onCanceled: () {

                                      },
                                      child: Container(),
                                    );
                                  }
                              ),
                            ),
                            const SizedBox(height: 6,),
                            if(_isTaxPreference)
                              const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("Select Tax Preference",style: TextStyle(color: Color(0xffB83730),fontSize: 13),),
                              ),
                            Container(color: Colors.white,)
                          ],
                        ),
                        const SizedBox(height: 20,),
                        const Text("Exemption Reason"),
                        const SizedBox(height: 6,),
                        TextFormField(
                          controller: exemptionController,
                          validator: checkExemptionReason,
                          decoration: textFieldDecoration(hintText: 'Enter Exemption Reason',
                              error: _isexemptionReason),),
                        const SizedBox(height: 20,)
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
                        const SizedBox(height: 20,),
                        const Text("Type"),
                        const SizedBox(height: 6,),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Focus(
                              onFocusChange: (value) {
                                setState(() {
                                  _isGoodsFocused = value;
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
                                            _invaliedGoodsType=true;
                                          });
                                          return null;
                                        }
                                        return null;
                                      },
                                      decoration: customPopupDecoration(hintText: 'Select Goods Type',
                                          error: _invaliedGoodsType,isFocused: _isGoodsFocused),
                                      hintText: selectedGoodsType,
                                      textController: goodsTypeController,
                                      childWidth: constraints.maxWidth,
                                      shape:  RoundedRectangleBorder(
                                        side: BorderSide(color:_invaliedGoodsType? Colors.redAccent :mTextFieldBorder),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      offset: const Offset(1, 40),
                                      tooltip: '',
                                      itemBuilder:  (BuildContext context) {
                                        return typeOfGoods.map((value) {
                                          return CustomPopupMenuItem(
                                            value: value,
                                            text:value,
                                            child: Container(),
                                          );
                                        }).toList();
                                      },

                                      onSelected: (String value)  {
                                        setState(() {
                                          goodsTypeController.text=value;
                                          selectedGoodsType= value;
                                          _invaliedGoodsType=false;
                                        });

                                      },
                                      onCanceled: () {

                                      },
                                      child: Container(),
                                    );
                                  }
                              ),
                            ),
                            const SizedBox(height: 6,),
                            if(_invaliedGoodsType)
                              const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("Select Goods Type",style: TextStyle(color: Color(0xffB83730),fontSize: 13),),
                              ),
                            Container(color: Colors.white,)
                          ],
                        ),
                        const SizedBox(height: 20,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
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