import 'package:rankers/models/student.dart';

class StudentIdMap {
  static final StudentIdMap _singleton = StudentIdMap._internal();

  factory StudentIdMap() {
    return _singleton;
  }

  StudentIdMap._internal();

  Map<String, String> _nameToDocumentIdMap = {};

  void updateMap(String name, documentId) {
    _nameToDocumentIdMap[name] = documentId;
  }

  String? getDocumentIdByName(String name) {
    return _nameToDocumentIdMap[name];
  }
}
