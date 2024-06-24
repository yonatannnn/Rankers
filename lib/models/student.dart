import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel implements Comparable<StudentModel> {
  final String name;
  final int grade;
  final String school;
  final double? average;
  final int? rank;
  final double? matricResult;
  final int phoneNumber;
  final double? cgpa;
  final String? university;
  final String? department;

  StudentModel.grade10({
    required this.name,
    required this.grade,
    required this.school,
    required this.matricResult,
    required this.phoneNumber,
  })  : average = null,
        rank = null,
        cgpa = null,
        university = null,
        department = null;

  StudentModel.grade12({
    required this.name,
    required this.grade,
    required this.school,
    required this.matricResult,
    required this.phoneNumber,
  })  : average = null,
        rank = null,
        cgpa = null,
        university = null,
        department = null;

  StudentModel.grade6({
    required this.name,
    required this.grade,
    required this.school,
    required this.matricResult,
    required this.phoneNumber,
  })  : average = null,
        rank = null,
        cgpa = null,
        university = null,
        department = null;

  StudentModel.otherGrades({
    required this.name,
    required this.grade,
    required this.school,
    required this.average,
    required this.rank,
    required this.phoneNumber,
  })  : matricResult = null,
        cgpa = null,
        university = null,
        department = null;

  StudentModel.graduate({
    required this.name,
    required this.university,
    required this.department,
    required this.cgpa,
    required this.phoneNumber,
  })  : grade = -1,
        school = '',
        average = null,
        rank = null,
        matricResult = null;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grade': grade,
      'school': school,
      'phoneNumber': phoneNumber,
      if (average != null) 'average': average,
      if (rank != null) 'rank': rank,
      if (matricResult != null) 'matricResult': matricResult,
      if (cgpa != null) 'cgpa': cgpa,
      if (university != null) 'university': university,
      if (department != null) 'department': department,
    };
  }

  @override
  int compareTo(StudentModel other) {
    return name.compareTo(other.name);
  }

  static StudentModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    if (data['grade'] == -1) {
      return StudentModel.graduate(
        name: data['name'],
        university: data['university'],
        department: data['department'],
        cgpa: data['cgpa'],
        phoneNumber: data['phoneNumber'],
      );
    } else if (data['grade'] == 6) {
      return StudentModel.grade6(
        name: data['name'],
        grade: data['grade'],
        school: data['school'],
        matricResult: data['matricResult'],
        phoneNumber: data['phoneNumber'],
      );
    } else if (data['grade'] == 12) {
      return StudentModel.grade12(
        name: data['name'],
        grade: data['grade'],
        school: data['school'],
        matricResult: data['matricResult'],
        phoneNumber: data['phoneNumber'],
      );
    } else if (data['grade'] == 8) {
      return StudentModel.grade6(
        name: data['name'],
        grade: data['grade'],
        school: data['school'],
        matricResult: data['matricResult'],
        phoneNumber: data['phoneNumber'],
      );
    } else {
      return StudentModel.otherGrades(
        name: data['name'],
        grade: data['grade'],
        school: data['school'],
        average: data['average'],
        rank: data['rank'],
        phoneNumber: data['phoneNumber'],
      );
    }
  }
}
