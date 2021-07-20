import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/commonWidget/commonWidget.dart';
import 'package:reminder_app/provider%20Services/requestProvider.dart';

import '../firebaseService.dart';

class NewRequest extends StatefulWidget {
  NewRequest(this.phoneNumber, {Key? key}) : super(key: key);
  String phoneNumber;

  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  final cntSub = TextEditingController();

  final cntNote = TextEditingController();

  final cntPrice = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    cntSub.dispose();
    cntNote.dispose();
    cntPrice.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        Provider.of<RequestProvider>(context, listen: false).initialSet());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height / 100;
    // final wt = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    10, MediaQuery.of(context).padding.top + 10, 10, 10),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: ht * 2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: TextField(
                              controller: cntSub,
                              decoration: new InputDecoration(
                                hintText: 'Enter subject',
                                suffixStyle:
                                    const TextStyle(color: Colors.green),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Provider.of<RequestProvider>(context, listen: false)
                                .setAddNote();
                            cntNote.clear();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Provider.of<RequestProvider>(context).isAddNote
                                  ? Icon(Icons.add_circle_outlined)
                                  : Icon(
                                      Icons.indeterminate_check_box_outlined),
                              Provider.of<RequestProvider>(context).isAddNote
                                  ? Text("Add note")
                                  : Text("remove note"),
                            ],
                          ),
                        ),
                        if (!Provider.of<RequestProvider>(context).isAddNote)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            height: ht * 40,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextField(
                                controller: cntNote,
                                decoration: new InputDecoration(
                                  hintText: 'Enter note',
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                            ),
                          ),
                        SizedBox(
                          height: ht * 2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: TextField(
                              controller: cntPrice,
                              decoration: new InputDecoration(
                                hintText: 'Enter price',
                                prefix: Text("\u{20B9} "),
                                suffixStyle:
                                    const TextStyle(color: Colors.green),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('([0-9]+(.[0-9]+)?)'))
                              ],
                            ),
                          ),
                        ),
                        CheckboxListTile(
                          title: Text(
                            "send notification to customer",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Provider.of<RequestProvider>(context)
                                      .isChecked
                                  ? Colors.black
                                  : Colors.grey[700],
                            ),
                          ),
                          value:
                              Provider.of<RequestProvider>(context).isChecked,
                          onChanged: (val) {
                            Provider.of<RequestProvider>(context, listen: false)
                                .setChecked(val);
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        SizedBox(
                          height: ht,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () {
                        addReminderFun(
                          context,
                          _scaffoldKey,
                        );
                      },
                      child: Text("Add to list")))
            ],
          ),
        ),
      ),
    );
  }

  addReminderFun(context, scaffoldKey) async {
    if (cntSub.text.isEmpty ||
        cntPrice.text.isEmpty ||
        (cntNote.text.isEmpty &&
            !Provider.of<RequestProvider>(context, listen: false).isAddNote))
      CommonWidget().snackBarShow(
          context, scaffoldKey, "Enter All Field !!", Colors.red, "Ok", () {});
    else {
      await FirebaseService().addItemList(
          context,
          scaffoldKey,
          cntSub.text,
          cntNote.text,
          cntPrice.text,
          DateFormat.yMd().add_jm().format(DateTime.now()),
          widget.phoneNumber);

      cntSub.clear();
      cntPrice.clear();
      cntNote.clear();
    }
  }
}
