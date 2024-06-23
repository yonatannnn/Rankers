import 'package:flutter/material.dart';
import 'package:rankers/models/documentId.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/screens/manageScreen.dart';
import 'package:rankers/services/studentService.dart';
import 'package:rankers/services/authService.dart'; // Import your AuthService here

class EditStudent extends StatefulWidget {
  final documentId;
  final String name;
  final int grade;
  final String school;
  final int rank;
  final double average;
  final int phoneNumber;

  const EditStudent({
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
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  final TextEditingController _averageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final StudentIdMap _studentIdMap = StudentIdMap();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _gradeController.text = widget.grade.toString();
    _schoolNameController.text = widget.school;
    _rankController.text = widget.rank.toString();
    _averageController.text = widget.average.toString();
    _phoneNumberController.text = widget.phoneNumber.toString();
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

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      bool canPerformEdit = await _authService.canPerformEdit();
      if (!canPerformEdit) {
        _showErrorDialog('You are not authorized to perform this action.');
        return;
      }

      StudentModel? student;
      int phoneNumber = int.tryParse(_phoneNumberController.text) ?? 0;
      int grade = int.tryParse(_gradeController.text) ?? 0;
      double? average = double.tryParse(_averageController.text);
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
        StudentService firebaseService = StudentService();
        try {
          await firebaseService.editStudentInFirestore(
              widget.documentId, student);
          _studentIdMap.updateMap(_nameController.text, widget.documentId);
          _showSuccessDialog();
          _nameController.clear();
          _schoolNameController.clear();
          _averageController.clear();
          _rankController.clear();
          _gradeController.clear();
          _phoneNumberController.clear();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Manage()));
        } catch (e) {
          _showErrorDialog('Error');
        }
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
