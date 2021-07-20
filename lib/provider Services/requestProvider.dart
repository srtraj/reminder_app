import 'package:flutter/material.dart';

//Provider.of<RequestProvider>(context, listen: false).
// Consumer<RequestProvider>(builder: (context, value, child) {return Text(value.countryCode);}, ),
class RequestProvider with ChangeNotifier {
  bool isAddNote = true;
  bool isChecked = false;

  initialSet() {
    isAddNote = true;
    isChecked = false;
    notifyListeners();
  }

  setAddNote() {
    isAddNote = !isAddNote;
    notifyListeners();
  }

  setChecked(value) {
    isChecked = value;
    notifyListeners();
  }
}
