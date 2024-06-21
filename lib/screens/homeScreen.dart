import 'package:flutter/material.dart';
import 'package:rankers/models/class.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/widgets/Drawer.dart';
import 'package:rankers/widgets/gradeSeparatorButton.dart';
import 'package:rankers/widgets/singleStudent.dart';
import 'package:rankers/services/studentService.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final Studentservice _studentService = Studentservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(),
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
                        print('Grade 12 button pressed');
                      },
                    ),
                    SizedBox(width: 10), // Separator
                    GradeSeparatorButton(
                      toBeWritten: '6',
                      opacity: 0.5,
                      grade: 12,
                      onPressed: () {
                        print('Grade 6 button pressed');
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
                        print('Grade 12 button pressed');
                      },
                    ),
                    SizedBox(width: 10), // Separator
                    GradeSeparatorButton(
                      toBeWritten: 'Graduate',
                      opacity: 0.5,
                      grade: 12,
                      onPressed: () {
                        print('Graduate button pressed');
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<StudentModel>>(
                stream: _studentService.getStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
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
                    },
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
