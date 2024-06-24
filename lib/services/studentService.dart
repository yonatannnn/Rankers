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
    grade6.sort((b, a) => (a.matricResult ?? 0).compareTo(b.matricResult ?? 0));
    grade8.sort((b, a) => (a.matricResult ?? 0).compareTo(b.matricResult ?? 0));
    grade10
        .sort((b, a) => (a.matricResult ?? 0).compareTo(b.matricResult ?? 0));
    grade12
        .sort((b, a) => (a.matricResult ?? 0).compareTo(b.matricResult ?? 0));

    final firstW = [];
    final graduateW = [];
    final grade6W = [];
    final grade8W = [];
    final grade10W = [];
    final grade12W = [];

    int counter = 1;
    for (StudentModel stud in first) {
      firstW.add([counter, stud]);
      counter++;
    }

    int counter2 = 1;
    for (StudentModel stud in graduate) {
      graduateW.add([counter2, stud]);
      counter2++;
    }

    int counter3 = 1;
    for (StudentModel stud in grade6) {
      grade6W.add([counter3, stud]);
      counter3++;
    }

    int counter4 = 1;
    for (StudentModel stud in grade8) {
      grade8W.add([counter4, stud]);
      counter4++;
    }

    int counter5 = 1;
    for (StudentModel stud in grade10) {
      grade10W.add([counter5, stud]);
      counter5++;
    }

    int counter6 = 1;
    for (StudentModel stud in grade12) {
      grade12W.add([counter6, stud]);
      counter6++;
    }

    List<String> _getTableHeaders(String header) {
      switch (header) {
        case 'First Category':
          return [
            'R_No',
            'Name',
            'Grade',
            'School',
            'Rank',
            'Average',
            'PhoneNumber'
          ];
        case 'Grade 12':
          return [
            'R_No',
            'Name',
            'School',
            'Grade',
            'Matric Result',
            'PhoneNumber'
          ];
        case 'Grade 6':
        case 'Grade 8':
          return [
            'R_No',
            'Name',
            'School',
            'Grade',
            'Ministry Result',
            'PhoneNumber'
          ];
        case 'Graduates':
          return [
            'R_No',
            'Name',
            'University',
            'Department',
            'CGPA',
            'PhoneNumber'
          ];
        default:
          return [];
      }
    }

    List<List<dynamic>> _getTableData(List<dynamic> students, String header) {
      return students.map((entry) {
        int rollNumber = entry[0];
        StudentModel student = entry[1];
        switch (header) {
          case 'First Category':
            return [
              rollNumber,
              student.name,
              student.grade != -1 ? student.grade : '',
              student.school,
              student.rank ?? '',
              student.average ?? '',
              student.phoneNumber,
            ];
          case 'Grade 6':
            return [
              rollNumber,
              student.name,
              student.school,
              student.grade,
              student.matricResult ?? '',
              student.phoneNumber,
            ];
          case 'Grade 8':
            return [
              rollNumber,
              student.name,
              student.school,
              student.grade,
              student.matricResult ?? '',
              student.phoneNumber,
            ];
          case 'Grade 12':
            int result = (student.matricResult as double?)?.toInt() ?? 0;

            return [
              rollNumber,
              student.name,
              student.school,
              student.grade,
              result ?? '',
              student.phoneNumber,
            ];
          case 'Graduates':
            return [
              rollNumber,
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

    void addSection(pw.Document pdf, List<dynamic> students, String header) {
      const int maxRowsPerPage = 20;
      final totalRows = students.length;
      for (int start = 0; start < totalRows; start += maxRowsPerPage) {
        final end = (start + maxRowsPerPage > totalRows)
            ? totalRows
            : start + maxRowsPerPage;
        final rows = students.sublist(start, end);
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (start == 0)
                    pw.Text(header,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  if (start == 0) pw.Divider(thickness: 1, height: 20),
                  pw.Table.fromTextArray(
                    border: pw.TableBorder.all(),
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    headers: _getTableHeaders(header),
                    data: _getTableData(rows, header),
                  ),
                ],
              );
            },
          ),
        );
      }
    }

    addSection(pdf, firstW, 'First Category');
    addSection(pdf, grade6W, 'Grade 6');
    addSection(pdf, grade8W, 'Grade 8');
    addSection(pdf, grade12W, 'Grade 12');
    addSection(pdf, graduateW, 'Graduates');
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
