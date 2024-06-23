import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rankers/widgets/Drawer.dart';
import 'package:rankers/widgets/EditStudentWidgets/Edit1-12Student.dart';
import 'package:rankers/widgets/EditStudentWidgets/EditGrade6-10-12Students.dart';
import 'package:rankers/widgets/EditStudentWidgets/EditGraduateStudent.dart';
import 'package:rankers/widgets/addStudentWidgets/Add1-12%20student.dart';
import 'package:rankers/widgets/addStudentWidgets/AddGraduateeStudent.dart';
import 'package:rankers/widgets/addStudentWidgets/addGrade61-0-12-Students.dart';
import 'package:rankers/widgets/gradeSeparatorButton.dart';
import 'package:rankers/widgets/singleStudent.dart';

class EditScreen extends StatefulWidget {
  final documentId;
  final String name;
  final int grade;
  final String school;
  final int rank;
  final double average;
  final int phoneNumber;
  final double matricResult;
  final String university;
  final String department;
  final double cgpa;

  const EditScreen({
    required this.university,
    required this.department,
    required this.cgpa,
    required this.matricResult,
    required this.documentId,
    required this.name,
    required this.grade,
    required this.school,
    required this.rank,
    required this.average,
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  int? chooseForm;

  @override
  void initState() {
    super.initState();
    if (widget.grade == 6 || widget.grade == 10 || widget.grade == 12) {
      chooseForm = 2;
    } else if (widget.grade == -1) {
      chooseForm = 3;
    } else {
      chooseForm = 1;
    }
  }

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.0),
                    child: chooseForm == 1
                        ? EditStudent(
                            documentId: widget.documentId,
                            name: widget.name,
                            grade: widget.grade,
                            school: widget.school,
                            rank: widget.rank,
                            average: widget.average,
                            phoneNumber: widget.phoneNumber)
                        : chooseForm == 2
                            ? EditMatricStudent(
                                documentId: widget.documentId,
                                name: widget.name,
                                grade: widget.grade,
                                school: widget.school,
                                matricResult: widget.matricResult,
                                phoneNumber: widget.phoneNumber,
                              )
                            : chooseForm == 3
                                ? EditGraduateStudent(
                                    documentId: widget.documentId,
                                    name: widget.name,
                                    university: widget.university,
                                    department: widget.department,
                                    cgpa: widget.cgpa,
                                    phoneNumber: widget.phoneNumber)
                                : Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
