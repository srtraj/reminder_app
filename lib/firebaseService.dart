import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/commonWidget/commonWidget.dart';
import 'package:reminder_app/provider%20Services/commonProvider.dart';

class FirebaseService {
  addItemList(
      context, scaffoldKey, subject, note, price, date, phoneNumber) async {
    var colId = "myNumber";
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference _mainCollection = _firestore.collection(colId);
    DocumentReference documentReferencer = _mainCollection.doc(phoneNumber);
    Map<String, dynamic> requestData = <String, dynamic>{
      "subject": subject,
      "Note": note,
      "price": price,
      "date": date,
    };
    await documentReferencer
        .collection('items')
        .doc()
        .set(requestData)
        .then((value) async {
      await updateCustField(
          context, scaffoldKey, documentReferencer, date, price);
      await updateUserData(_mainCollection, price, date);
      FocusScope.of(context).unfocus();
      Navigator.pop(context);
    }).catchError((e) {
      CommonWidget().snackBarShow(context, scaffoldKey,
          "Something went wrong!!!", Colors.black, "Ok", () {});
      print(e);
    });
  }

  updateCustField(context, scaffoldKey, docRef, date, price) async {
    double getPrice = double.parse(price);
    await docRef.get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          getPrice = getPrice + double.parse(documentSnapshot.get('get'));
        }
        docRef.set({'Modified': date, "get": getPrice.toString(), "give": 0});
      },
    );
  }

  updateUserData(collectRef, price, date) async {
    double getPrice = double.parse(price);
    var docRef = collectRef.doc("userData");
    await docRef.get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          getPrice = getPrice + double.parse(documentSnapshot.get('get'));
        }
        docRef.set({'Modified': date, "get": getPrice.toString(), "give": 0});
      },
    );
  }

  Future<Map<String, dynamic>?> getCustFieldVal(docId) async {
    var colId = "myNumber";
    return ((await FirebaseFirestore.instance
            .collection(colId)
            .doc(docId)
            .get())
        .data());
  }

  Future<Map<String, dynamic>?> getUserFieldVal() async {
    var colId = "myNumber";
    return ((await FirebaseFirestore.instance
            .collection(colId)
            .doc('userData')
            .get())
        .data());
  }

  getCustomerList() {
    Stream dataList =
        FirebaseFirestore.instance.collection('myNumber').snapshots();
    return dataList;
  }

  getCustomerChatList(phoneNumber) {
    Stream dataList = FirebaseFirestore.instance
        .collection('myNumber')
        .doc(phoneNumber)
        .collection("items")
        .orderBy('date')
        .snapshots();
    return dataList;
  }
}
