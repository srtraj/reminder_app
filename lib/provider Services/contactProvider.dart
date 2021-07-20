import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

//Provider.of<ContactProvider>(context, listen: false).
// Consumer<ContactProvider>(builder: (context, value, child) {return Text(value.countryCode);}, ),
class ContactProvider with ChangeNotifier {
  var completeContact = new Map();
  var contacts = new Map();
  String oldSearchValue = "";
  bool isSearch = true;
  RegExp regExp =
      new RegExp(r"^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[789]\d{9}$");

  setAllContacts() async {
    for (var k in (await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    ))
        .toList()) {
      for (var phone in k.phones!.toList()) {
        var pn = phone.value.toString().replaceAll(" ", "");
        if (regExp.hasMatch(pn))
          completeContact[pn.substring(pn.length - 10)] = k.displayName;
      }
    }
    contacts = completeContact;
    notifyListeners();
  }

  setSearch() {
    isSearch = !isSearch;
    print(isSearch);
    notifyListeners();
  }

  searchString(String value) {
    if (value.isEmpty)
      contacts = completeContact;
    else {
      if (!value.contains(oldSearchValue)) contacts = completeContact;
      contacts = Map.fromIterable(
          contacts.keys.where((element) => contacts[element]
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())),
          value: (k) => contacts[k]);
    }
    oldSearchValue = value;
    notifyListeners();
  }
}
