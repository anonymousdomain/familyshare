import 'package:flutter/material.dart';

AppBar header(context,{bool isAppTitle=false, appTitle }) {
  return AppBar(
    title: Text(
      isAppTitle?'FamilyShare':appTitle,
      style: TextStyle(color: Colors.white,fontSize:35,fontWeight: FontWeight.w500),),
      centerTitle: true,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
  );
}
