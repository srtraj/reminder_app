import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/commonWidget/commonWidget.dart';
import 'package:reminder_app/provider%20Services/contactProvider.dart';

import 'chatPage.dart';
import 'homePage.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  var focusNode = FocusNode();
  TextEditingController cntSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .95,
            decoration: BoxDecoration(
              border: Border.all(width: 3.0),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: cntSearch,
                    focusNode: focusNode,
                    decoration: new InputDecoration(
                      hintText: 'Search phone or name ....',
                      suffixStyle: const TextStyle(color: Colors.green),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    onChanged: (val) {
                      Provider.of<ContactProvider>(context, listen: false)
                          .searchString(val);
                    },
                    onTap: () =>
                        Provider.of<ContactProvider>(context, listen: false)
                            .setSearch(),
                    onSubmitted: (_) =>
                        Provider.of<ContactProvider>(context, listen: false)
                            .setSearch(),
                  ),
                ),
                Provider.of<ContactProvider>(context).isSearch
                    ? IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus();
                          Provider.of<ContactProvider>(context, listen: false)
                              .setSearch();
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          cntSearch.clear();
                          Provider.of<ContactProvider>(context, listen: false)
                            ..searchString("");
                          FocusScope.of(context).unfocus();
                          Provider.of<ContactProvider>(context, listen: false)
                              .setSearch();
                        },
                      ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: Provider.of<ContactProvider>(context, listen: false)
                    .contacts
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  var contacts =
                      Provider.of<ContactProvider>(context, listen: false)
                          .contacts;
                  var key = contacts.keys.elementAt(index);
                  return InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChatPage(key, contacts[key])),
                        ModalRoute.withName('/'),
                      );
                    },
                    child: ListTile(
                      title: Text(contacts[key]),
                      subtitle: Text(key),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
