import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerItemPage extends StatelessWidget {
  CustomerItemPage(this.item, {Key? key}) : super(key: key);
  final QueryDocumentSnapshot<Object?> item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
