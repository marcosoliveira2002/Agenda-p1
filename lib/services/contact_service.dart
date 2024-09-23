import 'package:agenda/Model/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//Uma forma de tentar salvar os dados, dps testar para ver se da certo
class ContactService {
  static const String _contactsKey = 'contacts';

  Future<void> saveContacts(List<Contact> contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactsJson = contacts.map((contact) => jsonEncode(contact.toMap())).toList();
    await prefs.setStringList(_contactsKey, contactsJson);
  }

  Future<List<Contact>> loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? contactsJson = prefs.getStringList(_contactsKey);
    if (contactsJson != null) {
      return contactsJson.map((json) => Contact.fromMap(jsonDecode(json))).toList();
    }
    return [];
  }
}
