import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/firebaseService.dart';

//Provider.of<CommonProvider>(context, listen: false).
// Consumer<CommonProvider>(builder: (context, value, child) {return Text(value.countryCode);}, ),
class CommonProvider with ChangeNotifier {}
