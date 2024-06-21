class StudentModel {
  final String name;
  final int grade;
  final String school;
  final double? average;
  final int? rank;
  final double? matricResult;

  StudentModel.grade10(
      {required this.name,
      required this.grade,
      required this.school,
      required this.matricResult})
      : average = null,
        rank = null;

  StudentModel.grade12(
      {required this.name,
      required this.grade,
      required this.school,
      required this.matricResult})
      : average = null,
        rank = null;

  StudentModel.grade6(
      {required this.name,
      required this.grade,
      required this.school,
      required this.matricResult})
      : average = null,
        rank = null;

  StudentModel.otherGrades(
      {required this.name,
      required this.grade,
      required this.school,
      required this.average,
      required this.rank})
      : matricResult = null;
}
