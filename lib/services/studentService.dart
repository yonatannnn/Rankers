import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Studentservice extends ChangeNotifier {
  final FirebaseFirestore _firebaseFiresore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getStudents() {
    return _firebaseFiresore.collection("students").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }
}
