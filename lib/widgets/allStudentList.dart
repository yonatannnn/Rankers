import 'package:flutter/material.dart';
import 'package:rankers/models/class.dart';
import 'package:rankers/models/documentId.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/screens/StudentDetailScreen.dart';
import 'package:rankers/services/studentService.dart';
import 'package:rankers/widgets/singleStudent.dart';
import '../screens/StudentEditScreen.dart';
import '../services/authService.dart';

class Allstudentlist extends StatelessWidget {
  final bool showButton;

  Allstudentlist(this.showButton, {super.key});

  final StudentIdMap _studentIdMap = StudentIdMap();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final StudentService _studentService = StudentService();

    return Expanded(
      child: StreamBuilder<List<StudentModel>>(
        stream: _studentService.getStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<StudentModel> students = snapshot.data ?? [];
          int compareStudents(StudentModel a, StudentModel b) {
            return a.name.compareTo(b.name);
          }

          students.sort(compareStudents);

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              int id;

              switch (student.grade) {
                case 10:
                  id = Grade.grade10;
                  break;
                case 12:
                  id = Grade.grade12;
                  break;
                case 6:
                  id = Grade.grade6;
                  break;
                case 8:
                  id = Grade.grade6;
                  break;
                case -1:
                  id = 13;
                  break;
                default:
                  id = Grade.defaultId;
              }

              return Student(
                id: id,
                name: student.name,
                grade: student.grade,
                school: student.school,
                average: student.average,
                rank: student.rank,
                matricResult: student.matricResult,
                phoneNumber: student.phoneNumber,
                university: student.university,
                department: student.department,
                CGPA: student.cgpa,
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentDetailScreen(student: student),
                    ),
                  );
                },
                showButtons: showButton,
                onEdit: () {
                  String? documentId =
                      _studentIdMap.getDocumentIdByName(student.name);
                  int rank = student.rank ?? 0;
                  double average = student.average ?? 0;
                  double matricResult = student.matricResult ?? 0;
                  String university = student.university ?? '';
                  String department = student.department ?? '';
                  double cgpa = student.cgpa ?? 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        university: university,
                        department: department,
                        cgpa: cgpa,
                        matricResult: matricResult,
                        documentId: documentId,
                        name: student.name,
                        grade: student.grade,
                        school: student.school,
                        rank: rank,
                        average: average,
                        phoneNumber: student.phoneNumber,
                      ),
                    ),
                  );
                },
                onDelete: () async {
                  bool canEdit = await _authService.canPerformEdit();

                  if (canEdit) {
                    bool confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Delete"),
                          content: Text(
                              "Are you sure you want to delete this student?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Text("Delete"),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm) {
                      String? studentName = student.name;

                      if (studentName != null) {
                        try {
                          String? documentId =
                              _studentIdMap.getDocumentIdByName(studentName);

                          if (documentId != null) {
                            await _studentService.deleteStudent(documentId);
                            print('Student deleted successfully!');
                          } else {
                            print(
                                'Document ID not found for student: $studentName');
                          }
                        } catch (error) {
                          print('Error deleting student: $error');
                        }
                      } else {
                        print('Student name is null');
                      }
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Unauthorized"),
                          content: Text(
                              "You are not authorized to delete students."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
