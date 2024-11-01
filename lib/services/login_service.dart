import 'package:sqflite/sqflite.dart';
import 'contact_service.dart';

class LoginService {
  static final LoginService instance = LoginService._init();
  static Database? _database;

  LoginService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await ContactService.instance.database; 
    return _database!;
  }

  Future<int> registerUser(String username, String password) async {
    final db = await instance.database;

    try {
      final id = await db.insert('users', {
        'username': username,
        'password': password,
      });
      return id;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return -1; // Indica falha
    }
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }
}
