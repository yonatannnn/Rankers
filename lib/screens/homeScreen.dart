import 'package:flutter/material.dart';
import 'package:rankers/services/authService.dart';
import 'package:rankers/utils/text.dart';
import 'package:rankers/widgets/gradeSeparatorButton.dart';
import 'package:rankers/widgets/singleStudent.dart';

import '../models/student.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<StudentModel> students = [
    StudentModel.grade10(
        name: 'Elias', grade: 10, school: 'Ebenezer', matricResult: 3.5),
    StudentModel.grade10(
        name: 'Elias', grade: 10, school: 'Ebenezer', matricResult: 3.5),
    StudentModel.grade10(
        name: 'Elias', grade: 10, school: 'Ebenezer', matricResult: 3.5),
    StudentModel.grade10(
        name: 'Elias', grade: 10, school: 'Ebenezer', matricResult: 3.5),
    StudentModel.grade12(
        name: 'Jo', grade: 12, school: 'Mission', matricResult: 610),
    StudentModel.grade6(
        name: 'Six', grade: 6, school: 'Beza', matricResult: 99.9),
    StudentModel.otherGrades(
        name: 'Other Grade',
        grade: 9,
        school: 'Ebenezer',
        average: 90.0,
        rank: 1),
  ];

  void logout() {
    final as = AuthService();
    try {
      as.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: () => logout(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/books2.jpg'),
            fit: BoxFit.cover,
          ),
          color: Colors.black.withOpacity(0.8),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GradeSeparatorButton(
                      toBeWritten: '1 - 12',
                      opacity: 0.5,
                      grade: 12,
                      onPressed: () {
                        print('Grade 10 button pressed');
                      },
                    ),
                    SizedBox(width: 10), // Separator
                    GradeSeparatorButton(
                      toBeWritten: '6',
                      opacity: 0.5,
                      grade: 12,
                      onPressed: () {
                        print('Grade 10 button pressed');
                      },
                    ),
                    SizedBox(width: 10), // Separator
                    GradeSeparatorButton(
                      toBeWritten: '10',
                      opacity: 0.5,
                      grade: 12,
                      onPressed: () {
                        print('Grade 10 button pressed');
                      },
                    ),
                    SizedBox(width: 10), // Separator
                    GradeSeparatorButton(
                      toBeWritten: '12',
                      opacity: 0.5,
                      grade: 12,
                      onPressed: () {
                        print('Grade 10 button pressed');
                      },
                    ),
                    SizedBox(width: 10), // Separator
                    GradeSeparatorButton(
                      toBeWritten: 'Graduate',
                      opacity: 0.5,
                      grade: 12,
                      onPressed: () {
                        print('Grade 10 button pressed');
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Student(
                    id: student.grade == 10
                        ? 10
                        : student.grade == 12
                            ? 12
                            : student.grade == 6
                                ? 6
                                : 0,
                    name: student.name,
                    grade: student.grade,
                    school: student.school,
                    average: student.average,
                    rank: student.rank,
                    matricResult: student.matricResult,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
