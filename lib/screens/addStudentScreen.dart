import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/services/studentService.dart';
import 'package:rankers/widgets/Drawer.dart';
import 'package:rankers/widgets/singleStudent.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  final TextEditingController _averageController = TextEditingController();
  final TextEditingController _matricResultController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                            0.5), // Slightly blackish with transparency
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Student Name',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the student\'s name.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _gradeController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Grade Level',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the grade level.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _schoolNameController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'School Name',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the school name.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _rankController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Rank (Optional)',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _averageController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Average Score (Optional)',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _matricResultController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Matric Result (Optional)',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _phoneNumberController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the phone number.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                StudentModel? student;
                                int phoneNumber =
                                    int.tryParse(_phoneNumberController.text) ??
                                        0;
                                int grade =
                                    int.tryParse(_gradeController.text) ?? 0;
                                double? matricResult = double.tryParse(
                                    _matricResultController.text);
                                double? average =
                                    double.tryParse(_averageController.text);
                                int? rank = int.tryParse(_rankController.text);

                                if (grade == 6) {
                                  student = StudentModel.grade6(
                                    name: _nameController.text,
                                    grade: grade,
                                    school: _schoolNameController.text,
                                    matricResult: matricResult,
                                    phoneNumber: phoneNumber,
                                  );
                                } else if (grade == 10) {
                                  student = StudentModel.grade10(
                                    name: _nameController.text,
                                    grade: grade,
                                    school: _schoolNameController.text,
                                    matricResult: matricResult,
                                    phoneNumber: phoneNumber,
                                  );
                                } else if (grade == 12) {
                                  student = StudentModel.grade12(
                                    name: _nameController.text,
                                    grade: grade,
                                    school: _schoolNameController.text,
                                    matricResult: matricResult,
                                    phoneNumber: phoneNumber,
                                  );
                                } else {
                                  student = StudentModel.otherGrades(
                                    name: _nameController.text,
                                    grade: grade,
                                    school: _schoolNameController.text,
                                    average: average,
                                    rank: rank,
                                    phoneNumber: phoneNumber,
                                  );
                                }

                                if (student != null) {
                                  print('Student Data: ${student.toMap()}');
                                  Studentservice firebaseService =
                                      Studentservice();
                                  try {
                                    firebaseService
                                        .saveStudentToFirestore(student);
                                    _nameController.clear();
                                    _schoolNameController.clear();
                                    _matricResultController.clear();
                                    _averageController.clear();
                                    _rankController.clear();
                                    _gradeController.clear();
                                    _phoneNumberController.clear();
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
