import 'package:flutter/material.dart';

class Student extends StatelessWidget {
  final int id;
  final String name;
  final int? grade;
  final String? school;
  final double? average;
  final int? rank;
  final double? matricResult;

  Student({
    Key? key,
    required this.id,
    required this.name,
    required this.grade,
    required this.school,
    this.average,
    this.rank,
    this.matricResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            id != 0 ? name : '$name (Rank: $rank)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.school, color: Colors.white, size: 16),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  '$school',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(Icons.grade, color: Colors.white, size: 16),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Grade: $grade',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              if (id == 0) ...[
                SizedBox(width: 10),
                Icon(Icons.bar_chart, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Icon(Icons.emoji_events, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Text(
                  'Rank: $rank',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
              if (id == 10 || id == 12 || id == 6) ...[
                Icon(Icons.assessment, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Text(
                  'Result: $matricResult',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
