import 'package:flutter/material.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/services/studentService.dart';
import 'package:rankers/services/authService.dart'; // Assuming AuthService is implemented here

class AddGraduateStudent extends StatefulWidget {
  const AddGraduateStudent({super.key});

  @override
  State<AddGraduateStudent> createState() => _AddStudentState13();
}

class _AddStudentState13 extends State<AddGraduateStudent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _CGPAContoller = TextEditingController();
  final TextEditingController _UniversityNameController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  final AuthService _authService = AuthService();

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
                  controller: _CGPAContoller,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'CGPA',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the CGPA.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _UniversityNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'University',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the University Name.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _departmentController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Department Name.';
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
                    if (_formKey.currentState!.validate()) {
                      bool canPerformEdit = await _authService.canPerformEdit();

                      if (!canPerformEdit) {
                        _showErrorDialog(
                            'You are not authorized to perform this action.');
                        return;
                      }
                      StudentModel? student;
                      int phoneNumber =
                          int.tryParse(_phoneNumberController.text) ?? 0;
                      double CGPA = double.tryParse(_CGPAContoller.text) ?? 0.0;
                      int? grade = null;
                      double? matricResult = null;
                      double? average = null;
                      int? rank = null;
                      student = StudentModel.graduate(
                        name: _nameController.text,
                        university: _UniversityNameController.text,
                        department: _departmentController.text,
                        cgpa: CGPA,
                        phoneNumber: phoneNumber,
                      );

                      if (student != null) {
                        print('Student Data: ${student.toMap()}');
                        StudentService firebaseService = StudentService();
                        try {
                          firebaseService.saveStudentToFirestore(student);
                          _showSuccessDialog();
                          _nameController.clear();
                          _phoneNumberController.clear();
                          _CGPAContoller.clear();
                          _UniversityNameController.clear();
                          _departmentController.clear();
                        } catch (e) {
                          _showErrorDialog('Error');
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
    );
  }
}
