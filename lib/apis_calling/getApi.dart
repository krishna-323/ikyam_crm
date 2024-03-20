import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

  // GetApi Call Async Function.
  Future<List<dynamic>> fetchGetApiData(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String basicAuth=prefs.getString('basicAuth')??"";
    log('++++++++++basicAuth++++++++++++');
    log(basicAuth);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json;charset=utf-8",
        'authorization':basicAuth
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['d']['results'];
    }

    else {
      throw Exception("Failed with status code: ${response.statusCode}");
    }
  }

  // PostApi Call Async Function.
  Future fetchPostApiData(String url, dynamic requestBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String basicAuth=prefs.getString('basicAuth')??"";

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "content-type": "application/json;charset=utf-8",
      'authorization': basicAuth
    },
    body: jsonEncode(requestBody),
  );
  try {
    return jsonDecode(response.body);
  }
  catch(e){
    return {"error":"Something Went Wrong"};
  }

}




