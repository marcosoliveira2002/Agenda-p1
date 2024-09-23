import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../model/contact.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;
  final int? contactIndex;

  ContactFormScreen({this.contact, this.contactIndex});

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  late MaskedTextController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = MaskedTextController(mask: '(00) 00000-0000');

    if (widget.contact != null) {
      _name = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
      _email = widget.contact!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact != null ? 'Editar Contato' : 'Adicionar Contato'),
        actions: [
          if (widget.contact != null) 
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Deletar Contato'),
                    content: Text('Voce tem certeza que deseja deletar esse contato?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); 
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          contactProvider.deleteContact(widget.contactIndex!);
                          Navigator.pop(context); 
                          Navigator.pop(context); 
                        },
                        child: Text('Deletar'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatorio';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefone é obrigatorio';
                  } else if (value.length != 15) {
                    return 'digite um numero valido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Digite um email valido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (widget.contact != null && widget.contactIndex != null) {
                      contactProvider.updateContact(
                        widget.contactIndex!,
                        Contact(
                          name: _name,
                          phone: _phoneController.text,
                          email: _email,
                        ),
                      );
                    } else {
                      contactProvider.addContact(
                        Contact(
                          name: _name,
                          phone: _phoneController.text,
                          email: _email,
                        ),
                      );
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.contact != null ? 'Atualizar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
