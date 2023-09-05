import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

bool userselected = false;

Future<Database> getDatabase() async {
  // Get a reference to the database
  var db = await openDatabase('getfit_database.db');
  print('THIS IS PATH = $db');
  return db;
}

//For inserting newly registered user data to database
Future<void> insertUser(List<String> controllers, GlobalKey<FormState> formKey) async {
  WidgetsFlutterBinding.ensureInitialized();

  Database db = await getDatabase();
  await deleteTable('users',db);
  await createUsersTable(db);

  List<TextEditingController> controllerList =
      controllers.cast<TextEditingController>();

  // Create a new user
  final newUser = User(
    fullName: controllerList[0].text,
    email: controllerList[1].text,
    passwrd: controllerList[2].text,
    dob: controllerList[3].text,
    weight: double.parse(controllerList[4].text),
    height: double.parse(controllerList[5].text),
  );


  await db.insert('users', newUser.toMap());
  
  // Retrieve all users from the database
  final users = await getUsers(db);

  // Print the list of users
  // ignore: avoid_print
  print(users.toString());
}


//fetching inserted user data
  Future<List<User>> getUsers(Database db) async {
    // Query the users table
    final List<Map<String, dynamic>> maps =
        await db.query('users', orderBy: 'userId ASC');

    // Convert the List<Map<String, dynamic>> into a List<User>
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }
  

  // Define a function to delete a table from the database
  Future<void> deleteTable(String tableName, Database db) async {
    // Execute a DROP TABLE statement to delete the table
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  Future<void> createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        fullname TEXT,
        email TEXT UNIQUE,
        passwrd TEXT,
        dob TEXT,
        weight REAL,
        height REAL
      )
    ''');
  }

Future<void> selectUsers(String email, String password) async {
  WidgetsFlutterBinding.ensureInitialized();

  Database db = await getDatabase();

  print('Login Email: $email');
  print('Login Password: $password');

  // Query the users table
  final List<Map<String, dynamic>> maps = await db.query(
    'users',
    columns: ['userId'],
    where: 'email = ? AND passwrd = ?',
    whereArgs: [email, password],
  );
  if (maps.isNotEmpty) {
    print('HELLS');
    userselected = true;
  }
}

Future<bool> emailExists(String email) async {
  Database db = await getDatabase();
  var result =
      await db.rawQuery('SELECT * FROM users WHERE email = ?', [email]);
  print('emailExists: $email, result: $result');
  return result.isNotEmpty;
}

Future<Map<String, dynamic>> getUserDetails(String email) async {
  Database db = await getDatabase();
  var result = await db.rawQuery(
      'SELECT dob, height, weight FROM users WHERE email = ?', [email]);
  Map<String, dynamic> userDetails = {
    'dob': DateTime.parse(result.first['dob'] as String),
    'height': result.first['height'] as double,
    'weight': result.first['weight'] as double
  };
  return userDetails;
}
