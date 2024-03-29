import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

enum OrderOptions {
  orderaz,
  orderza
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];


  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                    child: Text('Ordenar de A-Z'),
                value: OrderOptions.orderaz),
                const PopupMenuItem<OrderOptions>(
                    child: Text('Ordenar de Z-A'),
                    value: OrderOptions.orderza)
              ],
          onSelected: _orderList)
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
          return _contactCard(context, index);
          })
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: _getImage(index)
                  )
                )
              ),
              Padding(padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contacts[index]!.name!,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  )),
                  Text(contacts[index]!.email!,
                      style: TextStyle(
                          fontSize: 18
                      )),
                  Text(contacts[index]!.phone!,
                      style: TextStyle(
                          fontSize: 18
                      ))
                ],
              ))
            ],
          )
        )
      ),
      onTap: () {
        _showOptions(context, index);
      }
    );
  }

  _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: (){},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: () async {
                              await launch("tel:${contacts[index].phone}");
                              Navigator.pop(context);
                            },
                            child: Text('Ligar', style: TextStyle(
                              color: Colors.red, fontSize: 20
                            ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showContactPage(contact: contacts[index]);
                            },
                            child: Text('Editar', style: TextStyle(
                                color: Colors.red, fontSize: 20
                            ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FlatButton(
                            onPressed: () async {
                              await helper.deleteContact(contacts[index].id!);
                              setState(() {
                                contacts.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Excluir', style: TextStyle(
                                color: Colors.red, fontSize: 20
                            ))),
                      )
                    ],
                  )
                );
              });
        });
  }

  ImageProvider<Object> _getImage(int index) {
    var img = contacts[index].img;
    if (img != null) {
      return FileImage(File(img));
    } else {
      return AssetImage('images/person.png');
    }
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );

    if (recContact.id == null) {
      await helper.saveContact(recContact);
    } else {
      await helper.updateContact(recContact);
    }
      _getAllContacts();
    }

  void _getAllContacts() {
    helper.getAllContacts().then((value) {
      setState(() {
        contacts = value;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) => b.name!.toLowerCase().compareTo(a.name!.toLowerCase()));
        break;
    }
    setState(() {

    });
  }
}
