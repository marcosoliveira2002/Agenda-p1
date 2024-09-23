import 'package:flutter/material.dart';
import '../model/contact.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void updateContact(int index, Contact updatedContact) {
    _contacts[index] = updatedContact;
    notifyListeners();
  }

  void deleteContact(int index) {
    _contacts.removeAt(index);
    notifyListeners(); // Notifica os listeners para atualizar a UI
  }
}
