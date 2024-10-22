import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/contact.dart';

class ContactService {
  static final ContactService instance = ContactService._init();
  static Database? _database;

  ContactService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
  //   onOpen:(db) async {
  //     // await db.execute('ALTER TABLE contacts ADD COLUMN email TEXT');
  //      await db.execute('''
  //   CREATE TABLE users (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     username TEXT NOT NULL UNIQUE,
  //     password TEXT NOT NULL
  //   )
  // ''');
  //   } ,
    );
  }

  Future _createDB(Database db, int version) async {
  await db.execute(''' 
    CREATE TABLE contacts ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT NOT NULL, 
      phone TEXT NOT NULL, 
      email TEXT 
    ) 
  '''); 

  
}





  Future<int> insertContact(Contact contact) async {
    final db = await instance.database;
    try {
      final id = await db.insert('contacts', contact.toMap());
      print('Contato inserido com ID: $id'); 
      return id;
    } catch (e) {
      print('Erro ao inserir contato: $e'); 
      return -1; // Indica falha
    }
  }


  Future<List<Contact>> getContacts() async {
    final db = await instance.database;
    final result = await db.query('contacts');

    if (result.isEmpty) {
      print('Nenhum contato encontrado.'); 
    } else {
      print('Contatos carregados: ${result.length}'); 
    }

    return result.map((json) => Contact.fromMap(json)).toList();
  }


  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    try {
      final rowsAffected = await db.update(
        'contacts',
        contact.toMap(),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
      print('Linhas atualizadas: $rowsAffected'); 
      return rowsAffected;
    } catch (e) {
      print('Erro ao atualizar contato: $e'); 
      return -1; 
    }
  }


  Future<void> deleteContact(int id) async {
    final db = await instance.database;
    try {
      final rowsDeleted = await db.delete(
        'contacts',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Linhas deletadas: $rowsDeleted'); 
    } catch (e) {
      print('Erro ao deletar contato: $e');  
    }
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
