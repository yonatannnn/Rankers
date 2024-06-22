import 'package:flutter/material.dart';
import 'package:rankers/models/class.dart'; // Ensure this contains Grade class definition
import 'package:rankers/models/student.dart'; // Ensure this contains StudentModel class definition
import 'package:rankers/services/studentService.dart'; // Ensure this contains StudentService class definition
import 'package:rankers/widgets/singleStudent.dart'; // Ensure this contains Student widget definition

class FirstRankStudentsList extends StatelessWidget {
  const FirstRankStudentsList({super.key});

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
                case 10:
                  id = Grade.grade10;
                  break;
                case 12:
                  id = Grade.grade12;
                  break;
                case 6:
                  id = Grade.grade6;
                  break;
                default:
                  id = Grade.defaultId;
              }
              if (student.rank != null && student.rank == 1) {
                return Student(
                  id: id,
                  name: student.name,
                  grade: student.grade,
                  school: student.school,
                  average: student.average,
                  rank: student.rank,
                  matricResult: student.matricResult,
                  phoneNumber: student.phoneNumber,
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