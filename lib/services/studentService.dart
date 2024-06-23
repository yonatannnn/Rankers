import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankers/models/documentId.dart';
import 'package:rankers/models/student.dart';
import 'package:open_file/open_file.dart';

class StudentService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final StudentIdMap _studentIdMap = StudentIdMap();

  Stream<List<StudentModel>> getStudents() {
    return _firebaseFirestore.collection("student").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          _studentIdMap.updateMap(doc['name'], doc.id);
          return StudentModel.fromFirestore(doc);
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

  Future<void> editStudentInFirestore(
      String documentId, StudentModel student) async {
    DocumentReference docRef =
        _firebaseFirestore.collection('student').doc(documentId);
    try {
      await docRef.update(student.toMap());
      print('Student updated successfully!');
    } catch (error) {
      print('Error updating student: $error');
    }
  }

  Future<void> deleteStudent(String documentId) async {
    try {
      await _firebaseFirestore.collection('student').doc(documentId).delete();
      print('Student deleted successfully!');
    } catch (error) {
      print('Error deleting student: $error');
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final students = await _firebaseFirestore.collection('student').get();
    final studentList =
        students.docs.map((doc) => StudentModel.fromFirestore(doc)).toList();

    final List<StudentModel> first = [];
    final List<StudentModel> grade6 = [];
    final List<StudentModel> grade8 = [];
    final List<StudentModel> grade10 = [];
    final List<StudentModel> grade12 = [];
    final List<StudentModel> graduate = [];

    for (StudentModel stud in studentList) {
      if (stud.grade != -1 &&
          stud.grade != 6 &&
          stud.grade != 8 &&
          stud.grade != 10 &&
          stud.grade != 12) {
        first.add(stud);
      } else if (stud.grade == 6) {
        grade6.add(stud);
      } else if (stud.grade == 8) {
        grade8.add(stud);
      } else if (stud.grade == 10) {
        grade10.add(stud);
      } else if (stud.grade == 12) {
        grade12.add(stud);
      } else {
        graduate.add(stud);
      }
    }
    first.sort((a, b) => (a.rank ?? 0).compareTo(b.rank ?? 0));
    graduate.sort((b, a) => (a.cgpa ?? 0).compareTo(b.cgpa ?? 0));
    grade6.sort((a, b) => (a.matricResult ?? 0).compareTo(b.matricResult ?? 0));
    grade8.sort((a, b) => (a.matricResult ?? 0).compareTo(b.matricResult ?? 0));
    grade10
        .sort((a, b) => (a.matricResult ?? 0).compareTo(b.matricResult ?? 0));
    grade12
        .sort((a, b) => (a.matricResult ?? 0).compareTo(b.matricResult ?? 0));

    List<String> _getTableHeaders(String header) {
      switch (header) {
        case 'First Category':
          return ['Name', 'Grade', 'School', 'Rank', 'Average', 'PhoneNumber'];
        case 'Grade 10':
        case 'Grade 12':
          return ['Name', 'School', 'Grade', 'Matric Result', 'PhoneNumber'];
        case 'Grade 6':
        case 'Grade 8':
          return ['Name', 'School', 'Grade', 'Ministry Result', 'PhoneNumber'];
        case 'Graduate':
          return ['Name', 'University', 'Department', 'CGPA', 'PhoneNumber'];
        default:
          return [];
      }
    }

    List<List<dynamic>> _getTableData(
        List<StudentModel> students, String header) {
      return students.map((student) {
        switch (header) {
          case 'First Category':
            return [
              student.name,
              student.grade != -1 ? student.grade : '',
              student.school,
              student.rank ?? '',
              student.average ?? '',
              student.phoneNumber,
            ];
          case 'Grade 6':
          case 'Grade 8':
          case 'Grade 10':
          case 'Grade 12':
            return [
              student.name,
              student.school,
              student.grade,
              student.matricResult ?? '',
              student.phoneNumber,
            ];
          case 'Graduate':
            return [
              student.name,
              student.university ?? '',
              student.department ?? '',
              student.cgpa ?? '',
              student.phoneNumber,
            ];
          default:
            return [];
        }
      }).toList();
    }

    void addSection(
        pw.Document pdf, List<StudentModel> students, String header) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(header,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Divider(thickness: 1, height: 20),
                pw.Table.fromTextArray(
                  border: pw.TableBorder.all(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headers: _getTableHeaders(header),
                  data: _getTableData(students, header),
                ),
              ],
            );
          },
        ),
      );
    }

    addSection(pdf, first, 'First Category');
    addSection(pdf, grade6, 'Grade 6');
    addSection(pdf, grade8, 'Grade 8');
    addSection(pdf, grade10, 'Grade 10');
    addSection(pdf, grade12, 'Grade 12');
    addSection(pdf, graduate, 'Graduate');

    try {
      final externalDir = await getExternalStorageDirectory();
      final path = '${externalDir?.path}/student_list.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
      print('PDF saved successfully at ${file.path}');
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error saving or opening PDF: $e');
    }
  }
}
