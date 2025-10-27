// lib/models/symptom.dart

class Symptom {
  final int? id;
  final String diseaseName; // 1. ชื่อโรค
  final String symptoms;    // 2. อาการของโรค (คำอธิบาย)
  final String cause;       // 3. สาเหตุของโรค
  final String treatment;   // 4. วิธีการรักษา
  final int painLevel;     // 5. ระดับความเจ็บปวด (0-10)
  final String emotionalIcon; // อีโมจิ/ไอคอน

  Symptom({
    this.id,
    required this.diseaseName,
    required this.symptoms,
    required this.cause,
    required this.treatment,
    this.painLevel = 0,
    this.emotionalIcon = '🙂', 
  });

  Symptom copyWith({
    int? id,
    String? diseaseName,
    String? symptoms,
    String? cause,
    String? treatment,
    int? painLevel,
    String? emotionalIcon,
  }) {
    return Symptom(
      id: id ?? this.id,
      diseaseName: diseaseName ?? this.diseaseName,
      symptoms: symptoms ?? this.symptoms,
      cause: cause ?? this.cause,
      treatment: treatment ?? this.treatment,
      painLevel: painLevel ?? this.painLevel,
      emotionalIcon: emotionalIcon ?? this.emotionalIcon,
    );
  }

  // แปลง Symptom object เป็น Map สำหรับบันทึกลง SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'diseaseName': diseaseName,
      'symptoms': symptoms,
      'cause': cause,
      'treatment': treatment,
      'painLevel': painLevel,
      'emotionalIcon': emotionalIcon,
    };
  }

  // แปลง Map ที่ได้จาก SQLite กลับเป็น Symptom object
  factory Symptom.fromMap(Map<String, dynamic> map) {
    return Symptom(
      id: map['id'] as int?,
      diseaseName: map['diseaseName'] as String,
      symptoms: map['symptoms'] as String,
      cause: map['cause'] as String,
      treatment: map['treatment'] as String,
      painLevel: map['painLevel'] as int,
      emotionalIcon: map['emotionalIcon'] as String,
    );
  }

  @override
  String toString() {
    return 'Symptom{id: $id, diseaseName: $diseaseName, pain: $painLevel}';
  }
}