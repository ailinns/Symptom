// lib/screens/symptom_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/symptom_provider.dart';
import '../models/symptom.dart'; // ต้องนำเข้า Symptom Model
import 'add_edit_symptom_screen.dart'; 

class SymptomListScreen extends StatelessWidget {
  const SymptomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ใช้สี Teal จาก Theme ที่กำหนดใน main.dart
        title: const Text(
          'รายการโรค / อาการ',
          style: TextStyle(fontWeight: FontWeight.bold), 
        ),
        centerTitle: true,
      ),
      
      body: Consumer<SymptomProvider>(
        builder: (context, symptomProvider, child) {
          final symptoms = symptomProvider.symptoms;
          
          if (symptoms.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีข้อมูลโรค/อาการ แตะ + เพื่อเพิ่ม',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          
          return ListView.builder(
            itemCount: symptoms.length,
            itemBuilder: (context, index) {
              final symptom = symptoms[index];
              
              // 1. ฟังก์ชันกำหนดสีตามระดับความเจ็บปวด (เพื่อ UX)
              Color painIndicatorColor;
              if (symptom.painLevel >= 8) {
                  painIndicatorColor = Colors.red.shade700; // รุนแรงมาก
              } else if (symptom.painLevel >= 5) {
                  painIndicatorColor = Colors.orange.shade700; // ปานกลาง
              } else if (symptom.painLevel > 0) {
                  painIndicatorColor = Colors.amber.shade500; // เล็กน้อย
              } else {
                  painIndicatorColor = Colors.green.shade400; // ไม่ปวดเลย
              }
              
              return Card(
                // ใช้การจัดรูปแบบ CardTheme จาก main.dart
                child: ListTile(
                  // 2. ฟังก์ชันแก้ไข (Edit) เมื่อแตะที่รายการ
                  isThreeLine: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => AddEditSymptomScreen(existingSymptom: symptom),
                      ),
                    );
                  },
                  
                  // 3. Leading CircleAvatar เพื่อแสดงอีโมจิ (UX)
                  leading: CircleAvatar(
                    backgroundColor: painIndicatorColor.withOpacity(0.1),
                    radius: 24,
                    child: Text(
                      symptom.emotionalIcon, 
                      style: TextStyle(fontSize: 20, color: painIndicatorColor),
                    ),
                  ),

                  // 4. TITLE: ชื่อโรค
                  title: Text(
                    symptom.diseaseName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  
                  // 5. SUBTITLE: อาการ
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // อาการของโรค
                      Text(
                        'อาการ: ${symptom.symptoms}',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      // สาเหตุของโรค
                      Text(
                        'สาเหตุ: ${symptom.cause}',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      // วิธีการรักษา
                      Text(
                        'รักษา: ${symptom.treatment}',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                  
                  // 6. ปุ่มลบ (Delete) พร้อม Confirmation Dialog
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async { // ทำให้ onPressed เป็น async
                      
                      // แสดง Confirmation Dialog (ตามหลักการ UX Polishing)
                      final confirmed = await showDialog<bool>(
                        context: context, 
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('ยืนยันการลบ'),
                            content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลโรค/อาการ "${symptom.diseaseName}"?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('ยกเลิก'),
                                onPressed: () => Navigator.of(dialogContext).pop(false),
                              ),
                              TextButton(
                                child: const Text('ลบ', style: TextStyle(color: Colors.red)),
                                onPressed: () => Navigator.of(dialogContext).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      // ดำเนินการลบจริง ถ้าได้รับการยืนยัน
                      if (confirmed == true && symptom.id != null) {
                        context.read<SymptomProvider>().deleteSymptom(symptom.id!);
                        
                        // แสดง SnackBar
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('ลบ "${symptom.diseaseName}" สำเร็จ'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // นำทางไปยังหน้าเพิ่มใหม่
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const AddEditSymptomScreen()),
          );
        },
      ),
    );
  }
}