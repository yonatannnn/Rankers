class StudentModel {
  final String name;
  final int grade;
  final String school;
  final double? average;
  final int? rank;
  final double? matricResult;
  final int phoneNumber;

  StudentModel.grade10(
      {required this.name,
      required this.grade,
      required this.school,
      required this.matricResult,
      required this.phoneNumber})
      : average = null,
        rank = null;

  StudentModel.grade12(
      {required this.name,
      required this.grade,
      required this.school,
      required this.matricResult,
      required this.phoneNumber})
      : average = null,
        rank = null;

  StudentModel.grade6(
      {required this.name,
      required this.grade,
      required this.school,
      required this.matricResult,
      required this.phoneNumber})
      : average = null,
        rank = null;

  StudentModel.otherGrades(
      {required this.name,
      required this.grade,
      required this.school,
      required this.average,
      required this.rank,
      required this.phoneNumber})
      : matricResult = null;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grade': grade,
      'school': school,
      if (average != null) 'average': average,
      if (rank != null) 'rank': rank,
      if (matricResult != null) 'matricResult': matricResult,
    };
  }
}
