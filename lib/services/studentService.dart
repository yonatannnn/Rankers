import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rankers/models/student.dart';

class StudentService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<StudentModel>> getStudents() {
    return _firebaseFirestore.collection("student").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          if (doc['grade'] == -1) {
            return StudentModel.graduate(
              name: doc['name'],
              university: doc['university'],
              department: doc['department'],
              cgpa: doc['cgpa'],
              phoneNumber: doc['phoneNumber'],
            );
          } else if (doc['grade'] == 6) {
            return StudentModel.grade6(
              name: doc['name'],
              grade: doc['grade'],
              school: doc['school'],
              matricResult: doc['matricResult'],
              phoneNumber: doc['phoneNumber'],
            );
          } else if (doc['grade'] == 10) {
            return StudentModel.grade10(
              name: doc['name'],
              grade: doc['grade'],
              school: doc['school'],
              matricResult: doc['matricResult'],
              phoneNumber: doc['phoneNumber'],
            );
          } else if (doc['grade'] == 12) {
            return StudentModel.grade12(
              name: doc['name'],
              grade: doc['grade'],
              school: doc['school'],
              matricResult: doc['matricResult'],
              phoneNumber: doc['phoneNumber'],
            );
          } else {
            return StudentModel.otherGrades(
              name: doc['name'],
              grade: doc['grade'],
              school: doc['school'],
              average: doc['average'],
              rank: doc['rank'],
              phoneNumber: doc['phoneNumber'],
            );
          }
        } else {
          throw Exception('Document does not exist');
        }
      }).toList();
    });
  }

  Future<void> saveStudentToFirestore(StudentModel student) async {
    CollectionReference collection = _firebaseFirestore.collection('student');
    try {
      await collection.add(student.toMap());
      print('Data saved successfully!');
    } catch (error) {
      print('Error saving data: $error');
    }
  }
}
