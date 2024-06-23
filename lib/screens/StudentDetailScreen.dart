import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rankers/widgets/Drawer.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/widgets/TextWidget.dart';

class StudentDetailScreen extends StatefulWidget {
  final StudentModel student; 

  const StudentDetailScreen({Key? key, required this.student})
      : super(key: key);

  @override
  State<StudentDetailScreen> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/books2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DisplayInfo(k: 'Name', value: widget.student.name),
                  if (widget.student.school.isNotEmpty)
                    DisplayInfo(k: 'School', value: widget.student.school),
                  if (widget.student.grade != -1)
                    DisplayInfo(k: 'Grade', value: widget.student.grade),
                  if (widget.student.average != null)
                    DisplayInfo(k: 'Average', value: widget.student.average),
                  if (widget.student.rank != null)
                    DisplayInfo(k: 'Rank', value: widget.student.rank),
                  if (widget.student.matricResult != null)
                    DisplayInfo(
                        k: 'Matric Result', value: widget.student.matricResult),
                  DisplayInfo(
                      k: 'Phone Number', value: widget.student.phoneNumber),
                  if (widget.student.cgpa != null)
                    DisplayInfo(k: 'CGPA', value: widget.student.cgpa),
                  if (widget.student.university != null)
                    DisplayInfo(
                        k: 'University', value: widget.student.university),
                  if (widget.student.department != null)
                    DisplayInfo(
                        k: 'Department', value: widget.student.department),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
