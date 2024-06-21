import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/widgets/singleStudent.dart';
import 'package:firebase_database/firebase_database.dart';

class Studentservice extends ChangeNotifier {
  final FirebaseFirestore _firebaseFiresore = FirebaseFirestore.instance;
  Stream<List<Map<String, dynamic>>> getStudents() {
    print('inside getStudent');
    return _firebaseFiresore.collection("student").snapshots().map((snapshot) {
      print(snapshot);
      return snapshot.docs.map((doc) {
        final user = doc.data();
        print('userrrrr ${user}');
        return user;
      }).toList();
    });
  }

  Future<void> saveStudentToFirestore(StudentModel student) async {
    CollectionReference collection = _firebaseFiresore.collection('student');
    try {
      await collection.add(student.toMap());
      print('Data saved successfully!');
    } catch (error) {
      print('Error saving data: $error');
    }
  }
}
