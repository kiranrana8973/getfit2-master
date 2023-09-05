import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'getfit_database.db'),
    // When the database is first created, create a table to store data.
    onCreate: (db, version) {
      return db.execute(
        '''CREATE TABLE IF NOT EXISTS sensor_data(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          acc_x NUMERIC, 
          acc_y NUMERIC, 
          acc_z NUMERIC, 
          gyro_x NUMERIC, 
          gyro_y NUMERIC, 
          gyro_z NUMERIC,)''',
      );
    },
    version: 1,
  );

  // Function to insert data into the database
  Future<void> insertData(String value1, String value2, String value3,
      String value4, String value5, String value6) async {
    final Database db = await database;
    await db.insert(
      'sensor_data',
      {
        'acc_x': value1,
        'acc_y': value2,
        'acc_z': value3,
        'gyro_x': value4,
        'gyro_y': value5,
        'gyro_z': value6
      },
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read data from puTTY log file
  final file = File('E:\\getfit_data\\putty.log');
  final lines = file.readAsLinesSync().skip(1);
  for (final line in lines) {
    final values = line.split(',');
    if (values.length == 6) {
      await insertData(
          values[0], values[1], values[2], values[3], values[4], values[5]);
    }
  }
}
