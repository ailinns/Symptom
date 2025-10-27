// lib/screens/add_edit_symptom_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/symptom_provider.dart';
import '../models/symptom.dart'; 
import '../widgets/pain_level_selector.dart'; 

class AddEditSymptomScreen extends StatefulWidget {
  final Symptom? existingSymptom; 
  
  const AddEditSymptomScreen({super.key, this.existingSymptom});

  @override
  State<AddEditSymptomScreen> createState() => _AddEditSymptomScreenState();
}

class _AddEditSymptomScreenState extends State<AddEditSymptomScreen> {
  // Controllers
  final _diseaseNameController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _causeController = TextEditingController();
  final _treatmentController = TextEditingController();

  // State
  int _selectedPainLevel = 0;
  String _selectedEmotionalIcon = '🙂';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    // เติมข้อมูลเดิมเมื่อเป็นการแก้ไข
    if (widget.existingSymptom != null) {
      _diseaseNameController.text = widget.existingSymptom!.diseaseName;
      _symptomsController.text = widget.existingSymptom!.symptoms;
      _causeController.text = widget.existingSymptom!.cause;
      _treatmentController.text = widget.existingSymptom!.treatment;
      _selectedPainLevel = widget.existingSymptom!.painLevel;
      _selectedEmotionalIcon = widget.existingSymptom!.emotionalIcon;
    }
  }

  @override
  void dispose() {
    _diseaseNameController.dispose();
    _symptomsController.dispose();
    _causeController.dispose();
    _treatmentController.dispose();
    super.dispose();
  }

  void _saveSymptom() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final symptomProvider = context.read<SymptomProvider>();
    
    // ตรรกะ: Update vs Create
    if (widget.existingSymptom != null) {
      // === Update ===
      final updatedSymptom = widget.existingSymptom!.copyWith(
        diseaseName: _diseaseNameController.text.trim(),
        symptoms: _symptomsController.text.trim(),
        cause: _causeController.text.trim(),
        treatment: _treatmentController.text.trim(),
        painLevel: _selectedPainLevel,
        emotionalIcon: _selectedEmotionalIcon,
      );
      symptomProvider.updateSymptom(updatedSymptom);
    } else {
      // === Create ===
      symptomProvider.addSymptom(
        diseaseName: _diseaseNameController.text.trim(),
        symptoms: _symptomsController.text.trim(),
        cause: _causeController.text.trim(),
        treatment: _treatmentController.text.trim(),
        painLevel: _selectedPainLevel,
        emotionalIcon: _selectedEmotionalIcon,
      );
    }
    
    Navigator.of(context).pop();
  }

  // ปรับขนาดตัวอักษรและสีตัวอักษร
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 17.0, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        // กำหนดขนาดและสีของ Label Text
        labelStyle: const TextStyle(fontSize: 22.0, color: Colors.black), 
        hintStyle: const TextStyle(fontSize: 16.0, color: Colors.black54),
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาป้อน ${label.toLowerCase()}';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int initialPain = widget.existingSymptom?.painLevel ?? 0;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingSymptom != null ? 'แก้ไขข้อมูลอาการ/โรค' : 'เพิ่มข้อมูลอาการ/โรค'),
        // กำหนดสี AppBar เป็น Indigo (เพื่อให้เข้ากับปุ่มบันทึก)
        backgroundColor: Colors.indigo.shade500,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // 1-4. Text Fields
              _buildTextField(
                controller: _diseaseNameController, label: '1. ชื่อโรค', hint: 'เช่น ไข้หวัดใหญ่, ภูมิแพ้'),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _symptomsController, label: '2. อาการของโรค', hint: 'อธิบายอาการที่คุณเป็นโดยละเอียด', maxLines: 3),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _causeController, label: '3. สาเหตุของโรค', hint: 'สาเหตุที่ทราบ (ถ้ามี)'),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _treatmentController, label: '4. วิธีการรักษา', hint: 'วิธีการรักษาที่ใช้หรือแนะนำ'),
              const SizedBox(height: 25),
              
              // 5. หัวข้อระดับความเจ็บปวด (จัดวางให้ตรงกับ TextField)
              Container(
                alignment: Alignment.centerLeft, 
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child: const Text(
                  '5. ระดับความเจ็บปวด:', 
                  style: TextStyle(fontSize: 17.0, color: Colors.black), // ไม่เป็นตัวหนา
                ),
              ),
              
              // Pain Level Selector Widget
              PainLevelSelector(
                initialLevel: initialPain, 
                onLevelSelected: (level, icon) {
                  setState(() {
                    _selectedPainLevel = level;
                    _selectedEmotionalIcon = icon;
                  });
                },
              ),
              const SizedBox(height: 30),
              
              // ปุ่มบันทึก/แก้ไข
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveSymptom,
                  icon: Icon(widget.existingSymptom != null ? Icons.edit : Icons.save),
                  label: Text(widget.existingSymptom != null ? 'บันทึกการแก้ไข' : 'บันทึกข้อมูล'),
                  style: ElevatedButton.styleFrom(
                    // กำหนดสีปุ่มให้เป็น Indigo ตาม AppBar
                    backgroundColor: Colors.indigo.shade500, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}