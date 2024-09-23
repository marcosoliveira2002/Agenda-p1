import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/contacts_list_screen.dart';
import 'screens/contact_form_screen.dart';
import 'providers/contact_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactProvider(),
      child: MaterialApp(
        title: 'Agenda',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => ContactsListScreen(),
          '/edit': (context) => ContactFormScreen(),
        },
      ),
    );
  }
}
