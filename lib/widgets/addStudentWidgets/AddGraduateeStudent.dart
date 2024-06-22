import 'package:flutter/material.dart';
import 'package:rankers/models/student.dart';
import 'package:rankers/services/studentService.dart';

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
                      return 'Please enter the Univeristy Name.';
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
                          phoneNumber: phoneNumber);

                      if (student != null) {
                        print('Student Data: ${student.toMap()}');
                        StudentService firebaseService = StudentService();
                        try {
                          firebaseService.saveStudentToFirestore(student);
                          _nameController.clear();
                          _phoneNumberController.clear();
                          _CGPAContoller.clear();
                          _UniversityNameController.clear();
                          _departmentController.clear();
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
    );
  }
}
