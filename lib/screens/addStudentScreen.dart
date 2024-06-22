import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rankers/widgets/Drawer.dart';
import 'package:rankers/widgets/addStudentWidgets/Add1-12%20student.dart';
import 'package:rankers/widgets/addStudentWidgets/AddGraduateeStudent.dart';
import 'package:rankers/widgets/addStudentWidgets/addGrade61-0-12-Students.dart';
import 'package:rankers/widgets/gradeSeparatorButton.dart';
import 'package:rankers/widgets/singleStudent.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  int? chooseForm;

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
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GradeSeparatorButton(
                        toBeWritten: '1-12',
                        opacity: 0.5,
                        rank: 14,
                        onPressed: () {
                          setState(() {
                            chooseForm = 1;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '6',
                        opacity: 0.5,
                        rank: 6,
                        onPressed: () {
                          setState(() {
                            chooseForm = 2;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '10',
                        opacity: 0.5,
                        rank: 10,
                        onPressed: () {
                          setState(() {
                            chooseForm = 2;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '12',
                        opacity: 0.5,
                        rank: 12,
                        onPressed: () {
                          setState(() {
                            chooseForm = 2;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: 'Graduate',
                        opacity: 0.5,
                        rank: -1,
                        onPressed: () {
                          setState(() {
                            chooseForm = 3;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: chooseForm == 1
                      ? AddStudent()
                      : chooseForm == 2
                          ? AddGrade6_10_12Student()
                          : chooseForm == 3
                              ? AddGraduateStudent()
                              : Container(), // Fallback if chooseForm is null
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
