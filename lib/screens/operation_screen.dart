import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class OperationScreen extends StatefulWidget {
  final bool isTransfer;

  const OperationScreen({super.key, required this.isTransfer});

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  List<Contact> fContactList = [];
  List<Contact> contactList = [];
  bool isLoading = false;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  getContacts() async {
    setState(() {
      isLoading = true;
    });
    if (await FlutterContacts.requestPermission()) {}
    FlutterContacts.getContacts(
      withProperties: true,
    ).then(
      (value) {
        setState(() {
          value.removeWhere(
            (c) =>
                c.phones.isNotEmpty &&
                !c.phones[0].normalizedNumber.startsWith("+221"),
          );
          value.removeWhere(
            (c) =>
                c.phones.isNotEmpty &&
                !c.phones[0].normalizedNumber
                    .replaceAll("+221", "")
                    .startsWith("7"),
          );
          fContactList.addAll(value);
          contactList.addAll(value);
          isLoading = false;
        });
      },
    );
  }

  search(String text) {
    if (text.isEmpty) {
      fContactList.clear();
      fContactList.addAll(contactList);
    } else {
      fContactList.clear();
      fContactList.addAll(contactList
          .where(
            (contact) =>
                contact.displayName.toLowerCase().contains(text.toLowerCase()),
          )
          .toList());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back)),
        title: Text(
          widget.isTransfer ? "Envoyer de l'argent" : "Achat Crédit",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                search(value);
              },
              decoration: const InputDecoration(
                  labelText: "A",
                  labelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  focusColor: Colors.blue,
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(45)),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.isTransfer
                              ? "Envoyer à un nouveau numéro"
                              : "Acheter du crédit pour un nouveau numéro")
                        ],
                      ),
                    ),
                    const Text(
                      "Contacts",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: fContactList.length > 50
                                ? 50
                                : fContactList.length,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              Contact c = fContactList[index];
                              String number = c.phones.isNotEmpty
                                  ? c.phones[0].normalizedNumber
                                      .replaceAll("+221", "")
                                  : "";
                              Color color = number.startsWith("76")
                                  ? Colors.blueAccent
                                  : number.startsWith("70")
                                      ? Colors.deepPurpleAccent
                                      : Colors.orange;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    widget.isTransfer
                                        ? Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(45)),
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: color,
                                                borderRadius:
                                                    BorderRadius.circular(45)),
                                          ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c.displayName,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            number,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
