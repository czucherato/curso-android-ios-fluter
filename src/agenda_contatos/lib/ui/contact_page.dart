import 'dart:io';
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key, this.contact}) : super(key: key);

  final Contact? contact;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final ImagePicker _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  Contact? _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      _nameController.text = _editedContact!.name!;
      _emailController.text = _editedContact!.email!;
      _phoneController.text = _editedContact!.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact!.name ?? 'Novo contato'),
            centerTitle: true
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact!.name != null && _editedContact!.name!.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                    child:  Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _getImage()
                            )
                        )
                    ),
                  onTap: () async {
                    var file = await _picker.pickImage(source: ImageSource.camera);
                    if (file == null) {
                      return;
                    } else {
                      setState(() {
                        _editedContact!.img = file.path;
                      });
                    }
                  }
                ),
                TextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(
                        labelText: "Nome"
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedContact!.setName(text);
                      });
                    }
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "Email"
                  ),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact!.setEmail(text);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                        labelText: "Telefone"
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact!.setPhone(text);
                    },
                    keyboardType: TextInputType.phone
                )
              ],
            )
        )
    ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar alterações ?"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: [
                FlatButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('Cancelar')),
                FlatButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, child: Text('Sair'))
              ],
            );
          });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  ImageProvider<Object> _getImage() {
    var img = _editedContact?.img;
    if (img != null) {
      return FileImage(File(img));
    } else {
      return AssetImage('images/person.png');
    }
  }
}
