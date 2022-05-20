import 'package:flutter/material.dart';

AppBar header(context,{bool isAppTitle=false,String titleText='',removeBackButton=false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton?false:true,
    title: Text(
      isAppTitle?"FamilyShare":titleText,
      style: TextStyle(
          color: Colors.white,
          fontFamily: "Roboto",
          fontSize: isAppTitle? 50.0:22.0,
          fontWeight: FontWeight.w200,
          fontStyle: FontStyle.italic),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).secondaryHeaderColor,
  );
}
