// lib/helpers/database_helper.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/symptom.dart'; // นำเข้า Symptom Model

class DatabaseHelper {
  // ค่าคงที่
  static const _databaseName = "SymptomAppDB.db";
  static const _databaseVersion = 1;
  static const tableSymptoms = 'symptoms'; // <--- เปลี่ยนชื่อตารางเป็น symptoms
  
  // ชื่อคอลัมน์
  static const columnId = 'id';
  static const columnDiseaseName = 'diseaseName';
  static const columnSymptoms = 'symptoms';
  static const columnCause = 'cause';
  static const columnTreatment = 'treatment';
  static const columnPainLevel = 'painLevel';
  static const columnEmotionalIcon = 'emotionalIcon';

  // Singleton Pattern และ Database Getter (โค้ดส่วนนี้เหมือนเดิม)
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    // ... (โค้ดสำหรับหา path และ openDatabase เหมือนเดิม)
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // เมธอดสำหรับสร้างตาราง 'symptoms'
  Future _onCreate(Database db, int version) async {
    print('Executing _onCreate for symptoms table...');
    
    await db.execute("""
      CREATE TABLE $tableSymptoms (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDiseaseName TEXT NOT NULL,
        $columnSymptoms TEXT NOT NULL,
        $columnCause TEXT NOT NULL,
        $columnTreatment TEXT NOT NULL,
        $columnPainLevel INTEGER NOT NULL DEFAULT 0,
        $columnEmotionalIcon TEXT NOT NULL DEFAULT '🙂'
      )
    """);
    print('Table "$tableSymptoms" created.');
  }

  // 1. Create (Insert)
  Future<int> insertSymptom(Symptom symptom) async { // <--- เปลี่ยนชื่อเมธอด
    Database db = await instance.database;
    int id = await db.insert(tableSymptoms, symptom.toMap());
    return id; 
  }

  // 2. Read (Query All)
  Future<List<Symptom>> getAllSymptoms() async { // <--- เปลี่ยนชื่อเมธอด
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableSymptoms, orderBy: '$columnId DESC');

    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (i) => Symptom.fromMap(maps[i]));
  }

  // 3. Update
  Future<int> updateSymptom(Symptom symptom) async { // <--- เปลี่ยนชื่อเมธอด
    if (symptom.id == null) return 0;
    Database db = await instance.database;
    int rowsAffected = await db.update(
      tableSymptoms,
      symptom.toMap(), 
      where: '$columnId = ?',
      whereArgs: [symptom.id],
    );
    return rowsAffected;
  }

  // 4. Delete
  Future<int> deleteSymptom(int id) async { // <--- เปลี่ยนชื่อเมธอด
    Database db = await instance.database;
    int rowsDeleted = await db.delete(
      tableSymptoms,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return rowsDeleted;
  }
}