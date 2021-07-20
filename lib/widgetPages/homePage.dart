import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider%20Services/contactProvider.dart';
import '../config Page/Colorconfig.dart';
import '../commonWidget/commonWidget.dart';
import '../firebaseService.dart';
import 'chatPage.dart';
import 'contactListPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearch = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode focusSearch = FocusNode();

  void searchSet() {
    setState(() {});
    isSearch = !isSearch;
  }

  openAddContactPage() async {
    if (await Permission.contacts.request().isGranted) {
      await Provider.of<ContactProvider>(context, listen: false)
          .setAllContacts();
      CommonWidget().moveToNextPage(context, ContactListPage());
    } else if (await Permission.contacts.isPermanentlyDenied) {
      CommonWidget().snackBarShow(context, _scaffoldKey, "Permission Denied !!",
          Colors.red, "Open setting", openSettingFun);
    }
  }

  openSettingFun() async {
    await openAppSettings();
  }

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
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + ht),
            color: ColorConfig().topContainerColor,
            width: wt * 100,
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  color: Colors.white,
                ),
                Text(
                  "store name",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                Expanded(child: Container()),
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    var lst = await FirebaseService().getCustomerList();
                    final allData = lst.map((doc) => doc.data()).toList();
                    print(allData);
                    print(allData.runtimeType);
                  },
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          if (!isSearch)
            Container(
              width: wt * 100,
              height: ht * 28,
              color: Colors.grey[300],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      color: ColorConfig().topContainerColor,
                      width: wt * 100,
                      height: ht * 15,
                    ),
                  ),
                  Positioned(
                    top: ht * 5,
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: FirebaseService().getUserFieldVal(),
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
                  ),
                ],
              ),
            ),
          customerListView(wt, ht)
        ],
      ),
      floatingActionButton: isSearch
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                openAddContactPage();
              },
              label: Text("Add Customer"),
            ),
    );
  }

  customerListView(wt, ht) {
    return Expanded(
      child: Container(
        width: wt * 100,
        color: Colors.grey[300],
        child: Column(
          children: [
            Container(
              height: ht * 10,
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: wt * 3,
                    ),
                    isSearch
                        ? IconButton(
                            icon: Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              searchSet();
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.search, color: Colors.green),
                            onPressed: () {
                              FocusScope.of(context).requestFocus();
                              searchSet();
                            },
                          ),
                    SizedBox(
                      width: wt * 5,
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: focusSearch,
                        decoration:
                            InputDecoration(hintText: "Search name ..."),
                        onTap: () => searchSet(),
                        onSubmitted: (_) {
                          searchSet();
                        },
                      ),
                    ),
                    SizedBox(
                      width: wt * 5,
                    ),
                    Container(
                      child: new Material(
                        child: new InkWell(
                          onTap: () {
                            print("tapped");
                          },
                          child: new Container(
                              child: Icon(Icons.filter_alt_rounded)),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                    SizedBox(
                      width: wt * 5,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseService().getCustomerList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var items = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: items.length - 1,
                          itemBuilder: (BuildContext context, int index) {
                            var item = items.elementAt(index);
                            var phoneNumber = item.id;
                            var name = Provider.of<ContactProvider>(context,
                                        listen: false)
                                    .contacts[item.id] ??
                                "Unknown";
                            if (item.id == "userData") return Container();
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  CommonWidget().moveToNextPage(
                                      context, ChatPage(phoneNumber, name));
                                },
                                child: ListTile(
                                  leading: Container(
                                    width: wt * 10,
                                    height: wt * 10,
                                    decoration: BoxDecoration(
                                        color: Colors.primaries[Random()
                                            .nextInt(Colors.primaries.length)],
                                        shape: BoxShape.circle),
                                  ),
                                  title: Text(name),
                                  subtitle: Text(phoneNumber),
                                  trailing: Text(
                                    item['Modified'],
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 10),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
