import 'package:flutter/material.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/services/studentService.dart';
import 'package:provider/provider.dart';
import 'package:rankers/services/authService.dart';

class AddGrade6_10_12Student extends StatefulWidget {
  const AddGrade6_10_12Student({super.key});

  @override
  State<AddGrade6_10_12Student> createState() => _AddStudentState6();
}

class _AddStudentState6 extends State<AddGrade6_10_12Student> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _matricResultController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Student added successfully!"),
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    // Access AuthService instance using Provider
    final authService = Provider.of<AuthService>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
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
                  controller: _matricResultController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Result',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Result.';
                    }
                    return null;
                  },
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
                    if (value == null ||
                        value.isEmpty ||
                        value.length != 10 ||
                        value[0] != '0') {
                      return 'Please enter valid phone number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    bool canEdit = await authService.canPerformEdit();
                    if (canEdit && _formKey.currentState!.validate()) {
                      StudentModel? student;
                      int phoneNumber =
                          int.tryParse(_phoneNumberController.text) ?? 0;
                      int grade = int.tryParse(_gradeController.text) ?? 0;
                      double? matricResult =
                          double.tryParse(_matricResultController.text);
                      double? average = null;
                      int? rank = null;

                      student = StudentModel.grade6(
                        name: _nameController.text,
                        grade: grade,
                        school: _schoolNameController.text,
                        matricResult: matricResult,
                        phoneNumber: phoneNumber,
                      );

                      if (student != null) {
                        print('Student Data: ${student.toMap()}');
                        StudentService firebaseService = StudentService();
                        try {
                          firebaseService.saveStudentToFirestore(student);
                          _showSuccessDialog();
                          _nameController.clear();
                          _schoolNameController.clear();
                          _matricResultController.clear();
                          _gradeController.clear();
                          _phoneNumberController.clear();
                        } catch (e) {
                          _showErrorDialog('Error');
                        }
                      }
                    } else {
                      _showErrorDialog(
                          'You are not authorized to perform this action.');
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
