import 'package:flutter/material.dart';

typedef CallbackAction = void Function();

class Student extends StatelessWidget {
  final int id;
  final String name;
  final int? grade;
  final String? school;
  final double? average;
  final int? rank;
  final double? matricResult;
  final phoneNumber;
  final String? department;
  final String? university;
  final double? CGPA;
  final CallbackAction onpressed;
  final bool showButtons;
  final CallbackAction? onDelete;
  final CallbackAction? onEdit;

  Student({
    Key? key,
    required this.id,
    required this.name,
    required this.grade,
    required this.school,
    this.average,
    this.rank,
    this.matricResult,
    this.phoneNumber,
    this.department,
    this.university,
    this.CGPA,
    required this.onpressed,
    this.showButtons = false,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              id == 13
                  ? '${name} (${department ?? 'Department'})'
                  : id != 0
                      ? name
                      : '$name (Rank: $rank)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                if (id == 0 || id == 6 || id == 12 || id == 13) ...[
                  Icon(Icons.school, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      id != 13 ? '${school ?? 'School'}' : '${university}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (id == 0 || id == 6 || id == 12) ...[
                  Icon(Icons.grade, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Grade: ${grade ?? '-'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (id == 0) ...[
                  Icon(Icons.bar_chart, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text(
                    'Average: ${average ?? '-'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
                if (id == 6 || id == 8 || id == 12) ...[
                  Icon(Icons.bar_chart, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text(
                    'Result: ${matricResult ?? '-'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
                if (id == 13) ...[
                  Icon(Icons.bar_chart, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text(
                    'Result: ${CGPA ?? '-'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
            if (showButtons) ...[
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: onEdit,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
