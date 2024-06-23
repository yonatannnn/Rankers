import 'package:flutter/material.dart';
import 'package:rankers/models/documentId.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/screens/manageScreen.dart';
import 'package:rankers/services/studentService.dart';
import 'package:rankers/services/authService.dart'; // Import your AuthService here

class EditGraduateStudent extends StatefulWidget {
  final String documentId;
  final String name;
  final String university;
  final String department;
  final double cgpa;
  final int phoneNumber;

  const EditGraduateStudent({
    required this.documentId,
    required this.name,
    required this.university,
    required this.department,
    required this.cgpa,
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  _EditGraduateStudentState createState() => _EditGraduateStudentState();
}

class _EditGraduateStudentState extends State<EditGraduateStudent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _cgpaController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final StudentIdMap _studentIdMap = StudentIdMap();
  final AuthService _authService = AuthService(); // Initialize AuthService

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _universityController.text = widget.university;
    _departmentController.text = widget.department;
    _cgpaController.text = widget.cgpa.toString();
    _phoneNumberController.text = widget.phoneNumber.toString();
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Student edited successfully!"),
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

  Future<void> _confirmEdit() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Edit"),
          content: Text("Are you sure you want to save the changes?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm) {
      _saveChanges();
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Check authorization
      bool canPerformEdit = await _authService.canPerformEdit();
      if (!canPerformEdit) {
        _showErrorDialog('You are not authorized to perform this action.');
        return;
      }
      double cgpa = double.tryParse(_cgpaController.text) ?? 0.0;
      int phoneNumber = int.tryParse(_phoneNumberController.text) ?? 0;

      StudentModel student = StudentModel.graduate(
        name: _nameController.text,
        university: _universityController.text,
        department: _departmentController.text,
        cgpa: cgpa,
        phoneNumber: phoneNumber,
      );

      StudentService firebaseService = StudentService();
      try {
        await firebaseService.editStudentInFirestore(
          widget.documentId,
          student,
        );
        _studentIdMap.updateMap(
          _nameController.text,
          widget.documentId,
        );
        _showSuccessDialog();
        _nameController.clear();
        _universityController.clear();
        _departmentController.clear();
        _cgpaController.clear();
        _phoneNumberController.clear();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Manage()));
      } catch (e) {
        _showErrorDialog('Error');
      }
    }
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
                  controller: _universityController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'University',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the university.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
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
                      return 'Please enter the department.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _cgpaController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'CGPA',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter CGPA.';
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
                  onPressed: _confirmEdit,
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
