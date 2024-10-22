import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../Model/contact.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;

  ContactFormScreen({Key? key, this.contact}) : super(key: key);

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

    // Se o contato for fornecido, inicializa os campos com os dados do contato
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
              onPressed: () async {
                if (widget.contact != null && widget.contact!.id != null) {
                  await contactProvider.deleteContact(widget.contact!.id!);
                  Navigator.pop(context); // Voltar à lista de contatos após deletar
                }
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
                    return 'Nome é obrigatório';
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
                    return 'Telefone é obrigatório';
                  } else if (value.length != 15) {
                    return 'Digite um número válido';
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
                    return 'Digite um email válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Cria um novo contato com os dados do formulário
                    Contact newContact = Contact(
                      name: _name,
                      phone: _phoneController.text,
                      email: _email,
                    );

                    if (widget.contact != null) {
                      newContact.id = widget.contact!.id;
                      await contactProvider.updateContact(newContact);
                      print('Contato atualizado: ${newContact.id}');
                    } else {
                      // Adiciona um novo contato
                      await contactProvider.addContact(newContact);
                      print('Novo contato adicionado');
                    }

                    // Volta para a lista de contatos após salvar ou atualizar
                    Navigator.pop(context);
                  } else {
                    print('Formulário inválido');
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
