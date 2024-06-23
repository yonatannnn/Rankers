import 'package:flutter/material.dart';
import 'package:rankers/utils/text.dart'; // Ensure this contains TextUtil widget definition

class GradeSeparatorButton extends StatelessWidget {
  final String toBeWritten;
  final double opacity;
  final int rank;
  final VoidCallback onPressed;

  const GradeSeparatorButton({
    Key? key,
    required this.toBeWritten,
    required this.opacity,
    required this.rank,
    required this.onPressed,
  }) : super(key: key);

  int getRank() {
    return rank;
  }

  @override
  Widget build(BuildContext context) {
    String above;
    if (rank == 1 || rank == 2 || rank == 3) {
      above = 'Rank';
    } else if (rank == 6 || rank == 10 || rank == 12 || rank == 8) {
      above = 'Grade';
    } else if (rank == 0) {
      above = 'All';
    } else {
      above = '';
    }
    return SizedBox(
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(opacity),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextUtil(
              text: '$above',
              size: 20,
            ),
            TextUtil(
              text: '$toBeWritten',
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
