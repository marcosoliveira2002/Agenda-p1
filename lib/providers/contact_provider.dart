import 'package:flutter/material.dart';
import '../Model/contact.dart';
import '../services/contact_service.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  final ContactService _contactService = ContactService.instance;

  List<Contact> get contacts => _contacts;

  
  Future<void> loadContacts() async {
    _contacts = await _contactService.getContacts();
    notifyListeners();
  }


  Future<void> addContact(Contact contact) async {
    await _contactService.insertContact(contact); 
    await loadContacts(); 
  }


  Future<void> updateContact(Contact contact) async {
    await _contactService.updateContact(contact);
    await loadContacts(); 
  }


  Future<void> deleteContact(int id) async {
    await _contactService.deleteContact(id);
    await loadContacts(); 
  }
}
