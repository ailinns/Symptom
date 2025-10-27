// lib/widgets/pain_level_selector.dart
import 'package:flutter/material.dart';

// ฟังก์ชันช่วยเหลือในการจับคู่ระดับความเจ็บปวดกับอีโมจิ
String getEmotionalIcon(int level) {
  if (level == 0) {
    return '😁'; // 0: No pain / ไม่ปวดเลย
  } else if (level <= 2) {
    return '😊'; // 1-2: Minimal pain / ปวดน้อยมาก
  } else if (level <= 4) {
    return '😐'; // 3-4: Mild pain / ปวดเล็กน้อย (Moderate pain เริ่มที่ 5)
  } else if (level <= 6) {
    return '😔'; // 5-6: Moderate pain / ปวดปานกลาง (Sad face)
  } else if (level <= 8) {
    return '😟'; // 7-8: Severe pain / ปวดรุนแรง (Very sad/Worried face)
  } else {
    return '😭'; // 9-10: Worst possible pain / ปวดมากที่สุด (Crying face)
  }
}

class PainLevelSelector extends StatefulWidget {
  // Callback เพื่อส่งค่าที่เลือกกลับไปที่หน้าจอหลัก
  final Function(int level, String icon) onLevelSelected;
  final int initialLevel;

  const PainLevelSelector({
    super.key,
    required this.onLevelSelected,
    this.initialLevel = 0,
  });

  @override
  State<PainLevelSelector> createState() => _PainLevelSelectorState();
}

class _PainLevelSelectorState extends State<PainLevelSelector> {
  late int _currentLevel;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.initialLevel;
    
    // *** การแก้ไขที่จำเป็น: เลื่อนการเรียก callback ออกไป ***
    // การเรียก widget.onLevelSelected() โดยตรงใน initState ทำให้เกิด setState() during build
    // เราใช้ addPostFrameCallback เพื่อเรียกฟังก์ชันนี้หลังจากเฟรมแรกเสร็จสมบูรณ์
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLevelSelected(_currentLevel, getEmotionalIcon(_currentLevel));
    });
  }

  void _selectLevel(int level) {
    setState(() {
      _currentLevel = level;
    });
    // ส่งค่าใหม่กลับไปให้หน้าจอที่เรียกใช้
    widget.onLevelSelected(level, getEmotionalIcon(level));
  }

  @override
  Widget build(BuildContext context) {
    // ใช้ Slider เพื่อให้ผู้ใช้เลือกได้ 0 ถึง 10
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         // แสดงอีโมจิปัจจุบันและระดับ
        Center(
          child: Text(
            getEmotionalIcon(_currentLevel),
            style: const TextStyle(fontSize: 40),
          ),
        ),
        Slider(
          value: _currentLevel.toDouble(),
          min: 0,
          max: 10,
          divisions: 5,
          label: 'ระดับ ${_currentLevel}',
          onChanged: (double value) {
            _selectLevel(value.round());
          },
        ),
        Center(
           child: Text(
            'ระดับ: ${_currentLevel} (${getEmotionalIcon(_currentLevel)})',
            style: const TextStyle(fontSize: 17, color: Color.fromARGB(255, 51, 49, 49)),
          ),
        ),
      ],
    );
  }
}