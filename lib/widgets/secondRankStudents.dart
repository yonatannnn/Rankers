import 'package:flutter/material.dart';
import 'package:rankers/models/class.dart';
import 'package:rankers/models/student.dart'; 
import 'package:rankers/screens/StudentDetailScreen.dart';
import 'package:rankers/services/studentService.dart';
import 'package:rankers/widgets/singleStudent.dart'; 

class SecondRankStudentsList extends StatelessWidget {
  final bool showButton;
  const SecondRankStudentsList(this.showButton , {super.key});

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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<StudentModel> students = snapshot.data ?? [];
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              int id;
              switch (student.grade) {
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
              if (student.rank != null && student.rank == 2) {
                return Student(
                  id: id,
                  name: student.name,
                  grade: student.grade,
                  school: student.school,
                  average: student.average,
                  rank: student.rank,
                  matricResult: student.matricResult,
                  phoneNumber: student.phoneNumber,
                  showButtons: showButton,
                  onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentDetailScreen(student: student),
                    ),
                  );
                },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
