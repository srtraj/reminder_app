import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/commonWidget/customButton.dart';
import '../commonWidget/commonWidget.dart';
import '../firebaseService.dart';
import 'customerItemPage.dart';
import 'newRequest.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this.phoneNumber, this.contactName, {Key? key}) : super(key: key);
  final String phoneNumber;
  final String contactName;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height / 100;
    final wt = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contactName,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.phoneNumber,
              style: TextStyle(fontSize: 15, color: Colors.grey[300]),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          FutureBuilder<Map<String, dynamic>?>(
            future: FirebaseService().getCustFieldVal(widget.phoneNumber),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                    child: CommonWidget().cardWidget(
                        wt,
                        ht,
                        snapshot.data?['give'] ?? 0,
                        snapshot.data?['get'] ?? 0));
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseService().getCustomerChatList(widget.phoneNumber),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var items = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = items.elementAt(index);
                          return InkWell(
                            onTap: () {
                              print(item.id);
                              CommonWidget().moveToNextPage(
                                  context, CustomerItemPage(item));
                            },
                            child: Card(
                              child: ListTile(
                                // trailing: Text(item['price'].toString()),
                                title: Text(item['subject'].toString()),
                                subtitle: Text(
                                  item['date'].toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                trailing: Text(
                                  "\u{20B9} ${item['price']}",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
          CustomButton(
            height: 40,
            color: Colors.blue,
            width: wt * 80,
            text: 'Add Request',
            callBack: () {
              // Navigator.of(context).push(CommonWidget().createRoute(NewRequest(phoneNumber)));
              CommonWidget()
                  .moveToNextPage(context, NewRequest(widget.phoneNumber));
            },
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
