import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/contact_provider.dart';
import 'contact_form_screen.dart';
import 'login_screen.dart'; 

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  @override
  void initState() {
    super.initState();
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);
    contactProvider.loadContacts();
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');  // Remove o token de login

    // Redireciona o usuário para a tela de login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              ).then((_) {
                final contactProvider =
                    Provider.of<ContactProvider>(context, listen: false);
                contactProvider.loadContacts();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,  
          ),
        ],
      ),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          final contacts = contactProvider.contacts;

          return contacts.isEmpty
              ? Center(child: Text('Nenhum contato'))
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      title: Text(contact.name),
                      subtitle: Text('${contact.phone}\n${contact.email}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactFormScreen(contact: contact),
                          ),
                        ).then((_) {
                          final contactProvider =
                              Provider.of<ContactProvider>(context, listen: false);
                          contactProvider.loadContacts();
                        });
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
