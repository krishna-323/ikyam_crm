import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

// import 'package:qr_flutter/qr_flutter.dart';





Future<Uint8List> generatePdf2(Map jsonData) async {
  final pdf = Document();
  int total =0;

  //fontSize10withBold.
  TextStyle styleBold = TextStyle(fontWeight: FontWeight.bold,);
 TextStyle fontSize10withBold = TextStyle(fontWeight: FontWeight.bold,fontSize: 10);
 TextStyle fontSize10= const TextStyle(fontSize: 10);
 TextStyle fontSize9 = const TextStyle(fontSize: 9);

  /// Convert ByteData to Uint8List For Image.
  // Future<MemoryImage> generateQrCodeImage(String data) async {
  //   final qrImageData = await QrPainter(
  //     data: data,
  //     eyeStyle: const QrEyeStyle(color:Color(0xb2000000) ),
  //
  //     version: QrVersions.auto,
  //   ).toImageData(200); // Adjust size as needed
  //   return MemoryImage(qrImageData!.buffer.asUint8List());
  // }
  //
  // final qrCodeImage = await generateQrCodeImage('eyJhbGciOiJSUzI1NiIsImtpZCI6IkI4RDYzRUNCNThFQTVFNkY0QUFDM0Q1MjQ1NDNCMjI0NjY2OUIwRjgiLCJ4NXQiOiJ1TlkteTFqcVhtOUtyRDFTUlVPeUpHWnBzUGciLCJ0eXAiOiJKV1QifQ.eyJkYXRhIjoie1wiU2VsbGVyR3N0aW5cIjpcIjIwQUFCRlU1NjM3SjFaOVwiLFwiQnV5ZXJHc3RpblwiOlwiMjBBQUFDVDI4MDNNMlpPXCIsXCJEb2NOb1wiOlwiVUFFLzIzMTIvMDEyLzIzXCIsXCJEb2NUeXBcIjpcIklOVlwiLFwiRG9jRHRcIjpcIjE5LzAyLzIwMjRcIixcIlRvdEludlZhbFwiOjEzNTY0MS4wLFwiSXRlbUNudFwiOjEsXCJNYWluSHNuQ29kZVwiOlwiOTk3MzE5XCIsXCJJcm5cIjpcIjE3OWNlNGE0MDRkYmE3ZjQ0MDQwOTMwNzZkZWFmMWRiY2UzNmIxZjdhMDZmZGY0YjNhOGE4MDFlNTMzZTAxM2VcIixcIklybkR0XCI6XCIyMDI0LTAyLTE5IDE2OjAwOjAwXCJ9IiwiaXNzIjoiTklDIn0.l9aUCvhC2s8on112Ec31x7G9leceHcUbWddbwtqcq0vUxJdq9C-rs3BP5RRPeOMWQFGNcIWx3afwO5REPmx0ynd2rFXbksJj4t37yx1tuLo2qJzZv9SJPFGDzSvlErZXrx292d1_wt77f7fgUXPSHuP9OaViXiCn_dgPS8oDGK9jBKryqu_LugiAu4XpNiqaZ3e5rudyQdYSdHJMBkeQlwZC_1VYmxMj_C9XOJm5kbomCsbrRgiXZCR8tfmekysqKAG16RO40U4riPv5QZB9GKwAPobD2dPoB63lmv-ThnTKZ5I9nP6szbGTvXDw5FUVlzUqI9_fdeulAX-xqnHJJg');

  pdf.addPage(
    MultiPage(margin: const EdgeInsets.all(35) ,crossAxisAlignment: CrossAxisAlignment.start,
      build: (context) => [
        //first1.
        Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Customer Order Details",style: styleBold)
            ]
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
        //second.
        Container(
          height: 30,
          color: PdfColors.grey300,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Invoice No: 878999'),
                  Text("Invoice Date:${jsonData['serviceInvoiceDate']??""}"),
                ]
            ),
          ),
        ),
        SizedBox(height: 2 * PdfPageFormat.mm),
        //third.
        Row(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ikyam Solutions Pvt Ltd.",style: styleBold),
                    SizedBox(height: 5),
                    Text("# 5, 80ft Road,4th Block,Koramangala,Bangalore-560034",style: fontSize10withBold,maxLines: 2,overflow: TextOverflow.clip),
                    Text("Phone No : +91 7899726639",style: fontSize10withBold),
                    Text("Email Id : www.ikyam.com",style:fontSize10withBold),
                  ]
              ),

              ///Qr Code Displaying.
              // Container(
              //   height: 100,width: 100,
              //   child:  Center(
              //     child: Image(qrCodeImage,fit: BoxFit.cover),
              //   ),
              //
              // ),
            ]
        ),

        SizedBox(height: 25),

        //fourth.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text("Bill To",style: styleBold),
            Text("Customer Details",style: fontSize10withBold),
            Text("Customer Name: ${jsonData["billAddressName"]??""}",style: fontSize10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address:",style: fontSize10),
                      Column(children: [
                        Container(width: 150,
                          child: Text("${jsonData["billAddressStreet"]}.",style: fontSize10),
                        )

                      ]),

                    ]),
            Text("Phone: ${jsonData["billToPhone"]??""}",style: fontSize10),

          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
              children:[
            Text("Ship To",style: styleBold),
                //Text("Delivery",style: fontSize10withBold),
                Text("Name: ${jsonData["shipAddressName"]??""}",style: fontSize10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("Address:",style: fontSize10),
                  Column(children: [
                    Container(width: 150,
                     child: Text("${jsonData["shipAddressStreet"]}.",style: fontSize10),
                    )

                  ]),

                ]),
                Text("Pin code: ${jsonData["shipAddressZipcode"]??""}",style: fontSize10),
               // SizedBox(height: 10),
                Text("Delivery Date: ${jsonData['serviceInvoiceDate']??""}",style: fontSize10),
              ]),
        ]),

        SizedBox(height: 25),
        //five.
        ///Table.
        Container(decoration:const BoxDecoration(),child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header.
              Container(
                  height: 30,

                  decoration:const BoxDecoration(color: PdfColors.grey300,),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Expanded(child: Padding(padding:const EdgeInsets.only(left: 2),child: Text('SL NO',style: fontSize10withBold))),
                      Expanded(flex: 2,child: Padding(padding:const EdgeInsets.only(left: 2),child: Text('Name',style: fontSize10withBold))),
                     // Container(color: PdfColors.black,width: 1,height: 30),
                      Expanded(flex: 2,child: Padding(
                          padding: const EdgeInsets.only(left: 2),child: Text('Collection',style: fontSize10withBold)
                      )),
                      //Container(color: PdfColors.black,width: 1,height: 30),// Corrected this line
                      Expanded(flex: 2,child: Padding(
                          padding: const EdgeInsets.only(left: 2),child: Text('Type',style: fontSize10withBold)
                      )),
                     // Container(color: PdfColors.black,width: 1,height: 30),
                      Expanded(child: Padding(
                          padding: const EdgeInsets.only(left: 2),child: Text('Rate',style: fontSize10withBold)
                      )),

                     // Container(color: PdfColors.black,width: 1,height: 30),
                      Expanded(child: Padding(
                          padding: const EdgeInsets.only(left: 2),child: Text('Qty',style: fontSize10withBold)
                      )),
                      Expanded(child: Padding(
                          padding: const EdgeInsets.only(left: 2),child: Text('Discount',style: fontSize10withBold)
                      )),
                      Expanded(child: Padding(
                          padding: const EdgeInsets.only(left: 2),child: Text('Tax %',style: fontSize10withBold)
                      )),
                      Expanded(flex: 1,child: Padding(
                          padding: const EdgeInsets.only(left: 2),child: Text('Amount',style: fontSize10withBold)
                      )),
                    ],
                  )
              ),


             // Dynamic Data.

              for (int i = 0; i < jsonData['items'].length; i++)
                SizedBox(child:
                LayoutBuilder(builder: (context, constraints) {

                  Map storeMap=jsonData['items'][i];
                  // print('-------items-------');
                  // print(jsonData['items'][i]);

                  // Split the input string by whitespace
                  List<String> words = storeMap['type'].toLowerCase().split(' ');

                  // Capitalize the first letter of each word
                  List<String> capitalizedWords = words.map((word) {
                    // Capitalize the first letter of the word
                    String firstLetter = word.substring(0, 1).toUpperCase();
                    String restOfWord = word.substring(1);
                    return '$firstLetter$restOfWord';
                  }).toList();

                  // Join the capitalized words back into a single string
                  String result = capitalizedWords.join(' ');


                  String s = "";
                  if(i.isOdd){
                    s = "CustomerName sdsa dsfs dsfs dsfds  i asd sdsa";
                  }
                  else{
                    s ="sarhi";
                  }

                  print(s.length);
                  total = total+i;
                  return Column(children: [
                    Container(height: 30,child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Expanded(child: Padding(
                        //     padding: const EdgeInsets.only(left: 2),child: Text('${i +1}',style: fontSize10)
                        // )),
                        Expanded(flex: 2,child: Padding(
                            padding: const EdgeInsets.only(left: 2),child: Text(storeMap['itemsService'],style: fontSize9)
                        )),

                        //Container(color: PdfColors.black,width: 1,height: double.parse(s.length.toString())<30 ?38 :double.parse(s.length.toString())),// Corrected this line

                        Expanded(flex: 2,child: Padding(
                            padding:const EdgeInsets.only(left: 2),child: Text(storeMap['collection'],style: fontSize9)
                        )),
                        // Container(color: PdfColors.black,width: 1,height: double.parse(s.length.toString())<30 ?38 :double.parse(s.length.toString())),// Corrected this line
                        Expanded(flex: 2,child: Padding(
                            padding:const EdgeInsets.only(left: 2),child: Text(result,style: fontSize9)
                        )),
                        //Container(color: PdfColors.black,width: 1,height: double.parse(s.length.toString())<30 ?38 :double.parse(s.length.toString())),
                        Expanded(child: Padding(
                            padding:const EdgeInsets.only(left: 2),child: Text(storeMap['priceItem'].substring(1),style: fontSize9)
                        )),

                        Expanded(child: Padding(
                            padding:const EdgeInsets.only(left: 2),child: Text(storeMap['quantity'],style: fontSize9)
                        )),
                        // Container(color: PdfColors.black,width: 1,height: double.parse(s.length.toString())<30 ?38 :double.parse(s.length.toString())),
                        Expanded(child: Padding(
                            padding:const EdgeInsets.only(left: 2),child: Text(storeMap['discount'],style: fontSize9)
                        )),
                        // Container(color: PdfColors.black,width: 1,height: double.parse(s.length.toString())<30 ?38 :double.parse(s.length.toString())),
                        Expanded(child: Padding(
                            padding:const EdgeInsets.only(left: 2),child: Text(storeMap['tax'],style: fontSize9)
                        )),
                        // Container(color: PdfColors.black,width: 1,height: double.parse(s.length.toString())<30 ?38 :double.parse(s.length.toString())),
                        Expanded(flex: 1,child: Padding(
                            padding:const EdgeInsets.only(left: 2),child: Text(storeMap['amount'],style: fontSize9)
                        )),
                        // Container(color: PdfColors.black,width: 1,height: double.parse(s.length.toString())<30 ?38 :double.parse(s.length.toString())),


                      ],
                    ), )

                    //Divider(height: 1,color: PdfColors.black)
                  ]);
                },),),
              //Container(color: PdfColors.black,height: 5),

            ]
        ),),
        SizedBox(height: 10),
        ///Footer.
        Container(
          color: PdfColors.grey300,
          height: 30,
          child: Row(
            children:   [
               Expanded(child: Center(child: Text(''))),
               Expanded(flex: 4,child: Center(child: Text(""))),
               Expanded(child: Center(child: Text(''))),
               Container(color: PdfColors.grey300,height: 1),
               Expanded(child: Center(child: Text("Sub Total",style: fontSize9),)),
               Container(color: PdfColors.grey300,height: 1),
               Expanded(child: Center(child: Builder(
                  builder: (context) {
                    return Text("${jsonData["subTotalDiscount"].isEmpty?0:jsonData["subTotalDiscount"]}",style: fontSize9);
                  }
              ))),
              Container(color: PdfColors.grey300,height: 1),
              Expanded(child: Center(child: Builder(
                  builder: (context) {
                    return Text("${jsonData['subTotalTax'].isEmpty?0:jsonData['subTotalTax']}",style: fontSize9);
                  }
              ))),
              Container(color: PdfColors.grey300,height: 1),
              Expanded(child: Center(child: Builder(
                  builder: (context) {
                    return Text("${jsonData['subTotalAmount'].isEmpty?0 :jsonData['subTotalAmount']}",style: fontSize9);
                  }
              ))),
            ],
          ),
        ),
        //six.
        SizedBox(height: 20),
        Row(children: [
          Text("Notes :",style: fontSize10withBold),
          Text("${jsonData['termsConditions']??""}",style: fontSize10)
        ]),
      ],
    ),
  );

  // print('------pdf-------');
  // print(pdf.runtimeType);

  // Return PDF as bytes.
  return pdf.save();
}









