import 'package:flutter/material.dart';
import 'package:rankers/utils/text.dart';

class GradeSeparatorButton extends StatelessWidget {
  final double opacity;
  final int grade;
  final VoidCallback onPressed;

  const GradeSeparatorButton({
    Key? key,
    required this.opacity,
    required this.grade,
    required this.onPressed,
  }) : super(key: key);

  int getGrade() {
    return grade;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(opacity),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: TextUtil(
          text: '$grade',
          size: 20,
        ),
      ),
    );
  }
}
