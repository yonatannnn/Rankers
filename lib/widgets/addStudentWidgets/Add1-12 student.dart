import 'package:flutter/material.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/services/studentService.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:rankers/services/authService.dart'; // Import AuthService

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  final TextEditingController _averageController = TextEditingController();
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
                    } else if (value.length > 2) {
                      return 'please enter valid grade level';
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
                  decoration: InputDecoration(
                    labelText: 'Rank',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid Rank.';
                    }
                    int? rankValue = int.tryParse(value);
                    if (rankValue == null || rankValue < 0 || rankValue > 3) {
                      return 'Please enter a valid Rank between 0 and 3.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _averageController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Average Score',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Average Score';
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
                      double? matricResult = null;
                      double? average =
                          double.tryParse(_averageController.text);
                      int? rank = int.tryParse(_rankController.text);
                      student = StudentModel.otherGrades(
                        name: _nameController.text,
                        grade: grade,
                        school: _schoolNameController.text,
                        average: average,
                        rank: rank,
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
                          _averageController.clear();
                          _rankController.clear();
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
