import 'package:flutter/material.dart';

import '../utils/static_files/static_colors.dart';

decorationInput3(String hintString) {
  return  InputDecoration(

      label: Text(
        hintString,
      ),
      counterText: '',labelStyle: const TextStyle(fontSize: 12),
      contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      suffixIconColor: const Color(0xfff26442),
      disabledBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:  Colors.white)),
      enabledBorder:const OutlineInputBorder(borderSide:  BorderSide(color: mTextFieldBorder)),
      focusedBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:Color(0xff00004d))),
      border:   const OutlineInputBorder(borderSide:  BorderSide(color:Color(0xff00004d)))
  );
}

// Using In View CustomerDetails.
decorationSearch(String hintString,) {
  return InputDecoration(
    prefixIcon: const Icon(
      Icons.search,
      size: 18,
    ),
    prefixIconColor: Colors.blue,
    fillColor: Colors.white,
    counterText: "",
    contentPadding: const EdgeInsets.fromLTRB(12, -11, 01, 3),
    hintText: hintString,hintStyle: const TextStyle(fontSize: 14,color: Colors.grey),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.blue, width: 0.5)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.blue)),
  );
}