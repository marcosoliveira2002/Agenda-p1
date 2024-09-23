import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import 'contact_form_screen.dart'; 

class ContactsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final contacts = contactProvider.contacts;

    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: contacts.isEmpty
          ? Center(child: Text('Nenhum contato'))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text('${contact.phone}\n${contact.email}'),
                  onTap: () {
                    // Navega para a tela de edição com o contato selecionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactFormScreen(
                          contact: contact,
                          contactIndex: index, 
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
