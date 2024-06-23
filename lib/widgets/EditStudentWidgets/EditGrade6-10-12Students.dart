import 'package:flutter/material.dart';
import 'package:rankers/models/documentId.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/screens/manageScreen.dart';
import 'package:rankers/services/studentService.dart';
import 'package:rankers/services/authService.dart';

class EditMatricStudent extends StatefulWidget {
  final documentId;
  final String name;
  final String school;
  final double matricResult;
  final int phoneNumber;
  final int grade;

  const EditMatricStudent({
    required this.matricResult,
    required this.grade,
    required this.documentId,
    required this.name,
    required this.school,
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  State<EditMatricStudent> createState() => _EditMatricStudentState();
}

class _EditMatricStudentState extends State<EditMatricStudent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _matricResultController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final StudentIdMap _studentIdMap = StudentIdMap();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _gradeController.text = widget.grade.toString();
    _schoolNameController.text = widget.school;
    _matricResultController.text = widget.matricResult.toString();
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

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      bool canPerformEdit = await _authService.canPerformEdit();
      if (!canPerformEdit) {
        _showErrorDialog('You are not authorized to perform this action.');
        return;
      }
      int phoneNumber = int.tryParse(_phoneNumberController.text) ?? 0;
      int grade = int.tryParse(_gradeController.text) ?? 0;
      double? matricResult = double.tryParse(_matricResultController.text);

      StudentModel student = StudentModel.grade6(
        name: _nameController.text,
        grade: grade,
        school: _schoolNameController.text,
        matricResult: matricResult,
        phoneNumber: phoneNumber,
      );

      StudentService firebaseService = StudentService();
      try {
        await firebaseService.editStudentInFirestore(
            widget.documentId, student);
        _studentIdMap.updateMap(_nameController.text, widget.documentId);
        _showSuccessDialog();
        _nameController.clear();
        _schoolNameController.clear();
        _matricResultController.clear();
        _gradeController.clear();
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
