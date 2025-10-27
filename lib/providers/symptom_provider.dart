// lib/providers/symptom_provider.dart

import 'package:flutter/foundation.dart';
import '../้helpers/database_helper.dart';// ใช้ DatabaseHelper
import '../models/symptom.dart';// ใช้ Symptom Model
       

class SymptomProvider with ChangeNotifier {
  // อ้างอิงถึง Database Helper
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // State หลัก: รายการ Symptom ที่เก็บในหน่วยความจำ
  List<Symptom> _symptoms = [];
  
  // Getter สำหรับให้ UI เข้าถึงข้อมูล
  List<Symptom> get symptoms => [..._symptoms];

  // 1. Load Data: เมธอดสำหรับโหลดข้อมูลเริ่มต้นจาก DB
  Future<void> loadSymptoms() async {
    print('SymptomProvider: Loading symptoms...');
    try {
      _symptoms = await _dbHelper.getAllSymptoms();
      notifyListeners(); // แจ้ง UI ให้แสดงข้อมูลที่โหลดมา
      print('SymptomProvider: Symptoms loaded (${_symptoms.length} items)');
    } catch (e) {
      print('Error loading symptoms: $e');
    }
  }

  // 2. Add Data: เมธอดสำหรับเพิ่ม Symptom ใหม่
  Future<void> addSymptom({
    required String diseaseName,
    required String symptoms,
    required String cause,
    required String treatment,
    int painLevel = 0,
    String emotionalIcon = '🙂',
  }) async {
    final newSymptom = Symptom(
      diseaseName: diseaseName,
      symptoms: symptoms,
      cause: cause,
      treatment: treatment,
      painLevel: painLevel,
      emotionalIcon: emotionalIcon,
    );

    // 1. บันทึกลงฐานข้อมูลและรับ ID กลับมา
    int id = await _dbHelper.insertSymptom(newSymptom);

    // 2. อัปเดต State ในหน่วยความจำด้วย ID ที่ได้รับ
    final symptomWithId = newSymptom.copyWith(id: id);
    _symptoms.insert(0, symptomWithId); 
    
    notifyListeners(); // 3. แจ้ง UI
    print('Symptom added with id $id');
  }

  // 3. Update Data: เมธอดสำหรับแก้ไข (ใช้ในหน้า Add/Edit Screen)
  Future<void> updateSymptom(Symptom updatedSymptom) async {
    if (updatedSymptom.id == null) return;
    
    // 1. อัปเดตในฐานข้อมูล
    int rowsAffected = await _dbHelper.updateSymptom(updatedSymptom);

    if (rowsAffected > 0) {
      // 2. อัปเดต State ในหน่วยความจำ
      final index = _symptoms.indexWhere((s) => s.id == updatedSymptom.id);
      if (index >= 0) {
        _symptoms[index] = updatedSymptom;
        notifyListeners(); // 3. แจ้ง UI
        print('Symptom id ${updatedSymptom.id} updated.');
      }
    }
  }

  // 4. Delete Data: เมธอดสำหรับลบ
  Future<void> deleteSymptom(int id) async {
    // 1. ลบออกจากฐานข้อมูล
    int rowsDeleted = await _dbHelper.deleteSymptom(id);

    if (rowsDeleted > 0) {
      // 2. ลบออกจาก State ในหน่วยความจำ
      _symptoms.removeWhere((symptom) => symptom.id == id);
      
      notifyListeners(); // 3. แจ้ง UI
      print('Symptom id $id deleted.');
    }
  }
}