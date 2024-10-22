import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/contacts_list_screen.dart';
import 'screens/contact_form_screen.dart';
import 'screens/login_screen.dart';
import 'providers/contact_provider.dart';
import 'Model/contact.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactProvider()..loadContacts(),
      child: MaterialApp(
        title: 'Agenda',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),  // Adiciona a verificação de token na tela inicial
        routes: {
          '/contacts': (context) => ContactsListScreen(),
          '/login': (context) => LoginScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/edit') {
            final contact = settings.arguments as Contact?;
            return MaterialPageRoute(
              builder: (context) => ContactFormScreen(contact: contact),
            );
          }
          return null;
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // Se o token existir, vai para a tela de listagem de contatos
      Navigator.of(context).pushReplacementNamed('/contacts');
    } else {
      // Caso contrário, vai para a tela de login
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Tela de carregamento
    );
  }
}
