import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/login_service.dart';
import '../providers/contact_provider.dart';
import 'contacts_list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  final _secureStorage = FlutterSecureStorage();  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Cadastrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLogin ? _login : _register,
              child: Text(_isLogin ? 'Login' : 'Cadastrar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin ? 'Não tem uma conta? Cadastrar' : 'Já tem uma conta? Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final success = await LoginService.instance.loginUser(username, password);

    if (success) {
      await _secureStorage.write(key: 'token', value: username);

      final contactProvider = Provider.of<ContactProvider>(context, listen: false);
      await contactProvider.loadContacts();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ContactsListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha no login')));
    }
  }

  Future<void> _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final id = await LoginService.instance.registerUser(username, password);

    if (id != -1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário cadastrado')));
      setState(() {
        _isLogin = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cadastrar')));
    }
  }
}
